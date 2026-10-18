local _, ns = ...
local Module = ns.Addon:NewModule("FISHING", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local UNIT = "player"
local CVAR = "SoftTargetInteract"
local TARGET = "INTERACTTARGET"
local SPELL_NAME = "SPELL " .. _G.C_Spell.GetSpellName(131474)
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

local frame = _G.CreateFrame("Frame")
local cachedInteract
local channeling

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function Update()
    if InCombatLockdown() then return end

    ClearOverrideBindings(frame)

    if channeling then
        cachedInteract = cachedInteract or GetCVar(CVAR)
        SetCVar(CVAR, "3")
    elseif cachedInteract then
        SetCVar(CVAR, cachedInteract)
        cachedInteract = nil
    end

    local key = Module.db.fishingKey
    if key and key ~= "" then
        SetOverrideBinding(frame, false, key, channeling and TARGET or SPELL_NAME)
    end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "OnChannel")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "OnChannel")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", Update)

    Update()
end

function Module:OnDisable()
    self:UnregisterAllEvents()

    channeling = false
    Update()
    ClearOverrideBindings(frame)
end

function Module:InjectOptions(options)
    options:AddKeybind("fishingKey", {
        onChange = function() if self:IsEnabled() then Update() end end,
    })
end

function Module:OnChannel(event, unit, _, spellID)
    if unit ~= UNIT or not FISHING_SPELLS[spellID] then return end

    channeling = event == "UNIT_SPELLCAST_CHANNEL_START"
    if channeling then Update() else After(0.5, Update) end
end
