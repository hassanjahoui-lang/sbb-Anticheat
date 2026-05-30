local QBCore = exports['qb-core']:GetCoreObject()

-- Funzione per richiedere il ban al server
local function BanMe(reason)
    TriggerServerEvent('qb-anticheat:server:BanPlayer', reason)
end

CreateThread(function()
    while true do
        Wait(2000) -- Controlla ogni 2 secondi per non laggare
        local ped = PlayerPedId()
        local playerId = PlayerId()

        -- 1. Controllo GodMode (Invincibilità)
        if Config.Checks.GodMode then
            local maxHealth = GetEntityMaxHealth(ped)
            local health = GetEntityHealth(ped)
            if GetPlayerInvincible(playerId) or GetPlayerInvincible_2(playerId) then
                BanMe("Godmode Rilevato (Invincibile)")
            end
            if health > 200 and maxHealth <= 200 then
                BanMe("Godmode Rilevato (Vita oltre il limite)")
            end
        end

        -- 2. Controllo Danno Armi (One-shot kill cheats)
        if Config.Checks.WeaponDamageModifiers then
            local weaponHash = GetSelectedPedWeapon(ped)
            if weaponHash ~= `WEAPON_UNARMED` then
                local damageModifier = GetPlayerWeaponDamageModifier(playerId)
                local meleeModifier = GetPlayerMeleeWeaponDamageModifier(playerId)
                
                if damageModifier > 1.0 or meleeModifier > 1.0 then
                    BanMe("Modificatore Danno Arma Rilevato (Danno Aumentato)")
                end
            end
        end

        -- 3. Controllo Armi Blacklistate
        for _, weapon in pairs(Config.BlacklistedWeapons) do
            if HasPedGotWeapon(ped, GetHashKey(weapon), false) then
                RemoveWeaponFromPed(ped, GetHashKey(weapon))
                BanMe("Arma Blacklistata Rilevata: " .. weapon)
            end
        end

        -- 4. Controllo Visione Termica/Notturna
        if Config.Checks.ThermalVision then
            if GetUsingseethrough() or GetUsingnightvision() then
                BanMe("Visione Termica/Notturna da ModMenu Rilevata")
            end
        end

        -- 5. Controllo Munizioni Infinite
        if Config.Checks.InfiniteAmmo then
            SetPedInfiniteAmmoClip(ped, false)
        end
    end
end)
