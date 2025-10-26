*** Settings ***
Documentation    Keywords specifiek voor Frontend testen
Library          Browser

*** Keywords ***
FE Setup
    [Documentation]    Testomgeving opzetten voor frontend testen
    Browser & Website Openen
    Log    Browser geopend, frontend test begint

FE Teardown
    [Documentation]    Testomgeving opruimen na frontend testen
    Close Browser
    Log    Browser afgesloten, frontend test voltooid

Browser & Website Openen
    [Documentation]    Browser openen en naar de website navigeren
    ${browser_to_use}=    Set Variable If    '${BROWSER}' == 'brave'    chromium    ${BROWSER}

    # Als de browser Brave is, geef dan het pad naar de executable mee. Anders, open de browser zonder extra pad.
    Run Keyword If    '${BROWSER}' == 'brave'
    ...    New Browser    ${browser_to_use}    headless=${HEADLESS}    args=${BROWSER_ARGS}    executablePath=${BRAVE_EXECUTABLE}
    ...    ELSE
    ...    New Browser    ${browser_to_use}    headless=${HEADLESS}    args=${BROWSER_ARGS}
    Naar Website Navigeren

Naar Website Navigeren
    [Documentation]    Navigeer naar de website URL
    New Page    ${URL}
    Log    Navigatie naar ${URL} succesvol
