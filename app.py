import psycopg2
import psycopg2.extras
from flask import Flask, render_template, request

app = Flask(__name__)

def getConnection():
    connString=("dbname='footballstats' user='postgres' password='totallysecurepassword")
    conn = psycopg2.connect(connString)
    return conn

conn = None
conn = getConnection()
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
cur.execute('SET search_path to public')

@app.route('/')
def home():
	return render_template('home.html')

@app.route('/matches', methods =['GET'])
def getMatches():
    try:
        conn=None
        conn=getConnection()
        cur = conn.cursor()
        cur.execute('SET search_path to public')
        cur.execute('SELECT home_name, home_score, away_score, away_name \
                     FROM \
                     (SELECT match_id, team_name AS home_name, home_score \
                     FROM match, team \
                     WHERE home_team = team.team_id) Q1 \
                     JOIN \
                     (SELECT match_id, away_score, team_name AS away_name \
                     FROM match, team WHERE away_team = team.team_id) Q2 \
                     ON Q1.match_id = Q2.match_id;')
        rows = cur.fetchall()
        conn.commit()
        return render_template('match.html', detail = 'All matches', data = rows)
    except Exception as e:
        return render_template('matches.html', detail = 'There are no matches to be displayed')
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
	app.run(debug = True)
