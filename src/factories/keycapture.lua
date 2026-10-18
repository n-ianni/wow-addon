local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local CANCEL, CLEAR = "ESCAPE", "DELETE"
local MODIFIERS = {
    LSHIFT = true, RSHIFT = true, LCTRL = true, RCTRL = true,
    LALT = true, RALT = true, LMETA = true, RMETA = true,
}

local frame

local function Chord(key)
    return (IsAltKeyDown() and "ALT-" or "")
        .. (IsControlKeyDown() and "CTRL-" or "")
        .. (IsShiftKeyDown() and "SHIFT-" or "")
        .. key
end

local function OnKeyDown(self, key)
    if MODIFIERS[key] then return end

    local callback = self.callback
    self:Hide() -- OnHide clears self.callback

    if not callback or key == CANCEL then return end
    callback(key == CLEAR and "" or Chord(key))
end

local function GetFrame()
    if frame then return frame end

    frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(420, 70)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:EnableKeyboard(true)
    frame:Hide()

    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0, 0, 0, 0.85)

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetPoint("CENTER")
    text:SetText(L["KEY_CAPTURE"])

    frame:SetScript("OnKeyDown", OnKeyDown)
    frame:SetScript("OnHide", function(self) self.callback = nil end)

    return frame
end

function ns.CaptureKey(callback)
    local f = GetFrame()
    f.callback = callback
    f:Show()
end
