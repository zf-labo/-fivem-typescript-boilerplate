PlayerLoaded, PlayerData = nil, {}
ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
    TriggerEvent(cache.resource .. ':onPlayerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    table.wipe(PlayerData)
    PlayerLoaded = false
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not ESX.PlayerLoaded then return end
    PlayerData = ESX.GetPlayerData()
    PlayerLoaded = true
    TriggerEvent(cache.resource .. ':onPlayerLoaded')
end)

-- Function used to get latest player data
Bridge.GetPlayerData = function()
    return ESX.GetPlayerData()
end

-- Function to return nearby players
--- @param coords vector3 | vector4
Bridge.GetNearbyPlayers = function(coords)
    return ESX.Game.GetPlayersInArea(coords, 400)
end

-- Function the get the time difference between to given values
--- @param time1 number
--- @param time2 number
--- @return minutes number
Bridge.TimeAgo = function(time1, time2)
    return math.floor((time2 - time1) / 60)
end

-- Function to get a local player identifier
Bridge.GetIdentifier = function()
    local PlayerData = Bridge.GetPlayerData()
    if not PlayerData then return end
    return PlayerData.identifier
end

Bridge.Round = function(float, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(float * mult + 0.5) / mult
end

Bridge.addTargetSphere = function(data)
    return exports.ox_target:addSphereZone(data)
end

Bridge.addInteractPoint = function(data)
    return exports.interact:AddInteraction(data)
end

Bridge.removeTargetSphere = function(id)
    exports.ox_target:removeZone(id)
end

Bridge.removeInteractPoint = function(id)
    exports.interact:RemoveInteraction(id)
end
