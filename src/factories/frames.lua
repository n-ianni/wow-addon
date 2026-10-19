local _, ns = ...

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local BADGE_SIZE = 20
local EMPTY = ""

local CreateFrame = _G.CreateFrame

local Frames = {}
Frames.__index = Frames
ns.Frames = Frames

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function GetBackgroundTexture(parent)
    local min = CreateColor(0, 0, 0, 1)
    local max = CreateColor(0, 0, 0, 0)
    local texture = parent:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints()
    texture:SetColorTexture(1, 1, 1, 1)
    texture:SetGradient("VERTICAL", min, max)

    return texture
end

local function GetFontString(parent)
    local fs = parent:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    fs:SetPoint("CENTER")
    fs:SetJustifyH("CENTER")
    fs:SetJustifyV("MIDDLE")

    return fs
end

local function SetText(self, text)
    if not text or text == EMPTY then
        self:Hide()
        return
    end

    self.content:SetText(text)
    self:SetHeight(self.content:GetStringHeight() + 3)
    self:Show()
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Object Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Frames:GetContainer(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT")
    frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
    frame:Hide()

    frame.bg = GetBackgroundTexture(frame)
    frame.content = GetFontString(frame)

    frame.SetContent = SetText

    return frame
end

local function SetCount(self, count)
    if not count or count <= 0 then
        self:Hide()
        return
    end

    self.content:SetText(count)
    self:SetWidth(math.max(BADGE_SIZE, self.content:GetStringWidth() + 8))
    self:Show()
end

function Frames:GetBadge(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(BADGE_SIZE, BADGE_SIZE)
    frame:Hide()

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(0, 0, 0, 0.75)

    frame.content = GetFontString(frame)
    frame.SetCount = SetCount

    return frame
end

function Frames:GetTextureList(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("LEFT", parent, "RIGHT", 2, 0)
    frame:SetPoint("TOP", parent)
    frame:SetPoint("BOTTOM", parent)
    frame:Hide()

    frame.textures = {}

    local function GetTexture(index)
        local tex = frame.textures[index]
        if tex then return tex end

        tex = frame:CreateTexture(nil, "OVERLAY")

        if index == 1 then
            tex:SetPoint("LEFT", frame, "LEFT", 10, 0)
        else
            tex:SetPoint("LEFT", frame.textures[index - 1], "RIGHT", 2, 0)
        end

        tex:SetPoint("CENTER", frame, "CENTER", 0, 0)

        frame.textures[index] = tex

        return tex
    end

    function frame:SetTextures(ids)
        if not ids or #ids == 0 then
            self:Hide()
            return
        end

        local iconSize = self:GetHeight() * 0.7
        local count = 0

        for _, id in ipairs(ids) do
            if id then
                count = count + 1

                local tex = GetTexture(count)
                tex:SetSize(iconSize, iconSize)
                tex:SetTexture(id)
                tex:Show()
            end
        end

        local spacing = 2
        local padding = 10

        local width = padding * 2

        if count > 0 then
            width = width + count * iconSize + (count - 1) * spacing
        end

        self:SetWidth(width)
        self:Show()
    end

    return frame
end
