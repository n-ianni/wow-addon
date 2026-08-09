local _, ns = ...
local Module = ns.Addon:NewModule("CHARACTER", "AceEvent-3.0", "AceHook-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local UNIT = "player"
local ITEM_PATTERN = "item:([-%d:]+)"

local IDS = {
    ENCHANT    = 237118,
    GEM        = 7549187,
    MISSING    = 134400,
    NO_ENCHANT = 237133,
    NO_GEM     = 136256,
}
local SLOTS = {
    [_G.INVSLOT_HEAD]     = { frame = _G.CharacterHeadSlot, enchant = true, gems = 1 },
    [_G.INVSLOT_NECK]     = { frame = _G.CharacterNeckSlot, gems = 1 },
    [_G.INVSLOT_SHOULDER] = { frame = _G.CharacterShoulderSlot, enchant = true },
    [_G.INVSLOT_BACK]     = { frame = _G.CharacterBackSlot },
    [_G.INVSLOT_CHEST]    = { frame = _G.CharacterChestSlot, enchant = true },
    [_G.INVSLOT_WRIST]    = { frame = _G.CharacterWristSlot, gems = 1 },
    [_G.INVSLOT_HAND]     = { frame = _G.CharacterHandsSlot },
    [_G.INVSLOT_WAIST]    = { frame = _G.CharacterWaistSlot, gems = 1 },
    [_G.INVSLOT_LEGS]     = { frame = _G.CharacterLegsSlot, enchant = true },
    [_G.INVSLOT_FEET]     = { frame = _G.CharacterFeetSlot, enchant = true },
    [_G.INVSLOT_FINGER1]  = { frame = _G.CharacterFinger0Slot, enchant = true, gems = 1 },
    [_G.INVSLOT_FINGER2]  = { frame = _G.CharacterFinger1Slot, enchant = true, gems = 1 },
    [_G.INVSLOT_TRINKET1] = { frame = _G.CharacterTrinket0Slot },
    [_G.INVSLOT_TRINKET2] = { frame = _G.CharacterTrinket1Slot },
    [_G.INVSLOT_MAINHAND] = { frame = _G.CharacterMainHandSlot, enchant = true },
    [_G.INVSLOT_OFFHAND]  = { frame = _G.CharacterSecondaryHandSlot },
}

local Item = _G.C_Item
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function GetEnhancements(slotInfo, itemLink)
    if not itemLink then return end

    local result = {}

    if slotInfo.enchant then
        local _, enchantID = strsplit(":", itemLink:match(ITEM_PATTERN))
        enchantID = tonumber(enchantID) or 0
        result[#result + 1] = enchantID > 0 and IDS.ENCHANT or IDS.MISSING
    end

    if slotInfo.gems then
        for i = 1, slotInfo.gems do
            -- local _, gemLink = Item.GetItemGem(itemLink, i)
            -- result[#result + 1] = gemLink and IDS.GEM or IDS.MISSING    --Item.GetItemIconByID(gemLink) or IDS.MISSING
            result[#result + 1] = select(2, Item.GetItemGem(itemLink, i))
                and IDS.GEM
                or IDS.MISSING      --Item.GetItemIconByID(gemLink) or IDS.MISSING
        end
    end

    return result
end

local function GetItemLevel(itemLink)
    return itemLink and GetDetailedItemLevelInfo(itemLink)
end

local function UpdateGearInfo()
    if not CharacterFrame:IsShown() then return end

    for slotID, slotInfo in pairs(SLOTS) do
        local link = GetInventoryItemLink(UNIT, slotID)
        local frame = slotInfo.frame

        if frame._ilvl then frame._ilvl:SetContent(GetItemLevel(link)) end
        if frame._enhancements then frame._enhancements:SetTextures(GetEnhancements(slotInfo, link)) end
    end
end

local function UpdateContainers(showContainers)
    for _, slotInfo in pairs(SLOTS) do
        if not slotInfo.frame._ilvl then slotInfo.frame._ilvl = ns.Frames:GetContainer(slotInfo.frame) end
        if not slotInfo.frame._enhancements then slotInfo.frame._enhancements = ns.Frames:GetTextureList(slotInfo.frame) end

        if showContainers then
            slotInfo.frame._ilvl:Show()
            slotInfo.frame._enhancements:Show()
        else
            slotInfo.frame._ilvl:Hide()
            slotInfo.frame._enhancements:Hide()
        end
    end

    if showContainers then UpdateGearInfo() end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable()
    UpdateContainers(true)

    self:SecureHookScript(CharacterFrame, "OnShow", UpdateGearInfo)
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED",  UpdateGearInfo)
end

function Module:OnDisable()
    UpdateContainers(false)

    self:UnhookAll()
    self:UnregisterAllEvents()
end
