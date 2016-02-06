CREATE TABLE team
(
	team_id 	SERIAL	PRIMARY KEY,
	team_name	VARCHAR(25)	NOT NULL,
	stadium		VARCHAR(25)	NOT NULL
);

CREATE TABLE match
(
	match_id			SERIAL		PRIMARY KEY,
	home_team			INTEGER		NOT NULL,
	away_team			INTEGER		NOT NULL,
	home_score		INTEGER		DEFAULT null,
	away_score		INTEGER		DEFAULT null,
	match_date		DATE,
	kickoff_time	TIME,
	gameweek			INTEGER		NOT NULL,
	FOREIGN KEY (home_team) REFERENCES team
		ON DELETE RESTRICT,
	FOREIGN KEY (away_team) REFERENCES team
		ON DELETE RESTRICT
);

CREATE TABLE player
(
	player_id		SERIAL			PRIMARY KEY,
	first_name	VARCHAR(30)	DEFAULT	null,
	surname			VARCHAR(30)	NOT NULL,
	team_id			INTEGER			NOT NULL,
	kit_number	INTEGER,
	FOREIGN KEY (team_id) REFERENCES team
		ON DELETE RESTRICT
);

CREATE TABLE goal
(
	goal_id		SERIAL	PRIMARY KEY,
	player_id	INTEGER	NOT NULL,
	match_id	INTEGER	NOT NULL,
	team_id		INTEGER NOT NULL,
	own_goal	BOOLEAN	NOT NULL,
	goal_time	INTEGER	NOT NULL,
	FOREIGN KEY (player_id) REFERENCES player
		ON DELETE CASCADE,
	FOREIGN KEY (match_id) REFERENCES match
			ON DELETE RESTRICT,
	FOREIGN KEY (team_id) REFERENCES team
			ON DELETE RESTRICT
);

--Solves many to many relationship caused by player/match tables, one entry
--for a player indicates one match played. May have to include substitutions
--table eventually to indicate whether appearances were starts or not.
CREATE TABLE appearance
(
	player_id	INTEGER	NOT NULL,
	match_id	INTEGER	NOT NULL,
	PRIMARY KEY(player_id, match_id)
);
