local QBCore = exports['qb-core']:GetCoreObject()

-- Events

RegisterNetEvent('qb-hotdogjob:server:Sell', function(coords, amount, price)
    local src = source
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if #(pCoords - coords) > 4 then
        exports['qb-core']:ExploitBan(src, 'hotdog job exploit detected')
        return
    end

    Player.Functions.AddMoney('cash', tonumber(amount * price), 'sold hotdog')
    QBCore.Functions.Notify(src, 'You sold hotdogs for $'..(amount * price), 'success')
end)

RegisterNetEvent('qb-hotdogjob:server:UpdateReputation', function(quality)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local addRep = 0
    if quality == 'exotic' then addRep = 3
    elseif quality == 'rare' then addRep = 2
    elseif quality == 'common' then addRep = 1 end

    local currentRep = Player.Functions.GetRep('hotdog')
    local newRep = math.min(currentRep + addRep, Config.MaxReputation)
    Player.Functions.AddRep('hotdog', newRep - currentRep)

    TriggerClientEvent('qb-hotdogjob:client:UpdateReputation', src, Player.PlayerData.metadata['rep'])
end)
