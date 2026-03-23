# 📱 BlockerApp – Guida Completa di Installazione
## Da zero all'app sul tuo iPhone (senza Mac fisico)

---

## 🌐 PASSO 1 – Registrati su MacInCloud

1. Vai su **https://www.macincloud.com**
2. Scegli il piano **"Pay As You Go"** (paghi solo le ore usate, ~$1/ora)
   - Per compilare e installare questa app ti servono **meno di 2 ore**
3. Crea un account e accedi al pannello di controllo
4. Avvia una sessione Mac con **macOS Ventura o Sonoma** + **Xcode 15**
5. Connettiti via browser (Remote Desktop o NoMachine incluso)

---

## 💻 PASSO 2 – Prepara Xcode sul Mac virtuale

Una volta connesso al Mac remoto:

1. Apri **Xcode** (già installato su MacInCloud)
2. Accedi con il tuo **Apple ID**: `Xcode → Preferences → Accounts → +`
3. Verifica che il tuo iPhone sia riconosciuto come destinazione di build

---

## 📁 PASSO 3 – Crea il progetto Xcode

### 3a. Crea il progetto principale

1. `File → New → Project`
2. Seleziona **iOS → App**
3. Impostazioni:
   - **Product Name**: `BlockerApp`
   - **Bundle Identifier**: `com.tuonome.blockerapp` *(sostituisci "tuonome" con qualcosa di tuo)*
   - **Interface**: SwiftUI
   - **Language**: Swift
4. Scegli una cartella e clicca **Create**

### 3b. Aggiungi il target CallKit Extension

1. `File → New → Target`
2. Seleziona **iOS → Call Directory Extension**
3. **Product Name**: `CallBlockerExtension`
4. **Bundle Identifier**: `com.tuonome.blockerapp.CallBlockerExtension`
5. Clicca **Activate** quando richiesto

### 3c. Configura l'App Group (per condividere dati tra app ed extension)

1. Seleziona il progetto nel navigator → Target **BlockerApp**
2. Tab **Signing & Capabilities** → `+ Capability` → **App Groups**
3. Aggiungi: `group.com.tuonome.blockerapp`
4. Ripeti per il target **CallBlockerExtension** (stesso App Group ID)

---

## 📋 PASSO 4 – Copia i file Swift

Trasferisci i file sul Mac virtuale (trascina nella sessione Remote Desktop, oppure usa il clipboard):

### Nel folder `BlockerApp/` del progetto, sostituisci/aggiungi:

| File | Descrizione |
|------|-------------|
| `BlockerApp.swift` | Entry point app |
| `BlacklistStore.swift` | Modello dati + persistenza |
| `ContentView.swift` | Navigazione a tab |
| `BlacklistView.swift` | Lista numeri bloccati |
| `AddNumberView.swift` | Aggiunta manuale |
| `ImportView.swift` | Import CSV/TXT |
| `SettingsView.swift` | Impostazioni e stato |
| `Info.plist` | Configurazione app |

### Nel folder `CallBlockerExtension/`, sostituisci:

| File | Descrizione |
|------|-------------|
| `CallDirectoryHandler.swift` | Il vero blocco chiamate via CallKit |
| `Info.plist` | Configurazione extension |

---

## ✏️ PASSO 5 – Personalizza il Bundle Identifier

In **tutti** i file, sostituisci `com.tuonome.blockerapp` con il tuo identificatore unico.
Esempio: se ti chiami Mario Rossi → `com.mariorossi.blockerapp`

File da modificare:
- `BlacklistStore.swift` → riga `appGroupID`
- `CallDirectoryHandler.swift` → riga `appGroupID`
- `SettingsView.swift` → riga con l'identifier dell'extension
- `Info.plist` di entrambi i target
- Le impostazioni Xcode (Signing & Capabilities)

---

## 📱 PASSO 6 – Collega il tuo iPhone

### Con account gratuito (sideloading):
1. Collega iPhone al Mac virtuale via **USB** 
   *(su MacInCloud usa USB over Network o carica i file diversamente)*
2. In alternativa: usa **wireless** se iPhone e Mac sono sulla stessa rete
3. In Xcode: seleziona il tuo iPhone come destinazione
4. `Product → Run` (⌘R)
5. Sul iPhone: `Impostazioni → Generale → VPN e gestione dispositivo → Trust`

> ⚠️ **Limite account gratuito**: l'app scade dopo **7 giorni**. Devi ricollegare l'iPhone e fare rebuild. Con account a $99/anno l'app non scade mai.

---

## ⚙️ PASSO 7 – Attiva il blocco chiamate su iPhone

Dopo l'installazione:

1. `Impostazioni → Telefono`
2. `Blocco chiamate e identificazione ID chiamante`
3. Attiva l'interruttore accanto a **BlockerApp**

✅ Da questo momento tutte le chiamate dai numeri in blacklist verranno bloccate automaticamente.

---

## 📲 PASSO 8 – Usa l'app

### Aggiungere numeri:
- **Manualmente**: scheda "Aggiungi" → inserisci numero con prefisso (+39...)
- **Da file**: scheda "Importa" → scegli file CSV/TXT

### Formato file CSV/TXT accettato:
```
+393331234567,Telemarketing
+390212345678,Numero sconosciuto  
+393491111111
```

### Importare i bloccati già presenti su iOS:
1. `Impostazioni → Telefono → Bloccati e ID chiamante`
2. Prendi nota dei numeri
3. Nella scheda "Importa" → incollali nella casella di testo
4. Tocca "Importa dalla lista"

---

## 🔄 Aggiornare la blacklist in futuro

Ogni volta che aggiungi/rimuovi numeri nell'app, l'extension CallKit si ricarica automaticamente. Non serve fare nulla di extra.

---

## ❓ Problemi comuni

| Problema | Soluzione |
|----------|-----------|
| "App non verificata" su iPhone | `Impostazioni → Generale → VPN e gestione dispositivo → Trust` |
| L'extension non blocca le chiamate | `Impostazioni → Telefono → Blocco chiamate` → verifica attivazione |
| "Signing certificate" non trovato | `Xcode → Preferences → Accounts` → aggiungi il tuo Apple ID |
| App scaduta (7 giorni) | Riconnetti iPhone a Xcode e fai `Product → Run` di nuovo |
| Numeri non bloccati dopo import | Scheda Impostazioni → "Ricarica Extension" |

---

## 💡 Suggerimenti

- **Formato numeri**: usa sempre il prefisso internazionale (+39 per Italia)
- **Liste grandi**: puoi importare migliaia di numeri da un CSV, CallKit li gestisce
- **Backup**: la lista è salvata nell'App Group, fai un backup del file `blocklist.json`

---

*App sviluppata con SwiftUI + CallKit | Uso personale*
