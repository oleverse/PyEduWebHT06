CREATE TABLE `students` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(256) NOT NULL,
    `last_name` VARCHAR(256) NOT NULL,
    `group_id` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `groups` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(256) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `teachers` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(256) NOT NULL,
    `last_name` VARCHAR(256) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `subjects` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(256) NOT NULL,
    `teacher_id` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `grades` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `got_at` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `mark` INT NOT NULL,
    `student_id` INT NOT NULL,
    `subject_id` INT NOT NULL,
    PRIMARY KEY (`id`)
);