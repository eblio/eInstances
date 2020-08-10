local instances = {}

local inInstance = false
local currentInstanceId = 0

local function IsInTable(var, tab)
	for i = 1, #tab do
		if var == tab[i] then
			return true
		end
	end
	return false
end

-- Nettoyage de tous les conceal
function ClearPlayers()

	if not inInstance then

		local playerList = GetActivePlayers()

		for i = 1, #playerList do

			local player = playerList[i]

			if NetworkIsPlayerConcealed(player) then

				NetworkConcealPlayer(player, false)

			end

		end

	end

end

-- Retour channel
function ClearVocal()

	if not inInstance then

		exports.elio:ToggleForcedChannel()

	end

end

-- Cache des autres joueurs
function ConcealPlayers()

	if inInstance then

		local playerList = GetActivePlayers()
		local instanceList = instances[currentInstanceId]

		if instanceList ~= nil then

			for i = 1, #playerList do

				local player = playerList[i]

				if not NetworkIsPlayerConcealed(player) and not IsInTable(GetPlayerServerId(player), instanceList) then

					NetworkConcealPlayer(player, true)

				elseif NetworkIsPlayerConcealed(player) and IsInTable(GetPlayerServerId(player), instanceList) then

					NetworkConcealPlayer(player, false)

				end

			end

		end

	end

end

-- Connexion channel
function ConcealVocal()

	if inInstance then

		exports.elio:ToggleForcedChannel(currentInstanceId + 100)

	end

end

exports('GetClosestPlayerInInstance', function()

	local minDist = 2.0
	local closestPlayerServerId = nil

	local localPlayerId = PlayerId()
	local localPlayerServerId = GetPlayerServerId(localPlayerId)
	local playerList = GetActivePlayers()
	local playerCoords1 = GetEntityCoords(PlayerPedId())

	for i = 1, #playerList do

		local playerId = playerList[i]
		local playerServerId = GetPlayerServerId(playerId)
		local playerPed = GetPlayerPed(playerId)

		if playerServerId ~= localPlayerServerId then
			if inInstance then

				if IsInTable(playerServerId, instances[currentInstanceId]) then

					local playerCoords2 = GetEntityCoords(playerPed)
					local dist = #(playerCoords1 - playerCoords2)

					if dist <= minDist then
						minDist = dist
						closestPlayerServerId = playerServerId
					end

				end

			else

				local playerCoords2 = GetEntityCoords(playerPed)
				local dist = #(playerCoords1 - playerCoords2)

				if dist <= minDist then
					minDist = dist
					closestPlayerServerId = playerServerId
				end

			end
		end
	end

	return closestPlayerServerId, minDist
end)

exports('GetPlayersInInstance', function()
	if inInstance then
		return instances[currentInstanceId]
	else
		return {GetPlayerServerId(PlayerId())}
	end
end)

-- exports('GetPlayersInRangeInInstance', function(dist)
-- 	local playersServerId = {}

-- 	local localPlayerId = PlayerId()
-- 	local localPlayerServerId = GetPlayerServerId(localPlayerId)
-- 	local playerList = GetActivePlayers()
-- 	local playerCoords1 = GetEntityCoords(PlayerPedId())

-- 	if inInstance then
-- 		local playerList = instances[currentInctanceId]
-- 	else
-- 		local playerList = GetActivePlayers()
-- 	end

-- 	for i = 1, #playerList do

-- 		local playerId = playerList[i]
-- 		local playerServerId = GetPlayerServerId(playerId)
-- 		local playerPed = GetPlayerPed(playerId)

-- 		if playerServerId ~= localPlayerServerId then
			
-- 			local playerCoords2 = GetEntityCoords(playerPed)
-- 			local d = #(playerCoords1 - playerCoords2)

-- 			if d <= dist then
-- 				playersServerId[#playersServerId+1] = playerServerId
-- 			end
			
-- 		end
-- 	end

-- 	return playersServerId
-- end)

-- RegisterCommand('join', function(source, args)
-- 	TriggerEvent('instances:join', tonumber(args[1]))
-- end)

-- RegisterCommand('leave', function(source, args)
-- 	TriggerEvent('instances:leave')
-- end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('instances:get')
end)

RegisterNetEvent('instances:set')
AddEventHandler('instances:set', function(_instances)
	instances = _instances
end)

AddEventHandler('instances:join', function(instanceId)

	inInstance = true
	currentInstanceId = instanceId

	Wait(500)

	ConcealVocal()
	ConcealPlayers()

	TriggerServerEvent('instances:update', instanceId, true)

end)

AddEventHandler('instances:leave', function()

	inInstance = false
	currentInstanceId = 0

	Wait(500)

	ClearVocal()
	ClearPlayers()

	TriggerServerEvent('instances:update', currentInstanceId, false)

end)

Citizen.CreateThread(function()

	while true do
		Wait(750)

		ConcealPlayers()

	end

end)

Citizen.CreateThread(function()

	while true do
		Wait(0)

		if inInstance then

			SetVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			local playerCoords = GetEntityCoords(PlayerPedId())
			RemoveVehiclesFromGeneratorsInArea(playerCoords.x - 900.0, playerCoords.y - 900.0, playerCoords.z - 900.0, playerCoords.x + 900.0, playerCoords.y + 900.0, playerCoords.z + 900.0)

		end

	end

end)