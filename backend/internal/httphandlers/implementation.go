package httphandlers

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/sql"
	"go.uber.org/zap"
	"net/http"
)

type httpImpl struct {
	db      sql.SQL
	config  *consts.ServerConfig
	sugared *zap.SugaredLogger
}

type HTTPHandler interface {
	Registration(w http.ResponseWriter, r *http.Request)
	Login(w http.ResponseWriter, r *http.Request)
	DeleteRegistrationCode(w http.ResponseWriter, r *http.Request)
	NewRegistrationCode(w http.ResponseWriter, r *http.Request)
	GetRegistrationCodes(w http.ResponseWriter, r *http.Request)
	ConfirmEmail(w http.ResponseWriter, r *http.Request)
}

func NewHTTPHandler(db sql.SQL, config *consts.ServerConfig, sugared *zap.SugaredLogger) HTTPHandler {
	return &httpImpl{
		db:      db,
		config:  config,
		sugared: sugared,
	}
}
