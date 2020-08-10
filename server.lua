-- ## eInstances : server side

-- Current instances
local instances = {}

local function getInstances()
	local Source = source
	TriggerClientEvent('instances:set', Source, instances)
end

local function enteredInstance(instanceId)
	local Source = source

	if isInstanceIdValid(instanceId) then
		
		if not doesInstanceExist(instanceId) then
			instances[instanceId] = {}
		end

		instances[instanceId][Source] = true
		TriggerClientEvent('instance:set', -1, instanceId, instances[instanceId])

	end
end

local function leftInstance(instanceId)
	local Source = source

	if isInstanceIdValid(instanceId) and isPlayerInInstance(instanceId, Source) then
		instances[instanceId][Source] = nil
		TriggerClientEvent('instance:set', -1, instanceId, instances[instanceId])
	end
end

-- Register functions as events
createNetEvent('instance:entered', enteredInstance)
createNetEvent('instance:left', leftInstance)
createNetEvent('instances:get', getInstances)
