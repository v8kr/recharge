package common

import (
	"crypto/sha1"
	"fmt"
)

func GetSha1(str string) string {
	return fmt.Sprintf("%x", sha1.Sum([]byte(str)))
}
