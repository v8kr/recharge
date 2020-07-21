package common

import (
	"errors"
	"github.com/v8kr/recharge/models"
)

// api_id (uid) find user
// check status and allow ip
func ApiLoadUser(apiId string, ip string) (models.User, error) {
	var user models.User
	if err := models.DB.Where("api_id", apiId).First(&user).Error; err != nil {
		return user, errors.New("not found user")
	}

	if !user.IsActive() {
		return models.User{}, errors.New("account is forbidden")
	}

	if !user.IsAllowIP(ip) {
		return models.User{}, errors.New("ip deny")
	}

	return user, nil
}
