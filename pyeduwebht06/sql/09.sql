-- Знайти список курсів, які відвідує студент.

SELECT s.id,
    CONCAT(s.first_name, ' ', s.last_name) `student`,
    GROUP_CONCAT(DISTINCT sbj.name SEPARATOR ', ') `subjects`
FROM students s
    JOIN grades g ON g.student_id = s.id
    JOIN subjects sbj ON sbj.id = g.subject_id
GROUP BY s.id;