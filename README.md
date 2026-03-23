# 🛡️ BlockerApp – Guida GitHub Actions (100% Gratis)

Questa guida ti permette di compilare BlockerApp **senza Mac fisico e senza pagare nulla**,
usando i Mac virtuali gratuiti di GitHub Actions.

---

## 📋 Cosa ti serve

- Un account **GitHub** (gratuito) → https://github.com
- Un account **Apple** (gratuito) → https://appleid.apple.com
- **AltStore** o **Sideloadly** installato sul tuo PC Windows/Linux (gratuiti)
- Il tuo **iPhone** con cavo USB

---

## 🚀 PASSO 1 – Crea il repository su GitHub

1. Vai su **https://github.com/new**
2. Nome repository: `blockerapp` (o come preferisci)
3. Visibilità: **Public** ← obbligatorio per usare i Mac runner gratis
4. Clicca **Create repository**

---

## 📤 PASSO 2 – Carica i file nel repository

### Metodo A – Carica via browser (più semplice)

1. Apri il tuo repository su GitHub
2. Clicca **"uploading an existing file"** o il pulsante **Add file → Upload files**
3. Trascina l'intera cartella `BlockerApp/` (con tutto dentro)
4. Scrivi come commit message: `First commit`
5. Clicca **Commit changes**

### Struttura che deve avere il repository:
```
/
├── .github/
│   └── workflows/
│       └── build.yml          ← il file workflow
├── BlockerApp.xcodeproj/
│   └── project.pbxproj
├── BlockerApp/
│   ├── BlockerApp.swift
│   ├── BlacklistStore.swift
│   ├── ContentView.swift
│   ├── BlacklistView.swift
│   ├── AddNumberView.swift
│   ├── ImportView.swift
│   ├── SettingsView.swift
│   └── Info.plist
└── CallBlockerExtension/
    ├── CallDirectoryHandler.swift
    └── Info.plist
```

---

## ⚙️ PASSO 3 – Avvia la compilazione

### Automatica (ad ogni push):
La compilazione parte **automaticamente** ogni volta che carichi file nel repo.

### Manuale (on demand):
1. Vai nel tuo repository → tab **Actions**
2. Nel menu a sinistra clicca **"Build BlockerApp iOS"**
3. Clicca il pulsante **"Run workflow"** → **"Run workflow"**

---

## ⏳ PASSO 4 – Aspetta la compilazione (~10-15 minuti)

1. Tab **Actions** → clicca sul workflow in esecuzione
2. Vedrai i passaggi in tempo reale con ✅ o ❌
3. Quando finisce, scorri in basso fino alla sezione **Artifacts**

---

## 📥 PASSO 5 – Scarica il file .ipa

1. Nella pagina del workflow completato, sezione **Artifacts**
2. Clicca **"BlockerApp-ipa"** per scaricare lo ZIP
3. Estrai lo ZIP → trovi **BlockerApp.ipa**

---

## 📱 PASSO 6 – Installa sul iPhone con AltStore (GRATIS)

### Installa AltStore sul tuo PC:
1. Vai su **https://altstore.io** → scarica AltServer per Windows o Mac
2. Installa e avvia AltServer
3. Collega iPhone al PC con USB
4. Su iPhone: installa AltStore tramite AltServer (icona nella barra di sistema)
5. Su iPhone: `Impostazioni → Generale → VPN e gestione dispositivo → Trust "AltStore"`

### Installa BlockerApp:
1. Copia **BlockerApp.ipa** sul tuo iPhone (via AirDrop, email, Files...)
2. Su iPhone apri AltStore → **"My Apps"** → **+** in alto a sinistra
3. Seleziona il file **BlockerApp.ipa**
4. Inserisci la tua **Apple ID email e password** quando richiesto
5. Attendi l'installazione (~30 secondi)

> ⚠️ **Nota**: Con AltStore l'app dura **7 giorni**, poi devi rinnovarla.
> Connetti iPhone al PC con AltServer attivo → AltStore rinnova automaticamente.

---

## 📱 PASSO 6 alternativo – Installa con Sideloadly (GRATIS)

Se preferisci Sideloadly:
1. Scarica da **https://sideloadly.io**
2. Apri Sideloadly → trascina **BlockerApp.ipa**
3. Seleziona il tuo iPhone
4. Inserisci Apple ID → clicca **Start**
5. Su iPhone: `Impostazioni → Generale → VPN e gestione dispositivo → Trust`

---

## ⚙️ PASSO 7 – Attiva il blocco chiamate

1. `Impostazioni → Telefono`
2. `Blocco chiamate e identificazione ID chiamante`
3. Attiva **BlockerApp** ✅

---

## 🔁 Aggiornare l'app (aggiungere funzioni)

1. Modifica i file Swift nel repository GitHub (puoi farlo direttamente da browser)
2. La compilazione riparte automaticamente
3. Scarica il nuovo `.ipa` dagli Artifacts
4. Reinstalla con AltStore/Sideloadly

---

## ❓ Errori comuni

| Errore | Causa | Soluzione |
|--------|-------|-----------|
| Build fallita (❌) | Errore nel codice | Clicca sul step rosso per vedere i log, poi scarica "build-logs" |
| "Artifact not found" | Build non completata | Aspetta che tutti i ✅ siano verdi |
| "App non verificata" su iPhone | Normale con account gratuito | `Impostazioni → Generale → VPN e gestione dispositivo → Trust` |
| AltStore chiede rinnovo | App scaduta (7 giorni) | Apri AltStore con iPhone connesso al PC |
| Extension non blocca | Non attivata in iOS | `Impostazioni → Telefono → Blocco chiamate` → attiva BlockerApp |

---

## 💡 Riepilogo costi

| Componente | Costo |
|-----------|-------|
| GitHub (Mac runner) | **GRATIS** ✅ |
| AltStore / Sideloadly | **GRATIS** ✅ |
| Apple Developer Account | **GRATIS** ✅ (account base) |
| Rinnovo app ogni 7 giorni | **GRATIS** ✅ (automatico con AltServer) |
| **TOTALE** | **0 €** 🎉 |

---

*BlockerApp | Uso personale | SwiftUI + CallKit*
