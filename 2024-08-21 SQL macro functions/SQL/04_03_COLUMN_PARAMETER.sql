create or replace FUNCTION CC_RANKING_F_V3(
    p_geo_type      in VARCHAR2,
    p_imd_score_col in DBMS_TF.COLUMNS_T
) RETURN CLOB SQL_MACRO IS

/*
Coffee & Coding : Introduction to SQL Macros
SQL Table Macro Function Creation : Revise function to allow geography type to be passed as a parameter
File : 04_03_COLUMN_PARAMETER

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Revised function to also accept a column parameter to define which IMD score column to base rankings on

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

--define variable to hold created sql statement
v_sql clob;

BEGIN
v_sql := '
select      geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * '||p_imd_score_col(1)||') / sum(imd.TOTAL_POPULATION)                            as IMD_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * '||p_imd_score_col(1)||') / sum(imd.TOTAL_POPULATION) desc) as IMD_RANK
            
from        CC_IMD_DATA     imd
inner join  CC_GEO_MAPPING  geo on  imd.LSOA_CODE   =   geo.CHILD_ONS_CODE
where       1=1
    and     geo.PARENT_GEOGRAPHY = p_geo_type
group by    geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
';

RETURN v_sql;

END;
---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------