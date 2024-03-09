import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    dbname = 'damien.touati_db',
    host = 'sqletud.u-pem.fr',
    password = 'ok',
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True
  return conn