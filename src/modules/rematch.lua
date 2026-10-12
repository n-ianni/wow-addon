local _, ns = ...
local Module = ns.Addon:NewModule("REMATCH")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

-- Patch 12.1 removed the MouseIsOver global used by Rematch and BtWQuests.
-- Its 12.0.7 implementation was found on 'Blizzard_UIParent/Shared/UIParent.lua:530'.
local function MouseIsOverShim(region, topOffset, bottomOffset, leftOffset, rightOffset)
    return region:IsMouseOver(topOffset, bottomOffset, leftOffset, rightOffset)
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    if not _G.MouseIsOver then _G.MouseIsOver = MouseIsOverShim end
end

function Module:OnDisable()
    if _G.MouseIsOver == MouseIsOverShim then _G.MouseIsOver = nil end
end
