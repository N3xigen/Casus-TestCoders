*** Settings ***
Documentation    Generiek gebouwde keywords die hergebruikt kunnen worden (niet specifiek voor deze regressietest)
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

Controleer Of Tekst Op Pagina Staat
    [Documentation]    Controleert of een specifieke tekst zichtbaar is op de huidige pagina (inclusief modals)
    [Arguments]    ${verwachtte_tekst}
    # Wacht tot de tekst zichtbaar is (werkt ook voor modals)
    Wait For Elements State    text=${verwachtte_tekst}    visible    timeout=5s
    Log    Tekst '${verwachtte_tekst}' gevonden op de pagina

Klik Op Element
    [Documentation]
    ...    Klikt op een element, optioneel meerdere keren. Klikt een keer wanneer je geen ${aantal_keer} invult als argument.
    [Arguments]    ${selector}    ${aantal_keer}=1

    FOR    ${i}    IN RANGE    ${aantal_keer}
        Click    ${selector}
        Log    Klik ${i + 1}/${aantal_keer} uitgevoerd op ${selector}
    END
    Log    ${aantal_keer} klik(ken) succesvol uitgevoerd op element: ${selector}

Controleer Of Element Zichtbaar Is
    [Documentation]
    ...    Controleert of een element zichtbaar is op de pagina.
    ...    Gebruik timeout om aan te geven hoe lang gewacht moet worden (default 5s).
    [Arguments]    ${selector}    ${timeout}=5s
    Wait For Elements State    ${selector}    visible    timeout=${timeout}
    Log    Element '${selector}' is zichtbaar op de pagina

