local entitysets = lib.load("config.entitysets")
local ipl = lib.load("config.ipl")
local zones = lib.load("config.zones")

local function UnloadIPL(iplList)
    for _, iplName in ipairs(ipl[iplList]) do
        RemoveIpl(iplName)
    end
end

local function LoadIPL(iplList)
    for _, iplName in ipairs(ipl[iplList]) do
        RequestIpl(iplName)
    end
end

local function CreateIPLZone(zoneData)
    local zone = lib.zones.box({
        coords = vec3(zoneData.coords.x, zoneData.coords.y, zoneData.coords.z),
        size = zoneData.size,
        rotation = zoneData.coords.w,
        onEnter = function()
            LoadIPL(zoneData.ipl)
        end,
        onExit = function()
            UnloadIPL(zoneData.ipl)
        end,
        debug = zoneData.debug,
    })
end

local function EditEntitySet(mapName, setName, action)
    local iplList = entitysets[mapName][setName]

    if not iplList then return end

    if action == "load" then
        LoadIPL(iplList)
    elseif action == "unload" then
        UnloadIPL(iplList)
    end
end

RegisterNetEvent("mnr_ipl:client:EditEntitySet", EditEntitySet)

for _, iplList in pairs(ipl) do
    for _, iplName in ipairs(iplList) do
        RemoveIpl(iplName)
    end
end

for _, zoneData in pairs(zones) do
    CreateIPLZone(zoneData)
end

for _, entityData in pairs(entitysets) do
    LoadIPL(entityData["default"])
end