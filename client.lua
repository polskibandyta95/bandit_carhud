local isDriver = false
local barsTotal = 16 
local barsActive = 0

function UpdateRPMBar(rpm)
    local maxRpm = 1.0
    barsActive = math.floor((rpm / maxRpm) * barsTotal)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and DoesEntityExist(vehicle) then
            local speed = GetEntitySpeed(vehicle) * 3.6 
            local rpm = GetVehicleCurrentRpm(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local doorsOpen = false
            local seatbeltOn = IsPedWearingHelmet(playerPed)

            UpdateRPMBar(rpm)

            for i = 0, GetNumberOfVehicleDoors(vehicle) - 1 do
                if IsVehicleDoorDamaged(vehicle, i) then
                    doorsOpen = true
                    break
                end
            end

            SendNUIMessage({
                type = "updateSpeedometer",
                speed = speed,
                rpm = rpm,
                maxRpm = 1.0,
                gear = gear,
                fuel = fuel,
                engineHealth = engineHealth,
                doorsOpen = doorsOpen,
                seatbeltOn = seatbeltOn,
                isDriver = GetPedInVehicleSeat(vehicle, -1) == playerPed, 
                barsActive = barsActive
            })
        else
            SendNUIMessage({
                type = "hideSpeedometer"
            })
        end

        Citizen.Wait(100)
    end
end)
