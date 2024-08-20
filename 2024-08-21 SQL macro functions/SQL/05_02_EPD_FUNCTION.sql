create or replace FUNCTION CC_EPD_FUNCTION(
    p_geo_col       in DBMS_TF.COLUMNS_T,
    p_bnf_col       in DBMS_TF.COLUMNS_T,
    p_bnf_code      in VARCHAR2 default '*',
    p_qty_threshold in NUMBER default 0,
    p_min_ym        in NUMBER default 200001,
    p_max_ym        in NUMBER default 209912
) RETURN CLOB SQL_MACRO IS

/*
Coffee & Coding : Introduction to SQL Macros
SQL Table Macro Function Creation : Generic function to identify count of practices by parent geography with specific prescribing activity
File : 05_02_EPD_FUNCTION

AMENDMENTS:
	2024-07-30  : Steven Buckley    : Initial script created

DESCRIPTION:
    Function to query the CC_EPD_DATA table to identify the number of practices, aggregated by parent geography, with prescribing based on defined parameters
    Include parameters to limit the time period between two supplied YEAR_MONTH values
    
    Using p_geo_col will allow the end user to specify which geography they would like to aggregate results for
        p_geo_col must be specified as no defaults are allowed
    Using p_bnf_col will allow the end user to specify which drug column they want to apply a filter on
        p_bnf_col must be specified as no defaults are allowed
    Using p_bnf_code will allow a BNF code to be applied for the specific column for p_bnf_col
        The default value of * is handled in the code to allow this to be applied as a wildcard to return all records
    Using p_qty_threshold will allow the results to be limited to records with above a specific quantity
        The default value of 0 will include all records as the minimum value is 0
        The function could be further developed to replace this with filters for values in a column specified by a different parameter
    Using p_min_ym and p_max_ym allows a time period for analysis to be defined        

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

--define variable to hold created sql statement
v_sql clob;

BEGIN
v_sql := '
select      '||p_geo_col(1)||'              as GEO_NAME,
            count(distinct(PRACTICE_CODE))  as PRACTICES_WITH_ACTIVITY
from        CC_EPD_DATA
where       1=1
    and     (   '||p_bnf_col(1)||' = p_bnf_code
            or  p_bnf_code = ''*''  --allow * to be used as a wildcard to include all drugs
            )
    and     QUANTITY >= p_qty_threshold
    and     YEAR_MONTH between p_min_ym and p_max_ym
group by    '||p_geo_col(1)||'
';

RETURN v_sql;

END;
---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------