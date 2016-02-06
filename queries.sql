--appearances ranking
SELECT surname, COUNT(app_id) AS appearances
FROM player,appearance
WHERE player.player_id = appearance.player_id --AND team_id = given_id (for team specific appearance lists)
GROUP BY player.surname ORDER BY appearances DESC;

--goal ranking (not working yet)
(SELECT first_name, surname, COUNT(goal_id) AS goals
FROM player, goal
WHERE player.player_id = goal.player_id
GROUP BY first_name, surname ORDER BY goals DESC)
UNION
(SELECT first_name, surname
FROM player,goal WHERE player.player_id = goal.player_id AND (SELECT COUNT(goal_id) FROM player,goal) = 0
GROUP BY first_name, surname);

--List of matches ordered by date
SELECT * FROM
(SELECT home_score, away_score, team_name, match_date
FROM team
INNER JOIN match
ON team.team_id = match.away_team AND match.home_team = given_id) HOME_GAMES
UNION ALL
SELECT * FROM
(SELECT away_score, home_score, team_name, match_date
FROM team
INNER JOIN match
ON team.team_id = match.home_team AND match.away_team = given_id) AWAY_GAMES
ORDER BY match_date;

--- SELECT ALL MATCHES (outputs as home_team, home_score, away_score, away_team)

SELECT home_name, home_score, away_score, away_name FROM 
(SELECT match_id, team_name AS home_name, home_score
FROM match, team WHERE home_team = team.team_id) Q1
JOIN
(SELECT match_id, away_score, team_name AS away_name
FROM match, team WHERE away_team = team.team_id) Q2
ON Q1.match_id = Q2.match_id;