-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

/* 
 * spojit primary tabulku se sebou samotnou posunutou o rok - pak sledovat jak se meni mzda podle odvetvi - join podle industry code
 * vytvorit si podminku pro rust a pokles a podle toho pak seradit a najit jestli/kde klesala
 */

SELECT *
FROM (
	SELECT 
		tbl1.payroll_year,
		tbl1.industry_code,
		tbl1.industry_name,
		tbl1.avg_salary,
		tbl2.avg_salary AS avg_salary_previous_year,
		CASE WHEN tbl1.avg_salary - tbl2.avg_salary > 0 THEN 'salary is higher compared to previous year'
			ELSE 'salary is lower compared to previous year'
			END AS salary_change
	FROM t_zana_masarova_project_sql_primary_final tbl1
	INNER JOIN t_zana_masarova_project_sql_primary_final tbl2
		ON tbl1.industry_code =	 tbl2.industry_code AND 
		tbl1.payroll_year = tbl2.payroll_year+1
	GROUP BY tbl1.payroll_year, tbl1.industry_code
	) tbl
ORDER BY tbl.salary_change DESC, tbl.payroll_year, tbl.industry_code;