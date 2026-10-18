local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function ns.Addon:CreateSettings()
    local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)

    self._category = category
    self._root = { category = category, layout = layout }
    self._subcategories = {}
end

local function GetPage(self, name)
    if name == L["C_GENERAL"] then return self._root end

    local page = self._subcategories[name]
    if not page then
        local category, layout = Settings.RegisterVerticalLayoutSubcategory(self._category, name)
        page = { category = category, layout = layout }
        self._subcategories[name] = page
    end

    return page
end

function ns.Addon:RegisterModuleOptions(module)
    local page = GetPage(self, module._category)
    module.Options:Build(page.category, page.layout)
end

function ns.Addon:FinalizeSettings()
    Settings.RegisterAddOnCategory(self._category)
end

_G[addonName .. "_OnCompartmentClick"] = function()
    Settings.OpenToCategory(ns.Addon._category:GetID())
end
