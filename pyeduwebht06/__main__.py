import sys
import logging
import db_tools


def main():
    print(f'01. Creating database structure from "sql/db_structure.sql"...')
    if not db_tools.create_db_structure():
        db_tools.drop_database_tables()
        db_tools.create_db_structure()
    print(f'02. Filling database tables with random data...')
    db_tools.seed_data()
    print(f'03. Executing numbered queries from "sql" directory...')
    db_tools.queries_demo()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    sys.exit(main())
