local QBCore = exports['qb-core']:GetCoreObject()
local ExplosionLog = {}

-- Funzione Discord Webhook
local function SendWebhook(title, message, color)
    if Config.Webhook == "INSERISCI_QUI_IL_TUO_WEBHOOK_DISCORD" or Config.Webhook == "" then return end
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color,
            ["footer"] = { ["text"] = "QBCore AntiCheat System" },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "AntiCheat", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- 👑 FUNZIONE CONTROLLO ADMIN (txAdmin & QBCore)
local function IsPlayerAdmin(src)
    -- Controlla permessi QBCore
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        return true
    end
    -- Controlla permessi txAdmin / Ace Permissions
    if IsPlayerAceAllowed(src, "command") then
        return true
    end
    return false
end

-- 🚨 Evento Ban dal Client
RegisterNetEvent('qb-anticheat:server:BanPlayer', function(reason)
    local src = source
    if src <= 0 then return end

    -- SE IL GIOCATORE È UN ADMIN, BLOCCA IL BAN (Whitelist)
    if IsPlayerAdmin(src) then return end

    local identifier = QBCore.Functions.GetIdentifier(src, 'license')
    local discord = QBCore.Functions.GetIdentifier(src, 'discord')
    local playerName = GetPlayerName(src)

    -- Inserisce il ban nel database di QBCore
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', 
    {playerName, identifier, discord, GetPlayerEndpoint(src), reason, 2147483647, 'AntiCheat'})
    
    SendWebhook("🚫 GIOCATORE BANNATO", "**Nome:** " .. playerName .. "\n**ID:** " .. src .. "\n**Motivo:** " .. reason, 16711680)
    DropPlayer(src, "Sei stato bannato permanentemente dall'AntiCheat. Motivo: " .. reason)
end)

-- 🛡️ PROTEZIONE EXPLOIT EVENTI (Soldi infiniti ecc.)
local BlacklistedEvents = {
    "qb-bossmenu:server:withdrawMoney",
    "qb-shops:server:UpdateEquipment",
    "hospital:server:RevivePlayer"
}

for _, event in pairs(BlacklistedEvents) do
    AddEventHandler(event, function()
        local src = source
        if src > 0 and IsPlayerAdmin(src) then return end -- Ignora gli Admin
        
        CancelEvent()
        SendWebhook("⚠️ TENTATO EXPLOIT", "**Giocatore ID:** " .. src .. "\n**Ha tentato di triggerare:** " .. event, 16776960)
    end)
end

-- 🛡️ PROTEZIONE ENTITÀ E PROP (Spam Prop Crash)
AddEventHandler("entityCreating", function(entity)
    local model = GetEntityModel(entity)
    local eType = GetEntityType(entity)

    if eType == 3 then
        local owner = NetworkGetEntityOwner(entity)
        if owner > 0 and IsPlayerAdmin(owner) then return end -- Ignora gli Admin

        for _, blacklistedProp in pairs(Config.BlacklistedProps) do
            if model == GetHashKey(blacklistedProp) then
                CancelEvent() -- Ferma lo spawn
                if owner > 0 then
                    SendWebhook("🧱 PROP BLOCCATO", "Giocatore ID " .. owner .. " ha provato a spawnare " .. blacklistedProp, 16753920)
                end
                break
            end
        end
    end
end)

-- 🛡️ PROTEZIONE ESPLOSIONI MASSIVE
AddEventHandler('explosionEvent', function(sender, ev)
    if sender > 0 and IsPlayerAdmin(sender) then return end -- Ignora gli Admin

    if ev.damageScale > 1.0 or ev.isAudible == false then 
        CancelEvent()
    end

    if not ExplosionLog[sender] then
        ExplosionLog[sender] = { count = 0, time = os.time() }
    end

    if os.time() - ExplosionLog[sender].time > 1 then
        ExplosionLog[sender].count = 0
        ExplosionLog[sender].time = os.time()
    end

    ExplosionLog[sender].count = ExplosionLog[sender].count + 1

    if ExplosionLog[sender].count > Config.MaxExplosionsPerSecond then
        CancelEvent()
        TriggerEvent('qb-anticheat:server:BanPlayer', "Spam di Esplosioni (Crash Attempt)")
    end
end)
