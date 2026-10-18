local _, ns = ...
local Module = ns.Addon:NewModule("BANKERS", "AceEvent-3.0")

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Variables
-- ─────────────────────────────────────────────────────────────────────────────────

local BANK_TYPE = _G.Enum.BankType.Account

local Bank = _G.C_Bank
local Break = _G.BreakUpLargeNumbers
local GetMoney = _G.GetMoney
local GetMoneyString = _G.GetMoneyString

-- ─────────────────────────────────────────────────────────────────────────────────
--  Local Functions
-- ─────────────────────────────────────────────────────────────────────────────────

local function DepositFunds(threshold)
    if not Bank.CanDepositMoney(BANK_TYPE) then
        Module.Log:Error(Module.L.WB_ERROR)
        return
    end
    
    local money = GetMoney()
    local limit = tonumber(threshold) * 10000 -- Gold to copper conversion
    local deposit = abs(money - limit)

    if money > limit then
        Bank.DepositMoney(BANK_TYPE, deposit)
        Module.Log:Info(Module.L.WB_DEPOSIT, GetMoneyString(deposit, true))
    end
end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Functions
-- ─────────────────────────────────────────────────────────────────────────────────

function Module:OnEnable() self:RegisterEvent("BANKFRAME_OPENED") end
function Module:OnDisable() self:UnregisterAllEvents() end

function Module:InjectOptions(options)
    options:AddSlider("depositLimit", {
        min = 0, max = 500000, step = 500,
        default = 2500,
        format = function(value) return Break(value) .. "g" end,
    })
end

function Module:BANKFRAME_OPENED()
    DepositFunds(self.db.depositLimit)
end
