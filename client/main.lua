_menuPool = NativeUI.CreatePool()

RegisterKeyMapping('vehicleOptions', 'Open Vehicle Options', 'keyboard', Config.StandardKey)

RegisterCommand('vehicleOptions', function(source, args, Rawcommand)
    if Config.JobRestricted then
        checkJob()
    else
        checkJob()
    end
end)

function checkJob()
    ESX.TriggerServerCallback('mx_vehicleoptions:getJob', function(job)
        for k, v in pairs(Config.allowedJobs) do
            local currentJob = job.name
            
            print(currentJob)

            if currentJob == v then
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
            
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    OpenMenu()
                end
            end
        end
    end)
end

function OpenMenu()
    local items = {}
    local veh_extras = {}
    local isExtra = false
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicleHealth = GetVehicleBodyHealth(vehicle)

    _menuPool:ProcessMenus()

    mainMenu = NativeUI.CreateMenu('Vehicle Menu','Change your Vehicle preferences here')
	_menuPool:Add(mainMenu)

    if vehicleHealth < 1000 then
        _menuPool:RefreshIndex()
    end

    if not Config.UseWhenDamaged and vehicleHealth < 1000 then
        local extras = NativeUI.CreateItem('Extras', 'Change your Vehicle accessories')
        mainMenu:AddItem(extras)
    else
        local extras = _menuPool:AddSubMenu(mainMenu, 'Extras', 'Change your Vehicle accessories')
        
        for extraID = 1, 12 do
            local extras = DoesExtraExist(vehicle, extraID)

            if extras then
                local isOn = (IsVehicleExtraTurnedOn(vehicle, extraID) == 1)

                veh_extras[extraID] = isOn
                isExtra = true
            end
        end
        
        for k, v in pairs(veh_extras) do
            local extraItem = NativeUI.CreateCheckboxItem('Extra ' .. k, veh_extras[k], "Umschalten für Extra " ..k)
            extras:AddItem(extraItem)
            items[k] = extraItem
        end
        
        extras.OnCheckboxChange = function(sender, item, checked)
            for k, v in pairs(items) do
                if item == v then
                    veh_extras[k] = checked
                    if checked then
                        SetVehicleExtra(vehicle, k, 0)
                    else
                        SetVehicleExtra(vehicle, k, 1)
                    end
                end
            end
        end
    end
    
    local size = {}
    local currLivery = GetVehicleLivery(vehicle)
    local liveries = GetVehicleLiveryCount(vehicle)

    local livery = _menuPool:AddSubMenu(mainMenu, 'Livery', 'Change your Vehicle appearance')
  

    for i = 1, liveries do
        table.insert(size, i)
    end

    local selectLivery = NativeUI.CreateListItem('Select Livery', size, currLivery, 'Livery')
    livery:AddItem(selectLivery)

    livery.OnListChange = function(sender, item, index)
        SetVehicleLivery(vehicle, index)
    end

	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
	mainMenu:Visible(true)
end

CreateThread(function()
    while true do
        Wait(0)
        _menuPool:ProcessMenus()

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) == false then
			_menuPool:CloseAllMenus()
            Wait(500)
		end 
    end
end)