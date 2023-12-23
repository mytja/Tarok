package sql

const schema string = `
CREATE OR REPLACE FUNCTION update_changetimestamp_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE IF NOT EXISTS users (
	id								UUID			PRIMARY KEY		DEFAULT gen_random_uuid(),
	email							VARCHAR(250)	NOT NULL,
	name							VARCHAR(250)	NOT NULL,
	pass							VARCHAR(250)	NOT NULL,
	rating							INTEGER			NOT NULL,
	role							VARCHAR(50)		NOT NULL,
	login_token						VARCHAR(400),
	email_confirmation				VARCHAR(100)	DEFAULT '',
	email_confirmed					BOOLEAN			NOT NULL		DEFAULT false,
	disabled						BOOLEAN,
	password_reset_token			VARCHAR(250),
	password_reset_initiated_on		TIMESTAMP,
	email_sent_on					BIGINT,

	created_at						TIMESTAMP		NOT NULL		DEFAULT now(),
	updated_at						TIMESTAMP		NOT NULL		DEFAULT now()
);
CREATE TABLE IF NOT EXISTS game_user (
	id                      UUID			PRIMARY KEY     DEFAULT gen_random_uuid(),
	user_id                 UUID			NOT NULL,
	game_id                 UUID			NOT NULL,
	messages				JSON			NOT NULL,
	password				VARCHAR(250)	NOT NULL,
	
	created_at              TIMESTAMP		NOT NULL DEFAULT now(),
	updated_at              TIMESTAMP		NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS codes (
	code                    VARCHAR(100)   PRIMARY KEY,
	created_at              TIMESTAMP      NOT NULL DEFAULT now(),
	updated_at              TIMESTAMP      NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS friends (
	id                       UUID           PRIMARY KEY     DEFAULT gen_random_uuid(),
	user1                    VARCHAR(250)   NOT NULL,
	user2                    VARCHAR(250)   NOT NULL,
	connected                BOOLEAN        NOT NULL,
	
	created_at               TIMESTAMP      NOT NULL DEFAULT now(),
	updated_at               TIMESTAMP      NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS tournament (
	id							UUID			PRIMARY KEY DEFAULT gen_random_uuid(),
	created_by					VARCHAR(250)	NOT NULL,
	name						VARCHAR(250)	NOT NULL,
	start_time					BIGINT			NOT NULL,
	division					SMALLINT		NOT NULL,
	rated						BOOLEAN			NOT NULL,
	private						BOOLEAN			NOT NULL,
	
	created_at					TIMESTAMP		NOT NULL DEFAULT now(),
	updated_at					TIMESTAMP		NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS tournament_participant (
	id							UUID			PRIMARY KEY DEFAULT gen_random_uuid(),
	tournament_id				VARCHAR(250)	NOT NULL,
	user_id						VARCHAR(250)	NOT NULL,
	rated						BOOLEAN			NOT NULL,
	rating_delta				INTEGER			DEFAULT 0,
	
	created_at					TIMESTAMP		NOT NULL DEFAULT now(),
	updated_at					TIMESTAMP		NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS tournament_round (
	id							UUID			PRIMARY KEY DEFAULT gen_random_uuid(),
	tournament_id				VARCHAR(250)	NOT NULL,
	cards1						JSON			NOT NULL,
	cards2						JSON			NOT NULL,
	cards3						JSON			NOT NULL,
	cards4						JSON			NOT NULL,
	talon						JSON			NOT NULL,
	time						INTEGER			NOT NULL,
	round_number				INTEGER			NOT NULL,
	
	created_at					TIMESTAMP		NOT NULL DEFAULT now(),
	updated_at					TIMESTAMP		NOT NULL DEFAULT now()
);


CREATE OR REPLACE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_game_user_updated_at BEFORE UPDATE ON game_user FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_codes_updated_at BEFORE UPDATE ON codes FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_friends_updated_at BEFORE UPDATE ON friends FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
`
