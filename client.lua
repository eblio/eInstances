-- ## eInstances : client side

local KVP_LAST_INSTANCE = 'instance:last'

local inInstance = false
local currentInstanceId = 0

local function clearPlayers()

	local playerList = GetActivePlayers()
	for i = 1, #playerList do

		local player = playerList[i]

		if NetworkIsPlayerConcealed(player) then
			NetworkConcealPlayer(player, false)
			log("player : " .. player .. " - visible")
		end

	end

end

local function concealPlayers()

	local localPlayer = PlayerId()
	local playerList = GetActivePlayers()
	for i = 1, #playerList do

		local player = playerList[i]

		if player ~= localPlayer then

			local concealed = NetworkIsPlayerConcealed(player)
			local inCurrentInstance = isPlayerInInstance(currentInstanceId, GetPlayerServerId(player))

			if not concealed and not inCurrentInstance then
				NetworkConcealPlayer(player, true)
				log("player : " .. player .. " - invisible")
			end
			
			if concealed and inCurrentInstance then
				NetworkConcealPlayer(player, false)
				log("player : " .. player .. " - visible")
			end

		end

	end

end

local function getPlayersInInstance()
	local players = {}

	if inInstance then
		for k, _ in pairs(getInstance(currentInstanceId)) do
			players[#players+1] = GetPlayerFromServerId(k)
		end
	else
		players = GetActivePlayers()
	end

	return players
end

local function getClosestPlayer(radius)
	local min = radius
	local closestPlayer = nil

	local playersList = getPlayersInInstance()
	local localPed = PlayerPedId()
	local localCoords = GetEntityCoords(localPed)

	for i = 1, #playersList do

		local player = playersList[i]
		local playerPed = GetPlayerPed(player)

		if localPed ~= playerPed then

			local playerCoords = GetEntityCoords(playerPed)
			local dist = #(localCoords - playerCoords)

			if dist < min then
				closestPlayer = player
				min = dist
			end

		end
		
	end

	return closestPlayer, min
end

local function enterInstance(instanceId)
	if not inInstance then
		if isInstanceIdValid(instanceId) then
			TriggerServerEvent('instance:entered', instanceId)
			TriggerEvent('instance:entered', instanceId)

			inInstance = true
			currentInstanceId = instanceId

			SetResourceKvp('instance:last', instanceId)
			concealPlayers()

			log("entered : " .. instanceId)
		else
			log("failed to enter " .. instanceId .. " (invalid identifier)")
		end
	else
		log("failed to enter " .. instanceId .. " (already in an instance)")
	end
end

local function leaveInstance()
	if inInstance then
		local instanceId = currentInstanceId
		TriggerServerEvent('instance:left', instanceId)
		TriggerEvent('instance:left', instanceId)

		inInstance = false
		currentInstanceId = nil

		SetResourceKvp(KVP_LAST_INSTANCE, 'nil')
		clearPlayers()

		log("left : " .. instanceId)
	else
		log("failed to leave instance (not in an instance)")
	end
end

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('instances:get')
	local lastInstanceId = GetResourceKvpString(KVP_LAST_INSTANCE)

	if isInstanceIdValid(lastInstanceId) and lastInstanceId ~= 'nil' then
		TriggerEvent('instance:wasInInstance', lastInstanceId) -- Notify that the player was in an instance when he disconnected
		log("disconnected in an instance : " .. lastInstanceId)
	end
end)

-- Register Enter/Leave instance as exports
exports('EnterInstance', enterInstance)
exports('LeaveInstance', leaveInstance)
exports('GetPlayersInInstance', getPlayersInInstance)
exports('GetClosestPlayerInInstance', getClosestPlayer)

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
