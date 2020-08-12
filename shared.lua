-----
-- ## INSTANCES
-----

local instances = {} -- instances

-- OBJ : set all instances
-- PARAMS :
--      - new : instances
function setInstances(new)
	instances = new
end

-- OBJ : get all instances
function getInstances()
    return instances
end

-- OBJ : set a specific instance
-- PARAMS :
--      - id : instance id
--      - content : instance content
function setInstance(id, content)
	instances[id] = content
end

-- OBJ : get a specific instance
-- PARAMS :
--      - id : instance id
function getInstance(id)
    return instances[id]
end

-- OBJ : check if an instance id is valid
-- PARAMS :
--      - id : instance id
function isInstanceIdValid(id)
	return id ~= nil and type(id) == 'string'
end

-- OBJ : check if an instance exist
-- PARAMS :
--      - id : instance id
function doesInstanceExist(id)
	return (instances[id] ~= nil)
end

-- OBJ : check if a player is in an instance
-- PARAMS :
--      - id : instance id
--      - player : server id of the player
function isPlayerInInstance(id, player)
    return doesInstanceExist(id) and instances[id][player] ~= nil
end

-- OBJ : add a player to an instance
-- PARAMS :
--      - id : instance id
--      - player : server id of the player
function addPlayerToInstance(id, player)
    if not doesInstanceExist(id) then
        instances[id] = {}
    end

    instances[id][player] = true
end

-- OBJ : remove a player from instance
-- PARAMS :
--      - id : instance id
--      - player : server id of the player
function removePlayerFromInstance(id, player)
    if doesInstanceExist(id) then
        instances[id][player] = nil
    end
end

-----
-- ## UTILS
-----

local DEBUG = false -- is debug mode

-- OBJ : create a net event
-- PARAMS :
--      - name : event name
--      - reference : event function
function createNetEvent(name, reference)
    RegisterNetEvent(name)
    AddEventHandler(name, reference)
end

-- OBJ : print messages if in debug mode
-- PARAMS : 
--      - t : text to print
function log(t)
	if DEBUG then print("eInstances | " .. t) end
end
