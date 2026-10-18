local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Prototype = {}

function Prototype:OnInitialize()
    local name = self:GetName()
    local modules = ns.Addon.db.modules

    modules[name] = modules[name] or { enabled = false }

    self.L = L
    self.Log = ns.Log
    self.db = modules[name]

    self:SetEnabledState(self.db.enabled)
end

ns.Addon:SetDefaultModulePrototype(Prototype)
