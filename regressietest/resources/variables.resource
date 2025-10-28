*** Settings ***
Documentation    Variabelen voor de TestRPG website


*** Variables ***
# Algemene variabelen
${URL}                  https://test-rpg.vercel.app                                         # De URL van de TestRPG website
${BROWSER}              chromium                                                            # Browser type: chromium, firefox, webkit, brave
${HEADLESS}             False                                                               # True voor headless mode, False voor zichtbare browser
@{BROWSER_ARGS}         --start-maximized                                                   # Browser argumenten
${BRAVE_EXECUTABLE}     /Applications/Brave Browser.app/Contents/MacOS/Brave Browser        # Pad naar Brave browser executable

# Character level mapping voor keyword 'Controleer Character Level'
&{LEVEL_MAPPING}
...    1=The base character image                                                           # Level 1 alt text op de frontend
...    2=The characters' base weapon                                                        # Level 2 alt text op de frontend
...    3=The characters' base armor                                                         # Level 3 alt text op de frontend
...    4=The characters' upgraded weapon                                                    # Level 4 alt text op de frontend
...    5=The characters' upgraded armor                                                     # Level 5 alt text op de frontend

# Lijst met selectors voor alle frontend tests
&{SELECTORS}
...    CLICK_TO_PLAY_BUTTON=text=Click here to play                                         # Hoofdpagina start knop
...    LOGIN_BUTTON=button[data-testid="login-button"]                                      # Login knop op hoofdpagina
...    LOGOUT_BUTTON=button[data-testid="logout-button"]                                    # Logout knop op hoofdpagina
...    LOGIN_SUBMIT_BUTTON=button[type="submit"]                                            # Login submit knop in de modal
...    EMAIL_INPUT=input[name="email"]                                                      # Email invoerveld
...    PASSWORD_INPUT=input[name="password"]                                                # Wachtwoord invoerveld
