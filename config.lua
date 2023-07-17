Config = {}
Config.Debug = false -- If Debug mode is true, the bounding boxes of objects spawned by the script will be visible.

Config.Lang = 'en'

Config.CooldownGenerico = 600 -- Cooldown between various robberies.

Config.Notturno = { -- Section to limit the robbery start time to night only
    SoloNotte = true, -- If true, the times below are applied
    Orari = {inizio = 21, fine = 6} -- timeframe in which it is possible to start the robbery.
}

Config.Ordine = { -- list of law enforcement
    ["police"] = true
}

Config.Case = {
    [1] = {
        showBlip = true, -- if true, a blip will be created on the map.
        nome = "Franklin", -- Name shown on the map
        poliziottiRichiesti = 0, -- Police required to start the robbery in this house.
        timerAllarme = 60, -- timer before the alarm goes off
        cooldown = 1800, -- time before the house can be robbed again (timer for each house)
        tempoMax = 1200, -- maximum time to complete the mission
        oggettoApertura = "lockpick", -- object used to open the main door
        disabilitaAllarme = vec3(-7.79, 524.03, 175.19), -- point to disable the alarm.
        difSkillCheck = {'easy', 'easy', {areaSize = 100, speedMultiplier = 1.8}}, -- difficulty of the skillcheck for the access door to this structure.
        multigiocatore = true, -- true = multiple people can collect the bags on the ground; false = only the person who starts the robbery can collect the bags on the ground; NOTE: OBJECTS ARE SERVER SIDE SYNCHRONIZED

        porta = { -- Door Section
            modello = `v_ilev_fh_frontdoor`, -- IMPORTANT, USE THESE APOSTROPHES
            coordinate = vec3(8.21, 539.29, 176.03) -- Coordinates of the door
        },
        posizioneCodice = { -- Position alarm code, more points make the spawn position dynamic
            [1] = vec3(13.41, 527.85, 173.63)
        },
        puntiRaccolta = {
            [1] = {
                rand = 100, -- spawn percentage.
                prop = `prop_gold_bar`, -- prop of the spawn
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael", -- Single Collection Animation
                coordinate = vec3(-6.06, 531.31, 174.89), -- Spawn Coordinates
                denaroSporco = 600, -- Amount of dirty money, 0 to cancel.
                listaOggetti = { -- Table with list of items that are collected 
                    ["gold"] = {min = 1, max = 3, prob = 90} -- min is the minimum value of the random, max its maximum and prob is the probability that the item is inserted!
                }
            },
            [2] = {
                rand = 100, -- spawn percentage.
                prop = `prop_gold_bar`, -- prop of the spawn
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael", -- Single Collection Animation
                coordinate = vec3(1.50, 524.45, 174.63), -- Spawn Coordinates
                denaroSporco = 600, -- Amount of dirty money, 0 to cancel.
                listaOggetti = { -- Table with list of items that are collected 
                    ["gold"] = {min = 1, max = 3, prob = 80} -- min is the minimum value of the random, max its maximum and prob is the probability that the item is inserted!
                }
            },
            [3] = {
                rand = 100, -- spawn percentage.
                prop = `prop_gold_bar`, -- prop of the spawn
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael", -- Single Collection Animation
                coordinate = vec3(-6.61, 519.70, 174.58), -- Spawn Coordinates
                denaroSporco = 600, -- Amount of dirty money, 0 to cancel.
                listaOggetti = { -- Table with list of items that are collected 
                    ["gold"] = {min = 1, max = 3, prob = 90} -- min is the minimum value of the random, max its maximum and prob is the probability that the item is inserted!
                }
            },
            [4] = {
                rand = 100, -- spawn percentage.
                prop = `prop_gold_bar`, -- prop of the spawn
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael", -- Single Collection Animation
                coordinate = vec3(-5.57, 526.55, 174.91), -- Spawn Coordinates
                denaroSporco = 600, -- Amount of dirty money, 0 to cancel.
                listaOggetti = { -- Table with list of items that are collected 
                    ["gold"] = {min = 1, max = 3, prob = 50} -- min is the minimum value of the random, max its maximum and prob is the probability that the item is inserted!
                }
            },
        },
    }
}

Lang = {
    ["en"] = {
        ["allarme"] = "Alarm",
        ["leggi_codice"] = "Read Code",
        ["raccogli_oggetto"] = "Take",
        ["forza_porta"] = "Force Door",
        ["inserisci_password_title"] = "Alarm Code",
        ["inserisci_password_label"] = "Security Code",
        ["inserisci_password_description"] = "Enter the Password",
        ["fuggito"] = "You have fled the Robbery Zone.<br><br>Mission Concluded.",
        ["attendi_notte"] = "It would be better to wait for the night.",
        ["porta_aperta"] = "The Door has Opened!",
        ["rumore_strano"] = "You hear a strange noise, like a ticking.",
        ["allarme_attento"] = "OH SHIT!<br>It's an alarm, but it hasn't gone off yet!<br>You might want to try disabling it!",
        ["non_disponibile"] = "It seems like there's someone at Home.<br>Better come back later!",
        ["item_mancante"] = "You do not possess the right object to be able to open this door!",
        ["rapina_in_corso"] = "A Robbery is already taking place at this address!",
        ["password_corretta"] = "Correct Password!<br>Alarm disabled.",
        ["password_errata"] = "Wrong Password!",
        ["pannello_bloccato"] = "The Panel is Locked!",
        ["casa_reset_1"] = "House %s reset!",
        ["casa_reset_2"] = "House %s does not exist or does not need to be reset!"
    },
    ["it"] = {
        ["allarme"] = "Allarme",
        ["leggi_codice"] = 'Leggi Codice',
        ["raccogli_oggetto"] = 'Raccogli Oggetto',
        ["forza_porta"] = 'Forza Porta',
        ["inserisci_password_title"] = "Codice Allarme",
        ["inserisci_password_label"] = "Codice di Sicurezza",
        ["inserisci_password_description"] = "Inserisci la Password",
        ["fuggito"] = "Sei Fuggito dalla Zona della Rapina.<br><br>Missione Conclusa.",
        ["attendi_notte"] = "Sarebbe meglio attendere la notte.",
        ["porta_aperta"] = "La Porta si è Aperta!",
        ["rumore_strano"] = "Senti un rumore strano, come fosse un ticchettio.",
        ["allarme_attento"] = "OH CAZZO!<br>E' un Allarme, ma non è ancora scattato!<br>Forse dovresti provare a disabilitarlo!",
        ["non_disponibile"] = "Sembra ci sia qualcuno in Casa.<br>Meglio passare dopo!",
        ["item_mancante"] = "Non possiedi l'oggetto giusto per poter aprire questa porta!",
        ["rapina_in_corso"] = "Una Rapina è già in corso presso questo indirizzo!",
        ["password_corretta"] = "Password Corretta!<br>Allarme disabilitato.",
        ["password_errata"] = "Password Errata!",
        ["pannello_bloccato"] = "Il Pannello è Bloccato!",
        ["casa_reset_1"] = "Casa %s resettata!",
        ["casa_reset_2"] = "Casa %s non esiste o non ha bisono di essere resettata!"
    }
}

function ShowNotification(text, type, title, source)
    if IsDuplicityVersion() then
        if not source or source <= 0 then print("Error on Notification"); return; end
        TriggerClientEvent("esx:showNotification", source, text, type, title)
    else
        ESX.ShowNotification(text, type, title)
    end
end

function TableCopy(orig)
	local orig_type, copy = type(orig)

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[TableCopy(orig_key)] = TableCopy(orig_value)
        end
        setmetatable(copy, TableCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function Debug(...)
    if Config.Debug then
        print(...)
    end
end