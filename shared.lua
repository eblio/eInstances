-- OBJ : create a net event
-- PARAMS :
--      - name : event name
--      - reference : event function
function createNetEvent(name, reference)
    RegisterNetEvent(name)
    AddEventHandler(name, reference)
end

-- OBJ : check if an instance id is valid
-- PARAMS :
--      - instanceId : instance id
function isInstanceIdValid(instanceId)
	return instanceId ~= nil and type(instanceId) == 'string'
end

-- OBJ : check if an instance exist
-- PARAMS :
--      - instanceId : instance id
function doesInstanceExist(instanceId)
	return (instances[instanceId] ~= nil)
end

-- OBJ : check if a player is in an instance
-- PARAMS :
--      - instanceId : instance id
--      - serverId : server id of the player
function isPlayerInInstance(instanceId, serverId)
    return doesInstanceExist(instanceId) and instances[instanceId][serverId] ~= nil
end
