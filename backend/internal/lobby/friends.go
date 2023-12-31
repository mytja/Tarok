package lobby

import (
	sql2 "database/sql"
	"errors"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/sql"
)

func (s *serverImpl) AddNewFriend(userId string, friendHandle string) {
	user, err := s.db.GetUser(userId)
	if err != nil {
		return
	}
	friend, err := s.db.GetUserByHandle(friendHandle)
	if err != nil {
		return
	}
	found := true
	_, err = s.db.GetFriendRelationshipByUserID(userId, friend.ID)
	if err != nil {
		if errors.Is(err, sql2.ErrNoRows) {
			found = false
		} else {
			s.logger.Debugw("get friend relationship failed", "user1Id", userId, "user2Id", friend.ID, "err", err)
			return
		}
	}
	if found {
		return
	}
	friends := sql.Friends{
		User1:     userId,
		User2:     friend.ID,
		Connected: false,
	}
	err = s.db.InsertFriendRelationship(friends)
	if err != nil {
		s.logger.Debugw("insert friend relationship failed", "user1Id", userId, "user2Id", friend.ID, "err", err)
		return
	}

	friendRelationship, err := s.db.GetFriendRelationshipByUserID(userId, friend.ID)
	if err != nil {
		return
	}

	for _, v := range s.clients {
		if v.GetUserID() == userId {
			v.Send(&lobby_messages.LobbyMessage{
				PlayerId: friend.ID,
				Data: &lobby_messages.LobbyMessage_Friend{
					Friend: &lobby_messages.Friend{
						Status: 0,
						Name:   friend.Name,
						Handle: friend.Handle,
						Id:     friendRelationship.ID,
						Data:   &lobby_messages.Friend_Outgoing_{Outgoing: &lobby_messages.Friend_Outgoing{}},
					},
				},
			})
		} else if v.GetUserID() == friend.ID {
			v.Send(&lobby_messages.LobbyMessage{
				PlayerId: userId,
				Data: &lobby_messages.LobbyMessage_Friend{
					Friend: &lobby_messages.Friend{
						Status: 0,
						Name:   user.Name,
						Handle: user.Handle,
						Id:     friendRelationship.ID,
						Data:   &lobby_messages.Friend_Incoming_{Incoming: &lobby_messages.Friend_Incoming{}},
					},
				},
			})
		}
	}
}

func (s *serverImpl) IncomingFriendRequestAcceptDeny(userId string, friendRequestId string, accept bool) {
	relationship, err := s.db.GetFriendRelationship(friendRequestId)
	if err != nil {
		return
	}

	if relationship.User2 != userId {
		return
	}

	if accept {
		relationship.Connected = true
		err = s.db.UpdateFriends(relationship)
	} else {
		err = s.db.DeleteFriends(friendRequestId)
	}

	if err != nil {
		return
	}

	for _, v := range s.clients {
		if !(v.GetUserID() == relationship.User1 || v.GetUserID() == relationship.User2) {
			continue
		}

		v.Send(&lobby_messages.LobbyMessage{
			PlayerId: userId,
			Data: &lobby_messages.LobbyMessage_FriendRequestAcceptDecline{
				FriendRequestAcceptDecline: &lobby_messages.FriendRequestAcceptDecline{
					RelationshipId: relationship.ID,
					Accept:         accept,
				},
			},
		})

		// igralec je online
		v.Send(&lobby_messages.LobbyMessage{
			PlayerId: userId,
			Data: &lobby_messages.LobbyMessage_FriendOnlineStatus{
				FriendOnlineStatus: &lobby_messages.FriendOnlineStatus{Status: 1},
			},
		})
	}
}

func (s *serverImpl) RemoveFriend(userId string, relationshipId string) {
	relationship, err := s.db.GetFriendRelationship(relationshipId)
	if err != nil {
		return
	}
	if !(relationship.User1 == userId || relationship.User2 == userId) {
		return
	}
	err = s.db.DeleteFriends(relationshipId)
	if err != nil {
		return
	}
	for _, v := range s.clients {
		if !(v.GetUserID() == relationship.User1 || v.GetUserID() == relationship.User2) {
			continue
		}

		v.Send(&lobby_messages.LobbyMessage{
			PlayerId: userId,
			Data: &lobby_messages.LobbyMessage_RemoveFriend{
				RemoveFriend: &lobby_messages.RemoveFriend{
					RelationshipId: relationship.ID,
				},
			},
		})
	}
}
