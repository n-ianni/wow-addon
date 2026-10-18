local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Options = {}
Options.__index = Options
ns.Options = Options

local NAME, DESC = "N_%s", "D_%s"

-- Looks up defaults.profile.modules[MODULE][key], then the ["*"] wildcard section.
local function GetDefault(addon, moduleName, key, fallback)
    local defaults = addon.defaults
    local modules = defaults and defaults.profile and defaults.profile.modules
    local value = modules and modules[moduleName] and modules[moduleName][key]
    if value == nil then value = modules and modules["*"] and modules["*"][key] end
    if value == nil then return fallback end
    return value
end

local function Register(self, category, key, valueType, fallback, label)
    local moduleName = self.module:GetName()
    local variable = ("%s_%s_%s"):format(addonName, moduleName, key)
    local default = GetDefault(self.addon, moduleName, key, fallback)

    -- The Settings UI reads straight from the table; a missing value breaks sliders.
    if self.db[key] == nil then self.db[key] = default end

    return Settings.RegisterAddOnSetting(
        category, variable, key, self.db, valueType,
        label or L[NAME:format(key:upper())], default)
end

local function OnChange(setting, onChange)
    if onChange then
        setting:SetValueChangedCallback(function(_, value) onChange(value) end)
    end
end


-- ─────────────────────────────────────────────────────────────────────────────────
--  Key capture (the Settings UI has no keybinding control, so we roll a minimal one)
-- ─────────────────────────────────────────────────────────────────────────────────

local MODIFIER_KEYS = {
    LSHIFT = true, RSHIFT = true, LCTRL = true, RCTRL = true,
    LALT = true, RALT = true, LMETA = true, RMETA = true,
}
local KEY_CANCEL, KEY_CLEAR = "ESCAPE", "DELETE"

local capture

local function GetCapture()
    if capture then return capture end

    capture = CreateFrame("Frame", nil, UIParent)
    capture:SetSize(420, 70)
    capture:SetPoint("CENTER")
    capture:SetFrameStrata("FULLSCREEN_DIALOG")
    capture:EnableKeyboard(true)
    capture:Hide()

    local background = capture:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0, 0, 0, 0.85)

    capture.text = capture:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    capture.text:SetPoint("CENTER")
    capture.text:SetText(L["KEY_CAPTURE"])

    capture:SetScript("OnKeyDown", function(self, pressed)
        if MODIFIER_KEYS[pressed] then return end
        self:SetPropagateKeyboardInput(false)

        local callback = self.callback
        self:Hide()
        if pressed == KEY_CANCEL or not callback then return end

        if pressed == KEY_CLEAR then return callback("") end

        local chord = (IsAltKeyDown() and "ALT-" or "")
            .. (IsControlKeyDown() and "CTRL-" or "")
            .. (IsShiftKeyDown() and "SHIFT-" or "")
            .. pressed
        callback(chord)
    end)
    capture:SetScript("OnHide", function(self) self.callback = nil end)

    return capture
end

local function CaptureKey(callback)
    local frame = GetCapture()
    frame.callback = callback
    frame:Show()
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

function Options:AddKeybind(key, onChange)
    self._entries[#self._entries + 1] = function(category, layout)
        local function Label()
            local value = self:Get(key)
            return (value and value ~= "") and value or L["KEY_UNBOUND"]
        end

        local initializer = CreateSettingsButtonInitializer(
            L[NAME:format(key:upper())], Label(),
            function(button)
                CaptureKey(function(value)
                    self.db[key] = value
                    if type(button) == "table" and button.SetText then button:SetText(Label()) end
                    if onChange then onChange(value) end
                end)
            end,
            L[DESC:format(key:upper())], true)

        layout:AddInitializer(initializer)
        return initializer
    end
    return self
end

-- Module name [x]            <- the checkbox row is labelled with the module name
--     option                 <- indented children, greyed out while the module is disabled
function Options:Build(category, layout)
    local module, db = self.module, self.db

    local enabled = Register(self, category, "enabled", "boolean", false, module._name)
    enabled:SetValueChangedCallback(function(_, value)
        if value then module:Enable() else module:Disable() end
    end)
    local parent = Settings.CreateCheckbox(category, enabled, module._desc)
    local isEnabled = function() return db.enabled end

    for _, create in ipairs(self._entries) do
        local child = create(category, layout)
        if child.SetParentInitializer then child:SetParentInitializer(parent, isEnabled) end
    end
end
