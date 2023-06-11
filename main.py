import logging
from pathlib import Path
from configparser import ConfigParser


def get_config():
    config_file = Path('config') / Path('db.ini')
    config = ConfigParser()
    config.read(config_file)

    return config


def main():
    logging.basicConfig(level=logging.DEBUG)

    db_config = get_config()


if __name__ == "__main__":
    main()
