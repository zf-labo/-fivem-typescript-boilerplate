local ox_inv = GetResourceState('ox_inventory') == 'started'
ESX = exports['es_extended']:getSharedObject()

-- Get player from source
Bridge.GetPlayer = function(source)
    if not source then return end
    return ESX.GetPlayerFromId(source)
end

-- Function to get a player identifier by source
Bridge.GetIdentifier = function(source)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    return player.getIdentifier()
end

-- Function to get a players name
Bridge.GetName = function(source)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    return player.getName()
end

-- Function to return the specific amount of an item
Bridge.ItemCount = function(source, item)
    local player = Bridge.GetPlayer(source)
    if not player then return 0 end
    if ox_inv then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count
    else
        local item = player.getInventoryItem(item)
        if item ~= nil then
            return item.count
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
        player.addInventoryItem(item, count, metadata, slot)
    end
end

-- Function to remove an item from inventory
Bridge.RemoveItem = function(source, item, count, slot, metadata)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    if ox_inv then
        exports.ox_inventory:RemoveItem(source, item, count, metadata, slot)
    else
        player.removeInventoryItem(item, count, metadata, slot)
    end
end

-- Function to convert moneyType to match framework
ConvertMoneyType = function(moneyType)
    if moneyType == 'cash' then moneyType = 'money' end
    return moneyType
end

-- Function to add money to a players account
Bridge.AddMoney = function(source, moneyType, amount)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    player.addAccountMoney(moneyType, amount)
end

-- Function to remove money from a players account
Bridge.RemoveMoney = function(source, moneyType, amount)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    player.removeAccountMoney(moneyType, amount)
end

-- Function used to get players account balance
Bridge.GetPlayerAccountFunds = function(source, moneyType)
    local player = Bridge.GetPlayer(source)
    if not player then return 0 end
    moneyType = ConvertMoneyType(moneyType)
    return player.getAccount(moneyType).money
end

-- Function to register a usable item
Bridge.RegisterUsableItem = function(item, ...)
    ESX.RegisterUsableItem(item, ...)
end

Bridge.CheckMetadatas = function(metadatas)
    lib.versionCheck(metadatas.repo)
    for _,dependency in pairs(metadatas.dependencies) do
        if not lib.checkDependency(dependency.resource, dependency.version) then
            lib.print.error(('Missing dependency `%s` with minimum version `%s`'):format(dependency.resource, dependency.version))
        end
    end
end