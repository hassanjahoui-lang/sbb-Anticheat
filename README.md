# Stonebridge Bay Roleplay Anticheat
Non modificabile per questi di copyright e se si usa in un server pubblico deve essere menzionato durante la presentazione del server o della versione

Questo script fornisce una protezione di base contro i cheater sul tuo server QBCore. 
Include una **Whitelist per gli Admin** (sia txAdmin che QB-Admin), il che significa che lo staff può usare la GodMode, spawnare qualsiasi arma o prop senza essere bannato.

## ✨ Funzionalità
- **Anti-GodMode:** Banna chi prova ad essere invincibile o modifica la propria salute massima.
- **Anti-Danno Modificato:** Banna chi modifica il danno delle armi per uccidere con un colpo (One-Tap cheat).
- **Anti-Armi Blacklistate:** Blocca RPG, Minigun ecc. (Gli admin possono comunque spawnarle).
- **Anti-Spam Esplosioni:** Ferma i modder che provano a far laggare il server spammando esplosioni.
- **Anti-Spam Prop:** Blocca la creazione di oggetti noti per far crashare il server.
- **Log su Discord:** Segnala ban ed exploit direttamente nel tuo canale Discord.

## 🛠️ Come Installare
1. Inserisci la cartella `qb-anticheat` dentro la cartella `resources`.
2. Apri il file `config.lua` e inserisci il link del tuo Webhook Discord alla riga `Config.Webhook`.
3. Apri il tuo file `server.cfg` e aggiungi questa riga in basso:
   ```cfg
   ensure qb-anticheat

1. Riavvia il server.

Tutto fatto! Inserisci questi file, avvia lo script e il tuo server avrà un'ottima linea di difesa base contro i modder.
