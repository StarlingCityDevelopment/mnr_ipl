lib.addCommand('toggleipl', {
    help = 'Toggles an IPL of a map',
    params = {
        { name = 'mapName', type = 'string', help = 'Name of the map' },
        { name = 'iplName', type = 'string', help = 'Name of the IPL' },
        { name = 'action', type = 'string', help = 'load/unload' },
    },
    restricted = 'group.admin',
}, function(source, args, raw)
    if not args.mapName or not args.iplName or not args.action then return end

    TriggerClientEvent('mnr_ipl:client:ToggleMapIpl', -1, args)
end)