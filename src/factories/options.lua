local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local Options = {}
Options.__index = Options
ns.Options = Options

local NAME, DESC = "N_%s", "D_%s"

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function CreateOption(db, key, type, custom, onChange)
    local option = {
        type = type,
        name = L[NAME:format(key:upper())],
        desc = L[DESC:format(key:upper())],

        get = function() return db[key] end,
        set = function(_, value)
            local old = db[key]
            db[key] = value
            if onChange then onChange(value, old) end
        end,
        disabled = function() return key ~= "enabled" and not db.enabled end,
    }

    if custom then for k, v in pairs(custom) do option[k] = v end end
    return option
end

local function SetModuleState(object)
    local db = object.db
    local module = object.module
    local options = object._options

    module:SetEnabledState(db.enabled)
    options.enabled = CreateOption(db, "enabled", "toggle",
    {
        order = 0,
        width = "full",
        set = function(_, value)
            db.enabled = value
            if value then object.module:Enable() else object.module:Disable() end
        end,
    })
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Object Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Options:Get(key) return self.db[key] end
function Options:GetOptions() return self._options end

function Options:New(addon, module)
    local object = setmetatable({}, Options)
    object.db = addon.db.profile.modules[module:GetName()]
    object.addon = addon
    object.module = module
    object._options = {}

    SetModuleState(object)

    return object
end

function Options:AddToggle(key)
    self._options[key] = CreateOption(self.db, key, "toggle")
    return self
end

function Options:AddInput(key)
    self._options[key] = CreateOption(self.db, key, "input", { pattern = "^%d+$", usage = "0-9" })
    return self
end

function Options:AddKeybind(key, onChange)
    self._options[key] = CreateOption(self.db, key, "keybinding", nil, onChange)
    return self
end
