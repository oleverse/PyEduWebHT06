-- Знайти 5 студентів із найбільшим середнім балом з усіх предметів.
SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) student,
    gr.name `group`,
    AVG(g.mark) avg_mark
FROM grades g
    JOIN students s ON s.id = g.student_id
    JOIN groups gr ON s.group_id = gr.id
GROUP BY s.id
ORDER BY avg_mark DESC
LIMIT 5;