/*
Coffee & Coding : Introduction to SQL Macros
Scratchpad

*/
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Review raw datasets---------------------------------------------------------------------------------------------------------------

--review the IMD data table
select * from CC_IMD_DATA where rownum <= 10;

--count the number of records (should be 32844, one for each LSOA)
select      sum(1)                      as RCOUNT,
            count(distinct(LSOA_CODE))  as LSOA_COUNT
from        CC_IMD_DATA;


--review the GEO_MAPPING data table
select * from CC_GEO_MAPPING where rownum <= 10;

--count the number of records and geographic areas in each relationship
select      RELATIONSHIP,
            sum(1)                              as RCOUNT,
            count(distinct(CHILD_ONS_CODE))     as LSOA_COUNT,
            count(distinct(PARENT_ONS_CODE))    as PARENT_GEO_COUNT
from        CC_GEO_MAPPING
group by    RELATIONSHIP
order by    RELATIONSHIP
;
-----SECTION END: Review raw datasets-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Basic analysis on IMD and geography data------------------------------------------------------------------------------------------
--the view is created in file 02_01_BASIC_ANALYSIS


-----SECTION END: Basic analysis on geography data----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Review the view output------------------------------------------------------------------------------------------------------------
--the view is created in file 03_01_BASIC_VIEW

--review the output
select * from CC_RANKING_V;

--use the view to find the HEALTH_DEPRIVATION ranks for Local Authority Districts
select      PARENT_GEOGRAPHY,
            PARENT_ONS_CODE,
            PARENT_NAME,
            HEALTH_DEPRIVATION_AVG_SCORE,
            HEALTH_DEPRIVATION_RANK
from        CC_RANKING_V
where       1=1
    and     PARENT_GEOGRAPHY = 'LAD2023'
order by    HEALTH_DEPRIVATION_RANK
;
-----SECTION END: Review the view output--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Function V1 call------------------------------------------------------------------------------------------------------------------
--the function is created in file 04_01_BASIC_FUNCTION
--essentially mimicing the view

--review the output
select * from CC_RANKING_F_V1();

--use the function to find the HEALTH_DEPRIVATION ranks for Local Authority Districts
select      PARENT_GEOGRAPHY,
            PARENT_ONS_CODE,
            PARENT_NAME,
            HEALTH_DEPRIVATION_AVG_SCORE,
            HEALTH_DEPRIVATION_RANK
from        CC_RANKING_F_V1()
where       1=1
    and     PARENT_GEOGRAPHY = 'LAD2023'
order by    HEALTH_DEPRIVATION_RANK
;
-----SECTION END: Function V1 call--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Function V2 call------------------------------------------------------------------------------------------------------------------
--the function is created in file 04_02_GEOGRAPHY_PARAMETER
--this introduces a parameter to limit the geography returned

--the function requires a parameter and will produce an error is this is not supplied
select * from CC_RANKING_F_V2();

--use the function to find the HEALTH_DEPRIVATION ranks for Local Authority Districts
select      PARENT_GEOGRAPHY,
            PARENT_ONS_CODE,
            PARENT_NAME,
            HEALTH_DEPRIVATION_AVG_SCORE,
            HEALTH_DEPRIVATION_RANK
from        CC_RANKING_F_V2(p_geo_type => 'LAD2023')
--from        CC_RANKING_F_V2('LAD2023')
where       1=1
order by    HEALTH_DEPRIVATION_RANK
;
-----SECTION END: Function V2 call--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Function V3 call------------------------------------------------------------------------------------------------------------------
--the function is created in file 04_03_COLUMN_PARAMETER
--this introduces a parameter to define which IMD column to rank data by

--use the function to find the HEALTH_DEPRIVATION ranks for Local Authority Districts
select * from CC_RANKING_F_V3(p_geo_type => 'LAD2023', p_imd_score_col => columns(HEALTH_DEPRIVATION_SCORE));

--what if we want ranks by IMD score
select * from CC_RANKING_F_V3   (
                                p_geo_type => 'LAD2023',
                                p_imd_score_col => columns(INDEX_OF_MULT_DEPRIV_SCORE)
                                );
-----SECTION END: Function V3 call--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Function V4 call------------------------------------------------------------------------------------------------------------------
--the function is created in file 04_04_TABLE_PARAMETER
--this introduces parameters to define which tables to source data from
--this will allow the same function to be used for different tables (as long as expected columns are included in the tables

select * from CC_RANKING_F_V4   (
                                p_geo_type => 'LAD2023',
                                p_imd_score_col => columns(INDEX_OF_MULT_DEPRIV_SCORE),
                                p_imd_rank_tbl => CC_IMD_DATA,
                                p_geo_mapping_tbl => CC_GEO_MAPPING
                                );

--create alternative version of the CC_IMD_DATA table
create table CC_IMD_DATA_V2 as select * from CC_IMD_DATA;

--rerun query passing the new table
select * from CC_RANKING_F_V4   (
                                p_geo_type => 'LAD2023',
                                p_imd_score_col => columns(INDEX_OF_MULT_DEPRIV_SCORE),
                                p_imd_rank_tbl => CC_IMD_DATA_V2,
                                p_geo_mapping_tbl => CC_GEO_MAPPING
                                );
-----SECTION END: Function V4 call--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



/*
The IMD example gives a taste of how the functions can be used
Where the SQL functions really add value is handling queries that wouldn't be possible in regular views
One example would be where you might want to perform distinct counts over different aggregations
*/



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: Review of function using EPD data-------------------------------------------------------------------------------------------------
/*
The EPD data from the Open Data portal includes prescribing data split by prescribing account and drug

For this example we might want to query the data to find the proportion of practices that are prescribing certain drugs
This may be something we want to do to identify if practices are prescribing unusually high quantities
*/

--review the EPD dataset (sourced from https://opendata.nhsbsa.net/dataset/english-prescribing-data-epd)
select * from CC_EPD_DATA where rownum <= 10;
select      YEAR_MONTH, 
            sum(1)  as RCOUNT
from        CC_EPD_DATA
group by    YEAR_MONTH 
order by    YEAR_MONTH
;


/*
Create a query to identify the proportion of practices in each ICB that are:
  (A) prescribing any Paracetmol products
  (B) prescribing more than 250 Paracetamol 500mg Tablets to a patient on a single prescription
*/
with
identify_overall_practice_counts as
(
--identify the total number of practices
select      ICB_NAME,
            count(distinct(PRACTICE_CODE))  as TOTAL_PRACTICES
from        CC_EPD_DATA
where       1=1
group by    ICB_NAME
)
,
identify_chemsub_practice_counts as
(
--identify the total number of practices with prescribing of any Paracetamol products
select      ICB_NAME,
            count(distinct(PRACTICE_CODE)) as PRACTICES_WITH_CHEMSUB_RULE
from        CC_EPD_DATA
where       1=1
    and     BNF_CHEMICAL_SUBSTANCE = '0407010H0'   --Paracetamol
group by    ICB_NAME
)
,
identify_drug_practice_counts as
(
--identify the total number of practices with prescribing of more than 250 Paracetamol 500mg Tablets
select      ICB_NAME,            
            count(distinct(PRACTICE_CODE))  as PRACTICES_WITH_DRUG_RULE
from        CC_EPD_DATA
where       1=1
    and     BNF_CODE = '0407010H0AAAMAM'
    and     QUANTITY >= 251
group by    ICB_NAME
)
--calculate the proportion of practices
select      iopc.ICB_NAME,
            iopc.TOTAL_PRACTICES,
            icpc.PRACTICES_WITH_CHEMSUB_RULE,
            round(icpc.PRACTICES_WITH_CHEMSUB_RULE / iopc.TOTAL_PRACTICES * 100, 1) as PROP_PRACTICES_WITH_CHEMSUB_RULE,
            idpc.PRACTICES_WITH_DRUG_RULE,
            round(idpc.PRACTICES_WITH_DRUG_RULE / iopc.TOTAL_PRACTICES * 100, 1)    as PROP_PRACTICES_WITH_DRUG_RULE
from        identify_overall_practice_counts    iopc
left join   identify_chemsub_practice_counts    icpc    on  iopc.ICB_NAME   =   icpc.ICB_NAME
left join   identify_drug_practice_counts       idpc    on  iopc.ICB_NAME   =   idpc.ICB_NAME
order by    iopc.ICB_NAME
;



/*
A SQL function (see 05_02_EPD_FUNCTION) can be used to reduce repetition of code
When developing the function we may want to consider future requirements and code accordingly
This will allow more generalised functions to be created
*/
select      ovr.GEO_NAME,
            ovr.PRACTICES_WITH_ACTIVITY                                                 as TOTAL_PRACTICES,
            chem.PRACTICES_WITH_ACTIVITY                                                as PRACTICES_WITH_CHEMSUB_RULE,
            round(chem.PRACTICES_WITH_ACTIVITY / ovr.PRACTICES_WITH_ACTIVITY * 100, 1)  as PROP_PRACTICES_WITH_CHEMSUB_RULE,
            drug.PRACTICES_WITH_ACTIVITY                                                as PRACTICES_WITH_DRUG_RULE,
            round(drug.PRACTICES_WITH_ACTIVITY / ovr.PRACTICES_WITH_ACTIVITY * 100, 1)  as PROP_PRACTICES_WITH_DRUG_RULE
--identify the overall number of practices
from        CC_EPD_FUNCTION (
                            p_geo_col => columns(ICB_NAME),
                            p_bnf_col => columns(BNF_CHEMICAL_SUBSTANCE)
                            )                                               ovr
--use function to identify the total number of practices with prescribing of any Paracetamol products
left join   CC_EPD_FUNCTION (
                            p_geo_col => columns(ICB_NAME),
                            p_bnf_col => columns(BNF_CHEMICAL_SUBSTANCE), 
                            p_bnf_code => '0407010H0'
                            )                                               chem    on  ovr.GEO_NAME = chem.GEO_NAME
--identify the total number of practices with prescribing of more than 500 Paracetamol 500mg Tablets
left join   CC_EPD_FUNCTION (
                            p_geo_col => columns(ICB_NAME),
                            p_bnf_col => columns(BNF_CODE), 
                            p_bnf_code => '0407010H0AAAMAM', 
                            p_qty_threshold => 251
                            )                                               drug    on  ovr.GEO_NAME = drug.GEO_NAME

order by    ovr.GEO_NAME
;

/*
QUESTION: What if we wanted amend our code to only look at activity in specific YEAR_MONTH (202405) or instead of aggregating by ICB we want Region breakdowns
*/


/*
Amending the code above without the function will require the following changes:
  (1) ICB_NAME will need to be replaced with REGIONAL_OFFICE_NAME everywhere it is used
  (2) The YEAR_MONTH filters will need adding to each CTE block
*/



/*
When we developed the SQL macro we already considered these potential amendments so only minor tweaks are required to the function calls
We can change the column defined for p_geo_col to add the time period filters to replace the defaults which covered everything
    (1) p_geo_col => columns(REGIONAL_OFFICE_NAME)
    (2) p_min_ym => 202405, p_max_ym => 202405
*/

-----SECTION END: Review of function using EPD data---------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
-----SECTION START: CODE CLEANUP----------------------------------------------------------------------------------------------------------------------
--create statements to remove all objects created as part of this session
--STMTs produced should be checked before pasted into SQL worksheet and executed
select      'DROP '||OBJECT_TYPE||' '||OBJECT_NAME||';' as STMT
from        USER_OBJECTS
where       1=1
    and     OBJECT_NAME like 'CC_%'
    and     OBJECT_TYPE in ('TABLE','VIEW','FUNCTION')
    and     CREATED >= trunc(sysdate) --limit to objects created today
order by    OBJECT_TYPE, OBJECT_NAME
;
-----SECTION END: CODE CLEANUP------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------