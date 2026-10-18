local _, ns = ...
local Module = ns.Addon:NewModule("CINEMATICS", "AceHook-3.0")

local SKIP_CONDITIONS = {
    ["JUMP"] = true,
    ["TOGGLEGAMEMENU"] = true,
}

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    self:SecureHookScript(MovieFrame, "OnKeyDown", "SkipCinematic")
    self:SecureHookScript(CinematicFrame, "OnKeyDown", "SkipCinematic")
end

function Module:OnDisable() self:UnhookAll() end

function Module:SkipCinematic(frame, key)
    if not key or not SKIP_CONDITIONS[GetBindingAction(key)] then return end

    if frame == MovieFrame then MovieFrame:StopMovie() end
    if frame == CinematicFrame then CinematicFrame_CancelCinematic() end

    self.Log:Info(self.L.CUTSCENE_SKIPPED)
end
