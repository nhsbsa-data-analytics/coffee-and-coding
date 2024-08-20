create or replace FUNCTION CC_RANKING_F_V4(
    p_geo_type          in VARCHAR2,
    p_imd_score_col     in DBMS_TF.COLUMNS_T,
    p_imd_rank_tbl      in DBMS_TF.TABLE_T,
    p_geo_mapping_tbl   in DBMS_TF.TABLE_T
) RETURN CLOB SQL_MACRO IS

/*
Coffee & Coding : Introduction to SQL Macros
SQL Table Macro Function Creation : Revise function to allow geography type to be passed as a parameter
File : 04_04_TABLE_PARAMETER

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Revised function to also accept table parameter(s) to define which tables to collect data from

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
            
from        p_imd_rank_tbl      imd
inner join  p_geo_mapping_tbl   geo on  imd.LSOA_CODE   =   geo.CHILD_ONS_CODE
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