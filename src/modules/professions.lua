local _, ns = ...
local Module = ns.Addon:NewModule("PROFESSIONS", "AceEvent-3.0", "AceHook-3.0")

local HOST = {
    addon  = "Blizzard_ProfessionsBook",
    frame  = "ProfessionsBookFrame",
    anchor = "PrimaryProfession%dSpellButtonBottomNameFrame",
}

local badges = {}

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function GetUnspentKnowledge(professionIndex)
    if not professionIndex then return 0 end

    local skillLine = select(7, GetProfessionInfo(professionIndex))
    local info = skillLine and C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLine)

    return info and info.numAvailable or 0
end

local function GetBadge(slot)
    local host   = _G[HOST.frame]
    local target = _G[HOST.anchor:format(slot)]
    if not (host and target) then return end

    local badge = ns.Frames:GetBadge(host)
    badge:SetPoint("RIGHT", target, "BOTTOMRIGHT", -2.5, 12.5)
    badges[slot] = badge

    return badge
end

local function Update(slot, professionIndex)
    local count = GetUnspentKnowledge(professionIndex)
    local badge = badges[slot] or (count > 0 and GetBadge(slot))

    if badge then badge:SetCount(count) end
end

local function Refresh()
    local first, second = GetProfessions()

    Update(1, first)
    Update(2, second)
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    self:RegisterEvent("TRAIT_TREE_CURRENCY_INFO_UPDATED", Refresh)
    self:RegisterEvent("SKILL_LINES_CHANGED", Refresh)

    EventUtil.ContinueOnAddOnLoaded(HOST.addon, function()
        local host = _G[HOST.frame]

        if self:IsEnabled() and host and not self:IsHooked(host, "OnShow") then
            self:SecureHookScript(host, "OnShow", Refresh)
        end
    end)

    Refresh()
end

function Module:OnDisable()
    self:UnhookAll()
    self:UnregisterAllEvents()

    for _, badge in pairs(badges) do badge:Hide() end
end
