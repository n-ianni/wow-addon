local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Prototype = {}

function Prototype:OnInitialize()
    self.L = L
    self.Log = ns.Log
    self.db = ns.Addon.db.profile.modules[self:GetName()]

    self:SetEnabledState(self.db.enabled)
end

ns.Addon:SetDefaultModulePrototype(Prototype)
