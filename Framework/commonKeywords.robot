*** Settings ***
Library     Collections
Library     OperatingSystem
Library     SeleniumLibrary
Library     RequestsLibrary
Library     RPA.Excel.Files
Library     RPA.PDF
Library     String
Library     DateTime
#Library    RPA.Desktop.Windows
Resource    ..//Framework//Variable.robot
Resource    ..//Framework//Keywords.robot
Resource    ..//Framework//DataFileConfig.robot
Resource    Keywords.robot

*** Keywords ***
Open Local HTML And Maximize
    Open Browser    ${LOCAL_HTML}    chrome
    Maximize Browser Window