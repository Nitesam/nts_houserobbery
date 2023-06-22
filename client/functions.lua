function verificaNotte()
    if Config.Notturno.SoloNotte then
        local ore = GetClockHours()

        if Config.Notturno.Orari.inizio <= Config.Notturno.Orari.fine then
            if ore >= Config.Notturno.Orari.inizio and ore < Config.Notturno.Orari.fine then
                return true
            end
        else
            if ore >= Config.Notturno.Orari.inizio or ore < Config.Notturno.Orari.fine then
                return true
            end
        end

        return false
    else
        return true
    end
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 0.4
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, scale, 0.35, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function showInfobar(msg) -- Non in Utilizzo
	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function text(content) -- Non in Utilizzo
    SetTextFont(1)
    SetTextProportional(0)
    SetTextScale(0.65,0.65)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.74,0.9)
end

function text2(content) -- Non in Utilizzo
    SetTextFont(1)
    SetTextProportional(0)
    SetTextScale(0.75,0.75)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.74,0.85)
end