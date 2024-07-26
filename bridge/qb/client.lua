PlayerLoaded, PlayerData = nil, {}
QBCore = exports['qb-core']:GetCoreObject()

AddStateBagChangeHandler('isLoggedIn', '', function(_bagName, _key, value, _reserved, _replicated)
    if value then
        PlayerData = QBCore.Functions.GetPlayerData()
    else
        table.wipe(PlayerData)
    end
    PlayerLoaded = value
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent(cache.resource .. ':onPlayerLoaded')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true
    TriggerEvent(cache.resource .. ':onPlayerLoaded')
end)

-- Function used to get latest player data
Bridge.GetPlayerData = function()
    return QBCore.Functions.GetPlayerData()
end

-- Function to return nearby players
--- @param coords vector3 | vector4
Bridge.GetNearbyPlayers = function(coords)
    return QBCore.Functions.GetPlayersFromCoords(coords, 400)
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
    return PlayerData.citizenid
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
