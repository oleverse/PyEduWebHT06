-- Список курсів, які певному студенту читає певний викладач.

SELECT CONCAT(s.first_name, ' ', s.last_name) `student`,
    CONCAT(t.first_name, ' ', t.last_name) `teacher`,
    GROUP_CONCAT(DISTINCT sbj.name SEPARATOR ', ') `subjects`
FROM students s
    JOIN grades g ON g.student_id = s.id
    JOIN subjects sbj ON sbj.id = g.subject_id
    JOIN teachers t ON t.id = sbj.teacher_id
WHERE s.id = 11 -- певному студенту
    AND t.id = 4 -- певний викладач
GROUP BY s.id;