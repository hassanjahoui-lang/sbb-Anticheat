Config = {}

-- Inserisci qui l'URL del Webhook del tuo canale Discord (lascia vuoto "" se non lo vuoi usare)
Config.Webhook = "INSERISCI_QUI_IL_TUO_WEBHOOK_DISCORD" 

-- Attiva/Disattiva i controlli sul client
Config.Checks = {
    GodMode = true,
    InfiniteAmmo = true,
    WeaponDamageModifiers = true,
    ThermalVision = true,
}

-- Armi che nessun giocatore normale dovrebbe avere
Config.BlacklistedWeapons = {
    "weapon_rpg",
    "weapon_minigun",
    "weapon_railgun",
    "weapon_grenadelauncher",
    "weapon_raypistol",
}

-- Oggetti (Prop) usati dai modder per far laggare/crashare il server
Config.BlacklistedProps = {
    "prop_windmill_01c",
    "prop_crashed_heli",
    "des_w_crash",
    "p_spinning_anus_s",
    "prop_mass_meteorite",
}

-- Numero massimo di esplosioni al secondo prima del ban
Config.MaxExplosionsPerSecond = 3
