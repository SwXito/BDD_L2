import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    user = 'postgres',
    dbname = 'projet',
    host = 'localhost',
    password = 'rouge2003',
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True
  return conn

