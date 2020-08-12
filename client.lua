-- ## eInstances : client side

local KVP_LAST_INSTANCE = 'instance:last'

local instances = {}

local inInstance = false
local currentInstanceId = 0

function clearPlayers()

	local playerList = GetActivePlayers()
	for i = 1, #playerList do

		local player = playerList[i]

		if NetworkIsPlayerConcealed(player) then
			NetworkConcealPlayer(player, false)
		end

	end

end

function concealPlayers()

	local localPlayer = PlayerId()
	local playerList = GetActivePlayers()
	for i = 1, #playerList do

		local player = playerList[i]

		if player ~= localPlayer then

			local concealed = NetworkIsPlayerConcealed(player)
			local playerServerId = GetPlayerServerId(player)
			local inCurrentInstance = isPlayerInInstance(currentInstanceId, playerServerId)

			if not concealed and not inCurrentInstance then
				NetworkConcealPlayer(player, true)
			end
			
			if concealed and inCurrentInstance then
				NetworkConcealPlayer(player, false)
			end

		end

	end

end

local function setInstances(newInstances)
	instances = newInstances
end

local function setInstance(instanceId, instance)
	instances[instanceId] = instance
end

local function enterInstance(instanceId)
	if isInstanceIdValid(instanceId) then
		TriggerServerEvent('instance:entered', instanceId)
		TriggerEvent('instance:entered', instanceId)

		inInstance = true
		currentInstanceId = instanceId

		SetResourceKvp('instance:last', instanceId)
		concealPlayers()
	end
end

local function leaveInstance(instanceId)

	if not isInstanceIdValid(instanceId) then
		instanceId = currentInstanceId
	end

	TriggerServerEvent('instance:left', instanceId)
	TriggerEvent('instance:left', instanceId)

	inInstance = false
	currentInstanceId = nil

	SetResourceKvp(KVP_LAST_INSTANCE, 'nil')
	clearPlayers()
end

AddEventHandler('playerSpanwed', function()
	TriggerServerEvent('instances:get')
	local lastInstanceId = GetResourceKvpString(KVP_LAST_INSTANCE)

	if isInstanceIdValid(lastInstanceId) and lastInstanceId ~= 'nil' then
		TriggerEvent('instance:wasInInstance', lastInstanceId) -- Notify that the player was in an instance when he disconnected
	end
end)

-- Register Enter/Leave instance as exports
exports('EnterInstance', enterInstance)
exports('LeaveInstance', leaveInstance)

createNetEvent('instances:set', setInstances)
createNetEvent('instance:set', setInstance)

Citizen.CreateThread(function()
	while true do
		Wait(500)
		if inInstance then
			concealPlayers()
		end
	end
end)

RegisterCommand('enter', function(source, args)
	enterInstance(args[1])
end)

RegisterCommand('leave', function(source, args)
	leaveInstance()
end)

-- exports('GetClosestPlayerInInstance', function()

-- 	local minDist = 2.0
-- 	local closestPlayerServerId = nil

-- 	local localPlayerId = PlayerId()
-- 	local localPlayerServerId = GetPlayerServerId(localPlayerId)
-- 	local playerList = GetActivePlayers()
-- 	local playerCoords1 = GetEntityCoords(PlayerPedId())

-- 	for i = 1, #playerList do

-- 		local playerId = playerList[i]
-- 		local playerServerId = GetPlayerServerId(playerId)
-- 		local playerPed = GetPlayerPed(playerId)

-- 		if playerServerId ~= localPlayerServerId then
-- 			if inInstance then

-- 				if IsInTable(playerServerId, instances[currentInstanceId]) then

-- 					local playerCoords2 = GetEntityCoords(playerPed)
-- 					local dist = #(playerCoords1 - playerCoords2)

-- 					if dist <= minDist then
-- 						minDist = dist
-- 						closestPlayerServerId = playerServerId
-- 					end

-- 				end

-- 			else

-- 				local playerCoords2 = GetEntityCoords(playerPed)
-- 				local dist = #(playerCoords1 - playerCoords2)

-- 				if dist <= minDist then
-- 					minDist = dist
-- 					closestPlayerServerId = playerServerId
-- 				end

-- 			end
-- 		end
-- 	end

-- 	return closestPlayerServerId, minDist
-- end)

-- exports('GetPlayersInInstance', function()
-- 	if inInstance then
-- 		return instances[currentInstanceId]
-- 	else
-- 		return {GetPlayerServerId(PlayerId())}
-- 	end
-- end)
