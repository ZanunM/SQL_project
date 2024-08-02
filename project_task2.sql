-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

/*
 * data z tabulky pro dané potraviny - mléko 114201, chleba 111301
 * vypocitat salary/value - pro industry code NULL (prumer ve vsech odvetvich)
 * union - seradit vzestupne podle roku a code - limitovat na 2 & seradit sestupne podle roku a code - limitovat na 2
 */

SELECT *
FROM (
	SELECT 	
		tbl.payroll_year AS 'year',
		tbl.avg_salary,
		tbl.salary_unit,
		tbl.food_category_name,
		round((tbl.avg_salary/tbl.price_per_unit)) AS quantity_bought,
		tbl.unit 
	FROM t_zana_masarova_project_sql_primary_final tbl
	WHERE industry_code IS NULL AND 
		food_category_code IN ('114201', '111301')
	ORDER BY tbl.payroll_year ASC 
	LIMIT 2
	) first_year
UNION 
SELECT *
	FROM (
	SELECT 	
		tbl.payroll_year AS 'year',
		tbl.avg_salary,
		tbl.salary_unit,
		tbl.food_category_name,
		round((tbl.avg_salary/tbl.price_per_unit)) AS quantity_bought,
		tbl.unit 
	FROM t_zana_masarova_project_sql_primary_final tbl
	WHERE industry_code IS NULL AND 
		food_category_code IN ('114201', '111301')
	ORDER BY tbl.payroll_year DESC  
	LIMIT 2
	) last_year