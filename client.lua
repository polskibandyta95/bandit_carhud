local isDriver = false
local barsTotal = 16 -- Total number of bars for RPM meter
local barsActive = 0 -- This will be calculated based on RPM

-- Function to update the active bars based on RPM
function UpdateRPMBar(rpm)
    local maxRpm = 1.0 -- Maximum RPM, usually 1.0 for most vehicles
    barsActive = math.floor((rpm / maxRpm) * barsTotal)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and DoesEntityExist(vehicle) then
            -- Player is inside a valid vehicle
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert m/s to km/h
            local rpm = GetVehicleCurrentRpm(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local doorsOpen = false
            local seatbeltOn = IsPedWearingHelmet(playerPed) -- Assuming helmet is used as seatbelt indicator

            -- Update the RPM progress bar
            UpdateRPMBar(rpm)

            -- Check if any door is open
            for i = 0, GetNumberOfVehicleDoors(vehicle) - 1 do
                if IsVehicleDoorDamaged(vehicle, i) then
                    doorsOpen = true
                    break
                end
            end

            -- Ensure all players in the vehicle see the speedometer
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
                isDriver = GetPedInVehicleSeat(vehicle, -1) == playerPed, -- Indicate if the player is the driver
                barsActive = barsActive
            })
        else
            -- Player is not in a vehicle, hide the speedometer
            SendNUIMessage({
                type = "hideSpeedometer"
            })
        end

        Citizen.Wait(100)
    end
end)
