-- Знайти студента із найвищим середнім балом з певного предмету.

/*
SELECT s.id,
    CONCAT(s.first_name, ' ', s.last_name) student,
    gr.name "group",
    sbj.name "subject",
    AVG(g.mark) avg_mark
FROM grades g
    JOIN students s ON s.id = g.student_id
    JOIN subjects sbj ON sbj.id = g.subject_id
    LEFT JOIN groups gr ON s.group_id = gr.id
WHERE sbj.id = 6 -- з певного предмету
GROUP BY s.id, sbj.id
ORDER by avg_mark DESC
LIMIT 1;
*/

/*
Але метою було наступне: для всіх предметів вивести перелік усіх студентів,
чиї середні бали співпадали з максимальним середнім балом у розрізі
предметів.
*/


/*
Можливо існує більш простий спосіб :)
Але результат правильний.
Спочатку був варіант без створення тимчасової таблиці, але тоді логіка дублювалася у підзапиті, хоча і було
використано лише таблицю grades, оскікльки імена і назви були у підзапиті не потрібними.
Такий запит є у файлі 02.sql
*/
-- Шукаємо середній бал з кожного предмету для кожного студента і зберігаємо у
-- тимчасовій таблиці всю інфо про вибраних студентів
CREATE TEMPORARY TABLE table_a
SELECT s.id,
    CONCAT(s.first_name, ' ', s.last_name) student,
    gr.name `group`,
    sbj.name `subject`,
    sbj.id `subject_id`,
    -- перетворюємо тип явно, щоб запобігти попередженням типу:
    -- "Data truncated for column `avg_mark`"
    CAST(AVG(g.mark) AS FLOAT) `avg_mark`
FROM grades g
    JOIN students s ON s.id = g.student_id
    JOIN subjects sbj ON sbj.id = g.subject_id
    JOIN groups gr ON s.group_id = gr.id
GROUP BY s.id, sbj.id;

SELECT id,
    student,
    `group`,
    table_a.subject_id,
    `subject`,
    table_a.avg_mark
FROM table_a
    JOIN (
        -- Базуючись на раніше створеній тимчасовій таблиці,
        -- знаходимо значення максимального середнього балу для кожного предмету
        SELECT subject_id,
            max(avg_mark) max_avg
        FROM table_a
        GROUP BY subject_id
    -- об'єднуємо результати за критерієм ID предметів і середнього балу з максимальним
    ) table_b ON table_a.subject_id = table_b.subject_id
    AND table_a.avg_mark = table_b.max_avg
ORDER BY table_a.subject_id, id;
