*** Settings ***
Documentation    Frontend testsuite voor TestRPG website
...              Bevat testcases voor inloggen, gameplay en andere frontend functionaliteit
Resource         ../resources/variables.resource
Resource         keywords_FE.resource

Suite Setup      FE Setup
Suite Teardown   FE Teardown

*** Test Cases ***
TC001 - Inloggen
    [Documentation]    Test de inlog functionaliteit
    [Tags]    login    frontend
    Log    Inlog test wordt uitgevoerd

TC002 - Gameplay Functionaliteit
    [Documentation]    Test de verschillende gameplay opties in de RPG
    [Tags]    gameplay    frontend
    Log    Gameplay test wordt uitgevoerd
