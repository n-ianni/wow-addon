local addonName, ns = ...

local DB_NAME = addonName .. "_DB"

ns.Addon.defaults = {
    profile = {
        modules = {
            ["*"] = {
                enabled = false,
            },
        },
    },
}

function ns.Addon:CreateDatabase()
    self.db = LibStub("AceDB-3.0"):New(
        DB_NAME:upper(),
        self.defaults,
        true
    )
end
