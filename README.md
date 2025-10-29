# Testplan - TestRPG Regressietest

## 1. Applicatie Overzicht

**TestRPG** is een web-gebaseerde game waarbij spelers een karakter creëren en door het voltooien van taken levels behalen (max level 5).

**URL**: https://test-rpg.vercel.app/play

---

### Scherm 1: Intro Scherm
![Intro Scherm](afbeeldingen/scherm_1.png)

- Welkomstbericht met "Click here to play" knop

---

### Scherm 2: Character Creation
![Character Creation](afbeeldingen/scherm_2.png)

- Character naam invoer (minimaal 3 karakters)
- Build selectie dropdown (Thief, Mage, etc.)
- Start knop

---

### Scherm 3: Main Gameplay
![Main Gameplay](afbeeldingen/scherm_3.png)

**Vier taken voor level progression:**
1. **Level 1 → 2**: Klik 5x op knop
2. **Level 2 → 3**: Upload bestand
3. **Level 3 → 4**: Type "Lorem Ipsum"
4. **Level 4 → 5**: Beweeg slider naar rechts

---

### Scherm 4: Login
![Login Scherm](afbeeldingen/scherm_4.png)

- Email validatie (@ met tekst ervoor/erna + suffix)
- Wachtwoord veld (mag niet leeg zijn)
- Login/Logout functionaliteit

---

## 2. Testaanpak

### 2.1 Navigatie & Schermverificatie
- Verifieer intro scherm via welkomst tekst
- Test navigatie tussen schermen
- Controleer aanwezigheid karakteristieke teksten per scherm

### 2.2 Character Creation Validatie
**Negatieve tests:**
- Leeg naam veld → verwacht foutmelding
- Naam < 3 karakters → verwacht foutmelding

**Positieve test:**
- Geldige naam (≥3 karakters) + build selectie → verwacht navigatie naar gameplay

### 2.3 Gameplay Flow Testing
Voor elke taak (Level 1-5):
- Verifieer initiële state (level tekst, avatar, stats)
- Voer taak uit
- Controleer success message
- Verifieer level up (tekst, avatar, stats)

**Edge cases bij text input:**
- Incorrecte tekst ("Lorem Ipsumm")
- Case sensitivity ("lorem ipsum")
- Gedeeltelijke match ("Lorem")
- Extra spaties/special characters

### 2.4 Login Testing
**Negatieve tests:**
- Email zonder @ → verwacht foutmelding
- Email zonder suffix → verwacht foutmelding
- @ aan begin/einde → verwacht foutmelding
- Leeg wachtwoord → verwacht foutmelding

**Positieve test:**
- Geldig email + wachtwoord → verifieer via aanwezigheid "Logout" knop

### 2.5 Reset Functionaliteit
- Test "Play Again" → verwacht return naar character creation

---

## 3. Toegepaste TMAP Testtechnieken

### 3.1 Beslissingstabeltesten
Gebruikt voor character creation validatie met combinaties van:
- Naam lengte (leeg / <3 / ≥3 karakters)
- Build selectie (geselecteerd)

### 3.2 Grenswaarde Analyse
- Character naam: 0, 2, 3, 15, 16+ karakters
- Click taak: 4e vs 5e klik voor level up
- Email validatie: positie van @ (begin/midden/einde)

### 3.3 Equivalentieklasses
**Character naam:**
- Ongeldige klasse: leeg, <3 karakters
- Geldige klasse: 3-15 karakters
- Grenswaarde klasse: >15 karakters

**Email validatie:**
- Ongeldige: geen @, geen suffix, @ verkeerd gepositioneerd
- Geldige: correct formaat

### 3.4 State Transition Testing
Gameplay progression: Level 1 → 2 → 3 → 4 → 5
- Verifieer state veranderingen (avatar, tekst, stats)
- Test reset via "Play Again"

### 3.5 Exploratory Testing
- Lange character namen (>15 karakters) → UI break ontdekt
- Bestand upload zonder restricties → security risico geïdentificeerd
- Wachtwoord met 1 karakter → zwakke validatie ontdekt

---

## 4. Testdekking Regressietest

De geautomatiseerde regressietest (FE.robot) dekt de volgende onderdelen:
- ✅ Navigatie & schermverificatie (TC001)
- ✅ Login validatie met beslissingstabeltesten (TC002)
- ✅ Character creation met negatieve en positieve flows (TC003)
- ✅ Gameplay flow voor alle 5 levels met state transitions (TC004)
- ✅ Reset functionaliteit via "Play Again"

**Bevindingen uit Exploratory Testing** (handmatig ontdekt, niet geautomatiseerd):
- UI breaks bij character namen >15 karakters
- Zwakke wachtwoord validatie (1 karakter is toegestaan)
- Ongevalideerde bestand upload (security risico)

Deze bevindingen zijn gedocumenteerd in sectie 5 (Bevindingen & Aanbevelingen).

---

## 5. Bevindingen & Aanbevelingen

### 🔴 Kritiek - Security Risico's

**Issue 1: Ongevalideerde Bestand Upload**
- **Risico**: XSS aanvallen, malware uploads, server toegang
- **Aanbeveling**: Implementeer bestandstype whitelist, grootte limiet, malware scanning

**Issue 2: Zwakke Wachtwoord Vereisten**
- **Risico**: Extreem onveilig (1 karakter = geldig)
- **Aanbeveling**: Minimaal 8 karakters, 1 hoofdletter, 1 cijfer, 1 speciaal karakter

---

### 🟡 Hoog - UI/UX Issues

**Issue 3: Character Naam Lengte**
- **Probleem**: Geen maximale lengte → UI breekt bij >15 karakters
- **Aanbeveling**: Max 15 karakters OF automatische line breaks

**Issue 4: Misleidende Tekst**
- **Probleem**: "Choose a build and level up your character!" blijft zichtbaar in gameplay
- **Aanbeveling**: Wijzig naar "Complete tasks to level up!" in gameplay scherm

---

### 🟢 Laag - Feature Gaps

**Issue 5: Login zonder Toegevoegde Waarde**
- **Probleem**: Inloggen biedt geen functionaliteit
- **Aanbeveling**: Voeg highscore/leaderboard toe OF verwijder login feature

---

**Framework**: Robot Framework + Browser Library  
**Datum**: 26 oktober 2025  
**Auteur**: Tristan Weber
