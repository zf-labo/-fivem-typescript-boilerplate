local ox_inv = GetResourceState('ox_inventory') == 'started'
QBCore = exports['qb-core']:GetCoreObject()


-- Get player from source
Bridge.GetPlayer = function(source)
    if not source then return end
    return QBCore.Functions.GetPlayer(source)
end

-- Function to get a player identifier by source
Bridge.GetIdentifier = function(source)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    return player.PlayerData.citizenid
end

-- Function to get a players name
Bridge.GetName = function(source)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
end

-- Function to return the specific amount of an item
Bridge.ItemCount = function(source, item)
    local player = Bridge.GetPlayer(source)
    if not player then return 0 end
    if ox_inv then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count
    else
        local item = player.Functions.GetItemByName(item)
        if item ~= nil then
            return item.amount
        else
            return 0
        end
    end
end

-- Function to add an item to inventory
Bridge.AddItem = function(source, item, count, slot, metadata)
    if count <= 0 then return end
    local player = Bridge.GetPlayer(source)
    if not player then return end
    if ox_inv then
        exports.ox_inventory:AddItem(source, item, count, metadata, slot)
    else
        if item == 'cash' or item == 'money' then
            Bridge.AddMoney(source, item, count)
            return
        end
        player.Functions.AddItem(item, count, slot, metadata)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add')
    end
end

-- Function to remove an item from inventory
Bridge.RemoveItem = function(source, item, count, slot, metadata)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    if ox_inv then
        exports.ox_inventory:RemoveItem(source, item, count, metadata, slot)
    else
        player.Functions.RemoveItem(item, count, slot, metadata)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
    end
end

-- Function to convert moneyType to match framework
ConvertMoneyType = function(moneyType)
    if moneyType == 'money' then moneyType = 'cash' end
    return moneyType
end

-- Function to add money to a players account
Bridge.AddMoney = function(source, moneyType, amount)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    player.Functions.AddMoney(moneyType, amount)
end

-- Function to remove money from a players account
Bridge.RemoveMoney = function(source, moneyType, amount)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    player.Functions.RemoveMoney(moneyType, amount)
end

-- Function used to get players account balance
Bridge.GetPlayerAccountFunds = function(source, moneyType)
    local player = Bridge.GetPlayer(source)
    if not player then return 0 end
    moneyType = ConvertMoneyType(moneyType)
    return player.PlayerData.money[moneyType]
end

-- Function to register a usable item
Bridge.RegisterUsableItem = function(item, ...)
    QBCore.Functions.CreateUseableItem(item, ...)
end

Bridge.CheckMetadatas = function(metadatas)
    lib.versionCheck(metadatas.repo)
    for _,dependency in pairs(metadatas.dependencies) do
        if not lib.checkDependency(dependency.resource, dependency.version) then
            lib.print.error(('Missing dependency `%s` with minimum version `%s`'):format(dependency.resource, dependency.version))
        end
    end
end
