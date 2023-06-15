-- Знайти середній бал, який ставить певний викладач зі своїх предметів.

SELECT t.id,
	CONCAT(t.first_name, ' ', t.last_name) `teacher`,
    sbj.name `subject`,
    AVG(g.mark) `subjects`
FROM grades g
    JOIN subjects sbj ON sbj.id = g.subject_id
    JOIN teachers t ON t.id = sbj.teacher_id
WHERE t.id = 2 -- певний викладач
GROUP BY sbj.id, sbj.teacher_id;