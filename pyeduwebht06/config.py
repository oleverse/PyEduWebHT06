from pathlib import Path
from configparser import ConfigParser


def get_config(config_file):
    config_file = Path(config_file)
    if not config_file.is_file():
        print("DB config file doesn't exist.")
        return False

    config = ConfigParser()
    config.read(config_file)

    return config


def get_db_params(config_file):
    if db_config := get_config(config_file):
        return (
            db_config['database']['db_user'],
            db_config['database']['db_password'],
            db_config['database']['db_host'],
            db_config['database']['db_port'],
            db_config['database']['db_name']
        )
