local instances = {}

local function DoesInstanceExist(instanceId)
	return (instances[instanceId] ~= nil)
end

local function FindElement(var, tab)
	for i = 1, #tab do
		if var == tab[i] then
			return true, i
		end
	end
	return false, 0
end

RegisterServerEvent('instances:get')
AddEventHandler('instances:get', function()
	local Source = source
	TriggerClientEvent('instances:set', Source, instances)
end)

RegisterServerEvent('instances:update')
AddEventHandler('instances:update', function(instanceId, joining)
	local Source = source

	if joining then

		if not DoesInstanceExist(instanceId) then
			instances[instanceId] = {}
		end

		table.insert(instances[instanceId], Source)

	else

		if DoesInstanceExist(instanceId) then
			local handle, index = FindElement(Source, instances[instanceId])

			if handle then
				table.remove(instances[instanceId], index)
			end

		end

	end

	TriggerClientEvent('instances:set', -1, instances)
end)