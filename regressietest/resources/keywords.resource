*** Settings ***
Documentation    Generiek gebouwde keywords die hergebruikt kunnen worden (niet specifiek voor deze regressietest)
Resource         variables.resource
Resource         libraries.resource


*** Keywords ***
# ============================================================================
# Browser openen en navigeren
# ============================================================================

Browser & Website Openen
    [Documentation]    Browser openen en naar de website navigeren
    ${browser_to_use}=    Set Variable If    '${BROWSER}' == 'brave'    chromium    ${BROWSER}

    # Als de browser Brave is, geef dan het pad naar de applicatie mee. Anders, open de browser zonder extra pad.
    IF    '${BROWSER}' == 'brave'
        New Browser
        ...    ${browser_to_use}
        ...    headless=${HEADLESS}
        ...    executablePath=${BRAVE_APP}
    ELSE
        New Browser
        ...    ${browser_to_use}
        ...    headless=${HEADLESS}
    END

    Naar Website Navigeren

Naar Website Navigeren
    [Documentation]    Navigeer naar de website URL
    New Page    ${URL}
    Log    Navigatie naar ${URL} succesvol

# ============================================================================
# Keywords gerelateerd aan interacties met elementen
# ============================================================================

Klik Op Element
    [Documentation]
    ...    Klikt op een element, optioneel meerdere keren. Klikt een keer wanneer je geen ${aantal_keer} invult als argument.
    [Arguments]    ${selector}    ${aantal_keer}=1

    FOR    ${i}    IN RANGE    ${aantal_keer}
        Click    ${selector}
        Log    Klik ${i + 1}/${aantal_keer} uitgevoerd op ${selector}
    END
    Log    ${aantal_keer} klik(ken) succesvol uitgevoerd op element: ${selector}

Upload Bestand
    [Documentation]
    ...    Generieke keyword voor het uploaden van een bestand.
    [Arguments]    ${bestand_pad}

    # Controleer of bestand bestaat en upload het bestand vervolgens
    File Should Exist    ${bestand_pad}
    Upload File By Selector    ${SELECTORS.FILE_UPLOAD_INPUT}    ${bestand_pad}
    Log    Bestand '${bestand_pad}' succesvol geupload via '${SELECTORS.FILE_UPLOAD_INPUT}'

Beweeg Slider Naar Percentage
    [Documentation]
    ...    Beweegt de slider naar een specifiek percentage (0-100).
    ...    0% = helemaal links, 100% = helemaal rechts.
    ...    Gebruikt keyboard arrows voor nauwkeurige controle.
    [Arguments]    ${percentage}

    # Valideer percentage tussen 0 en 100
    ${percentage_int}=    Convert To Integer    ${percentage}
    IF    ${percentage_int} < 0 or ${percentage_int} > 100
        Fail    Percentage moet tussen 0 en 100 liggen, maar kreeg: ${percentage}
    END

    # Focus op de slider
    Click    ${SELECTORS.SLIDER_BUTTON}

    FOR    ${_}    IN RANGE    ${percentage_int}
        Keyboard Key    press    ArrowRight
    END

    Log    Slider bewogen naar ${percentage}%

Controleer Of Tekst Op Pagina Staat
    [Documentation]    Controleert of een specifieke tekst zichtbaar is op de huidige pagina (inclusief modals)
    [Arguments]    ${verwachtte_tekst}    ${timeout}=5s
    Wait For Elements State    text=${verwachtte_tekst}    visible    timeout=${timeout}
    Log    Tekst '${verwachtte_tekst}' gevonden op de pagina

Controleer Of Element Zichtbaar Is
    [Documentation]
    ...    Controleert of een element zichtbaar is op de pagina.
    ...    Gebruik timeout om aan te geven hoe lang gewacht moet worden (default 5s).
    [Arguments]    ${selector}    ${timeout}=5s
    Wait For Elements State    ${selector}    visible    timeout=${timeout}
    Log    Element '${selector}' is zichtbaar op de pagina
