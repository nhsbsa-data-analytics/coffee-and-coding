create or replace view CC_RANKING_V as
/*
Coffee & Coding : Introduction to SQL Macros
View Creation : Create a master view with all parent geographies and rank measures
File : 03_01_BASIC_VIEW

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Script to create a single master view encompassing all the required data

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------
/*
select * from CC_IMD_DATA where rownum <= 10;
select * from CC_GEO_MAPPING where rownum <= 10;
select distinct RELATIONSHIP from CC_GEO_MAPPING;
*/

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
group by    geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
;
-----SECTION END: RANK GEOGRAPHY BY HEALTH-DEPRIVATION------------------------------------------------------------------------------------------------
---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------