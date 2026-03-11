*** Settings ***
Library     Collections
Library     OperatingSystem
Library     SeleniumLibrary
Library     RequestsLibrary
Library     RPA.Excel.Files
Library     String
Resource    ..//Framework//Keywords.robot



*** Keywords ***
#Data Prep Allocation
ConfigureDataFromSpreedsheet
    [Arguments]     ${datafile}  ${worksheet_Name}     ${row_index}
    Open Workbook   ${datafile}
    ${worksheet_data}=  Read Worksheet  ${worksheet_Name}  header=True
    ${row_num}=  Set Variable  ${row_index}   # set the row number you want to read
    ${row_data}=  Get From List  ${worksheet_data}  ${row_num}
    #Log Dictionary  ${row_data}   # to verify that the data was read correctly
    #Log To Console    This is the data in the dictionary:${row_data}
    Close Workbook

    ${excel_dict}=  Create Dictionary
    FOR  ${key}  IN  @{row_data.keys()}
        ${value}=  Set Variable  ${row_data}[${key}]
        Set To Dictionary  ${excel_dict}  ${key}=${value}
    END
    Set Suite Variable  ${excel_dict}
    RETURN    ${excel_dict}

#-------------------------------------------------------
#For loop for script to run multiple times
#for a loop
ConfigureTableFromExcelForALoop
    [Arguments]     ${datafile}  ${worksheet_Name}     ${row_index}
    Open Workbook   ${datafile}
    ${worksheet_data}=  Read Worksheet  ${worksheet_Name}  header=True
    ${row_num}=  Set Variable  ${row_index}   # set the row number you want to read
    ${row_data}=  Get From List  ${worksheet_data}  ${row_num}
    Close Workbook

    ${excel_dict}=  Create Dictionary
    ${data_length}=  Get Length  ${worksheet_data}
    Set To Dictionary  ${excel_dict}  row_count=${data_length}
    FOR  ${key}  IN  @{row_data.keys()}
        ${value}=  Set Variable  ${row_data}[${key}]
        Set To Dictionary  ${excel_dict}  ${key}=${value}
    END
    Set Suite Variable  ${excel_dict}
    RETURN    ${excel_dict}
