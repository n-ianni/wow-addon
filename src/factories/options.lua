local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Options = {}
Options.__index = Options
ns.Options = Options

local function Text(key)
    local label = "OPT_" .. key
    return L[label], L[label .. "_DESC"]
end

local function Register(self, key, valueType, default, label, onChange)
    local db = self.db
    if db[key] == nil then db[key] = default end

    local variable = ("%s_%s_%s"):format(addonName, self.module:GetName(), key)
    local setting = Settings.RegisterAddOnSetting(self.category, variable, key, db, valueType, label, default)

    if onChange then
        setting:SetValueChangedCallback(function(_, value) onChange(value) end)
    end

    return setting
end

function Options:New(module, page, label, desc)
    local db = module.db
    local self = setmetatable({
        module    = module,
        db        = db,
        category  = page.category,
        layout    = page.layout,
        isEnabled = function() return db.enabled end,
    }, Options)

    local setting = Register(self, "enabled", "boolean", false, label, function(value)
        if value then module:Enable() else module:Disable() end
    end)
    self.parent = Settings.CreateCheckbox(page.category, setting, desc)

    return self
end

-- Every Add* method takes (key, spec); spec is optional for toggles and keybinds.
--   toggle:  { default = false, onChange = fn(value) }
--   slider:  { min, max, step, default = min, format = fn(value), onChange = fn(value) }
--   keybind: { onChange = fn(value) }

function Options:AddToggle(key, spec)
    spec = spec or {}
    local label, desc = Text(key)
    local setting = Register(self, key, "boolean", spec.default or false, label, spec.onChange)
    local initializer = Settings.CreateCheckbox(self.category, setting, desc)
    initializer:SetParentInitializer(self.parent, self.isEnabled)
end

function Options:AddSlider(key, spec)
    local label, desc = Text(key)
    local setting = Register(self, key, "number", spec.default or spec.min, label, spec.onChange)

    local slider = Settings.CreateSliderOptions(spec.min, spec.max, spec.step)
    slider:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, spec.format)

    local initializer = Settings.CreateSlider(self.category, setting, slider, desc)
    initializer:SetParentInitializer(self.parent, self.isEnabled)
end

function Options:AddKeybind(key, spec)
    spec = spec or {}
    local label, desc = Text(key)
    local db = self.db

    local function Label()
        local value = db[key]
        return (value and value ~= "") and value or L["KEY_UNBOUND"]
    end

    local initializer
    initializer = CreateSettingsButtonInitializer(label, Label(), function(button)
        ns.CaptureKey(function(value)
            db[key] = value

            local text = Label()
            button:SetText(text)
            initializer.data.buttonText = text

            if spec.onChange then spec.onChange(value) end
        end)
    end, desc, true)

    self.layout:AddInitializer(initializer)
    initializer:SetParentInitializer(self.parent, self.isEnabled)
end
