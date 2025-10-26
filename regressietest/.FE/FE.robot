*** Settings ***
Documentation    Frontend testsuite voor TestRPG website
...              Bevat testcases voor inloggen, gameplay en andere frontend functionaliteit
Resource         ../resources/variables.resource
Resource         FE.resource

Suite Setup      FE Setup
Suite Teardown   FE Teardown


*** Test Cases ***
TC001 - Website Laden
    [Documentation]    Test of de website correct wordt geladen
    [Tags]    smoke
    ${title}=    Get Title
    Log    Pagina titel: ${title}
    Should Not Be Empty    ${title}
    Sleep    5s

TC002 - Inloggen
    [Documentation]    Test de inlog functionaliteit
    [Tags]    login
    Log    Inlog test wordt uitgevoerd

TC003 - Gameplay Functionaliteit
    [Documentation]    Test de verschillende gameplay opties in de RPG
    [Tags]    gameplay
    Log    Gameplay test wordt uitgevoerd
