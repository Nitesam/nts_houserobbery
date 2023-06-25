Config = {}
Config.Debug = true -- If Debug mode is true, the bounding boxes of objects spawned by the script will be visible.

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
                    ["gold"] = {min = 1, max = 3, prob = 20} -- min is the minimum value of the random, max its maximum and prob is the probability that the item is inserted!
                }
            }
        },
    }
}

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