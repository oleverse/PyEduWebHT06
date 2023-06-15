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