/*
Coffee & Coding : Introduction to SQL Macros
Data Creation : Geography Mapping Data
File : 01_02_GEO_MAPPING

AMENDMENTS:
	2024-07-29  : Steven Buckley    : Initial script created

DESCRIPTION:
    Script to create placeholder table to hold geography mapping dataset

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

CREATE TABLE CC_GEO_MAPPING
(
    RELATIONSHIP        VARCHAR2(50 BYTE), 
	CHILD_GEOGRAPHY     VARCHAR2(50 BYTE), 
	CHILD_ONS_CODE      VARCHAR2(50 BYTE), 
	CHILD_NAME          VARCHAR2(500 BYTE), 
	PARENT_GEOGRAPHY    VARCHAR2(180 BYTE), 
	PARENT_ONS_CODE     VARCHAR2(50 BYTE), 
	PARENT_NAME         VARCHAR2(500 BYTE)
)
;

---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


