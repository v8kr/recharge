package common

import "strings"

//自然排序
type NSort []string

func (s NSort) Len() int {
	return len(s)
}

func (s NSort) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s NSort) Less(i, j int) bool {
	return strings.ToLower(s[i]) < strings.ToLower(s[j])
}
