import logging
import mysql.connector as mysql
from contextlib import contextmanager


@contextmanager
def create_db_connection(db_user, db_password, db_host="localhost",
                         db_port=3306, db_name=None) -> mysql.MySQLConnection:
    conn = None

    try:
        conn = mysql.connect(
            host=db_host,
            user=db_user,
            passwd=db_password,
            port=db_port,
            database=db_name
        )
        yield conn
    except mysql.Error as error:
        if conn is not None:
            conn.rollback()
        logging.info(error)
    finally:
        conn.close()
