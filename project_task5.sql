/*
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
 * projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */

/*
 * zmeny mezd a cen z predchoziho ukolu
 * zmena HDP z druhe tabulky - postup jako u posuzovani mezd a cen - propojit se sebou samou o rok drive
 * obe tabulky spojit do jedne podle roku, pro data o CR v druhe tabulce
 */

SELECT
	tbl_sal_pr.payroll_year,
	tbl_sal_pr.avg_salary_perc_change,
	tbl_sal_pr.avg_price_perc_change,
	tbl_gdp.GDP_perc_change
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
	) tbl_sal_pr
LEFT JOIN (
	SELECT 
		tbl3.`year`,
		tbl3.GDP_mio_USD,
		tbl4.`year` AS previous_year, 
		tbl4.GDP_mio_USD AS GDP_previous_year,
		round((((tbl3.GDP_mio_USD - tbl4.GDP_mio_USD)*100)/tbl4.GDP_mio_USD),2) AS GDP_perc_change
	FROM t_zana_masarova__project_sql_secondary_final tbl3
	LEFT JOIN t_zana_masarova__project_sql_secondary_final tbl4
	ON tbl3.`year` = tbl4.`year`+1 AND 
	tbl3.country = tbl4.country		 
	WHERE tbl3.country = 'Czech Republic'
	) tbl_gdp
ON tbl_sal_pr.payroll_year = tbl_gdp.`year`
ORDER BY tbl_sal_pr.payroll_year
