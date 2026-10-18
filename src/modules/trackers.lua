local _, ns = ...
local Module = ns.Addon:NewModule("TRACKERS", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local MSG = "%s: (%d) %s"
local ACHIEVEMENT = _G.Enum.ContentTrackingType.Achievement
local COLLECTED = _G.Enum.ContentTrackingStopType.Collected

local ContentTracking = _G.C_ContentTracking
local GetAchievementInfo = _G.GetAchievementInfo
local GetAchievementLink = _G.GetAchievementLink

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable() self:RegisterEvent("PLAYER_ENTERING_WORLD") end
function Module:OnDisable() self:UnregisterAllEvents() end

function Module:PLAYER_ENTERING_WORLD(_, isInitialLogin)
    if not isInitialLogin then return end

    for _, id in ipairs(ContentTracking.GetTrackedIDs(ACHIEVEMENT)) do
        local completed = select(4, GetAchievementInfo(id))

        if completed then
            ContentTracking.StopTracking(ACHIEVEMENT, id, COLLECTED)
            self.Log:Info(MSG:format(self.L.UNTRACK, id, GetAchievementLink(id)))
        end
    end
end
