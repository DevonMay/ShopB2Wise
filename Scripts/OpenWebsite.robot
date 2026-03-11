*** Settings ***
Library     Collections
Library     OperatingSystem
Library     SeleniumLibrary
Library     RequestsLibrary
Library     RPA.Excel.Files
Library     DynamicTestCases.py
Resource    ..//Framework//Keywords.robot
Resource    ..//Framework//Variable.robot
Resource    ..//Framework//DataFileConfig.robot
Resource    ..//Framework//commonKeywords.robot

*** Test Cases ***
Open ShopB2Wise
    [Tags]  Regression  Validation
    Set Selenium Speed    0.300
    ${excel_dict}=    ConfigureTableFromExcelForALoop     ${Datafile}    Sheet1   0  #this is the row after the header in excel
    FOR    ${row_index}    IN RANGE    0    ${excel_dict.row_count}
        ConfigureTableFromExcelForALoop     ${Datafile}    Sheet1   ${row_index}
        ${excel_dict}=    ConfigureTableFromExcelForALoop     ${Datafile}   Sheet1   ${row_index}
        Set Global Variable    ${Global_index4}    ${row_index}
        Set Global Variable    ${ReportSheet}    AddressValidation
        Run Keyword    OpenWebsite
        Run Keyword    Close Browser
    END