-- Знайти список студентів у певній групі.

SELECT gr.name `group`,
    CONCAT(s.first_name, ' ', s.last_name) `student`
FROM students s
    JOIN groups gr ON s.group_id = gr.id
WHERE gr.id = 2; -- у певній групі