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
	id                       UUID           PRIMARY KEY     DEFAULT gen_random_uuid(),
	email                    VARCHAR(250)   NOT NULL,
	name                     VARCHAR(250)   NOT NULL,
	pass                     VARCHAR(250)   NOT NULL,
	rating                   INTEGER        NOT NULL,
	role                     VARCHAR(50)    NOT NULL,
	login_token              VARCHAR(400),
	
	created_at               TIMESTAMP      NOT NULL DEFAULT now(),
	updated_at               TIMESTAMP      NOT NULL DEFAULT now()
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


CREATE OR REPLACE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_game_user_updated_at BEFORE UPDATE ON game_user FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_codes_updated_at BEFORE UPDATE ON codes FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
CREATE OR REPLACE TRIGGER update_friends_updated_at BEFORE UPDATE ON friends FOR EACH ROW EXECUTE PROCEDURE update_changetimestamp_column();
`
