local _, ns = ...
local Module = ns.Addon:NewModule("PLAYERTEXT", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Constants
-- ─────────────────────────────────────────────────────────────────────────────────

local HP_THRESHOLD   = 80 -- Show health text at or below this percentage
local MANA_THRESHOLD = 80 -- Show mana text at or below this percentage
local CURVE_SCALE    = 100 -- Curve x-axis: 100 if it expects 0-1 fractions, 1 if it expects 0-100

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local UnitPowerType = _G.UnitPowerType
local UnitHealthPercent = _G.UnitHealthPercent
local UnitPowerPercent = _G.UnitPowerPercent
local MANA = _G.Enum.PowerType.Mana

local TEXT_REGIONS = { "TextString", "LeftText", "RightText" }

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function CreateThresholdCurve(threshold)
    local curve = _G.C_CurveUtil.CreateCurve()
    curve:SetType(_G.Enum.LuaCurveType.Step)
    curve:AddPoint(0, 1)
    curve:AddPoint((threshold + 0.01) / CURVE_SCALE, 0)
    return curve
end

local HealthCurve = CreateThresholdCurve(HP_THRESHOLD)
local ManaCurve = CreateThresholdCurve(MANA_THRESHOLD)

local function GetMain()
    local frame = _G.PlayerFrame
    local content = frame and frame.PlayerFrameContent
    return content and content.PlayerFrameContentMain
end

local function GetHealthBar()
    local main = GetMain()
    local container = main and main.HealthBarsContainer
    return (container and container.HealthBar) or _G.PlayerFrameHealthBar
end

local function GetManaBar()
    local main = GetMain()
    local area = main and main.ManaBarArea
    return (area and area.ManaBar) or _G.PlayerFrameManaBar
end

local function SetBarTextAlpha(bar, alpha)
    if not bar then return end
    for _, key in ipairs(TEXT_REGIONS) do
        local region = bar[key]
        if region then region:SetAlpha(alpha) end
    end
end

local function UpdateHealth()
    SetBarTextAlpha(GetHealthBar(), UnitHealthPercent("player", false, HealthCurve))
end

local function UpdateMana()
    local bar = GetManaBar()
    if UnitPowerType("player") ~= MANA then
        SetBarTextAlpha(bar, 1)
        return
    end
    SetBarTextAlpha(bar, UnitPowerPercent("player", MANA, false, ManaCurve))
end

local function UpdateAll()
    UpdateHealth()
    UpdateMana()
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnInitialize()
    -- Blizzard refreshes the status text through this; reapply afterwards
    -- in case it touches alpha. Guarded so the module is safe if it's missing.
    if _G.TextStatusBar_UpdateTextString then
        _G.hooksecurefunc("TextStatusBar_UpdateTextString", function(bar)
            if not self:IsEnabled() then return end
            if bar == GetHealthBar() then UpdateHealth()
            elseif bar == GetManaBar() then UpdateMana() end
        end)
    end

    _G.SLASH_PLAYERTEXTDEBUG1 = "/ptdebug"
    _G.SlashCmdList.PLAYERTEXTDEBUG = function()
        local h, m = GetHealthBar(), GetManaBar()
        print("health bar:", h, "mana bar:", m)
        for _, key in ipairs(TEXT_REGIONS) do
            print(key, "health:", h and h[key], "mana:", m and m[key])
        end
    end
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateAll)
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MAXHEALTH", "UNIT_HEALTH")
    self:RegisterEvent("UNIT_POWER_UPDATE")
    self:RegisterEvent("UNIT_MAXPOWER", "UNIT_POWER_UPDATE")
    self:RegisterEvent("UNIT_DISPLAYPOWER", "UNIT_POWER_UPDATE")
    UpdateAll()
end

function Module:OnDisable()
    self:UnregisterAllEvents()
    SetBarTextAlpha(GetHealthBar(), 1)
    SetBarTextAlpha(GetManaBar(), 1)
end

function Module:UNIT_HEALTH(_, unit)
    if unit == "player" then UpdateHealth() end
end

function Module:UNIT_POWER_UPDATE(_, unit)
    if unit == "player" then UpdateMana() end
end