-- ## eInstances : server side

local function getAllInstances()
	local Source = source
	TriggerClientEvent('instances:set', Source, getInstances())
end

local function enteredInstance(id)
	local Source = source

	if isInstanceIdValid(id) then

		addPlayerToInstance(id, Source)
		TriggerClientEvent('instance:set', -1, id, getInstance(id))
		log("player " .. Source .. " entered " .. id)

	end
end

local function leftInstance(id)
	local Source = source
	
	if isInstanceIdValid(id) and isPlayerInInstance(id, Source) then

		removePlayerFromInstance(id, Source)
		TriggerClientEvent('instance:set', -1, id, getInstance(id))
		log("player " .. Source .. " left " .. id)

	end
end

-- Register functions as events
createNetEvent('instance:entered', enteredInstance)
createNetEvent('instance:left', leftInstance)
createNetEvent('instances:get', getAllInstances)
