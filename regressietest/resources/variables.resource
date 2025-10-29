*** Settings ***
Documentation    Variabelen voor de TestRPG website


*** Variables ***
# Algemene variabelen
${URL}                  https://test-rpg.vercel.app                                         # De URL van de TestRPG website
${BROWSER}              chromium                                                            # Browser type: chromium, firefox, webkit, brave
${HEADLESS}             False                                                               # True voor headless mode, False voor zichtbare browser
${BRAVE_APP}     /Applications/Brave Browser.app/Contents/MacOS/Brave Browser        # Pad naar Brave browser executable
${TESTPLAN_AFBEELDING}    ${CURDIR}/../../Testplan/afbeeldingen/scherm_1.png                              # Pad naar testplan afbeeldingen folder

# Test character gegevens
&{PLAYER}
...    naam=Click Norris                                                                     # Test character naam
...    build=Brigadier                                                                       # Test character build

# Login credentials voor testen
&{LOGIN}
...    email=tester@test.com                                                                 # Test email voor login
...    wachtwoord=test                                                                       # Test wachtwoord voor login

# Verwachte teksten op de website (voor eenvoudiger onderhoud bij tekstaanpassingen)
&{TEKST}
...    HOMEPAGE_TITEL=TestRPG is a simple 'game'                                             # Hoofdpagina titel
...    LOGIN_MODAL_TITEL=Login to TestRPG                                                    # Login modal titel
...    LOGIN_EMAIL_FOUT=This should be an email address                                      # Email validatie foutmelding
...    CHARACTER_CREATION_TITEL=Choose a name and build                                      # Character creation scherm titel
...    CHARACTER_NAAM_FOUT=Name must be at least 3 characters                                # Character naam validatie foutmelding
...    GAMEPLAY_INSTRUCTIE=Complete the tasks below and level up your character              # Gameplay instructie tekst
...    LEVEL_UP_BERICHT=Great job! You levelled up                                           # Level up success message
...    BESTAND_UPLOAD_SUCCES=File selected, level up!                                        # Bestand upload success message
...    TEXT_INPUT_SUCCES=Dolar sit amet!                                                     # Lorem ipsum success message
...    SLIDER_SUCCES=Slid to the next level!                                                 # Slider success message
...    MAX_LEVEL_BERICHT=You've reached the highest level!                                   # Maximaal level bereikt message

# Character level mapping voor keyword 'Controleer Character Level'
&{LEVEL_MAPPING}
...    1=The base character image                                                           # Level 1 alt text op de frontend
...    2=The characters' base weapon                                                        # Level 2 alt text op de frontend
...    3=The characters' base armor                                                         # Level 3 alt text op de frontend
...    4=The characters' upgraded weapon                                                    # Level 4 alt text op de frontend
...    5=The characters' upgraded armor                                                     # Level 5 alt text op de frontend

# Build mapping voor keyword 'Selecteer Build Via Dropdown'
&{BUILD_MAPPING}
...    Brigadier=[role="option"] >> text=Brigadier                                          # Build optie: Brigadier
...    Knight=[role="option"] >> text=Knight                                                # Build optie: Knight
...    Mage=[role="option"] >> text=Mage                                                    # Build optie: Mage
...    Thief=[role="option"] >> text=Thief                                                  # Build optie: Thief

# Lijst met selectors voor alle frontend tests
&{SELECTORS}
...    CLICK_TO_PLAY_BUTTON=text=Click here to play                                         # Hoofdpagina start knop
...    CLICK_TO_PLAY_AGAIN_BUTTON=text=Play again                                           # Play again knop na uitspelen spel
...    HOME_BUTTON=a[href="/"]                                                              # Home link in de navigatiebalk
...    LOGIN_BUTTON=button[data-testid="login-button"]                                      # Login knop op hoofdpagina
...    LOGOUT_BUTTON=button[data-testid="logout-button"]                                    # Logout knop op hoofdpagina
...    LOGIN_SUBMIT_BUTTON=button[type="submit"]                                            # Login submit knop in de modal
...    EMAIL_INPUT=input[name="email"]                                                      # Email invoerveld
...    PASSWORD_INPUT=input[name="password"]                                                # Wachtwoord invoerveld
...    CHARACTER_NAME_INPUT=input[name="name"]                                              # Character naam invoerveld op character creator
...    BUILD_LABEL=label:has-text("Build")                                                  # Build label op character creator (voor keyboard navigatie)
...    BUILD_DROPDOWN=button[role="combobox"]                                               # Build dropdown button
...    START_BUTTON=text=Start!                                                             # Start knop op character creator
...    CLICK_TO_LEVEL_BUTTON=button:has-text("Click me")                                    # Button om te klikken voor level up (tekst verandert van 5 naar 4, 3, etc)
...    FILE_UPLOAD_INPUT=input[type="file"]                                                 # File upload input element
...    LOREM_IPSUM_INPUT=section[data-testid="adventure-typer"] input                       # Text input voor Lorem Ipsum level up (binnen adventure-typer section)
...    SLIDER_BUTTON=span[role="slider"]                                                    # Slider knop (thumb) element