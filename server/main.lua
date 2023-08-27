local CBCore = exports['cb-core']:GetCoreObject()

-- Get permissions --

CBCore.Functions.CreateCallback('cb-anticheat:server:GetPermissions', function(source, cb)
    local group = CBCore.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterNetEvent('cb-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerEvent("cb-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", "You were banned "..reason, false)
    MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        CBCore.Functions.GetIdentifier(src, 'license'),
        CBCore.Functions.GetIdentifier(src, 'discord'),
        CBCore.Functions.GetIdentifier(src, 'ip'),
        reason,
        2145913200,
        'Anti-Cheat'
    })
    DropPlayer(src, "You have been banned for cheating. Check our Discord for more information: " .. QBCore.Config.Server.discord)
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("cb-anticheat:client:NonRegisteredEventCalled", source, "cheating", CalledEvent)
end

for x, v in pairs(Config.BlacklistedEvents) do
    RegisterServerEvent(v)
    AddEventHandler(v, function(source)
        NonRegisteredEventCalled(v, source)
    end)
end

-- RegisterServerEvent('banking:withdraw')
-- AddEventHandler('banking:withdraw', function(source)
--     NonRegisteredEventCalled('bank:withdraw', source)
-- end)

CBCore.Functions.CreateCallback('cb-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = CBCore.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)