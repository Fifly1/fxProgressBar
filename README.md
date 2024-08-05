![fxprogressbar_thumbnail](https://github.com/user-attachments/assets/a2185594-d253-4b8a-8767-fb167c364115)

**|Preview|**
Click [here ](https://youtu.be/VxtPegVqBOg)to see a preview

**|Information|**
A progress bar offering a range of customizable features including animations, props, particle effects, and control settings.

**Features included:**

1. **Duration & Label**:
  * `duration` (number): Set the length of the progress bar in milliseconds.
  * `label` (string): Customize the label displayed on the progress bar.
2. **Behavioral Controls** (**optional**):
  * `useWhileDead` (boolean): Allows actions while the player is dead.
  * `allowRagdoll` (boolean): Permits ragdolling during progress.
  * `allowSwimming` (boolean): Enables swimming during progress.
  * `allowCuffed` (boolean): Allows actions while the player is cuffed.
  * `allowFalling` (boolean): Continue actions while the player is falling.
  * `canCancel` (boolean): Let players cancel the progress.
3. **Animation Controls** (**optional**):
  * `anim` (table): Define animations with:
    * `dict` (string): Animation dictionary.
    * `clip` (string): Specific animation clip.
    * `flag` (number, **optional**): Animation flag, default is 49.
    * `blendIn` (float, **optional**): Time to blend in the animation.
    * `blendOut` (float, **optional**): Time to blend out the animation.
    * `playbackRate` (float, **optional**): Speed of the animation.
    * `lockX` (boolean, **optional**), `lockY` (boolean, **optional**), `lockZ` (boolean, **optional**): Lock movement on specific axes.
4. **Prop Handling** (**optional**):
  * `prop` (table): Attach props to the player with:
    * `model` (hash): Prop model hash.
    * `bone` (number, **optional**): Bone to attach the prop, default is 60309.
    * `pos` (table): Position offsets (x, y, z).
    * `rot` (table): Rotation offsets (x, y, z).
    * `rotOrder` (number, **optional**): Order of applying rotations.
5. **Particle Effects** (**optional**):
  * `particles` (table): Add particle effects with:
    * `assetName` (string): Particle asset name.
    * `effectName` (string): Specific particle effect.
    * `bone` (number, **optional**): Bone index for attachment.
    * `pos` (table): Position offsets (x, y, z).
    * `rot` (table): Rotation offsets (x, y, z).
    * `scale` (number, **optional**): Scale of the particle effect.
6. **Disable Controls** (**optional**):
  * `disable` (table): Control player actions by disabling:
    * `move` (boolean): Movement.
    * `car` (boolean): Car controls.
    * `combat` (boolean): Combat actions.
    * `mouse` (boolean): Mouse input.
    * `sprint` (boolean): Sprinting.
7. **Event Handlers** (**optional**):
  * `onFinish` (function, **optional**): Callback function on successful completion.
  * `onCancel` (function, **optional**): Callback function if canceled.

**|How to use|**
You just have to trigger this export: `exports['fx_progressbar']:ShowProgressBar()`
It can be anywhere, in any script.

Example with everything that you can do:

```
exports['fx_progressbar']:ShowProgressBar({
    duration = 10000, -- The duration for which the progress bar will be shown, in milliseconds.
    label = "Performing Action...", -- The label displayed on the progress bar.

    -- Behavioral Controls
    useWhileDead = false, -- Whether the action can be performed while the player is dead.
    allowRagdoll = false, -- Whether the player can ragdoll during the progress.
    allowSwimming = true, -- Whether the player can swim during the progress.
    allowCuffed = false, -- Whether the action can be performed while the player is cuffed.
    allowFalling = false, -- Whether the action can continue if the player is falling.
    canCancel = true, -- Whether the player can cancel the progress.

    -- Animation Controls
    anim = {
        dict = "amb@world_human_stand_mobile@male@text@base", -- Animation dictionary.
        clip = "base", -- Animation clip.
        flag = 49, -- Animation flag (default is 49).
        blendIn = 3.0, -- Time to blend in the animation.
        blendOut = 1.0, -- Time to blend out the animation.
        playbackRate = 1.0, -- Speed at which the animation is played.
        lockX = true, -- Lock X-axis movement.
        lockY = false, -- Lock Y-axis movement.
        lockZ = true, -- Lock Z-axis movement.
    },

    -- Prop Handling
    prop = {
        {
            model = `prop_ld_flow_bottle`, -- Prop model hash.
            bone = 60309, -- Bone to attach the prop to (default is 60309).
            pos = { x = 0.05, y = 0.0, z = -0.15 }, -- Position offset for the prop.
            rot = { x = 0.0, y = 0.0, z = 0.0 }, -- Rotation offset for the prop.
            rotOrder = 0, -- Order in which rotations are applied.
        }
    },

    -- Particle Effects
    particles = {
        {
            assetName = "core", -- Particle asset name
            effectName = "ent_amb_sparks", -- Particle effect name
            bone = 28422, -- Bone to attach the particle to (e.g., right hand)
            pos = { x = 0.0, y = 0.0, z = 0.0 }, -- Position offset for the particle
            rot = { x = 0.0, y = 0.0, z = 0.0 }, -- Rotation offset for the particle
            scale = 1.0, -- Scale of the particle effect
        },
        {
            assetName = "scr_rcbarry2",
            effectName = "scr_clown_death",
            bone = 24818, -- Another bone index for demonstration (e.g., left hand)
            pos = { x = 0.1, y = 0.1, z = 0.0 },
            rot = { x = 0.0, y = 0.0, z = 0.0 },
            scale = 0.5,
        }
    },

    -- Disable Controls
    disable = {
        move = true, -- Disable player movement.
        car = false, -- Allow entering/exiting cars.
        combat = true, -- Disable combat controls.
        mouse = true, -- Disable mouse controls.
        sprint = true, -- Disable sprinting.
    },

    -- Event Handlers
    onFinish = function()
        print("Action completed successfully!")
    end,
    onCancel = function()
        print("Action was canceled.")
    end
})

```

**|Implementing to qb-core|**
If you want to change the default progress bar in the qb-core go to qb-core/client/functions.lua and replace the `QBCore.Functions.Progressbar` function with this:

```
function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if exports['fx_progressbar']:IsProgressActive() then QBCore.Functions.Notify('You are already doing something!', 'error', 3000) return end

    local disable = {}
    if disableControls then
        disable.move = disableControls.disableMovement
        disable.car = disableControls.disableCarMovement
        disable.combat = disableControls.disableCombat
        disable.mouse = disableControls.disableMouse
        disable.sprint = disableControls.disableSprint
    end

    local defaultPos = { x = 0.0, y = 0.0, z = 0.0 }
    local defaultRot = { x = 0.0, y = 0.0, z = 0.0 }

    if prop then
        prop.pos = prop.pos or defaultPos
        prop.rot = prop.rot or defaultRot
    end

    if propTwo then
        propTwo.pos = propTwo.pos or defaultPos
        propTwo.rot = propTwo.rot or defaultRot
    end

    local props = {}
    if prop then table.insert(props, prop) end
    if propTwo then table.insert(props, propTwo) end

    local anim = nil
    if animation then
        anim = {
            dict = animation.animDict,
            clip = animation.anim,
            flag = animation.flags,
            blendIn = 3.0,
            blendOut = 1.0,
            playbackRate = animation.playbackRate or 1.0,
            lockX = animation.lockX,
            lockY = animation.lockY,
            lockZ = animation.lockZ,
        }
    end

    exports['fx_progressbar']:ShowProgressBar({
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        disable = disable,
        anim = anim,
        prop = props,
        onFinish = function()
            if onFinish then
                onFinish()
            end
        end,
        onCancel = function()
            if onCancel then
                onCancel()
            end
        end,
    })
end
```

After which add this `'@fx_progressbar/client.lua'` to the fxmanifest.lua in shared_scripts. Also make sure that the `fx_progressbar` is ensured before `qb-core` in the cfg.


**|Download (FREE)|**
Get this resource at [Tebex ](https://fxscripts.tebex.io/package/6392298) or at [Github ](https://github.com/Fifly1/fxWelcomeUI)
