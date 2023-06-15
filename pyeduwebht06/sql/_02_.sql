-- Такий запит поверне один рядок
-- Також у цьому запиті задається ідентифікатор предмету
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
WHERE sbj.id = 6
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
Швидше за все існує більш простий спосіб :)
Але результат правильний.
*/
SELECT id,
    student,
    "group",
    table_a.subject_id,
    "subject",
    table_a.avg_mark
FROM (
        SELECT s.id,
            CONCAT(s.first_name, ' ', s.last_name) student,
            gr.name "group",
            sbj.name "subject",
            sbj.id "subject_id",
            AVG(g.mark) avg_mark
        FROM grades g
            JOIN students s ON s.id = g.student_id
            JOIN subjects sbj ON sbj.id = g.subject_id
            JOIN groups gr ON s.group_id = gr.id
        GROUP BY s.id, sbj.id
    ) table_a
    JOIN (
        -- Знаходимо значення максимального середнього балу для кожного предмету
        SELECT subject_id,
            max(avg_mark) max_avg
        FROM (
                -- шукаємо середній бал з кожного предмету для кожного студента
                SELECT subject_id,
                    AVG(g.mark) avg_mark
                FROM grades g
                GROUP BY student_id, subject_id
            ) t
        GROUP BY subject_id
    ) table_b ON table_a.subject_id = table_b.subject_id
    AND table_a.avg_mark = table_b.max_avg
ORDER BY table_a.subject_id, id;


-- Шукаємо середній бал з кожного предмету для кожного студента і зберігаємо у 
-- тимчасовій таблиці
CREATE TEMPORARY TABLE table_a
SELECT s.id,
            CONCAT(s.first_name, ' ', s.last_name) student,
            gr.name `group`,
            sbj.name `subject`,
            sbj.id `subject_id`,
            AVG(g.mark) `avg_mark`
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
    ) table_b ON table_a.subject_id = table_b.subject_id
    AND table_a.avg_mark = table_b.max_avg
ORDER BY table_a.subject_id, id;
