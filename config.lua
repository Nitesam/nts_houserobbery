Config = {}

Config.CooldownGenerico = 600 -- in secondi

Config.Notturno = {
    SoloNotte = true,
    Orari = {inizio = 21, fine = 6}
}

Config.Ordine = {
    ["police"] = true
}

Config.Case = {
    [1] = {
        nome = "Franklin",
        poliziottiRichiesti = 0,
        timerAllarme = 60,
        cooldown = 1800, -- tempo prima che la casa possa essere rirapinata
        tempoMax = 1200, -- tempo massimo per concludere la missione
        oggettoApertura = "lockpick", -- oggetto utilizzato per aprire la porta principale
        disabilitaAllarme = vec3(-7.79, 524.03, 175.19), -- il punto per disabilitare l'allarme.
        difSkillCheck = {'easy', 'easy', {areaSize = 100, speedMultiplier = 1.8}}, -- la difficoltà dello skillcheck per la porta di accesso a questa struttura.
        multigiocatore = true, -- true = più persone possono rapinare i sacchi a terra;  false - solo chi inizia la rapina può raccogliere i sacchi a terra;

        porta = {
            modello = `v_ilev_fh_frontdoor`, -- IMPORTANTE, USARE QUESTI APICI
            coordinate = vec3(8.21, 539.29, 176.03)
        },
        posizioneCodice = {
            [1] = vec3(13.41, 527.85, 173.63)
        },
        puntiRaccolta = {
            [1] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(-6.06, 531.31, 174.89), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 20} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [2] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(-12.13, 516.83, 174.78), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 100} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [3] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(-1.57, 536.43, 175.27), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [4] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(9.23, 530.45, 170.76), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            }
        },
    },
    [2] = {
        nome = "Casa 1",
        poliziottiRichiesti = 0,
        timerAllarme = 60,
        cooldown = 1800, -- tempo prima che la casa possa essere rirapinata
        tempoMax = 1200, -- tempo massimo per concludere la missione
        oggettoApertura = "lockpick", -- oggetto 
        disabilitaAllarme = vec3(1222.44, -669.67, 64.01),
        difSkillCheck = {'medium', 'easy', {areaSize = 60, speedMultiplier = 1.1}, 'easy'},
        multigiocatore = true, -- true = più persone possono rapinare i sacchi a terra;  false - solo chi inizia la rapina può raccogliere i sacchi a terra.

        porta = {
            modello = -1422530141, -- IMPORTANTE, USARE QUESTI APICI
            coordinate = vec3(1221.65, -669.67, 63.90)
        },
        posizioneCodice = {
            [1] = vec3(1228.60, -667.91, 63.23)
        },
        puntiRaccolta = {
            [1] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1223.79, -673.45, 62.99), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 20} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [2] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1222.95, -668.15, 63.29), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 100} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [3] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1229.40, -673.69, 63.28), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [4] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1217.56, -673.26, 63.34), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            }
        },
    },
    [3] = {
        nome = "Casa 2",
        poliziottiRichiesti = 0,
        timerAllarme = 60,
        cooldown = 1800, -- tempo prima che la casa possa essere rirapinata
        tempoMax = 1200, -- tempo massimo per concludere la missione
        oggettoApertura = "lockpick", -- oggetto 
        disabilitaAllarme = vec3(1097.18, -446.17, 68.03),
        difSkillCheck = {'medium', 'easy', {areaSize = 60, speedMultiplier = 1.1}, 'easy'},
        multigiocatore = true, -- true = più persone possono rapinare i sacchi a terra;  false - solo chi inizia la rapina può raccogliere i sacchi a terra.

        porta = {
            modello = -232187956, -- IMPORTANTE, USARE QUESTI APICI
            coordinate = vec3(1099.43, -439.06, 68.01)
        },
        posizioneCodice = {
            [1] = vec3(1104.46, -435.20, 67.00)
        },
        puntiRaccolta = {
            [1] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1107.75, -442.39, 67.74), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 20} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [2] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1105.79, -438.61, 67.42), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 100} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [3] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1106.77, -443.79, 67.51), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            },
            [4] = {
                rand = 100, -- percentuale spawn di questa sezione in %.
                prop = `prop_gold_bar`,
                dizionario = "missexile3", animazione = "ex03_dingy_search_case_b_michael",
                coordinate = vec3(1107.00, -451.06, 67.06), -- Non possono essere creati entrambi, solo denaro sporco o oggetti possono essere trovati per via del bilanciamento!
                denaroSporco = 600,
                listaOggetti = {
                    ["gold"] = {min = 1, max = 3, prob = 30} -- min è il valore minimo del random, max il suo massimo e prob è la probabilità che il drop venga creato!
                }
            }
        },
    }
}

