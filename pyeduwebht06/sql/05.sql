-- Знайти, які курси читає певний викладач.

SELECT t.id,
	CONCAT(t.first_name, ' ', t.last_name) `teacher`,
    GROUP_CONCAT(sbj.name SEPARATOR ', ') `subjects`
FROM teachers t
JOIN subjects sbj ON sbj.teacher_id = t.id
WHERE t.id = 1; -- певний викладач