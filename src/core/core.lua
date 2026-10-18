local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName)

ns.Addon = addon

local DEFAULTS = {
    profile = {
        modules = {
            ["*"] = { enabled = false },
        },
    },
}

function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(addonName .. "_DB", DEFAULTS, true)
end

function addon:OnEnable()
    ns.SettingsPanel.Build(self)
end
