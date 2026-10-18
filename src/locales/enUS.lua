local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module/Settings Names
-- ─────────────────────────────────────────────────────────────────────────────────

L["N_ARTIFACTS"]  = "Artifact: Underlight's Angler"
L["N_BANKERS"]    = "Warband bank deposit"
L["N_CHARACTER"]  = "Improved character info"
L["N_CINEMATICS"] = "Cinematic skip"
L["N_CONTAINERS"] = "Sort bags"
L["N_ENABLED"]    = "Enable"
L["N_FISHING"]    = "Easy fishing"
L["N_INDICATORS"] = "Frame indicators"
L["N_MERCHANTS"]  = "Merchant interaction"
L["N_POPUPS"]     = "Bypass popups"
L["N_REMATCH"]    = "External Addon: Rematch crashing bug"
L["N_TRACKERS"]   = "Untrack achievements"
L["N_UNITTEXT"]   = "Unit frame text values"

L["N_KEY_DEPOSIT"] = "Gold limit"
L["N_KEY_FISHING"] = "Fishing interaction key"
L["N_KEY_REPAIR_GUILD"]    = "Repair gear (guild)"
L["N_KEY_REPAIR_PERSONAL"] = "Repair gear"
L["N_KEY_SELL"]    = "Sell junk"

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module/Settings Descriptions
-- ─────────────────────────────────────────────────────────────────────────────────

L["D_ARTIFACTS"]  = "Fix the Underlight Angler's artifact UI not displaying perks.\n\nLegion restriction:\nRequires a class artifact (other than the Underlight's Angler) to be unlocked to work.\nClasses with no artifacts can't access the Angler's tree."
L["D_BANKERS"]    = "Deposit any excess of gold on the warband bank account."
L["D_CHARACTER"]  = "Display item levels, enchants, and gems on the character info panel."
L["D_CINEMATICS"] = "Bypass the confirmation popup to skip cinematics."
L["D_CONTAINERS"] = "Invert the player's bag sorting order."
L["D_ENABLED"]    = "Enable module"
L["D_FISHING"]    = "Cast and reel in with a single keybind."
L["D_INDICATORS"] = "Remove damage and healing indicators from the player and pet frames."
L["D_MERCHANTS"]  = "Enable auto repair and auto sell junk options when interacting with a merchant."
L["D_POPUPS"]     = "Bypass confirmation mechanisms for popups with text confirmation or countdown timers."
L["D_REMATCH"]    = "Fix 'Rematch' addon crashing when the pet frame is opened. Bug introduced in patch 12.1."
L["D_TRACKERS"]   = "Fix achievements getting stuck in the tracked state when completed by different characters."
L["D_UNITTEXT"]   = "Hide HP/Mana text values until a percentage threshold is reached."

L["D_KEY_DEPOSIT"] = "The maximum amount of gold to keep per character."
L["D_KEY_FISHING"] = "Keybind for casting the fishing rod and/or loot fished items."
L["D_KEY_REPAIR_GUILD"]    = "Attempt to use guild funds when repairing gear items automatically."
L["D_KEY_REPAIR_PERSONAL"] = "Attempt to use personal funds when repairing gear items automatically."
L["D_KEY_SELL"]    = "Sell all junk items automatically."

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Categories (Settings menu)
-- ─────────────────────────────────────────────────────────────────────────────────

L["C_ARTIFACTS"]  = "Issue fix"
L["C_BANKERS"]    = "General"
L["C_CHARACTER"]  = "General"
L["C_CINEMATICS"] = "General"
L["C_CONTAINERS"] = "General"
L["C_FISHING"]    = "General"
L["C_GENERAL"]    = "General"
L["C_INDICATORS"] = "General"
L["C_MERCHANTS"]  = "General"
L["C_POPUPS"]     = "General"
L["C_REMATCH"]    = "Issue fix"
L["C_TRACKERS"]   = "Issue fix"
L["C_UNITTEXT"]   = "General"

-- ─────────────────────────────────────────────────────────────────────────────────
--  String Resources
-- ─────────────────────────────────────────────────────────────────────────────────

L["CUTSCENE_SKIPPED"] = "Cutscene skipped"
L["DELETE_INPUT"]     = "DELETE"
L["KEY_CAPTURE"]      = "Press a key (ESC to cancel, DEL to clear)"
L["KEY_UNBOUND"]      = "Not bound"
L["UNTRACK"]          = "Untracked"
L["WB_DEPOSIT"]       = "Bank deposit:"
L["WB_ERROR"]         = "The warband bank is experiencing technical difficulties.\nBank interaction's been omitted to prevent any issues."
