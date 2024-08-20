/*
Coffee & Coding : Introduction to SQL Macros
Basic Analysis : Calculate IMD ranks per Local Authority District
File : 02_01_BASIC_ANALYSIS

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Script to perform basic analysis on the imported datasets
    
    Includes calculating deprivation ranks for geographies above LSOA (e.g. Local Authority)

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------
/*
select * from CC_IMD_DATA where rownum <= 10;
select * from CC_GEO_MAPPING where rownum <= 10;
select distinct RELATIONSHIP from CC_GEO_MAPPING;
*/


-----SECTION START: RANK LOCAL AUTHORITY BY IMD-------------------------------------------------------------------------------------------------------
--How do we rank Local Authority District by deprivation
--We can combine the two tables and use the defined calculation to identify the ranks at Local Authority District level

--The ranks are based on the "Average score for parent geography"
--Average score for parent geography = sum(Sum of population * IMD score for each LSOA) / Sum(LSOA populations within parent geography)


select      geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE)                                                          as IMD_COMBINED_SCORE,
            sum(imd.TOTAL_POPULATION)                                                                                       as TOTAL_POPULATION,
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION)                              as IMD_AVG_SCORE,
            rank() over (order by sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION) desc)  as IMD_RANK
from        CC_GEO_MAPPING  geo
inner join  CC_IMD_DATA     imd on  geo.CHILD_ONS_CODE = imd.LSOA_CODE
where       1=1
    and     geo.RELATIONSHIP = 'LSOA11_LAD2023'
group by    geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
;
-----SECTION END: RANK LOCAL AUTHORITY BY IMD---------------------------------------------------------------------------------------------------------



-----SECTION START: RANK SUB-ICB LOCATION BY IMD------------------------------------------------------------------------------------------------------
--What if we wanted to switch to a different geography level

--We could amend our code to limit to SUB-ICB locations
select      geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION)                              as IMD_AVG_SCORE,
            rank() over (order by sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION) desc)  as IMD_RANK
from        CC_IMD_DATA     imd
inner join  CC_GEO_MAPPING  geo on  imd.LSOA_CODE   =   geo.CHILD_ONS_CODE
where       1=1
    and     geo.RELATIONSHIP = 'LSOA11_SICBL2023'
group by    geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
;

--Or we could amend the code to include all parent geographies and handle the geography filter afterwards
select      geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION)                              as IMD_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION) desc)   as IMD_RANK
from        CC_IMD_DATA     imd
inner join  CC_GEO_MAPPING  geo on  imd.LSOA_CODE   =   geo.CHILD_ONS_CODE
where       1=1
group by    geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
;
-----SECTION END: RANK SUB-ICB LOCATION BY IMD--------------------------------------------------------------------------------------------------------



-----SECTION START: RANK GEOGRAPHY BY HEALTH-DEPRIVATION----------------------------------------------------------------------------------------------
--What if we wanted to look at a specific deprivation measure other than IMD

--We could amend our code to reflect the required deprivation fields
select      geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION)                                as HEALTH_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION) desc)     as HEALTH_DEPRIVATION_RANK
from        CC_IMD_DATA     imd
inner join  CC_GEO_MAPPING  geo on  imd.LSOA_CODE   =   geo.CHILD_ONS_CODE
where       1=1
group by    geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME
;

--Or we could include multiple ranks in the output
select      geo.PARENT_GEOGRAPHY,
            geo.PARENT_ONS_CODE,
            geo.PARENT_NAME,
            sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION)                              as IMD_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * INDEX_OF_MULT_DEPRIV_SCORE) / sum(imd.TOTAL_POPULATION) desc)   as IMD_RANK,
            sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION)                                as HEALTH_DEPRIVATION_AVG_SCORE,
            rank() over (
                        partition by geo.PARENT_GEOGRAPHY
                        order by sum(imd.TOTAL_POPULATION * HEALTH_DEPRIVATION_SCORE) / sum(imd.TOTAL_POPULATION) desc)     as HEALTH_DEPRIVATION_RANK
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