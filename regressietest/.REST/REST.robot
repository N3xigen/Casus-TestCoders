*** Settings ***
Documentation    REST service testsuite voor TestRPG API
...              Bevat testcases voor REST API endpoints
Resource         ../resources/variables.resource
Resource         ../resources/keywords.resource
Resource         REST.resource


*** Test Cases ***
TC001 - GET Alle Builds
    [Documentation]
    ...    Test het ophalen van alle builds zonder parameters.
    ...    Verwacht een succesvolle response met alle beschikbare builds.
    [Tags]    GET-Alle-Builds

    # validate_parameters naar FALSE gezet, want niet alle parameters per build worden teruggegeven
    Controleer Builds [REST]    ${API_BASE_URL}/builds    validate_parameters=${FALSE}

TC002 - GET Builds Voor Alle Geldige Build Types
    [Documentation]
    ...    Haalt de vier specifieke builds op, en controleert vervolgens alle geldige parameters.
    ...    Test ook een ongeldige build: duelist. Verwachting is dat we de DLC niet hebben!
    ...    Brigadier wordt standaard niet gevalideerd vanwege een bevinding. Zet ${valideer_brigadier} op TRUE om dit te forceren.
    [Tags]    GET-Builds-Voor-Alle-Geldige-Build-Types

    # Test alle geldige builds
    Controleer Alle Build Types [REST]    ${API_BASE_URL}/builds    ${FALSE}

    # Test ongeldige build: duelist (FOUTPAD)
    ${response}=    Controleer Builds [REST]    ${API_BASE_URL}/builds?build=duelist    expected_status=any    expect_valid_response=${FALSE}    validate_parameters=${FALSE}
    Should Contain    ${response.text}    Unknown build 'duelist'

TC003 - POST Geldige Brigadier Build Met 10 Skillpoints
    [Documentation]
    ...    Test het versturen van een geldige Brigadier build met een totaal van 10 skillpoints.
    [Tags]    POST-Geldige-Brigadier-Build

    # Verstuur geldige Brigadier build
    Verstuur Build [REST]
    ...    ${API_BASE_URL}/builds
    ...    build_name=Corrected Brigadier
    ...    strength=${2}
    ...    agility=${1}
    ...    wisdom=${6}
    ...    magic=${1}
    ...    expected_status=201
