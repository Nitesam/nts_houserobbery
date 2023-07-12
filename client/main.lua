local listaZone, missioneCorrente = {}, 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function generaRapina(id)
    missioneCorrente = id
    ----------------------------------------------------------------------------------------------------------------

    local posDisattivaAllarme = lib.points.new({
        coords = Config.Case[id].disabilitaAllarme,
        distance = 6
    })

    listaZone[id].posDisattivaAllarme = posDisattivaAllarme

    function posDisattivaAllarme:nearby()
        if self.currentDistance < 3 then
            Draw3DText(self.coords.x, self.coords.y, self.coords.z, "[E] - " .. Lang[Config.Lang]["allarme"])
        
            if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
                local input = lib.inputDialog(Lang[Config.Lang]["inserisci_password_title"], {
                    {type = 'number', label = Lang[Config.Lang]["inserisci_password_label"], description = Lang[Config.Lang]["inserisci_password_description"], icon = 'fa-barcode'},
                })

                if input and input[1] then
                    TriggerServerEvent("furto_case:disabilitaAllarme", id, input[1])

                    listaZone[id].posDisattivaAllarme:remove()
                end
            end
        end
    end

    ----------------------------------------------------------------------------------------------------------------

    local exitCheck = lib.points.new({
        coords = Config.Case[id].porta.coordinate,
        distance = 150
    })

    function exitCheck:onExit()
        missioneCorrente = 0
        TriggerServerEvent("furto_case:lasciaZona", id)
        ShowNotification(Lang[Config.Lang]["fuggito"], "error", "House Robbery")
        exitCheck:remove()
    end
end

Citizen.CreateThread(function()
    Wait(1000)
    while not ESX.PlayerLoaded do Wait(10) end
    for k, v in ipairs(Config.Case) do
        listaZone[k] = {}

        listaZone[k].blip = AddBlipForCoord(v.porta.coordinate.x, v.porta.coordinate.y)
        SetBlipSprite(listaZone[k].blip, 374)
        SetBlipDisplay(listaZone[k].blip, 6)
        SetBlipScale(listaZone[k].blip, 0.6)
        SetBlipColour(listaZone[k].blip, 6)
        SetBlipAsShortRange(listaZone[k].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("House Robbery - " .. v.nome)
        EndTextCommandSetBlipName(listaZone[k].blip)

        AddDoorToSystem(k + (joaat(v.nome)), v.porta.modello, v.porta.coordinate)

        listaZone[k].puntiRaccolta = {}
        listaZone[k].posDisattivaAllarme = nil
        listaZone[k].porta = exports.ox_target:addBoxZone({
            coords = v.porta.coordinate,
            size = vec3(2, 2, 2),
            rotation = 45,
            debug = Config.Debug,
            options = {
                {
                    label = Lang[Config.Lang]["forza_porta"],
                    icon = 'fas fa-person-booth',
                    name = k .. v.nome,
                    onSelect = function()
                        if not Config.Ordine[ESX.PlayerData.job.name] then
                            if DoorSystemGetDoorState(k + (joaat(v.nome))) == 1 then
                                if not verificaNotte() then ShowNotification(Lang[Config.Lang]["attendi_notte"], "error", "House Robbery") return end
                                if not lib.callback.await("furto_case:callbackStato", false, k) then
                                    local qty = exports.ox_inventory:Search('count', v.oggettoApertura)
                                    if qty > 0 then
                                        RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                                        while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
                                            Citizen.Wait(50)
                                        end

                                        Citizen.Wait(250)
                                        TaskPlayAnim(cache.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 2.0, -2.0, -1, 1, 0, 0, 0, 0)

                                        local success = lib.skillCheck(v.difSkillCheck, {'w', 'a', 'd'})

                                        ClearPedTasks(cache.ped)
                                        ClearPedSecondaryTask(cache.ped)
                                        
                                        if success then
                                            if lib.callback.await('furto_case:iniziaRapina', false, k) then
                                                TriggerServerEvent("furto_case:rimuoviOggetto", v.oggettoApertura, 1)
                                                TriggerServerEvent("furto_case:cambiaStatoPorta", k, 0)
                                                generaRapina(k)

                                                ShowNotification(Lang[Config.Lang]["porta_aperta"], "success", "House Robbery")
                                                if math.random(1, 100) < 20 then
                                                    Wait(8000)
                                                    ShowNotification(Lang[Config.Lang]["rumore_strano"], "info", "House Robbery")
                                                    Wait(6000)
                                                    ShowNotification(Lang[Config.Lang]["allarme_attento"], "error", "House Robbery", 7500)
                                                end
                                            else
                                                ShowNotification(Lang[Config.Lang]["non_disponibile"], "error", "House Robbery")
                                            end
                                        else
                                            if math.random(1, 100) < 30 then
                                                TriggerServerEvent("furto_case:rimuoviOggetto", v.oggettoApertura, 1)
                                            end
                                        end
                                    else
                                        ShowNotification(Lang[Config.Lang]["item_mancante"], "error", "House Robbery")
                                    end
                                else
                                    ShowNotification(Lang[Config.Lang]["rapina_in_corso"], "error", "House Robbery")
                                end
                            end
                        else
                            if DoorSystemGetDoorState(k + (joaat(v.nome))) == 1 then
                                TriggerServerEvent("furto_case:cambiaStatoPorta", k, 0)
                            elseif DoorSystemGetDoorState(k + (joaat(v.nome))) == 0 then
                                TriggerServerEvent("furto_case:cambiaStatoPorta", k, 1)
                            end
                        end
                    end
                }
            }
        })

        local oggetto = lib.points.new({
            coords = v.porta.coordinate,
            distance = 10
        }) 

        function oggetto:onEnter()
            DoorSystemSetDoorState(k + (joaat(v.nome)), GlobalState.PortaRapina[k])
        end
    end
end)

RegisterNetEvent("furto_case:ripristina")
AddEventHandler("furto_case:ripristina", function(indice)
    if not Config.Case[indice] then return end

    if listaZone[indice].puntiRaccolta then
        for _,v in pairs(listaZone[indice].puntiRaccolta) do
            if v then
                exports.ox_target:removeZone(v)
            end
        end

        listaZone[indice].puntiRaccolta = {}
    end

    if listaZone[indice].posDisattivaAllarme then
        listaZone[indice].posDisattivaAllarme:remove()
        listaZone[indice].posDisattivaAllarme = nil
    end
end)

RegisterNetEvent("furto_case:aggiungiTacquinoCodice")
AddEventHandler("furto_case:aggiungiTacquinoCodice", function(indice, netId)
    if Config.Case[indice] then
        exports.ox_target:addEntity({[1] = netId}, {
            {
                name = 'tacquino_codice_' .. indice,
                icon = 'fa-solid fa-barcode',
                label = Lang[Config.Lang]["leggi_codice"],
                canInteract = function(entity, distance, coords, name, bone)
                    return not exports.funzioni_varie:statusMani() and not exports.ns_deathsystem:Morto() and distance < 1.2
                end,
                onSelect = function(data)
                    lib.hideTextUI()
                    lib.callback('furto_case:ottieniCodice', false, function(risultato)
                        if risultato then
                            lib.showTextUI(tostring(risultato), {
                                position = "top-center",
                                icon = "fa-barcode",
                                style = {
                                    borderRadius = 2
                                }
                            })
                        end
                    end, indice)

                    Wait(4000)
                    lib.hideTextUI()
                end
            }
        })
    end
end)

RegisterNetEvent("furto_case:inizializzaProp")
AddEventHandler("furto_case:inizializzaProp", function(indice, tabella)
    if Config.Case[indice] then
        for k,v in pairs(tabella) do
            listaZone[indice].puntiRaccolta[k] = exports.ox_target:addBoxZone({
                coords = v.coordinate,
                size = vec3(0.3, 0.3, 0.6),
                rotation = 45,
                debug = Config.Debug,
                options = {
                    {
                        label = Lang[Config.Lang]["raccogli_oggetto"],
                        icon = 'fas fa-person-booth',
                        name = k .. "_punti_raccolta",
                        onSelect = function()
                            while not IsPedHeadingTowardsPosition(cache.ped, vec3(v.coordinate.x, v.coordinate.y, v.coordinate.z), 40.0) do
                                TaskTurnPedToFaceCoord(cache.ped, vec3(v.coordinate.x, v.coordinate.y, v.coordinate.z), 500)
                                Wait(500)
                            end
        
                            if lib.progressCircle({
                                duration = 4000,
                                position = 'bottom',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                },
                                anim = {
                                    dict = Config.Case[indice].puntiRaccolta[k].dizionario,
                                    clip = Config.Case[indice].puntiRaccolta[k].animazione
                                }
                            }) then                          
                                TriggerServerEvent("furto_case:raccogli", indice, k)
                            end
                        end
                    }
                }
            })
        end
    end
end)

RegisterNetEvent("furto_case:rimuoviProp")
AddEventHandler("furto_case:rimuoviProp", function(indice, idProp)
    if Config.Case[indice] and listaZone[indice].puntiRaccolta[idProp] then
        exports.ox_target:removeZone(listaZone[indice].puntiRaccolta[idProp])
        listaZone[indice].puntiRaccolta[idProp] = nil
    end
end)

RegisterNetEvent("furto_case:rimuoviTacquinoCodice")
AddEventHandler("furto_case:rimuoviTacquinoCodice", function(indice, netId)
    if Config.Case[indice] then
        exports.ox_target:removeEntity({[1] = netId}, {'tacquino_codice_' .. indice})
    end
end)

RegisterNetEvent("furto_case:impostaStatoPorta")
AddEventHandler("furto_case:impostaStatoPorta", function(indice, status)
    if Config.Case[indice] then
        DoorSystemSetDoorState(indice + (joaat(Config.Case[indice].nome)), status)
    end
end)

RegisterNetEvent("furto_case:inviaDispatch")
AddEventHandler("furto_case:inviaDispatch", function()
    -- exports["ls-dispatch"]:HouseRobbery()

    -- PUT YOUR DISPATCH SYSTEM HERE TO NOTIFY LAW ENFORCEMENT!!!!
end)

AddEventHandler("esx:onPlayerDeath", function ()
    if missioneCorrente > 0 then

        TriggerServerEvent("furto_case:lasciaZona", missioneCorrente)
        missioneCorrente = 0
    end
end)

lib.callback.register("furto_case:furtoVicino", function()
    local coordinateGiocatore, indice, dIndice = GetEntityCoords(cache.ped), 0, 100
    for k,v in pairs(Config.Case) do
        local tempD = #(v.porta.coordinate - coordinateGiocatore)

        if tempD < dIndice then
            dIndice = tempD
            indice = k
        end
    end

    Debug(indice, dIndice)

    if indice < 1 then return false end
    return indice
end)