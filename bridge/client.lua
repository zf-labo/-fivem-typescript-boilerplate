Bridge = {}

exports('getBridge', function()
    return Bridge
end)

local framework
local frameworks = {
    ['qb-core'] = 'qb',
    ['qbx_core'] = 'qb',
    ['es_extended'] = 'esx',
	-- ['custom'] = 'custom', -- UNCOMMENT THIS LINE TO ADD A CUSTOM FRAMEWORK AND ADD YOUR CODE IN THE CUSTOM FOLDER
}

for resource, name in pairs(frameworks) do
    if GetResourceState(resource) == 'started' then
        framework = name
        break
    end
end

if not framework then
	return error('No framework detected')
end

local scriptPath = ('bridge/%s/client.lua'):format(framework)
local resourceFile = LoadResourceFile(cache.resource, scriptPath)

if not resourceFile then
	return error(("Unable to find framework bridge for '%s'"):format(framework))
end

local func, err = load(resourceFile, ('@@%s/%s'):format(cache.resource, scriptPath))

if not func or err then
	return error(err)
end

func()