package consts

type ServerConfig struct {
	Debug         bool
	Host          string
	Port          string
	Path          string
	Postgres      string
	EmailAccount  string
	EmailServer   string
	EmailPassword string
	EmailPort     int
}

type ServerFileConfig struct {
	EmailAccount  string `json:"email_account"`
	EmailServer   string `json:"email_server"`
	EmailPassword string `json:"email_password"`
	EmailPort     int    `json:"email_port"`
}
