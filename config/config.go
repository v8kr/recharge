package config

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
	"strings"
)

type config struct {
	Env    string `yaml:"env"`
	Debug  bool
	Notify notify
	Mysql  mysql
}

type notify struct {
	Email struct {
		connection `yaml:",inline"`
		From       string
		Default    []string
	}
	Alertover struct {
		Source   string
		Receiver string
	}
}

type connection struct {
	Host     string
	Port     int
	Username string
	Password string
}

type mysql struct {
	connection `yaml:",inline"`
	Database   string
}

var Cfg config

func init() {
	Reload()
}

func Reload() {
	f, err := ioutil.ReadFile("config.yaml")
	if err != nil {
		log.Fatalln("config.yaml not found")
	}

	err = yaml.Unmarshal([]byte(f), &Cfg)
	if err != nil {
		log.Fatalln("config.yaml content error", err)
	}
}

func IsLocal() bool {
	return strings.ToLower(Cfg.Env) == "local"
}

func Debug() bool {
	return Cfg.Debug
}

func DefaultNotifyEmail() []string {
	return Cfg.Notify.Email.Default
}
