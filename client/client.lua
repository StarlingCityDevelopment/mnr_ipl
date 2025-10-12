local dynamic = require 'config.dynamic'
local disable = lib.load('config.disable')
local entitysets = lib.load('config.entitysets')
local static = lib.load('config.static')

---@description Vanilla Interior/IPL disabler
for _, data in ipairs(disable) do
    if data.id and data.disable then
        DisableInterior(data.id, data.disable)
    end

    if data.ipl and data.disable then
        RemoveIpl(data.ipl)
    end
end

---@description Dynamic IPL loading section
local function cleanIpls(group)
    for _, ipl in ipairs(group) do
        if IsIplActive(ipl) then
            RemoveIpl(ipl)
        end
    end
end

local function toggleDynamicIpl(group, inside)
    for _, name in ipairs(group) do
        if inside then
            RequestIpl(name)
        elseif not inside then
            RemoveIpl(name)
        end
    end
end

local function createZone(data)
    cleanIpls(data.ipl)

    lib.zones.box({
        coords = data.coords,
        size = data.size,
        rotation = data.rotation,
        debug = data.debug,
        onEnter = function(self)
            toggleDynamicIpl(data.ipl, true)
        end,
        onExit = function(self)
            toggleDynamicIpl(data.ipl, false)
        end,
    })
end

for _, data in pairs(dynamic) do
    createZone(data)
end

---@description Static IPL default loading
local function loadDefault(ipls)
    for name, data in pairs(ipls) do
        if data.default and not IsIplActive(data.ipl) then
            RequestIpl(data.ipl)
        end
    end
end

for name, data in pairs(static) do
    loadDefault(data)
end

---@description Static IPL command section
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

---@description [BETA] EntitySets loader section
local function editEntitySet(interiorId, data)
    for _, entityset in pairs(data) do
        local isActive = IsInteriorEntitySetActive(interiorId, entityset.name)
        if entityset.enable and not isActive then
            ActivateInteriorEntitySet(interiorId, entityset.name)
        elseif not entityset.enable and isActive then
            DeactivateInteriorEntitySet(interiorId, entityset.name)
        end
    end
end

for code, data in pairs(entitysets) do
    if not IsValidInterior(code) then return end

    editEntitySet(code, data)
end