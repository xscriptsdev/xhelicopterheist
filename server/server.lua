ESX = exports["es_extended"]:getSharedObject()
local framework = Config.Framework == "ESX" and ESX or QBCore

RegisterServerEvent("xhelicopterheist:reward")
AddEventHandler("xhelicopterheist:reward", function()
    local source = source

    if Config.EnableReward then
        if Config.Framework == "ESX" then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                xPlayer.addMoney(Config.RewardCash)
                TriggerClientEvent("ox_lib:notify", source, { title = "Reward", description = string.format(Config.RewardMessage, Config.RewardCash), type = "success" })
            end
        elseif Config.Framework == "QB" then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                Player.Functions.AddMoney("cash", Config.RewardCash)
                TriggerClientEvent("ox_lib:notify", source, { title = "Reward", description = string.format(Config.RewardMessage, Config.RewardCash), type = "success" })
            end
        end
    end
end)
