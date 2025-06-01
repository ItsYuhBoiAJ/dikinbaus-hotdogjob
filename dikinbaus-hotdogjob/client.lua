local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local IsWorking = false
local IsUIActive = false
local PreparingFood = false
local ActivePeds = {}

-- Locations
local StartStopSpot = vector3(-342.72, 7154.71, 6.4)   -- Start/stop selling
local PedStartSpot = vector3(-326.3, 7158.39, 6.41)    -- Peds spawn here
local PedBuySpot = vector3(-338.64, 7152.67, 6.41)     -- Peds buy here
local CookingSpot = vector3(-342.65, 7151.64, 6.4)     -- Player cooks here

-- Draw 3D Text
local function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- UI Updater
local function UpdateUI()
    IsUIActive = true
    CreateThread(function()
        while IsUIActive do
            SendNUIMessage({
                action = 'UpdateUI',
                IsActive = IsUIActive,
                Stock = Config.Stock,
            })
            Wait(1000)
        end
    end)
end

-- Finish Minigame
local function FinishMinigame(faults)
    local Quality = 'common'
    if faults == 0 then Quality = 'exotic'
    elseif faults == 1 then Quality = 'rare' end

    if Config.Stock[Quality].Current + 1 <= Config.Stock[Quality].Max[4] then
        QBCore.Functions.Notify("You cooked a " .. Config.Stock[Quality].Label .. "!", "success")
        Config.Stock[Quality].Current = Config.Stock[Quality].Current + 1
    else
        QBCore.Functions.Notify("You can't carry more " .. Config.Stock[Quality].Label .. "s!", "error")
    end
    PreparingFood = false
end

-- Minigame Logic
local function StartHotdogMinigame()
    PreparingFood = true
    local result = exports['qb-minigames']:KeyMinigame(10)
    if result.quit then return end
    FinishMinigame(result.faults)
end

-- Sell Hotdogs to Ped
local function SellToPed(ped)
    local found = false
    local hotdogType

    for type, data in pairs(Config.Stock) do
        if data.Current > 0 then
            hotdogType = type
            found = true
            break
        end
    end

    if not found then
        QBCore.Functions.Notify("You have no hotdogs to sell!", "error")
        return
    end

    local price = math.random(Config.Stock[hotdogType].Price[1].min, Config.Stock[hotdogType].Price[1].max)
    QBCore.Functions.Notify("Sold a " .. Config.Stock[hotdogType].Label .. " for $" .. price, "success")

    Config.Stock[hotdogType].Current = Config.Stock[hotdogType].Current - 1
    TriggerServerEvent('qb-hotdogjob:server:Sell', GetEntityCoords(ped), 1, price)

    LoadAnim('mp_common')
    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT', 0, false)

    Wait(2000)
    ClearPedTasks(ped)
    DeleteEntity(ped)
end

-- Start/Stop Selling 
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - StartStopSpot)

        if dist < 3.0 then
            DrawText3Ds(StartStopSpot.x, StartStopSpot.y, StartStopSpot.z + 1.0, "[E] Start/Stop Selling Hotdogs")
            if IsControlJustReleased(0, 38) then
                IsWorking = not IsWorking
                if IsWorking then
                    QBCore.Functions.Notify("You started selling hotdogs!", "success")
                    UpdateUI()
                else
                    QBCore.Functions.Notify("You stopped selling hotdogs.", "error")
                    IsUIActive = false
                    SendNUIMessage({ action = 'UpdateUI', IsActive = false, Stock = Config.Stock })
                end
            end
        else
            Wait(500)
        end
    end
end)

-- Cooking Spot 
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - CookingSpot)

        if dist < 3.0 then
            DrawText3Ds(CookingSpot.x, CookingSpot.y, CookingSpot.z + 1.0, "[G] Cook Hotdogs")
            if IsControlJustReleased(0, 47) then
                StartHotdogMinigame()
            end
        else
            Wait(500)
        end
    end
end)

-- Ped Spawner
local function SpawnHotdogCustomer()
    local pedModels = { 'a_f_m_beach_01', 'a_f_m_bevhills_01', 'a_f_m_bevhills_02', 'a_f_m_bodybuild_01', 'a_f_m_business_02', 'a_f_m_downtown_01', 'a_f_m_eastsa_01', 'a_f_m_eastsa_02', 'a_f_m_fatbla_01', 'a_f_m_fatcult_01', 'a_f_m_fatwhite_01', 'a_f_m_ktown_01', 'a_f_m_ktown_02',
                        'a_f_m_prolhost_01', 'a_f_m_salton_01', 'a_f_m_skidrow_01', 'a_f_m_soucent_01', 'a_f_m_soucent_02', 'a_f_m_soucentmc_01', 'a_f_m_tourist_01', 'a_f_m_tramp_01', 'a_f_m_trampbeac_01', 'a_f_o_genstreet_01', 'a_f_o_indian_01', 'a_f_o_ktown_01', 'a_f_o_salton_01',
                        'a_f_o_soucent_01', 'a_f_o_soucent_02', 'a_f_y_beach_01', 'a_f_y_bevhills_01', 'a_f_y_bevhills_02', 'a_f_y_bevhills_03', 'a_f_y_bevhills_04', 'a_f_y_business_01', 'a_f_y_business_02', 'a_f_y_business_03', 'a_f_y_business_04', 'a_f_y_clubcust_01', 'a_f_y_clubcust_02',
                        'a_f_y_clubcust_03', 'a_f_y_eastsa_01', 'a_f_y_eastsa_02', 'a_f_y_eastsa_03', 'a_f_y_epsilon_01', 'a_f_y_femaleagent', 'a_f_y_fitness_01', 'a_f_y_fitness_02', 'a_f_y_genhot_01', 'a_f_y_golfer_01', 'a_f_y_hiker_01', 'a_f_y_hippie_01', 'a_f_y_hipster_01', 'a_f_y_hipster_02',
                        'a_f_y_hipster_03', 'a_f_y_hipster_04', 'a_f_y_indian_01', 'a_f_y_juggalo_01', 'a_f_y_runner_01', 'a_f_y_rurmeth_01', 'a_f_y_scdressy_01', 'a_f_y_skater_01', 'a_f_y_soucent_01', 'a_f_y_soucent_02', 'a_f_y_soucent_03' }
    local model = pedModels[math.random(#pedModels)]
    local spawnPos = PedStartSpot

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local ped = CreatePed(4, model, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
    table.insert(ActivePeds, ped)

    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    TaskGoStraightToCoord(ped, PedBuySpot.x, PedBuySpot.y, PedBuySpot.z, 1.0, -1, 0.0, 0.0)

    CreateThread(function()
        while IsWorking and DoesEntityExist(ped) do
            Wait(0)
            local pedCoords = GetEntityCoords(ped)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(pedCoords - playerCoords)

            if distance < 2.5 then
                DrawText3Ds(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "[E] Sell Hotdog")
                if IsControlJustReleased(0, 38) then
                    SellToPed(ped)
                    break
                end
            end
        end
    end)
end

-- Ped Spawner Loop
CreateThread(function()
    while true do
        Wait(math.random(50000, 70000))
        if IsWorking then
            SpawnHotdogCustomer()
        end
    end
end)

-- Stop Command
RegisterCommand("stophotdog", function()
    IsWorking = false
    IsUIActive = false
    for _, ped in pairs(ActivePeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    ActivePeds = {}
    SendNUIMessage({ action = 'UpdateUI', IsActive = false, Stock = Config.Stock })
    QBCore.Functions.Notify("Hotdog hustle stopped. Peds cleared.", "error")
end, false)

-- Helper: Load Anim
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

-- Rep Update Event
RegisterNetEvent('qb-hotdogjob:client:UpdateReputation', function(JobRep)
    PlayerData.metadata['rep'] = JobRep
end)
