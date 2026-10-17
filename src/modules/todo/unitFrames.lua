local _, ns = ...
local Module = ns.Addon:NewModule("UNITTEXT", "AceEvent-3.0", "AceHook-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Configuration
-- ─────────────────────────────────────────────────────────────────────────────────

local CONFIG = {
    THRESHOLD = 35,     -- Hide text while health/power is ABOVE this percentage (0-100)
}

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local TEXT_KEYS = { "TextString", "LeftText", "RightText" }

local EVENTS = {
    "UNIT_HEALTH",
    "UNIT_MAXHEALTH",
    "UNIT_POWER_UPDATE",
    "UNIT_POWER_FREQUENT",
    "UNIT_MAXPOWER",
    "UNIT_DISPLAYPOWER",
    "UNIT_PET",
    "UNIT_TARGET",
    "PLAYER_TARGET_CHANGED",
    "PLAYER_FOCUS_CHANGED",
    "PLAYER_ENTERING_WORLD",
    "NAME_PLATE_UNIT_ADDED",
}

-- Each entry resolves its bars lazily, since some frames are created late.
local UNITS = {
    player = {
        function() return _G.PlayerFrame and _G.PlayerFrame.healthbar, _G.PlayerFrame and _G.PlayerFrame.manabar end,
        function()
            local frame = _G.PersonalResourceDisplayFrame
            if not frame then return end

            local container = frame.HealthBarsContainer or frame.HealthBarContainer
            local health = container and (container.healthBar or container.HealthBar or container)

            return health, frame.PowerBar
        end,
    },
    pet = {
        function() return _G.PetFrame and _G.PetFrame.healthbar, _G.PetFrame and _G.PetFrame.manabar end,
    },
    target = {
        function() return _G.TargetFrame and _G.TargetFrame.healthbar, _G.TargetFrame and _G.TargetFrame.manabar end,
    },
    targettarget = {
        function()
            local frame = _G.TargetFrame and _G.TargetFrame.totFrame
            return frame and frame.healthbar, frame and frame.manabar
        end,
    },
    focus = {
        function() return _G.FocusFrame and _G.FocusFrame.healthbar, _G.FocusFrame and _G.FocusFrame.manabar end,
    },
    focustarget = {
        function()
            local frame = _G.FocusFrame and _G.FocusFrame.totFrame
            return frame and frame.healthbar, frame and frame.manabar
        end,
    },
}

local UnitExists = _G.UnitExists
local UnitPowerType = _G.UnitPowerType
local UnitHealthPercent = _G.UnitHealthPercent
local UnitPowerPercent = _G.UnitPowerPercent

local visibilityCurve

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

-- Health/power values can be "secret" in combat, so they can't be compared in Lua.
-- Instead, a step curve converts the percentage into an alpha (1 = show, 0 = hide)
-- which is then passed straight to SetAlpha.
local function BuildCurve()
    local curve = _G.C_CurveUtil.CreateCurve()
    curve:SetType(_G.Enum.LuaCurveType.Step)
    curve:AddPoint(0, 1)
    curve:AddPoint(CONFIG.THRESHOLD / 100 + 0.0001, 0)
    return curve
end

local function SetBarTextAlpha(bar, alpha)
    if not bar then return end

    for _, key in ipairs(TEXT_KEYS) do
        local text = bar[key]
        if text then text:SetAlpha(alpha) end
    end
end

local function UpdateUnit(unit, resolvers)
    if not UnitExists(unit) then return end

    local healthAlpha = UnitHealthPercent(unit, false, visibilityCurve)
    local powerAlpha  = UnitPowerPercent(unit, (UnitPowerType(unit)), false, visibilityCurve)

    for _, resolve in ipairs(resolvers) do
        local healthBar, powerBar = resolve()
        SetBarTextAlpha(healthBar, healthAlpha)
        SetBarTextAlpha(powerBar, powerAlpha)
    end
end

local function UpdateAll()
    for unit, resolvers in pairs(UNITS) do
        UpdateUnit(unit, resolvers)
    end
end

local function ResetAll()
    for _, resolvers in pairs(UNITS) do
        for _, resolve in ipairs(resolvers) do
            local healthBar, powerBar = resolve()
            SetBarTextAlpha(healthBar, 1)
            SetBarTextAlpha(powerBar, 1)
        end
    end
end

local function OnUnitEvent(_, unit)
    local resolvers = UNITS[unit]
    if resolvers then UpdateUnit(unit, resolvers) end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    visibilityCurve = BuildCurve()

    for _, event in ipairs(EVENTS) do
        if event:find("^UNIT_") and event ~= "UNIT_TARGET" then
            self:RegisterEvent(event, OnUnitEvent)
        else
            self:RegisterEvent(event, UpdateAll)
        end
    end

    UpdateAll()
end

function Module:OnDisable()
    self:UnhookAll()
    self:UnregisterAllEvents()

    ResetAll()
end


-- local _, ns = ...
-- local Module = ns.Addon:NewModule("PLAYERTEXT", "AceEvent-3.0")

-- local HP_THRESHOLD   = 35 -- show health text at or below this %
-- local MANA_THRESHOLD = 25 -- show mana text at or below this %

-- local MANA = Enum.PowerType.Mana
-- local TEXT_REGIONS = { "TextString", "LeftText", "RightText" }

-- -- Step curve: alpha 1 up to the threshold, 0 above it.
-- -- (If the curve x-axis turns out to be 0-1 rather than 0-100, divide by 100.)
-- local function CreateThresholdCurve(threshold)
--     local curve = C_CurveUtil.CreateCurve()
--     curve:SetType(Enum.LuaCurveType.Step)
--     curve:AddPoint(0, 1)
--     curve:AddPoint(threshold + 0.01, 0)
--     return curve
-- end

-- local HealthCurve = CreateThresholdCurve(HP_THRESHOLD)
-- local ManaCurve   = CreateThresholdCurve(MANA_THRESHOLD)

-- local healthBar, manaBar

-- local function SetBarTextAlpha(bar, alpha)
--     for _, key in ipairs(TEXT_REGIONS) do
--         local region = bar[key]
--         if region then region:SetAlpha(alpha) end
--     end
-- end

-- local function UpdateAll()
--     SetBarTextAlpha(healthBar, UnitHealthPercent("player", false, HealthCurve))

--     local alpha = 1
--     if UnitPowerType("player") == MANA then
--         alpha = UnitPowerPercent("player", MANA, false, ManaCurve)
--     end
--     SetBarTextAlpha(manaBar, alpha)
-- end

-- function Module:OnEnable()
--     local main = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
--     healthBar = main.HealthBarsContainer.HealthBar
--     manaBar   = main.ManaBarArea.ManaBar

--     self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateAll)
--     for _, event in ipairs({ "UNIT_HEALTH", "UNIT_MAXHEALTH", "UNIT_POWER_UPDATE",
--                              "UNIT_MAXPOWER", "UNIT_DISPLAYPOWER" }) do
--         self:RegisterEvent(event, "OnUnitEvent")
--     end
--     UpdateAll()
-- end

-- function Module:OnDisable()
--     self:UnregisterAllEvents()
--     SetBarTextAlpha(healthBar, 1)
--     SetBarTextAlpha(manaBar, 1)
-- end

-- function Module:OnUnitEvent(_, unit)
--     if unit == "player" then UpdateAll() end
-- end
