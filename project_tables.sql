/* 
 * Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku 
 * sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final 
 * (pro dodatečná data o dalších evropských státech).
 */

/*
 * potreba spojit czechia price a czechia payroll podle roku, LEFT pro price (kratsi obdobi)
 * czechia price spojit i s czechia price category (ukol 2, 3) podle category code
 * czechia payroll spojit s czechia payroll industry branch (ukol 1) podle industry code
 * czechia payroll s czechia payroll unit a czechia payroll calculation podle code pro lepsi prehlednost vysledne tabulky
 * czechia payroll value type = 5958 pro prumernou mzdu
 */

CREATE OR REPLACE TABLE t_Zana_Masarova_project_SQL_primary_final AS (
	SELECT 
		cp.payroll_year,
		cp.industry_code,
		cp.industry_name,
		cp.avg_salary,
		cp.salary_unit,
		cprc.food_category_code,
		cprc.food_category_name,
		cprc.price_per_unit,
		cprc.unit
	FROM (
		SELECT
			cprc.date_from,
			cprc.category_code AS food_category_code,
			cpc.name AS food_category_name,
			round(avg(cprc.value),2) AS price_per_unit,
			concat(cpc.price_value, ' ' ,cpc.price_unit) AS unit
		FROM czechia_price cprc 
		LEFT JOIN czechia_price_category cpc 
			ON cprc.category_code = cpc.code
		WHERE cprc.region_code IS NULL
		GROUP BY year(cprc.date_from), cprc.category_code
		) cprc
	LEFT JOIN (
		SELECT 
			cp.payroll_year,
			cp.industry_branch_code AS industry_code,
			cpib.name AS industry_name,
			round(avg(cp.value), 2) AS avg_salary,
			cpu.name AS salary_unit
		FROM czechia_payroll cp 
		LEFT JOIN czechia_payroll_industry_branch cpib 
			ON cp.industry_branch_code = cpib.code 
		LEFT JOIN czechia_payroll_unit cpu 
			ON cp.unit_code = cpu.code 
		LEFT JOIN czechia_payroll_calculation cpc 
			ON cp.calculation_code = cpc.code  
		WHERE cp.value_type_code = '5958'
		GROUP BY cp.payroll_year, cp.industry_branch_code
		) cp
		ON cp.payroll_year = YEAR(cprc.date_from)
	ORDER BY cp.payroll_year ASC, cp.industry_Code ASC, cprc.food_category_name ASC 
)


/*
 * dodatecna data pro evropske zeme
 * spojit country a economies podle statu jen pro evropsky staty s vyplnenym rokem mereni
 */

CREATE OR REPLACE TABLE t_Zana_Masarova__project_SQL_secondary_final AS (
	SELECT 
		c.country,
		e.`year`,	
		c.population,
		round(e.GDP/1000000, 2) as GDP_mio_USD,
		round(e.GDP/c.population) AS GDP_per_capita_USD,
		e.gini 
	FROM countries c 
	LEFT JOIN economies e 
		ON c.country = e.country 
	WHERE c.continent = 'Europe' AND e.`year` IS NOT NULL
	ORDER BY c.country, e.`year` DESC 
)