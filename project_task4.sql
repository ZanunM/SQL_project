-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

/* 
 * spojit primary tabulku se sebou samotnou posunutou o rok - propjit na food category
 * spocitat mezirocni narust/pokles prumerne mzdy - industry code NULL
 * spocitat mezirocni narust/pokles cen - prumer zmeny cen pro kategorie a roky
 * spocitat rozdil mezi rozdily cen - seradit a zjistit, zda nekdy byl rozdil nad 10 (procentni bod, ne procento)
 */


SELECT 
	tbl.payroll_year,
	tbl.avg_salary_perc_change,
	tbl.avg_price_perc_change,
	tbl.avg_price_perc_change - tbl.avg_salary_perc_change AS price_salary_change_diff
FROM (
	SELECT
		tbl1.payroll_year,
		tbl1.avg_salary,
		tbl2.avg_salary AS avg_salary_previous_year,
		round((((tbl1.avg_salary - tbl2.avg_salary)*100)/tbl2.avg_salary),2) AS avg_salary_perc_change,
		round(avg(((tbl1.price_per_unit - tbl2.price_per_unit)*100)/tbl2.price_per_unit),2) AS avg_price_perc_change
	FROM t_zana_masarova_project_sql_primary_final tbl1
	INNER JOIN t_zana_masarova_project_sql_primary_final tbl2
		ON tbl1.food_category_code = tbl2.food_category_code AND 
		tbl1.payroll_year = tbl2.payroll_year+1
	WHERE tbl1.industry_code IS NULL
	GROUP BY tbl1.payroll_year
	) tbl
ORDER BY price_salary_change_diff