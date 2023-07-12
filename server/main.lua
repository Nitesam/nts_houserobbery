GlobalState.PortaRapina = nil
local statoRapine, Inv, Cooldown = {}, exports.ox_inventory, 0

local function defaultRapina(k, v)
    statoRapine[k] = {}

    statoRapine[k].starter = nil
    statoRapine[k].inCorso = false

    statoRapine[k].allarme = {
        attivo = true,
        oggettoAllarme = nil,
        codiceAllarme = nil,
        tempoResiduo = v.timerAllarme
    }
end

local function cambiaStatoPorta(indice, stato)
    local temp = GlobalState.PortaRapina
    temp[indice] = stato
    GlobalState.PortaRapina = temp

    TriggerClientEvent("furto_case:impostaStatoPorta", -1, indice, stato)
end

local function verificaOrdine(indice)
    if not Config.Case[indice].poliziottiRichiesti or Config.Case[indice].poliziottiRichiesti == 0 then return true end

    local forzeP = 0
    for _,v in pairs(ESX.GetExtendedPlayers()) do --lazy function, nella mia versione modificata di esx ho elaborato un metodo più efficiente per avere una lista dei dipendenti suddivisa per lavoro, potre implementarla su github in futuro.
        if Config.Ordine[v.job.name] then
            forzeP += 1
        end
    end

    if forzeP <= Config.Case[indice].poliziottiRichiesti then return false end
end

Citizen.CreateThreadNow(function()
    local temp = {}
    for k,v in ipairs(Config.Case) do
        temp[k] = 1

        defaultRapina(k, v)

        statoRapine[k].cooldown = {
            default = v.cooldown,
            attuale = 0
        }
    end

    GlobalState.PortaRapina = temp
end)

lib.callback.register('furto_case:callbackStato', function(source, indice)
    if statoRapine[indice] then
        return statoRapine[indice].inCorso
    end

    return false
end)

lib.callback.register('furto_case:iniziaRapina', function(source, indice)
    local G = ESX.GetPlayerFromId(source)
    if not G then return false end


    if statoRapine[indice] and statoRapine[indice].cooldown.attuale < os.time() and Cooldown < os.time() and verificaOrdine(indice) then
        local tabellaCase = TableCopy(Config.Case[indice])

        Cooldown = os.time() + Config.CooldownGenerico

        statoRapine[indice].inCorso = true

        statoRapine[indice].starter = G.source
        statoRapine[indice].allarme.codiceAllarme = math.random(1000, 9999)
        statoRapine[indice].cooldown.attuale = os.time() + statoRapine[indice].cooldown.default

        statoRapine[indice].puntiRaccolta = {}
        for a, b in ipairs(tabellaCase.puntiRaccolta) do
            if b.rand and math.random(1, 100) <= b.rand then
                local tempLista, oggettiCount = {}, 0
                for x, y in pairs(b.listaOggetti) do
                    if math.random(1, 100) <= y.prob then
                        tempLista[x] = math.random(y.min, y.max)
                        oggettiCount += 1
                    end
                end

                if oggettiCount > 0 and math.random(0, 100) <= 75 then
                    b.denaroSporco = 0
                else
                    table.wipe(tempLista)
                    tempLista = {}
                    b.prop = `prop_money_bag_01`
                end

                statoRapine[indice].puntiRaccolta[a] = {
                    disponibile = true,
                    coordinate = b.coordinate,
                    denaroSporco = b.denaroSporco,
                    listaOggetti = tempLista,
                    prop = CreateObject(b.prop, b.coordinate.x, b.coordinate.y, b.coordinate.z, true, true, false)
                }

                Wait(10)
                FreezeEntityPosition(statoRapine[indice].puntiRaccolta[a].prop, true)
            end
        end

        if tabellaCase.multigiocatore then
            TriggerClientEvent("furto_case:inizializzaProp", -1, indice, statoRapine[indice].puntiRaccolta)
        else
            TriggerClientEvent("furto_case:inizializzaProp", G.source, indice, statoRapine[indice].puntiRaccolta)
        end

        local coordOggetto = tabellaCase.posizioneCodice[math.random(#tabellaCase.posizioneCodice)]
        statoRapine[indice].allarme.oggettoAllarme = CreateObject(`prop_cs_documents_01`, coordOggetto.x, coordOggetto.y, coordOggetto.z, true, true, false)

        -- THREAD INIZIO
        Citizen.CreateThread(function()
            Citizen.Wait(statoRapine[indice].allarme.tempoResiduo * 1000)
            if not statoRapine[indice].inCorso then return end

            if statoRapine[indice].allarme.attivo then
                TriggerClientEvent("furto_case:inviaDispatch", statoRapine[indice].starter)
                statoRapine[indice].allarme.attivo = false
            end

            if statoRapine[indice].allarme.oggettoAllarme then
                TriggerClientEvent("furto_case:rimuoviTacquinoCodice", -1, indice, NetworkGetNetworkIdFromEntity(statoRapine[indice].allarme.oggettoAllarme))
            end

            Citizen.Wait(tabellaCase.tempoMax * 1000)

            if statoRapine[indice] and statoRapine[indice].inCorso and statoRapine[indice].starter == G.source then
                TriggerClientEvent("furto_case:ripristina", -1, indice)

                for a,b in pairs(statoRapine[indice].puntiRaccolta) do
                    if b.prop then
                        DeleteEntity(b.prop)

                        if tabellaCase.multigiocatore then
                            TriggerClientEvent("furto_case:rimuoviProp", -1, indice, a)
                        else
                            TriggerClientEvent("furto_case:rimuoviProp", G.source, indice, a)
                        end
                    end
                end

                if statoRapine[indice].allarme.oggettoAllarme then
                    DeleteEntity(statoRapine[indice].allarme.oggettoAllarme)
                end

                local tempCooldown = TableCopy(statoRapine[indice].cooldown)
                table.wipe(statoRapine[indice])
                defaultRapina(indice, Config.Case[indice])
                statoRapine[indice].cooldown = tempCooldown

                cambiaStatoPorta(indice, 1)
                Debug("Il Furto non era concluso, ho provveduto da solo per [" .. indice .. "]!")
            else
                Debug("Il Furto era già Concluso! [" .. indice .. "]")
            end
        end)
        -- THREAD FINE

        Wait(200)
        TriggerClientEvent("furto_case:aggiungiTacquinoCodice", -1, indice, NetworkGetNetworkIdFromEntity(statoRapine[indice].allarme.oggettoAllarme))

        return true
    else
        if Config.Debug then
            if statoRapine[indice] then
                Debug("Rimanente per " .. indice, statoRapine[indice].cooldown.attuale - os.time(), Cooldown - os.time())
            end
        end
    end

    return false
end)

lib.callback.register('furto_case:ottieniCodice', function (source, indice)
    if statoRapine[indice] and statoRapine[indice].inCorso then
        return statoRapine[indice].allarme.codiceAllarme
    end
end)

RegisterServerEvent("furto_case:cambiaStatoPorta")
AddEventHandler("furto_case:cambiaStatoPorta", function(indice, stato)
    cambiaStatoPorta(indice, stato)
end)

RegisterServerEvent("furto_case:rimuoviOggetto")
AddEventHandler("furto_case:rimuoviOggetto", function(oggetto, qty)
    Inv:RemoveItem(source, oggetto, qty)
end)

RegisterServerEvent("furto_case:lasciaZona")
AddEventHandler("furto_case:lasciaZona", function(indice)
    if statoRapine[indice] and statoRapine[indice].inCorso and statoRapine[indice].starter == source then
        TriggerClientEvent("furto_case:ripristina", -1, indice)

        if statoRapine[indice].allarme.oggettoAllarme then
            DeleteEntity(statoRapine[indice].allarme.oggettoAllarme)
        end

        for a,b in pairs(statoRapine[indice].puntiRaccolta) do
            if b.prop then
                DeleteEntity(b.prop)
    
                if Config.Case[indice].multigiocatore then
                    TriggerClientEvent("furto_case:rimuoviProp", -1, indice, a)
                else
                    TriggerClientEvent("furto_case:rimuoviProp", source, indice, a)
                end
            end
        end

        local tempCooldown = TableCopy(statoRapine[indice].cooldown)
        table.wipe(statoRapine[indice])
        defaultRapina(indice, Config.Case[indice])
        statoRapine[indice].cooldown = tempCooldown

        cambiaStatoPorta(indice, 1)

        Debug("Furto Concluso, il Rapinatore è Uscito dalla Zona ed ho Resettato [" .. indice .. "]!")
    end
end)

RegisterServerEvent("furto_case:disabilitaAllarme")
AddEventHandler("furto_case:disabilitaAllarme", function(casa, codice)
    local G = ESX.GetPlayerFromId(source)
    if not G then return end

    if statoRapine[casa] and statoRapine[casa].inCorso and statoRapine[casa].allarme.attivo then
        statoRapine[casa].allarme.attivo = false
        
        if codice == statoRapine[casa].allarme.codiceAllarme then
            ShowNotification(Lang[Config.Lang]["password_corretta"], "success", "House Robbery", G.source)
        else
            ShowNotification(Lang[Config.Lang]["password_errata"], "error", "House Robbery", G.source)
            TriggerClientEvent("furto_case:inviaDispatch", statoRapine[casa].starter)
        end
    else
        ShowNotification(Lang[Config.Lang]["pannello_bloccato"], "error", "House Robbery", G.source)
    end
end)

RegisterServerEvent("furto_case:raccogli")
AddEventHandler("furto_case:raccogli", function(casa, indiceDrop)
    local G = ESX.GetPlayerFromId(source)
    if not G then return end

    if statoRapine[casa] and statoRapine[casa].inCorso and statoRapine[casa].puntiRaccolta[indiceDrop].disponibile then
        statoRapine[casa].puntiRaccolta[indiceDrop].disponibile = false

        if statoRapine[casa].puntiRaccolta[indiceDrop].denaroSporco and statoRapine[casa].puntiRaccolta[indiceDrop].denaroSporco > 0 then
            G.addAccountMoney("black_money", statoRapine[casa].puntiRaccolta[indiceDrop].denaroSporco)

            statoRapine[casa].puntiRaccolta[indiceDrop].denaroSporco = 0
        end

        for k,v in pairs(statoRapine[casa].puntiRaccolta[indiceDrop].listaOggetti) do
            if Inv:CanCarryItem(G.source, k, v) then
                Inv:AddItem(G.source, k, v)

                statoRapine[casa].puntiRaccolta[indiceDrop].listaOggetti[k] = nil
            else
                statoRapine[casa].puntiRaccolta[indiceDrop].disponibile = true
            end
        end

        if not statoRapine[casa].puntiRaccolta[indiceDrop].disponibile then
            if Config.Case[casa].multigiocatore then
                TriggerClientEvent("furto_case:rimuoviProp", -1, casa, indiceDrop)
            else
                TriggerClientEvent("furto_case:rimuoviProp", G.source, casa, indiceDrop)
            end

            DeleteEntity(statoRapine[casa].puntiRaccolta[indiceDrop].prop)
            statoRapine[casa].puntiRaccolta[indiceDrop].prop = nil
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if GetCurrentResourceName() ~= resource then return end
    
    for k,v in pairs(statoRapine) do
        if v.allarme.oggettoAllarme then
            DeleteEntity(v.allarme.oggettoAllarme)
        end

        if statoRapine[k].puntiRaccolta then
            for a,b in pairs(statoRapine[k].puntiRaccolta) do
                if b.prop then
                    DeleteEntity(b.prop)
        
                    if Config.Case[k].multigiocatore then
                        TriggerClientEvent("furto_case:rimuoviProp", -1, k, a)
                    else
                        if statoRapine[k].starter then
                            TriggerClientEvent("furto_case:rimuoviProp", statoRapine[k].starter, k, a)
                        else
                            break
                        end
                    end
                end
            end
        end
    end
end)

RegisterCommand("furto_case:debug", function (source, args, raw)
    if source > 0 then return end
    print(json.encode(statoRapine, {indent = true}))
end, true)

RegisterCommand("furto_case:riavvia", function (source, args, raw)
    if source > 0 then
        local G = ESX.GetPlayerFromId(source)
        if not G or G.grouo ~= "admin" then return end --[[not G.controllaGrado("admin") -- Utile solo su E-Life con ESX Legacy pesantemente modificato da Nitesam]]

        lib.callback("furto_case:furtoVicino", source, function(indice)
            if indice and statoRapine[indice].inCorso then
                TriggerClientEvent("furto_case:ripristina", -1, indice)

                for a,b in pairs(statoRapine[indice].puntiRaccolta) do
                    if b.prop then
                        DeleteEntity(b.prop)
            
                        if Config.Case[indice].multigiocatore then
                            TriggerClientEvent("furto_case:rimuoviProp", -1, indice, a)
                        else
                            TriggerClientEvent("furto_case:rimuoviProp", G.source, indice, a)
                        end
                    end
                end

                if statoRapine[indice].allarme.oggettoAllarme then
                    DeleteEntity(statoRapine[indice].allarme.oggettoAllarme)
                end

                Cooldown = 0
                local tempCooldown = TableCopy(statoRapine[indice].cooldown)
                tempCooldown.attuale = 0
                
                table.wipe(statoRapine[indice])
                defaultRapina(indice, Config.Case[indice])
                statoRapine[indice].cooldown = tempCooldown

                cambiaStatoPorta(indice, 1)
                ShowNotification(string.format(Lang[Config.Lang]["casa_reset_1"], indice), "success", "House Robbery", G.source)
            else
                ShowNotification(string.format(Lang[Config.Lang]["casa_reset_2"], indice) , "error", "House Robbery", G.source)
            end
        end)
    end
end)