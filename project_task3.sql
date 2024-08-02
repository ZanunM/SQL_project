-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

/* 
 * spojit primary tabulku se sebou samotnou posunutou o rok - propojit na good category
 * spocitat prumerny narust/pokles ceny potravin podle kategorii - prumer za vsechny roky a seradit podle rustu vzestupne
 */

SELECT 
	tbl1.food_category_code,
	tbl1.food_category_name,
	round(avg(((tbl1.price_per_unit-tbl2.price_per_unit)*100)/tbl2.price_per_unit),2) AS avg_price_change_perecentage
FROM t_zana_masarova_project_sql_primary_final tbl1
INNER JOIN t_zana_masarova_project_sql_primary_final tbl2
	ON tbl1.food_category_code = tbl2.food_category_code AND 
	tbl1.payroll_year = tbl2.payroll_year+1
GROUP BY tbl1.food_category_code
ORDER BY avg_price_change_perecentage