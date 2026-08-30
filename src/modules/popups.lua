local _, ns = ...
local Module = ns.Addon:NewModule("POPUPS", "AceHook-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function BypassTimer(popup)
    popup.timeleft = 0
    popup.acceptDelay = 0
    if popup:GetButton1() then popup:GetButton1():Enable() end
end

local function BypassEditBox(popup)
    if popup:GetButton1() then popup:GetButton1():Enable() end
    if popup:GetEditBox() then
        popup:GetEditBox():SetText(Module.L.DELETE_INPUT)
        popup:GetEditBox():Disable()
    end
end

local POPUPS = {
    ["CONFIRM_SELECT_WEEKLY_REWARD"] = BypassTimer,
    ["DELETE_GOOD_ITEM"]             = BypassEditBox,
    ["DELETE_GOOD_QUEST_ITEM"]       = BypassEditBox,
    ["ITEM_INTERACTION_CONFIRMATION_DELAYED"] = BypassTimer,
    ["PERKS_PROGRAM_CONFIRM_OVERRIDE_FROZEN_ITEM"] = BypassTimer,
}

local function OnEvent(popup)
    local handler = POPUPS[popup.which]
    if handler then handler(popup) end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable() self:SecureHook("StaticPopup_OnShow", OnEvent) end
function Module:OnDisable() self:UnhookAll() end
