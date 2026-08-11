local _, ns = ...
local Module = ns.Addon:NewModule("FISHING", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local UNIT = "player"
local CVAR = "SoftTargetInteract"
local TARGET = "INTERACTTARGET"
local K_FISHING = "KEY_FISHING"
local SPELL_NAME = _G.C_Spell.GetSpellName(131474)
local BINDINGS = {
    CAST = "CAST",
    INTERACT = "INTERACT"
}
local FISHING_SPELLS = {
    [131474] = true,
    [131476] = true,
    [131490] = true, 
    [7620]   = true,
}

local After = _G.C_Timer.After
local GetCVar, SetCVar = _G.GetCVar, _G.SetCVar
local InCombatLockdown = _G.InCombatLockdown
local SetOverrideBinding = _G.SetOverrideBinding
local ClearOverrideBindings = _G.ClearOverrideBindings
local SetOverrideBindingSpell = _G.SetOverrideBindingSpell

local frame = _G.CreateFrame("Frame")
local cachedInteract

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function SetBinding(mode)
    if InCombatLockdown() then return end
    
    if mode == BINDINGS.INTERACT then
        cachedInteract = GetCVar(CVAR)
        if cachedInteract ~= "3" then SetCVar(CVAR, "3") end
        SetOverrideBinding(frame, false, Module.Options:Get(K_FISHING), TARGET)
    else
        if cachedInteract then SetCVar(CVAR, cachedInteract) end
        SetOverrideBindingSpell(frame, false, Module.Options:Get(K_FISHING), SPELL_NAME)
    end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")

    SetBinding(BINDINGS.CAST)
end

function Module:OnDisable()
    ClearOverrideBindings(frame)
    self:UnregisterAllEvents()
end

function Module:InjectOptions()
    self.Options:AddKeybind(K_FISHING)
end

function Module:UNIT_SPELLCAST_CHANNEL_START(_, unit, _, spellID)
    if unit == UNIT and FISHING_SPELLS[spellID] then SetBinding(BINDINGS.INTERACT) end
end

function Module:UNIT_SPELLCAST_CHANNEL_STOP(_, unit, _, spellID)
    if unit == UNIT and FISHING_SPELLS[spellID] then After(0.5, SetBinding) end
end

function Module:PLAYER_REGEN_ENABLED()
    SetBinding(BINDINGS.CAST)
end
