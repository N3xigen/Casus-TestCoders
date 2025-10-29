*** Settings ***
Documentation    Keywords die uniek gebouwd zijn voor de frontend tests
Resource         ../resources/variables.resource
Resource         ../resources/keywords.resource
Resource         ../resources/libraries.resource


*** Keywords ***
# ============================================================================
# Omgeving opzetten & opruimen
# ============================================================================

FE Setup
    [Documentation]    Testomgeving opzetten
    Browser & Website Openen
    Log    Browser geopend, frontend test begint

FE Teardown
    [Documentation]    Testomgeving opruimen
    Close Browser
    Log    Browser afgesloten, frontend test voltooid

# ============================================================================
# Inloggen en navigeren
# ============================================================================

Inloggen Valideren
    [Documentation]    Voert een Beslissingtabeltest uit voor het inloggen
    [Arguments]    ${email}    ${wachtwoord}

    # Vul niks in en druk meteen op login (verwacht: blijf op login pagina)
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.LOGIN_MODAL_TITEL}

    # Vul email in zonder @ (verwacht: blijf op login pagina)
    Fill Text    ${SELECTORS.EMAIL_INPUT}    tester
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.LOGIN_MODAL_TITEL}

    # Vul email in zonder suffix (verwacht: toon email validatie foutmelding)
    Fill Text    ${SELECTORS.EMAIL_INPUT}    tester@test
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.LOGIN_EMAIL_FOUT}

    # Vul email en wachtwoord correct in (verwacht: succesvol inloggen)
    Fill Text    ${SELECTORS.EMAIL_INPUT}    ${email}
    Fill Text    ${SELECTORS.PASSWORD_INPUT}    ${wachtwoord}
    Klik Op Element    ${SELECTORS.LOGIN_SUBMIT_BUTTON}
    Controleer Of Element Zichtbaar Is    ${SELECTORS.LOGOUT_BUTTON}

    # Log uit en verifieer dat login knop weer zichtbaar is
    Klik Op Element    ${SELECTORS.LOGOUT_BUTTON}
    Controleer Of Element Zichtbaar Is    ${SELECTORS.LOGIN_BUTTON}

Klik Play In Het Hoofdmenu
    [Documentation]    Drukt op de play knop in het hoofdmenu en verifieert dat de character aanmaak pagina wordt geladen
    Klik Op Element    ${SELECTORS.CLICK_TO_PLAY_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.CHARACTER_CREATION_TITEL}

Play Again Controleren Na Het Spelen
    [Documentation]    Controleert of de 'Play again' knop correct werkt na het uitspelen van het spel
    Controleer Of Element Zichtbaar Is    ${SELECTORS.CLICK_TO_PLAY_AGAIN_BUTTON}
    Klik Op Element    ${SELECTORS.CLICK_TO_PLAY_AGAIN_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${TEKST.CHARACTER_CREATION_TITEL}
    Controleer Of Tekst Op Pagina Staat    A level 1 thief

# ============================================================================
# Keywords gerelateerd aan het maken van de Character
# ============================================================================

Maak Character, Start Spel En Controleer Status
    [Documentation]    Maakt een character aan en start het spel.
    ...                Selecteer_wijze kan 'dropdown' of 'keyboard' zijn (default: keyboard).
    [Arguments]    ${selecteer_wijze}=keyboard

    # Vul naam in
    Fill Text    ${SELECTORS.CHARACTER_NAME_INPUT}    ${PLAYER.naam}

    # Selecteer build op basis van de gekozen wijze
    IF    '${selecteer_wijze}' == 'dropdown'
        Selecteer Build Via Dropdown    ${PLAYER.build}
    ELSE
        Selecteer Build Met Toetsenbord    ${PLAYER.build}
    END

    # Klik op Start en verifieer of de character goed is aangemaakt en het spel is gestart
    Klik Op Element    ${SELECTORS.START_BUTTON}
    Controleer Of Tekst Op Pagina Staat    ${PLAYER.naam}
    Controleer Of Tekst Op Pagina Staat    A level 1 ${PLAYER.build}
    Log    Spel gestart met character '${PLAYER.naam}' en build '${PLAYER.build}' (selectie: ${selecteer_wijze})

Selecteer Build Via Dropdown
    [Documentation]
    ...    Selecteert een character build via de dropdown door erop te klikken.
    ...    Kiest vervolgens de juiste build optie uit de lijst.
    [Arguments]    ${build}

    # Controleer of build geldig is
    Controleer Op Geldige Build Invoer    ${build}

    # Klik op de dropdown button om te openen
    Klik Op Element    ${SELECTORS.BUILD_DROPDOWN}
    ${gekozen_build}=    Set Variable    ${BUILD_MAPPING.${build}}
    Klik Op Element    ${gekozen_build}
    Log    Build ${build} geselecteerd via dropdown

Selecteer Build Met Toetsenbord
    [Documentation]
    ...    Selecteert net als 'Selecteer Build Via Dropdown' een character build,
    ...    maar doet dit via het toetsenbord door op het Build label te klikken.
    ...    Drukt zoals een toetsenbord op de eerste letter van de build om te selecteren.
    [Arguments]    ${build}

    # Controleer of build geldig is
    Controleer Op Geldige Build Invoer    ${build}

    # Klik op Build label om focus te krijgen
    Klik Op Element    ${SELECTORS.BUILD_LABEL}

    # Druk op de eerste letter van de build (bijv. 'k' van Knight)
    ${key}=    Evaluate    $build[0].lower()
    Keyboard Key    press    ${key}
    Log    Build ${build} geselecteerd via toetsenbord (key: ${key})

Controleer Op Geldige Build Invoer
    [Documentation]    Controleert of de opgegeven build geldig is.
    [Arguments]    ${build}

    IF    '${build}' not in ${BUILD_MAPPING}
        Fail    Ongeldige build: ${build}. Alleen Thief, Knight, Mage en Brigadier worden ondersteund.
    END

# ============================================================================
# Keywords gerelateerd aan het levelen en verifieren van de Character
# ============================================================================

Character Level Procedure
    [Documentation]
    ...    Beheert het leveling proces voor alle levels (1-5) d.m.v. state transition testing.
    ...    Level 1: alleen controle. Level 2-5: level up en controleer.
    [Arguments]    ${verwacht_level}

    ${verwacht_level}=    Convert To String    ${verwacht_level}

    IF    '${verwacht_level}' == '1'
        Controleren Van Character Status    ${verwacht_level}

    ELSE IF    '${verwacht_level}' == '2'
        Level Up Via 5x Klikken    ${verwacht_level}
        Controleren Van Character Status    ${verwacht_level}

    ELSE IF    '${verwacht_level}' == '3'
        Upload Bestand    ${TESTPLAN_AFBEELDING}
        Controleer Of Tekst Op Pagina Staat    ${TEKST.BESTAND_UPLOAD_SUCCES}
        Controleren Van Character Status    ${verwacht_level}

    ELSE IF    '${verwacht_level}' == '4'
        Fill Text    ${SELECTORS.LOREM_IPSUM_INPUT}    Lorem ipsum
        Run Keyword And Expect Error    *    Controleer Of Tekst Op Pagina Staat    ${TEKST.TEXT_INPUT_SUCCES}    100ms
        Fill Text    ${SELECTORS.LOREM_IPSUM_INPUT}    Lorem Ipsum
        Controleer Of Tekst Op Pagina Staat    ${TEKST.TEXT_INPUT_SUCCES}
        Controleren Van Character Status    ${verwacht_level}

    ELSE IF    '${verwacht_level}' == '5'
        Beweeg Slider Naar Percentage    90
        Run Keyword And Expect Error    *    Controleer Of Tekst Op Pagina Staat    ${TEKST.SLIDER_SUCCES}    100ms
        Beweeg Slider Naar Percentage    100
        Controleer Of Tekst Op Pagina Staat    ${TEKST.SLIDER_SUCCES}
        Controleren Van Character Status    ${verwacht_level}

    ELSE
        Fail    Ongeldig level: ${verwacht_level}. Alleen level 1-5 worden ondersteund.
    END

Level Up Via 5x Klikken
    [Documentation]
    ...    Level up door 5x klikken naar het verwachte level. Berekent automatisch huidig level (verwacht - 1).
    ...    Controleert na elke stap of de juiste level tekst en afbeelding zichtbaar is.
    [Arguments]    ${verwacht_level}

    # Berekent ${huidig_level} en bereidt de variabelen voor
    ${verwacht_level}=    Convert To String    ${verwacht_level}
    ${build}=    Evaluate    $PLAYER.build.lower()
    ${huidig_level}=    Evaluate    int($verwacht_level) - 1
    ${huidig_level}=    Convert To String    ${huidig_level}

    # Controleer startlevel en build, klik vier keer, controleer, klik voor de vijfde keer
    Controleer Of Tekst Op Pagina Staat    A level ${huidig_level} ${build}
    Klik Op Element    ${SELECTORS.CLICK_TO_LEVEL_BUTTON}    4
    Controleer Of Tekst Op Pagina Staat    A level ${huidig_level} ${build}
    Klik Op Element    ${SELECTORS.CLICK_TO_LEVEL_BUTTON}

    # Controleer of het verwachtte level is bereikt en check ook meteen of de afbeelding matcht
    Controleer Of Tekst Op Pagina Staat    ${TEKST.LEVEL_UP_BERICHT}
    Controleer Of Tekst Op Pagina Staat    A level ${verwacht_level} ${build}
    Controleer Character Afbeelding    ${verwacht_level}
    Log    Character geleveld van level ${huidig_level} naar ${verwacht_level} na 5x klikken

Controleren Van Character Status
    [Documentation]    Controleert de naam, build en afbeelding van de character op basis van het level.
    [Arguments]    ${verwacht_level}
    ${build}=    Evaluate    $PLAYER.build.lower()
    Controleer Of Tekst Op Pagina Staat    ${PLAYER.naam}
    Controleer Of Tekst Op Pagina Staat    A level ${verwacht_level} ${build}
    Controleer Character Afbeelding    ${verwacht_level}
    Log    Level ${verwacht_level} gecontroleerd voor ${PLAYER.naam} (${build})

Controleer Character Afbeelding
    [Documentation]    Controleert of de character de juiste zichtbare afbeelding heeft op basis van het level.
    [Arguments]    ${verwacht_level}

    # Kijkt of we op de goede pagina zitten
    Controleer Of Tekst Op Pagina Staat    ${TEKST.GAMEPLAY_INSTRUCTIE}

    # Check of level geldig is
    ${verwacht_level}=    Convert To String    ${verwacht_level}
    IF    '${verwacht_level}' not in ${LEVEL_MAPPING}
        Fail    Ongeldig level: ${verwacht_level}. Alleen level 1-5 worden ondersteund.
    END

    # Haal de verwachte alt text op en controleer
    ${verwachtte_alt}=    Get From Dictionary    ${LEVEL_MAPPING}    ${verwacht_level}
    Get Attribute    img[alt="${verwachtte_alt}"]    alt    ==    ${verwachtte_alt}
    Log    Level ${verwacht_level} matcht met de juiste afbeelding
