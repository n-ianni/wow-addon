local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Options = {}
Options.__index = Options
ns.Options = Options

local NAME, DESC = "N_%s", "D_%s"

-- Assumes your AceDB defaults follow defaults.profile.modules[MODULE][key]
local function GetDefault(addon, moduleName, key, fallback)
    local defaults = addon.defaults
    local modules = defaults and defaults.profile and defaults.profile.modules
    local value = modules and modules[moduleName] and modules[moduleName][key]
    if value == nil then return fallback end
    return value
end

local function Register(self, category, key, valueType, fallback)
    local moduleName = self.module:GetName()
    local variable = ("%s_%s_%s"):format(addonName, moduleName, key)
    local default = GetDefault(self.addon, moduleName, key, fallback)

    return Settings.RegisterAddOnSetting(
        category, variable, key, self.db, valueType,
        L[NAME:format(key:upper())], default)
end

local function OnChange(setting, onChange)
    if onChange then
        setting:SetValueChangedCallback(function(_, value) onChange(value) end)
    end
end

function Options:Get(key) return self.db[key] end

function Options:New(addon, module)
    local object = setmetatable({}, Options)
    object.db = addon.db.profile.modules[module:GetName()]
    object.addon = addon
    object.module = module
    object._entries = {}

    module:SetEnabledState(object.db.enabled)

    return object
end

function Options:AddToggle(key, onChange)
    self._entries[#self._entries + 1] = function(category)
        local setting = Register(self, category, key, "boolean", false)
        OnChange(setting, onChange)
        return Settings.CreateCheckbox(category, setting, L[DESC:format(key:upper())])
    end
    return self
end

function Options:AddSlider(key, min, max, step, onChange, formatter)
    self._entries[#self._entries + 1] = function(category)
        local setting = Register(self, category, key, "number", min)
        OnChange(setting, onChange)

        local options = Settings.CreateSliderOptions(min, max, step)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, formatter)

        return Settings.CreateSlider(category, setting, options, L[DESC:format(key:upper())])
    end
    return self
end

function Options:Build(category, layout)
    local module, db = self.module, self.db

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(module._name))

    local enabled = Register(self, category, "enabled", "boolean", true)
    enabled:SetValueChangedCallback(function(_, value)
        if value then module:Enable() else module:Disable() end
    end)
    local parent = Settings.CreateCheckbox(category, enabled, module._desc)
    local isEnabled = function() return db.enabled end

    for _, create in ipairs(self._entries) do
        create(category):SetParentInitializer(parent, isEnabled)
    end
end
