ESX = nil
local camp = false
local camping = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

local prevtent = 0
local prevfire = 0
RegisterNetEvent('srht-camp:campfire')
AddEventHandler('srht-camp:campfire', function()
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))
    local prop = CreateObject(GetHashKey("prop_beach_fire"), x+3.2, y+0.4, z, true, false, true)
    if prevfire ~= 0 then
        SetEntityAsMissionEntity(prevfire)
        DeleteObject(prevfire)
        prevfire = 0
    end
    TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', -1, false)
        prevfire = prop
        ClearPedTasksImmediately(PlayerPedId())
	
end)

RegisterCommand('kampkur', function(source, args, rawCommand)
    ESX.TriggerServerCallback('camp:item', function(qtty,deletecamp)
        if qtty > 0 and deletecamp ~= 0  then
            if prevtent ~= 0 then
                SetEntityAsMissionEntity(prevtent)
                DeleteObject(prevtent)
                prevtent = 0
            end
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.95))
            local tents = {
                'prop_skid_tent_01',
                'prop_skid_tent_01b',
                'prop_skid_tent_03',
            }
            local randomint = math.random(1,3)
            local tent = GetHashKey(tents[randomint])
            local prop = CreateObject(tent, x, y, z, true, false, true)
            OpenCamp() 
            prevtent = prop
            ClearPedTasksImmediately(PlayerPedId())
            TriggerEvent('srht-camp:campfire')
            camping = true


        else 
            exports['mythic_notify']:DoHudText('error', 'Kamp yapmak için kamp malzemesine ihtiyacın var!')
        end
    end)
end, false)                   
      
    

RegisterCommand('kampkaldır', function(source, args, rawCommand)
    if prevtent ~= 0 then
        CloseCamp()
        SetEntityAsMissionEntity(prevtent)
        DeleteObject(prevtent)
        prevtent = 0
        TriggerEvent('srht-camp:campfiredel')
        ClearPedTasksImmediately(PlayerPedId())
	    
    end
end, false)

RegisterNetEvent('srht-camp:campfiredel')
AddEventHandler('srht-camp:campfiredel', function()
    if prevfire == 0 then
    else
        SetEntityAsMissionEntity(prevfire)
        DeleteObject(prevfire)
        prevfire = 0
    end
end)

function OpenCamp()
    TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, true)
    exports['progressBars']:startUI(31000, "Kamp kuruyorsun..")
    Citizen.Wait(30000)
    exports['mythic_notify']:DoHudText('success', 'Kamp kuruldu.')
end
function CloseCamp()
    TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, true)
    exports['progressBars']:startUI(31000, "Kampı kaldırıyorsun..")
    Citizen.Wait(30000)
    exports['mythic_notify']:DoHudText('success', 'Kamp kaldırıldı.')
   
end
