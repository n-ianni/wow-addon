local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName)

ns.Addon = addon

function addon:OnInitialize()
    self:CreateDatabase()
    self:CreateSettings()
end

function addon:OnEnable()
    self:FinalizeSettings()
end
