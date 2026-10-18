local _, ns = ...
local Module = ns.Addon:NewModule("MERCHANTS", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local INTERACTION_TYPE = _G.Enum.PlayerInteractionType.Merchant

local IsInGuild = _G.IsInGuild
local RepairAllItems = _G.RepairAllItems
local SellAllJunkItems = _G.C_MerchantFrame.SellAllJunkItems
local CanGuildBankRepair = _G.CanGuildBankRepair

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable() self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW") end
function Module:OnDisable() self:UnregisterAllEvents() end

function Module:InjectOptions(options)
    options:AddToggle("sell")
    options:AddToggle("repairGuild")
    options:AddToggle("repairPersonal")
end

function Module:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(_, type)
    if type ~= INTERACTION_TYPE then return end

    if self.db.sell then SellAllJunkItems() end
    if self.db.repairGuild and CanGuildBankRepair() then RepairAllItems(true) end
    if self.db.repairPersonal then RepairAllItems(false) end
end
