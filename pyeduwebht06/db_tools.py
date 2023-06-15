import datetime
import logging
import random
from pathlib import Path

import faker.providers
from faker import Faker

from config import get_db_params
from connection import create_db_connection

DB_PARAMS = get_db_params('conf/db.ini')

groups_provider = faker.providers.DynamicProvider(
    provider_name="edu_groups_shortcuts",
    elements=[f"{''.join(random.choices([chr(c) for c in range(ord('К'), ord('Ш'))], k=random.randint(2,3)))}-"
              f"{random.choice(range(18, 23))}" for _ in range(3)]
)

subjects_provider = faker.providers.DynamicProvider(
    provider_name="edu_subjects",
    elements=["Вища математика", "Українська мова", "Архітектура",
              "Програмування", "Бази даних", "Філософія",
              "Економіка", "Технології виробництва"]
)


def create_db_structure(sql_path):
    if not Path(sql_path).exists():
        logging.debug(f'"{sql_path}" does not exist')
        return False

    with open(sql_path, 'r') as sql_fh, create_db_connection(*DB_PARAMS) as conn:
        cursor = conn.cursor()
        cursor.execute(sql_fh.read(), multi=True)
        logging.info("The structure has been created.")
        cursor.close()


def get_all_ids(table_name):
    with create_db_connection(*DB_PARAMS) as conn:
        cursor = conn.cursor()
        cursor.execute(f"SELECT id FROM {table_name}")
        ids = [i[0] for i in cursor.fetchall()]
        cursor.close()
        return ids


def insert_data(sql_statement, data):
    with create_db_connection(*DB_PARAMS) as conn:
        cursor = conn.cursor()
        cursor.executemany(sql_statement, data)
        conn.commit()
        cursor.close()


def add_students(students):
    insert_data("INSERT INTO students(first_name, last_name, group_id) VALUES(%s, %s, %s)", students)
    logging.info("Students added.")


def add_groups(groups):
    insert_data("INSERT INTO groups(name) VALUES(%s)", groups)
    logging.info("Groups added.")


def add_teachers(teachers):
    insert_data("INSERT INTO teachers(first_name, last_name) VALUES(%s, %s)", teachers)
    logging.info("Teachers added.")


def add_subjects(subjects):
    insert_data("INSERT INTO subjects(name, teacher_id) VALUES(%s, %s)", subjects)
    logging.info("Subjects added.")


def add_grades(grades):
    insert_data("INSERT INTO grades(got_at, mark, student_id, subject_id) VALUES(%s, %s, %s, %s)", grades)
    logging.info("Grades added.")


def seed_data():
    Faker.seed(0)
    real_faker = Faker(locale="uk_UA")
    real_faker.seed_instance(0)
    real_faker.add_provider(groups_provider)
    real_faker.add_provider(subjects_provider)

    groups = [(real_faker.unique.edu_groups_shortcuts(),) for _ in range(3)]
    add_groups(groups)

    students = [(real_faker.first_name(), real_faker.last_name(),
                 random.choice(get_all_ids('groups')))
                for _ in range(random.randint(30, 50))]
    add_students(students)

    teachers = [(real_faker.first_name(), real_faker.last_name()) for _ in range(random.randint(3, 5))]
    add_teachers(teachers)

    subjects = [(real_faker.unique.edu_subjects(), random.choice(get_all_ids('teachers')))
                for _ in range(random.randint(5, 8))]
    add_subjects(subjects)

    students_ids = get_all_ids('students')
    students_count = len(students_ids)
    date_range = datetime.date(2018, 9, 1), datetime.date(2023, 6, 1)
    grades = []
    for student in students_ids:
        grades.extend([(real_faker.date_time_between_dates(*date_range),
                        random.randint(2, 5),
                        student,
                        random.choice(get_all_ids('subjects')))
                       for _ in range(random.randint(15, 20))])
    add_grades(grades)

    # logging.debug(real_faker.first_name())
