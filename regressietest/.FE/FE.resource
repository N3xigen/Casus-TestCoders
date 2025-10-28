*** Settings ***
Documentation    Keywords die uniek gebouwd zijn voor de frontend tests
Resource         ../resources/variables.resource
Resource         ../resources/keywords.resource
Resource         ../resources/libraries.resource


*** Keywords ***
FE Setup
    [Documentation]    Testomgeving opzetten
    Browser & Website Openen
    Log    Browser geopend, frontend test begint

FE Teardown
    [Documentation]    Testomgeving opruimen
    Close Browser
    Log    Browser afgesloten, frontend test voltooid

Controleer Character Level
    [Documentation]    Controleert of de character de juiste zichtbare afbeelding heeft op basis van het level.
    [Arguments]    ${verwacht_level}

    # Check of level geldig is
    ${verwacht_level}=    Convert To String    ${verwacht_level}
    IF    '${verwacht_level}' not in ${LEVEL_MAPPING}
        Fail    Ongeldig level: ${verwacht_level}. Alleen level 1-5 worden ondersteund.
    END

    # Haal de verwachte alt text op en controleer
    ${verwachtte_alt}=    Set Variable    ${LEVEL_MAPPING.${verwacht_level}}
    Get Attribute    img[alt="${verwachtte_alt}"]    alt    ==    ${verwachtte_alt}
    Log    Level ${verwacht_level} correct gedetecteerd

Inloggen Valideren
    [Documentation]    Voert een Beslissingtabeltest uit voor het inloggen
    [Arguments]    ${email}    ${wachtwoord}

    # Vul email  in - @ vergeten we bewust
    Fill Text    ${SELECTORS.EMAIL_INPUT}    tester
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Tekst Op Pagina Staat    Login to TestRPG

    # Vul email in - suffix vergeten we bewust
    Fill Text    ${SELECTORS.EMAIL_INPUT}    tester@test
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Tekst Op Pagina Staat    This should be an email address

    # Vul email en wachtwoord correct in - happy flow
    Fill Text    ${SELECTORS.EMAIL_INPUT}    ${email}
    Fill Text    ${SELECTORS.PASSWORD_INPUT}    ${wachtwoord}
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Element Zichtbaar Is    ${SELECTORS.LOGOUT_BUTTON}

    # Log weer uit en kijk of login knop weer zichtbaar is
    Klik Op Element    ${SELECTORS.LOGOUT_BUTTON}
    Controleer Of Element Zichtbaar Is    ${SELECTORS.LOGIN_BUTTON}
