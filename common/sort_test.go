package common

import (
	"sort"
	"testing"
)

func TestNSort(t *testing.T) {
	okStr := NSort{"0123", "abc", "Bcd", "def"}
	testStr := NSort{"Bcd", "abc", "def", "0123"}

	sort.Sort(testStr)

	for i, v := range okStr {
		if v != testStr[i] {
			t.Fatalf("nstor error \r\n %v \r\n%v", okStr, testStr)
		}
	}

}
