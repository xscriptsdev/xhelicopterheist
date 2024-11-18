local framework = Config.Framework == "ESX" and exports["es_extended"]:getSharedObject() or exports["qb-core"]:GetCoreObject()
local isJobActive = false
local spawnedEnemies = {}
local playerStartedJob = nil
local helicopter = nil
local blip = nil
local lastHeistTime = 0


Citizen.CreateThread(function()
    RequestModel(Config.ManagerPed.model)
    while not HasModelLoaded(Config.ManagerPed.model) do
        Wait(100)
    end

    local managerPed = CreatePed(4, GetHashKey(Config.ManagerPed.model), Config.ManagerPed.location, Config.ManagerPed.heading, false, true)
    FreezeEntityPosition(managerPed, true)
    SetEntityInvincible(managerPed, true)
    SetBlockingOfNonTemporaryEvents(managerPed, true)

    
    if Config.ManagerBlip.enable then
        local managerBlip = AddBlipForCoord(Config.ManagerPed.location)
        SetBlipSprite(managerBlip, Config.ManagerBlip.sprite)
        SetBlipScale(managerBlip, Config.ManagerBlip.scale)
        SetBlipColour(managerBlip, Config.ManagerBlip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.ManagerBlip.label)
        EndTextCommandSetBlipName(managerBlip)
    end


 
    if Config.TargetSystem == "ox_target" then
    
        exports.ox_target:addLocalEntity(managerPed, {
            {
                name = "xstart",
                icon = "fas fa-helicopter",
                label = "Start Helicopter Heist",
                onSelect = function()
                    if not isJobActive then
                        startHelicopterHeist()
                    else
                        lib.notify({ title = "Error", description = Config.NotifyFail, type = "error" })
                    end
                end,
            },
        })
    elseif Config.TargetSystem == "qb-target" then
       
        exports['qb-target']:AddTargetEntity(managerPed, {
            options = {
                {
                    type = "client",
                    event = "xstart",
                    icon = "fas fa-helicopter",
                    label = "Start Helicopter Heist",
                    action = function()
                        if not isJobActive then
                            startHelicopterHeist()
                        else
                            lib.notify({ title = "Error", description = Config.NotifyFail, type = "error" })
                        end
                    end,
                },
            },
            distance = 2.5
        })
    end
end)




function startHelicopterHeist()
    local currentTime = GetGameTimer()


    if Config.CooldownEnabled and (currentTime - lastHeistTime) < Config.CooldownDuration then
        local remainingTime = math.ceil((Config.CooldownDuration - (currentTime - lastHeistTime)) / 60)
        lib.notify({ title = "Cooldown", description = string.format(Config.NotifyCooldown, remainingTime), type = "error" })
        return
    end

    isJobActive = true
    lastHeistTime = currentTime
    playerStartedJob = PlayerPedId()
    lib.notify({ title = "Heist Started", description = Config.NotifyStart, type = "info" })

   
    local model = GetHashKey(Config.HelicopterModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    helicopter = CreateVehicle(model, Config.HelipadLocation, Config.HelicopterSpawnHeading, true, false)
    SetVehicleHasBeenOwnedByPlayer(helicopter, false)

   
    if Config.HelicopterBlip.enable then
        blip = AddBlipForCoord(Config.HelipadLocation)
        SetBlipSprite(blip, Config.HelicopterBlip.sprite)
        SetBlipScale(blip, Config.HelicopterBlip.scale)
        SetBlipColour(blip, Config.HelicopterBlip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.HelicopterBlip.label)
        EndTextCommandSetBlipName(blip)
    end


    Citizen.CreateThread(function()
        while isJobActive do
            local playerCoords = GetEntityCoords(playerStartedJob)
            if #(playerCoords - Config.HelipadLocation) < 50.0 then
                spawnEnemies()
                if blip then RemoveBlip(blip) end
                lib.notify({ title = "Warning", description = Config.NotifyArrived, type = "error" })
                return
            end
            Wait(500)
        end
    end)

   
    Citizen.CreateThread(function()
        while isJobActive do
            if IsPedInVehicle(playerStartedJob, helicopter, false) then
                completeHeist()
                return
            end
            Wait(500)
        end
    end)


    Citizen.CreateThread(function()
        while isJobActive do
            if IsEntityDead(playerStartedJob) then
                endHeistOnFailure() 
                return
            end
            Wait(500)
        end
    end)
end

function spawnEnemies()
  
    AddRelationshipGroup("HeistEnemies")

    for i, enemyData in ipairs(Config.Enemies) do
        local pedModel = GetHashKey(enemyData.model)

        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(100)
        end
      
        local spawnPosition = Config.HelipadLocation + (Config.EnemyLocationOffset * i)

        local enemy = CreatePed(4, pedModel, spawnPosition, 0.0, true, true)
        
        SetPedRelationshipGroupHash(enemy, GetHashKey("HeistEnemies"))

    
        SetPedCombatAttributes(enemy, 46, true) 
        SetPedCombatRange(enemy, 2) 
        SetPedCombatMovement(enemy, 2) 
        TaskCombatPed(enemy, playerStartedJob, 0, 16) 

        
        SetRelationshipBetweenGroups(5, GetHashKey("HeistEnemies"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(0, GetHashKey("HeistEnemies"), GetHashKey("HeistEnemies")) 
        
      
        GiveWeaponToPed(enemy, GetHashKey(enemyData.weapon), 255, false, true)
        
    
        table.insert(spawnedEnemies, enemy)
    end
end



function endHeistOnFailure()
    isJobActive = false
    lib.notify({ title = "Heist Failed", description = "You were killed! The heist has been aborted.", type = "error" })

    for _, enemy in ipairs(spawnedEnemies) do
        DeleteEntity(enemy)
    end
    spawnedEnemies = {}

    if helicopter then
        DeleteEntity(helicopter)
        helicopter = nil
    end
end



function completeHeist()
    isJobActive = false


    if Config.EnableReward then
        TriggerServerEvent("xhelicopterheist:reward")
    end

    lib.notify({ title = "Heist Complete", description = Config.NotifyReward, type = "success" })

  
    for _, enemy in ipairs(spawnedEnemies) do
        DeleteEntity(enemy)
    end
    spawnedEnemies = {}


end
