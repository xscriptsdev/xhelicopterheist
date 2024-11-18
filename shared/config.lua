--██╗░░██╗  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
--╚██╗██╔╝  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
--░╚███╔╝░  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
--░██╔██╗░  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
--██╔╝╚██╗  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
--╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░
-- Support: https://discord.gg/N74Yuq9ARQ

Config = {}

-- Framework
Config.Framework = "ESX" -- ESX / QB

-- Target System (ox_target or qb-target)
Config.TargetSystem = "ox_target"

-- Manager Config
Config.ManagerPed = {
    model = "cs_bankman", -- Model of the ped
    location = vector3(44.0880, -106.9069, 55.0743), -- Location of the manager ped
    heading = 333.0, -- Heading of the ped
    enableBlip = true -- Enable or disable the manager's blip on the map
}

-- Heist Manager Blip Configuration
Config.ManagerBlip = {
    enable = true,       -- Enable or disable the manager blip
    sprite = 280,        -- Blip icon 
    color = 2,           -- Blip color
    scale = 0.8,         -- Blip size
    label = "Heist Manager" -- Blip label text
}

-- Helicopter Config
Config.HelicopterModel = "buzzard2" -- Helicopter model to spawn
Config.HelipadLocation = vector3(-745.75, -1468.96, 5.0) -- Location of the helicopter
Config.HelicopterSpawnHeading = 90.0 -- Helicopter spawn heading

-- Heist Blip Configuration
Config.HelicopterBlip = {
    enable = true,       -- Enable or disable the helicopter location blip
    sprite = 43,         -- Blip icon 
    color = 1,           -- Blip color
    scale = 1.2,         -- Blip size
    label = "Helicopter Location" -- Blip label text
}

-- Enemies Config
Config.Enemies = {
    { model = "g_m_m_chicold_01", weapon = "WEAPON_SMG" },
    { model = "g_m_m_chicold_01", weapon = "WEAPON_CARBINERIFLE" },
    { model = "g_m_m_chicold_01", weapon = "WEAPON_ASSAULTRIFLE" } 
    -- add more if you need to
}

Config.EnemyLocationOffset = vector3(0, 5, 0) -- Spawn offset for enemies
Config.EnemyCount = #Config.Enemies -- Dont touch , it gets the enemies from above


-- Cooldown Configuration
Config.CooldownEnabled = true -- Enable or disable the cooldown
Config.CooldownDuration = 1800 -- Cooldown duration in seconds (e.g., 1800 seconds = 30 minutes)
Config.NotifyCooldown = "You must wait %s minutes before starting another heist."

-- Reward Configuration
Config.EnableReward = true -- Enable or disable rewards
Config.RewardCash = 10000 -- Cash reward for completing the heist
Config.RewardMessage = "You received $%s for successfully stealing the helicopter!"

-- Notifications
Config.NotifyStart = "The heist has begun! A location has been marked on your map."
Config.NotifyArrived = "Hostile guards are defending the helicopter!"
Config.NotifyReward = "You successfully stole the helicopter!"
Config.NotifyFail = "You cannot start the job right now."
