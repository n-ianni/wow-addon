local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName)

ns.Addon = addon

function addon:OnInitialize()
    local name = addonName .. "_DB"

    _G[name] = _G[name] or {}
    self.db = _G[name]
    self.db.modules = self.db.modules or {}
end

function addon:OnEnable()
    ns.SettingsPanel.Build(self)
end
