package ws

import (
	"math"
	"sort"
)

type UserRating struct {
	UserID    string
	Rank      float64
	OldRating int
	Seed      float64
	NewRating int
	Delta     int
}

func NewUserRating(userId string, rank float64, oldRating int) UserRating {
	return UserRating{
		UserID:    userId,
		Rank:      rank,
		OldRating: oldRating,
		Seed:      1.0,
		NewRating: 0,
	}
}

func CalP(userA UserRating, userB UserRating) float64 {
	return 1.0 / (1.0 + math.Pow(10, float64(userB.OldRating-userA.OldRating)/400.0))
}

// da ne kopiramo zaman, dam pointer sem. nil ptr dereference incoming
func GetExSeed(userList *[]UserRating, rating int, ownUser *UserRating) float64 {
	exUser := NewUserRating(ownUser.UserID, 0.0, rating)
	result := 1.0
	for _, user := range *userList {
		if user.UserID == ownUser.UserID {
			continue
		}
		result += CalP(user, exUser)
	}
	return result
}

func CalcRat(userList *[]UserRating, rank float64, user *UserRating) int {
	left := 1
	right := 8000
	for right-left > 1 {
		mid := int((left + right) / 2)
		if GetExSeed(userList, mid, user) < rank {
			right = mid
		} else {
			left = mid
		}
	}
	return left
}

func CalculateRating(userList *[]UserRating) {
	// Calculate seed
	for i := range *userList {
		(*userList)[i].Seed = 1.0
		for j := range *userList {
			if i == j {
				continue
			}
			(*userList)[i].Seed += CalP((*userList)[j], (*userList)[i])
		}
	}

	// Calculate initial delta and sum_delta
	sum_delta := 0
	for _, user := range *userList {
		user.Delta = (CalcRat(userList, math.Sqrt(user.Rank*user.Seed), &user) - user.OldRating) / 2
		sum_delta += user.Delta
	}

	// Calculate first inc
	inc := int(-sum_delta/len(*userList)) - 1
	for _, user := range *userList {
		user.Delta += inc
	}

	// Calculate second inc
	sort.Slice(*userList, func(i, j int) bool {
		return (*userList)[i].OldRating > (*userList)[j].OldRating
	})
	s := int(math.Min(float64(len(*userList)), 4*math.Round(math.Sqrt(float64(len(*userList))))))
	sumS := 0
	for i := 0; i < s; i++ {
		sumS += (*userList)[i].Delta
	}
	inc = int(math.Min(math.Max(math.Floor(float64(-sumS/s)), -10), 0))

	// Calculate new rating
	for _, user := range *userList {
		user.Delta += inc
		user.NewRating = user.OldRating + user.Delta
	}

	sort.Slice(*userList, func(i, j int) bool {
		return (*userList)[i].Rank < (*userList)[j].Rank
	})
}
