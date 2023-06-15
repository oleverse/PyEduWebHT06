import sys
import logging
import db_tools


def main():
    logging.info(f'01. Creating database structure from "sql/db_structure.sql"...')
    db_tools.create_db_structure('sql/db_structure.sql')
    logging.info(f'02. Filling database tables with random data...')
    db_tools.seed_data()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    sys.exit(main())
