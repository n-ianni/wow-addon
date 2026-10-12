local _, ns = ...
local Module = ns.Addon:NewModule("REMATCH")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

-- Tracks whether *we* installed the shim, so we never remove a native MouseIsOver (e.g. if Blizzard restores it in a later patch).
local installedShim = false

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

-- Patch 12.1 removed the MouseIsOver global. 12.0.7 implementation: Blizzard_UIParent/Shared/UIParent.lua:530
local function MouseIsOverShim(region, topOffset, bottomOffset, leftOffset, rightOffset)
    return region:IsMouseOver(topOffset, bottomOffset, leftOffset, rightOffset)
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    if not MouseIsOver then
        MouseIsOver = MouseIsOverShim
        installedShim = true
    end
end

function Module:OnDisable()
    if installedShim and MouseIsOver == MouseIsOverShim then
        MouseIsOver = nil
    end
    installedShim = false
end
