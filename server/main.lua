ESX.RegisterServerCallback('mx_vehicleoptions:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local JobName = xPlayer.getJob()

    if JobName ~= nil then
        cb(JobName)
    else
        cb('Error')
    end
end)