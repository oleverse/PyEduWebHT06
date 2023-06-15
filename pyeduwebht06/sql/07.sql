-- Знайти оцінки студентів в окремій групі з певного предмета.

SELECT CONCAT(s.first_name, ' ', s.last_name) `student`,
    gr.name `group`,
    sbj.name `subject`,
    g.mark
FROM grades g
    JOIN students s ON s.id = g.student_id
    JOIN subjects sbj ON sbj.id = g.subject_id
    JOIN groups gr ON s.group_id = gr.id
WHERE gr.id = 1 -- окрема група
    AND sbj.id = 3; -- з певного предмету