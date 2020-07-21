package logger

import (
	"fmt"
	"github.com/sirupsen/logrus"
	"io"
	"os"
)

const (
	LOG_PATH    = "./storage/logs/"
	DEFAULT_LOG = "defalut"
)

var loggers = make(map[string]*logrus.Logger)

func init() {
	loggers[DEFAULT_LOG] = New(DEFAULT_LOG)
}

func New(name string) *logrus.Logger {
	l := logrus.New()
	file, err := openLogFile(name)
	if err == nil {
		l.SetOutput(io.MultiWriter(file, os.Stderr))
	} else {
		logrus.Info("Failed to log to file, using default stderr")
	}
	loggers[name] = l
	return l
}

func Get(name string) *logrus.Logger {
	l, ok := loggers[name]
	if ok {
		return l
	}
	return New(name)
}

func openLogFile(name string) (io.Writer, error) {
	filename := fmt.Sprintf("%s%s.log", LOG_PATH, name)
	return os.OpenFile(filename, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
}
