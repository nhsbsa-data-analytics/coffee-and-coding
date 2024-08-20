create or replace FUNCTION CC_RANKING_F_V2(
    p_geo_type in VARCHAR2
) RETURN CLOB SQL_MACRO IS

/*
Coffee & Coding : Introduction to SQL Macros
SQL Table Macro Function Creation : Revise function to allow geography type to be passed as a parameter
File : 04_02_GEOGRAPHY_PARAMETER

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Revised function script to handle the required geography as a parameter

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
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION)                              as IMD_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION) desc)   as IMD_RANK,
                        
            sum(imd.TOTAL_POPULATION * INCOME_SCORE) / sum(imd.TOTAL_POPULATION)                                            as INCOME_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * INCOME_SCORE) / sum(imd.TOTAL_POPULATION) desc)                 as INCOME_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * EMPLOYMENT_SCORE) / sum(imd.TOTAL_POPULATION)                                        as EMPLOYMENT_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * EMPLOYMENT_SCORE) / sum(imd.TOTAL_POPULATION) desc)             as EMPLOYMENT_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * EDUCATION_SKILLS_SCORE) / sum(imd.TOTAL_POPULATION)                                  as EDUCATION_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * EDUCATION_SKILLS_SCORE) / sum(imd.TOTAL_POPULATION) desc)       as EDUCATION_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION)                                as HEALTH_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION) desc)     as HEALTH_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * CRIME_SCORE) / sum(imd.TOTAL_POPULATION)                                             as CRIME_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * CRIME_SCORE) / sum(imd.TOTAL_POPULATION) desc)                  as CRIME_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * BARRIERS_TO_HOUSING_SCORE) / sum(imd.TOTAL_POPULATION)                               as BARRIERS_TO_HOUSING_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * BARRIERS_TO_HOUSING_SCORE) / sum(imd.TOTAL_POPULATION) desc)    as BARRIERS_TO_HOUSING_DEPRIVATION_RANK,
                        
            sum(imd.TOTAL_POPULATION * LIVING_ENVIRONMENT_SCORE) / sum(imd.TOTAL_POPULATION)                                as LIVING_ENVIRONMENT_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * LIVING_ENVIRONMENT_SCORE) / sum(imd.TOTAL_POPULATION) desc)     as LIVING_ENVIRONMENT_DEPRIVATION_RANK
            
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
-----SECTION END: RANK GEOGRAPHY BY HEALTH-DEPRIVATION------------------------------------------------------------------------------------------------
---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------