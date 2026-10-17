local addonName, ns = ...

function ns.Addon:CreateSettings()
    self._category = Settings.RegisterVerticalLayoutCategory(addonName)
    self._subcategories = {}
end

function ns.Addon:RegisterModuleOptions(module)
    local name = module._category
    local sub = self._subcategories[name]

    if not sub then
        local category, layout = Settings.RegisterVerticalLayoutSubcategory(self._category, name)
        sub = { category = category, layout = layout }
        self._subcategories[name] = sub
    end

    module.Options:Build(sub.category, sub.layout)
end

function ns.Addon:FinalizeSettings()
    Settings.RegisterAddOnCategory(self._category)
end

_G[addonName .. "_OnCompartmentClick"] = function()
    Settings.OpenToCategory(ns.Addon._category:GetID())
end
