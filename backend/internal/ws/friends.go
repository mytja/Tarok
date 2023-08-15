package ws

import (
	sql2 "database/sql"
	"encoding/json"
	"errors"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net/http"
	"strconv"
)

type RelationshipUser struct {
	ID         string
	Email      string
	Name       string
	OnlineType int
}

type Relationship struct {
	ID   string
	User RelationshipUser
}

type Friends struct {
	CurrentFriends []Relationship
	Incoming       []Relationship
	Outgoing       []Relationship
}

func (s *serverImpl) AddFriendByEmail(w http.ResponseWriter, r *http.Request) {
	user1, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	email := r.FormValue("email")
	user2, err := s.db.GetUserByEmail(email)
	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		return
	}
	found := true
	_, err = s.db.GetFriendRelationshipByUserID(user1.ID, user2.ID)
	if err != nil {
		if errors.Is(err, sql2.ErrNoRows) {
			found = false
		} else {
			s.logger.Debugw("get friend relationship failed", "user1Id", user1.ID, "user2Id", user2.ID, "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
	if found {
		w.WriteHeader(http.StatusConflict)
		return
	}
	friends := sql.Friends{
		User1:     user1.ID,
		User2:     user2.ID,
		Connected: false,
	}
	err = s.db.InsertFriendRelationship(friends)
	if err != nil {
		s.logger.Debugw("insert friend relationship failed", "user1Id", user1.ID, "user2Id", user2.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}

func (s *serverImpl) IncomingFriendRequestAcceptDeny(w http.ResponseWriter, r *http.Request) {
	user2, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	relationshipId := r.FormValue("relationship")
	relationship, err := s.db.GetFriendRelationship(relationshipId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	if relationship.User2 != user2.ID {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	friendRequest := r.FormValue("friendRequest")
	friendRequestAccept, err := strconv.ParseBool(friendRequest)
	if err != nil {
		return
	}

	if friendRequestAccept {
		relationship.Connected = true
		err = s.db.UpdateFriends(relationship)
	} else {
		err = s.db.DeleteFriends(relationshipId)
	}

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	return
}

func (s *serverImpl) RemoveFriend(w http.ResponseWriter, r *http.Request) {
	user1, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	relationshipId := r.FormValue("relationship")
	relationship, err := s.db.GetFriendRelationship(relationshipId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	if !(relationship.User1 == user1.ID || relationship.User2 == user1.ID) {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	err = s.db.DeleteFriends(relationshipId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func (s *serverImpl) SQLFriendsConverter(user sql.User, friends []sql.Friends) []Relationship {
	currentFriends := make([]Relationship, 0)
	for _, v := range friends {
		var u string
		if v.User1 != user.ID {
			u = v.User1
		} else {
			u = v.User2
		}
		usr, err := s.db.GetUser(u)
		if err != nil {
			return make([]Relationship, 0)
		}

		status := 0
		for _, game := range s.games {
			for _, user := range game.Players {
				if user.GetUser().ID == usr.ID && len(user.GetClients()) != 0 {
					status = 1
				}
			}
		}

		currentFriends = append(currentFriends, Relationship{
			ID: v.ID,
			User: RelationshipUser{
				ID:         usr.ID,
				Email:      usr.Email,
				Name:       usr.Name,
				OnlineType: status,
			},
		})
	}
	return currentFriends
}

func (s *serverImpl) GetFriends(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	friends, err := s.db.GetFriends(user.ID)
	if err != nil {
		s.logger.Debugw("get friends failed", "userId", user.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	outgoing, err := s.db.GetOutgoingFriends(user.ID)
	if err != nil {
		s.logger.Debugw("get outgoing friends failed", "userId", user.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	incoming, err := s.db.GetIncomingFriends(user.ID)
	if err != nil {
		s.logger.Debugw("get incoming friends failed", "userId", user.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	j := Friends{
		CurrentFriends: s.SQLFriendsConverter(user, friends),
		Incoming:       s.SQLFriendsConverter(user, incoming),
		Outgoing:       s.SQLFriendsConverter(user, outgoing),
	}
	marshal, err := json.Marshal(j)
	if err != nil {
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(marshal)
}
