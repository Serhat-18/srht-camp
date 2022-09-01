ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)
ESX.RegisterServerCallback('camp:item', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
    local qtty = xPlayer.getInventoryItem('camp').count
    local deletecamp = xPlayer.removeInventoryItem('camp', 1)
    cb(qtty)
    cb(deletecamp)
end)


print("^2DESTEK & ILETISIM: https://www.discord.gg/9R2xdaSNXC")