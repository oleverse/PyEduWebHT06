-- Знайти середній бал у групах з певного предмета.
SELECT gr.name `group`,
    sbj.name `subject`,
    AVG(g.mark) `avg_mark`
FROM grades g
    JOIN students s ON s.id = g.student_id
    JOIN subjects sbj ON sbj.id = g.subject_id
    JOIN groups gr ON s.group_id = gr.id
GROUP BY gr.id,
    g.subject_id
ORDER BY `group`,
    `avg_mark`;