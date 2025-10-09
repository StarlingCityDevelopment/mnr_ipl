local static = lib.load('config.static')

local ipl = require 'config.ipl'
local zones = lib.load('config.zones')
local disable = lib.load('config.disable')

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

local function loadDefault(ipls)
    for name, data in pairs(ipls) do
        if data.default then
            RequestIpl(data.ipl)
        end
    end
end

for name, data in pairs(static) do
    loadDefault(data)
end

RegisterNetEvent('mnr_ipl:client:ToggleMapIpl', function(data)
    if GetInvokingResource() then return end
    
    local ipl = static[data.mapName][data.iplName].ipl

    if not ipl then
        return
    end

    local isLoaded = IsIplActive(ipl)

    if data.action == 'load' and not isLoaded then
        RequestIpl(ipl)
    elseif data.action == 'unload' and isLoaded then
        RemoveIpl(ipl)
    end
end)