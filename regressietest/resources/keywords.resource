*** Settings ***
Documentation    Algemene keywords die breed inzetbaar zijn
...              Niet specifiek voor deze regressietest, maar algemene hulpfuncties
Resource         variables.resource
Resource         libraries.resource


*** Keywords ***
Browser & Website Openen
    [Documentation]    Browser openen en naar de website navigeren
    ${browser_to_use}=    Set Variable If    '${BROWSER}' == 'brave'    chromium    ${BROWSER}

    # Als de browser Brave is, geef dan het pad naar de executable mee. Anders, open de browser zonder extra pad.
    IF    '${BROWSER}' == 'brave'
        New Browser
        ...    ${browser_to_use}
        ...    headless=${HEADLESS}
        ...    args=${BROWSER_ARGS}
        ...    executablePath=${BRAVE_EXECUTABLE}
    ELSE
        New Browser
        ...    ${browser_to_use}
        ...    headless=${HEADLESS}
        ...    args=${BROWSER_ARGS}
    END
    Naar Website Navigeren

Naar Website Navigeren
    [Documentation]    Navigeer naar de website URL
    New Page    ${URL}
    Log    Navigatie naar ${URL} succesvol
