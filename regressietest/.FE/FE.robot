*** Settings ***
Documentation    Frontend testsuite voor TestRPG website
...              Bevat testcases voor inloggen, gameplay en andere frontend functionaliteit
Resource         ../resources/variables.resource
Resource         FE.resource

Test Setup      FE Setup
Test Teardown   FE Teardown


*** Test Cases ***
TC001 - Website Laden En Verifieren
    [Documentation]    Test of de website correct is geladen
    [Tags]    Website-Laden-En-Verifieren
    Controleer Of Tekst Op Pagina Staat    TestRPG is a simple 'game'

TC002 - Inloggen Controleren
    [Documentation]    Test de inlog functionaliteit met een Beslissingtabeltest
    [Tags]    login
    Klik Op Element    ${SELECTORS.LOGIN_BUTTON}
    Controleer Of Tekst Op Pagina Staat    Login to TestRPG
    Inloggen Valideren    tester@test.com    test

TC003 - Spel Starten En Verifieren
    [Documentation]    Start het spel en verifieer dat de gameplay pagina is geladen
    [Tags]    gameplay
    Log    Gameplay test wordt uitgevoerd
    Klik Op Element    ${SELECTORS.CLICK_TO_PLAY_BUTTON}
    Controleer Of Tekst Op Pagina Staat    Choose a name and build