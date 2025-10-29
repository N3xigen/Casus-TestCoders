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
    Controleer Of Tekst Op Pagina Staat    ${TEKST.HOMEPAGE_TITEL}

TC002 - Inloggen Controleren
    [Documentation]
    ...    Test de inlog functionaliteit met een beslissingtabel-test.
    ...    Controleert verschillende scenario's zoals ontbrekende '@' in email, ontbrekend suffix en correcte inloggegevens.
    ...    Controleert of de juiste foutmeldingen worden weergegeven.
    [Tags]    Inloggen-Controleren
    Klik Op Element    ${SELECTORS.LOGIN_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.LOGIN_MODAL_TITEL}
    Inloggen Valideren    ${LOGIN.email}    ${LOGIN.wachtwoord}

TC003 - Character Aanmaken En Spel Starten
    [Documentation]
    ...    Maakt een character aan (een keer met het toetsenbord een keer met de dropdown menu) en controleert of dit goed is gegaan.
    ...    Controleert meteen of de juiste foutmeldingen worden weergegeven bij ongeldige invoer.
    [Tags]    Character-Aanmaken-En-Spel-Starten

    Klik Play In Het Hoofdmenu
    Klik Op Element    ${SELECTORS.START_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.CHARACTER_NAAM_FOUT}

    Maak Character, Start Spel En Controleer Status    keyboard
    Klik Op Element    ${SELECTORS.HOME_BUTTON}
    Klik Play In Het Hoofdmenu
    Maak Character, Start Spel En Controleer Status    dropdown

TC004 - Character Controleren Per Level
    [Documentation]
    ...    Verifieert dat het character correct leveled van level 1 tot en met level 5.
    ...    Voor elk level wordt gecontroleerd of de juiste elementen en teksten op de pagina verschijnen.
    [Tags]    Character-Level-Controleren
    Klik Play In Het Hoofdmenu
    Maak Character, Start Spel En Controleer Status

    Character Level Procedure    1
    Character Level Procedure    2
    Character Level Procedure    3
    Character Level Procedure    4
    Character Level Procedure    5

    # Spel uitgespeeld, laatste controles uitvoeren
    Controleer Of Tekst Op Pagina Staat    ${TEKST.MAX_LEVEL_BERICHT}
    Play Again Controleren Na Het Spelen
