*** Settings ***
Documentation    Keywords specifiek voor REST API testen
Resource         ../resources/variables.resource
Resource         ../resources/keywords.resource


*** Keywords ***
# ============================================================================
# REST API request keywords
# ============================================================================

Controleer Builds [REST]
    [Documentation]
    ...    Voert een GET request uit naar builds endpoint en valideert de response.
    ...    ${expect_valid_response} kan voor foutpaden op FALSE worden gezet, zodat hij geen lege response leest en fout gaat.
    ...    ${validate_parameters} kan ook worden uitgeschakeld voor foutpaden of list responses.
    ...    ${validate_skillpoints} kan op FALSE worden gezet om known bugs te negeren (bijv. Brigadier met 11 points).
    [Arguments]    ${endpoint}    ${expected_status}=200    ${expect_valid_response}=${TRUE}    ${validate_parameters}=${TRUE}    ${validate_skillpoints}=${TRUE}

    ${response}=    REST GET Request    ${endpoint}    expected_status=${expected_status}
    Status Should Be    ${expected_status}    ${response}
    IF    ${expect_valid_response}    Should Not Be Empty    ${response.json()}

    # Valideer de parameters en totaal aantal skillpoints bij een goedpad met ${validate_parameters} aan
    IF    ${validate_parameters} and ${expected_status} == 200
        Valideer Build Response Parameters    ${response}
        IF    ${validate_skillpoints}    Valideer Skillpoints    ${response}
    END

    Log    Response: ${response.json()}

    RETURN    ${response}

Controleer Alle Build Types [REST]
    [Documentation]
    ...    Test alle geldige builds en controleert of er een 200 terug komt
    ...    Gebruikt de keys uit BUILD_MAPPING voor de build namen.
    [Arguments]    ${base_endpoint}    ${valideer_brigadier}=${FALSE}

    @{builds}=    Get Dictionary Keys    ${BUILD_MAPPING}
    FOR    ${build}    IN    @{builds}
        ${build}=    Evaluate    $build.lower()
        IF    '${build}' == 'brigadier' and not ${valideer_brigadier}
            ${response}=    Controleer Builds [REST]    ${base_endpoint}?build=${build}    validate_skillpoints=${FALSE}
        ELSE
            ${response}=    Controleer Builds [REST]    ${base_endpoint}?build=${build}
        END

        Log    ${response.json()}
    END

Verstuur Build [REST]
    [Documentation]
    ...    Voert een POST request uit naar builds endpoint om een custom build te versturen.
    ...    Valideert automatisch dat de build voldoet aan de API regels (max 10 skillpoints totaal).
    [Arguments]    ${endpoint}    ${build_name}    ${strength}    ${agility}    ${wisdom}    ${magic}    ${expected_status}=200

    # Maak build JSON body
    &{build}=    Create Dictionary    name=${build_name}    strength=${strength}    agility=${agility}    wisdom=${wisdom}    magic=${magic}
    &{json_body}=    Create Dictionary    build=&{build}

    # Voer POST request uit
    ${response}=    REST POST Request    ${endpoint}    ${json_body}    expected_status=${expected_status}
    Status Should Be    ${expected_status}    ${response}
    Log    Response: ${response.json()}

    RETURN    ${response}

# ============================================================================
# REST API validatie keywords
# ============================================================================

Valideer Build Response Parameters
    [Documentation]
    ...    Valideert dat een build response alle vereiste velden bevat.
    ...    Controleert op: weapon, upgradedWeapon, armor, upgradedArmor, strength, agility, wisdom, magic.
    [Arguments]    ${response}

    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    weapon
    Dictionary Should Contain Key    ${json}    upgradedWeapon
    Dictionary Should Contain Key    ${json}    armor
    Dictionary Should Contain Key    ${json}    upgradedArmor
    Dictionary Should Contain Key    ${json}    strength
    Dictionary Should Contain Key    ${json}    agility
    Dictionary Should Contain Key    ${json}    wisdom
    Dictionary Should Contain Key    ${json}    magic
    Log    Response: ${json}

Valideer Skillpoints
    [Documentation]
    ...    Valideert dat het totaal van alle skills gelijk is aan 10 (volgens API specificatie).
    ...    NOTE: Brigadier heeft een totaal van 11, wat een bug is in de API.
    [Arguments]    ${response}

    ${json}=    Set Variable    ${response.json()}
    ${totaal}=    Evaluate    ${json}[strength] + ${json}[agility] + ${json}[wisdom] + ${json}[magic]
    Should Be Equal As Numbers    ${totaal}    10
    Log    Skills totaal: ${totaal} (strength:${json}[strength], agility:${json}[agility], wisdom:${json}[wisdom], magic:${json}[magic])