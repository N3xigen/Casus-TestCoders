*** Settings ***
Documentation    Keywords specifiek voor Frontend testen
Resource         ../resources/variables.resource
Resource         ../resources/keywords.resource


*** Keywords ***
FE Setup
    [Documentation]    Testomgeving opzetten voor frontend testen
    Browser & Website Openen
    Log    Browser geopend, frontend test begint

FE Teardown
    [Documentation]    Testomgeving opruimen na frontend testen
    Close Browser
    Log    Browser afgesloten, frontend test voltooid
