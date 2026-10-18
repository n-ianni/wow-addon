local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local SettingsPanel = {}
ns.SettingsPanel = SettingsPanel

local categoryID

local function SortedModules(addon)
    local list = {}
    for _, module in addon:IterateModules() do list[#list + 1] = module end
    table.sort(list, function(a, b) return a:GetName() < b:GetName() end)
    return list
end

function SettingsPanel.Build(addon)
    local root, rootLayout = Settings.RegisterVerticalLayoutCategory(addonName)
    local pages = { [L["C_GENERAL"]] = { category = root, layout = rootLayout } }

    local function GetPage(name)
        local page = pages[name]
        if not page then
            local category, layout = Settings.RegisterVerticalLayoutSubcategory(root, name)
            page = { category = category, layout = layout }
            pages[name] = page
        end
        return page
    end

    for _, module in ipairs(SortedModules(addon)) do
        local name = module:GetName()
        local options = ns.Options:New(module, GetPage(L["C_" .. name]), L["N_" .. name], L["D_" .. name])

        if module.InjectOptions then module:InjectOptions(options) end
    end

    Settings.RegisterAddOnCategory(root)
    categoryID = root:GetID()
end

_G[addonName .. "_OnCompartmentClick"] = function()
    Settings.OpenToCategory(categoryID)
end
