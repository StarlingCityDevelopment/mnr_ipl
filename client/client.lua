local ipl = require 'config.ipl'
local zones = lib.load('config.zones')
local disable = lib.load('config.disable')
local entitysets = lib.load('config.entitysets')

local function unloadIpl(self)
    local iplList = ipl[self.name]
    if not iplList then return end

    for _, name in ipairs(iplList) do
        RemoveIpl(name)
    end
end

local function loadIpl(self)
    local iplList = ipl[self.name]
    if not iplList then return end

    for _, name in ipairs(iplList) do
        RequestIpl(name)
    end
end

local function createZone(name, data)
    lib.zones.box({
        name = name,
        coords = data.coords,
        size = data.size,
        rotation = data.rotation,
        debug = data.debug,
        onEnter = loadIpl,
        onExit = unloadIpl,
    })
end

RegisterNetEvent('mnr_ipl:client:EditEntitySet', function(map, name, action)
    if GetInvokingResource() then return end
    
    local set = entitysets[map][name]
    if not set then return end

    if action == 'load' then
        loadIpl({ name = set })
    elseif action == 'unload' then
        unloadIpl({ name = set })
    end
end)

for _, iplList in pairs(ipl) do
    for _, iplName in ipairs(iplList) do
        RemoveIpl(iplName)
    end
end

for name, data in pairs(zones) do
    createZone(name, data)
end

for _, data in ipairs(disable) do
    if data.id and data.disable then
        DisableInterior(data.id, data.disable)
    end

    if data.ipl and data.disable then
        RemoveIpl(data.ipl)
    end
end

for _, data in pairs(entitysets) do
    local set = data['default']
    loadIpl({ name = set })
end