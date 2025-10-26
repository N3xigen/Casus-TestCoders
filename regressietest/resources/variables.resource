*** Settings ***
Documentation    Variabelen voor de TestRPG website

*** Variables ***
${URL}                  https://test-rpg.vercel.app/play                                    # De URL van de TestRPG website
${BROWSER}              chromium                                                            # Browser type: chromium, firefox, webkit, brave
${HEADLESS}             False                                                               # True voor headless mode, False voor zichtbare browser
${BROWSER_ARGS}         --start-maximized                                                   # Extra browser argumenten
${BRAVE_EXECUTABLE}     /Applications/Brave Browser.app/Contents/MacOS/Brave Browser        # Pad naar Brave browser executable (macOS)
