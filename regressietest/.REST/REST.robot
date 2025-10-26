*** Settings ***
Documentation    REST service testsuite voor TestRPG API
...              Bevat testcases voor REST API endpoints
Resource         ../resources/variables.resource


*** Test Cases ***
TC001 - REST API Test
    [Documentation]    Test de REST API endpoints
    [Tags]    api    rest
    Log    REST API test wordt uitgevoerd
