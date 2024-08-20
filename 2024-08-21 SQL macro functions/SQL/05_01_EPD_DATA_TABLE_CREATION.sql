/*
Coffee & Coding : Introduction to SQL Macros
Data Creation : EPD data
File : 05_01_EPD_DATA_TABLE_CREATION

AMENDMENTS:
	2024-07-30  : Steven Buckley    : Initial script created

DESCRIPTION:
    Script to create placeholder table to hold EPD dataset
    EPD data available at: https://opendata.nhsbsa.net/dataset/english-prescribing-data-epd

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------
create table CC_EPD_DATA
(
    YEAR_MONTH                      NUMBER,
    REGIONAL_OFFICE_NAME            VARCHAR2(250 BYTE),
    REGIONAL_OFFICE_CODE            VARCHAR2(250 BYTE),
    ICB_NAME                        VARCHAR2(250 BYTE),
    ICB_CODE                        VARCHAR2(250 BYTE),
    PCO_NAME                        VARCHAR2(250 BYTE),
    PCO_CODE                        VARCHAR2(250 BYTE),
    PRACTICE_NAME                   VARCHAR2(250 BYTE),
    PRACTICE_CODE                   VARCHAR2(250 BYTE),
    ADDRESS_1                       VARCHAR2(250 BYTE),
    ADDRESS_2                       VARCHAR2(250 BYTE),
    ADDRESS_3                       VARCHAR2(250 BYTE),
    ADDRESS_4                       VARCHAR2(250 BYTE),
    POSTCODE                        VARCHAR2(250 BYTE),
    BNF_CHEMICAL_SUBSTANCE          VARCHAR2(250 BYTE),
    CHEMICAL_SUBSTANCE_BNF_DESCR    VARCHAR2(250 BYTE),
    BNF_CODE                        VARCHAR2(250 BYTE),
    BNF_DESCRIPTION                 VARCHAR2(250 BYTE),
    BNF_CHAPTER_PLUS_CODE           VARCHAR2(250 BYTE),
    QUANTITY                        NUMBER,
    ITEMS                           NUMBER,
    TOTAL_QUANTITY                  NUMBER,
    ADQUSAGE                        NUMBER,
    NIC                             NUMBER,
    ACTUAL_COST                     NUMBER,
    UNIDENTIFIED                    VARCHAR2(250 BYTE)
)
;
---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------