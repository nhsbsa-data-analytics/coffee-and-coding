/*
Coffee & Coding : Introduction to SQL Macros
Data Creation : IMD Data
File : 01_01_IMD_DATA

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Script to create placeholder table to hold IMD dataset

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

CREATE TABLE CC_IMD_DATA
(
    LSOA_CODE                   VARCHAR2(30 BYTE), 
	LSOA_NAME                   VARCHAR2(150 BYTE), 
	TOTAL_POPULATION            NUMBER(6,0), 
	INDEX_OF_MULT_DEPRIV_SCORE  NUMBER(6,3), 
	INDEX_OF_MULT_DEPRIV_RANK   NUMBER(6,0), 
	INCOME_SCORE                NUMBER(6,3), 
	INCOME_RANK                 NUMBER(6,0), 
	EMPLOYMENT_SCORE            NUMBER(6,3), 
	EMPLOYMENT_RANK             NUMBER(6,0), 
	EDUCATION_SKILLS_SCORE      NUMBER(6,3), 
	EDUCATION_SKILLS_RANK       NUMBER(6,0), 
	HEALTH_DEPRIVATION_SCORE    NUMBER(6,3), 
	HEALTH_DEPRIVATION_RANK     NUMBER(6,0), 
	CRIME_SCORE                 NUMBER(6,3), 
	CRIME_RANK                  NUMBER(6,0), 
	BARRIERS_TO_HOUSING_SCORE   NUMBER(6,3), 
	BARRIERS_TO_HOUSING_RANK    NUMBER(6,0), 
	LIVING_ENVIRONMENT_SCORE    NUMBER(6,3), 
	LIVING_ENVIRONMENT_RANK     NUMBER(6,0)
)
;

---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


