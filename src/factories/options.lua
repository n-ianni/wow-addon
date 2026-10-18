local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Options = {}
Options.__index = Options
ns.Options = Options

local function Text(key)
    local label = "OPT_" .. key
    return L[label], L[label .. "_DESC"]
end

local function Register(self, key, valueType, default, label)
    local db = self.db
    if db[key] == nil then db[key] = default end

    local variable = ("%s_%s_%s"):format(addonName, self.module:GetName(), key)
    return Settings.RegisterAddOnSetting(self.category, variable, key, db, valueType, label, default)
end

local function OnChange(setting, onChange)
    if onChange then
        setting:SetValueChangedCallback(function(_, value) onChange(value) end)
    end
end

local function Attach(self, initializer)
    initializer:SetParentInitializer(self.parent, self.isEnabled)
    return self
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

    local setting = Register(self, "enabled", "boolean", false, label)
    setting:SetValueChangedCallback(function(_, value)
        if value then module:Enable() else module:Disable() end
    end)
    self.parent = Settings.CreateCheckbox(page.category, setting, desc)

    return self
end

function Options:AddToggle(key, onChange)
    local label, desc = Text(key)
    local setting = Register(self, key, "boolean", false, label)
    OnChange(setting, onChange)

    return Attach(self, Settings.CreateCheckbox(self.category, setting, desc))
end

function Options:AddSlider(key, spec)
    local label, desc = Text(key)
    local setting = Register(self, key, "number", spec.default or spec.min, label)
    OnChange(setting, spec.onChange)

    local slider = Settings.CreateSliderOptions(spec.min, spec.max, spec.step)
    slider:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, spec.format)

    return Attach(self, Settings.CreateSlider(self.category, setting, slider, desc))
end

function Options:AddKeybind(key, onChange)
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
            button:SetText(Label())
            initializer.data.buttonText = Label()
            if onChange then onChange(value) end
        end)
    end, desc, true)

    self.layout:AddInitializer(initializer)

    return Attach(self, initializer)
end
