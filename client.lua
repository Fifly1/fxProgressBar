local progressActive = false
local progressData = nil
local props = {}
local particles = {}

local function RequestModelSync(model)
    local modelHash = type(model) == "string" and GetHashKey(model) or model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end
    return modelHash
end

local function RequestAnimDictSync(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

local function RequestPtfxAssetSync(assetName)
    RequestNamedPtfxAsset(assetName)
    while not HasNamedPtfxAssetLoaded(assetName) do
        Citizen.Wait(0)
    end
end

function ShowProgressBar(data, callback)

    if progressActive then
        FinishProgress(true, callback)
    end

    progressData = data
    progressActive = true

    SendNUIMessage({
        action = "show",
        duration = data.duration or 5000,
        label = data.label
    })

    Citizen.CreateThread(function()
        local progressEndTime = GetGameTimer() + (data.duration or 5000)
        while progressActive do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 177) and progressData.canCancel then
                FinishProgress(true, callback)
                return
            end
            if GetGameTimer() >= progressEndTime then
                FinishProgress(false, callback)
                return
            end
        end
    end)

    if IsEntityDead(PlayerPedId()) and not data.useWhileDead then
        FinishProgress(true, callback)
        return
    end

    if IsPedRagdoll(PlayerPedId()) and not data.allowRagdoll then
        FinishProgress(true, callback)
        return
    end

    if IsPedSwimming(PlayerPedId()) and not data.allowSwimming then
        FinishProgress(true, callback)
        return
    end

    if IsPedCuffed(PlayerPedId()) and not data.allowCuffed then
        FinishProgress(true, callback)
        return
    end

    if IsPedFalling(PlayerPedId()) and not data.allowFalling then
        FinishProgress(true, callback)
        return
    end

    if data.disable then
        DisableControlAction(0, 30, data.disable.move or false)
        DisableControlAction(0, 31, data.disable.move or false)
        DisableControlAction(0, 75, data.disable.car or false)
        DisableControlAction(0, 140, data.disable.combat or false)
        DisableControlAction(0, 142, data.disable.combat or false)
        DisableControlAction(0, 263, data.disable.combat or false)
        DisableControlAction(0, 1, data.disable.mouse or false)
        DisableControlAction(0, 2, data.disable.mouse or false)
        DisableControlAction(0, 21, data.disable.sprint or false)
    end

    if data.anim then
        local playerPed = PlayerPedId()
        RequestAnimDictSync(data.anim.dict)
        TaskPlayAnim(playerPed, data.anim.dict, data.anim.clip, data.anim.blendIn or 3.0, data.anim.blendOut or 1.0, data.duration or -1, data.anim.flag or 49, data.anim.playbackRate or 0, data.anim.lockX or false, data.anim.lockY or false, data.anim.lockZ or false)
    elseif data.scenario then
        TaskStartScenarioInPlace(PlayerPedId(), data.scenario, 0, data.playEnter ~= false)
    end

    if data.prop then
        local propList = type(data.prop) == "table" and data.prop or {data.prop}
        for _, p in ipairs(propList) do
            local modelHash = RequestModelSync(p.model)
            local prop = CreateObject(modelHash, 0, 0, 0, true, true, true)
            AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), p.bone or 60309), p.pos.x, p.pos.y, p.pos.z, p.rot.x, p.rot.y, p.rot.z, false, false, false, true, p.rotOrder or 0, true)
            table.insert(props, prop)
        end
    end

    if data.particles then
        for _, p in ipairs(data.particles) do
            RequestPtfxAssetSync(p.assetName)
            UseParticleFxAssetNextCall(p.assetName)
            local particle = StartParticleFxLoopedOnEntityBone(p.effectName, PlayerPedId(), p.pos.x, p.pos.y, p.pos.z, p.rot.x, p.rot.y, p.rot.z, GetPedBoneIndex(PlayerPedId(), p.bone or 60309), p.scale or 1.0, false, false, false)
            table.insert(particles, particle)
        end
    end
end

function FinishProgress(cancelled, callback)
    if not progressActive then return end

    progressActive = false
    SendNUIMessage({
        action = "hide"
    })
    ClearPedTasks(PlayerPedId())

    for _, prop in ipairs(props) do
        DeleteObject(prop)
    end
    props = {}

    for _, particle in ipairs(particles) do
        StopParticleFxLooped(particle, false)
    end
    particles = {}

    if cancelled then
        if progressData.onCancel then
            progressData.onCancel()
        end
    else
        if progressData.onFinish then
            progressData.onFinish()
        end
    end

    if callback then
        callback(cancelled)
    end
end

function IsProgressActive()
    return progressActive
end

exports("ShowProgressBar", ShowProgressBar)
exports("IsProgressActive", IsProgressActive)

RegisterNUICallback("cancel", function()
    FinishProgress(true, callback)
end)
