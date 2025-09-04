lib.addCommand("entityset", {
    help = "Loads an entityset for a map",
    params = {
        {
            name = "mapName",
            type = "string",
            help = "Name of the map",
        },
        {
            name = "setName",
            type = "string",
            help = "Name of the EntitySet to load",
        },
        {
            name = "action",
            type = "string",
            help = "Action to perform (load/unload)",
        },
    },
    restricted = "group.admin"
}, function(source, args, raw)
    local mapName = args.mapName
    local entitySet = args.setName
    local action = args.action

    if not mapName or not entitySet or not action then
        return
    end

    TriggerClientEvent("mnr_ipl:client:EditEntitySet", -1, mapName, entitySet, action)
end)