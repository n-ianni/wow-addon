local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "esES")

if not L then return end

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module/Settings Names
-- ─────────────────────────────────────────────────────────────────────────────────

L["N_ARTIFACTS"]  = "Artefacto: Underlight Angler"
L["N_BANKERS"]    = "Depósito en el banco de banda de guerra"
L["N_CHARACTER"]  = "Información de personaje mejorada"
L["N_CINEMATICS"] = "Omitir cinemáticas"
L["N_CONTAINERS"] = "Ordenar bolsas"
L["N_ENABLED"]    = "Activar"
L["N_FISHING"]    = "Pesca fácil"
L["N_INDICATORS"] = "Indicadores de marco"
L["N_MERCHANTS"]  = "Interacción con mercaderes"
L["N_POPUPS"]     = "Omitir ventanas emergentes"
L["N_REMATCH"]    = "Addon externo: error de cierre de Rematch"
L["N_TRACKERS"]   = "Dejar de seguir logros"

L["N_KEY_DEPOSIT"] = "Límite de oro"
L["N_KEY_FISHING"] = "Tecla de interacción de pesca"
L["N_KEY_REPAIR_GUILD"]    = "Reparar equipo (hermandad)"
L["N_KEY_REPAIR_PERSONAL"] = "Reparar equipo"
L["N_KEY_SELL"]    = "Vender basura"

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module/Settings Descriptions
-- ─────────────────────────────────────────────────────────────────────────────────

L["D_ARTIFACTS"]  = "Corrige que la interfaz del artefacto Underlight Angler no muestre las ventajas.\n\nRestricción de Legion:\nRequiere tener desbloqueado un artefacto de clase (distinto del Underlight Angler) para funcionar.\nLas clases sin artefactos no pueden acceder al árbol del Angler."
L["D_BANKERS"]    = "Deposita el exceso de oro en la cuenta del banco de banda de guerra."
L["D_CHARACTER"]  = "Muestra el nivel de objeto, los encantamientos y las gemas en el panel de información del personaje."
L["D_CINEMATICS"] = "Omite la ventana de confirmación para saltar cinemáticas."
L["D_CONTAINERS"] = "Invierte el orden de clasificación de las bolsas del jugador."
L["D_ENABLED"]    = "Activar módulo"
L["D_FISHING"]    = "Lanza el sedal y recoge la captura con una sola tecla."
L["D_INDICATORS"] = "Elimina los indicadores de daño y sanación de los marcos del jugador y de la mascota."
L["D_MERCHANTS"]  = "Activa las opciones de reparación automática y de venta automática de basura al interactuar con un mercader."
L["D_POPUPS"]     = "Omite los mecanismos de confirmación de las ventanas emergentes que piden escribir un texto o muestran una cuenta atrás."
L["D_REMATCH"]    = "Corrige que el addon 'Rematch' se cierre de forma inesperada al abrir el marco de mascotas. Error introducido en el parche 12.1."
L["D_TRACKERS"]   = "Corrige que los logros se queden atascados como seguidos cuando los completa un personaje distinto."

L["D_KEY_DEPOSIT"] = "La cantidad máxima de oro que se conserva por personaje."
L["D_KEY_FISHING"] = "Tecla para lanzar la caña de pescar y/o recoger los objetos pescados."
L["D_KEY_REPAIR_GUILD"]    = "Intenta usar los fondos de la hermandad al reparar automáticamente el equipo."
L["D_KEY_REPAIR_PERSONAL"] = "Intenta usar fondos personales al reparar automáticamente el equipo."
L["D_KEY_SELL"]    = "Vende automáticamente todos los objetos basura."

-- ─────────────────────────────────────────────────────────────────────────────────
--  Module Categories (Settings menu)
-- ─────────────────────────────────────────────────────────────────────────────────

L["C_ARTIFACTS"]  = "Corrección de errores"
L["C_BANKERS"]    = "General"
L["C_CHARACTER"]  = "General"
L["C_CINEMATICS"] = "General"
L["C_CONTAINERS"] = "General"
L["C_FISHING"]    = "General"
L["C_GENERAL"]    = "General"
L["C_INDICATORS"] = "General"
L["C_MERCHANTS"]  = "General"
L["C_POPUPS"]     = "General"
L["C_REMATCH"]    = "Corrección de errores"
L["C_TRACKERS"]   = "General"

-- ─────────────────────────────────────────────────────────────────────────────────
--  String Resources
-- ─────────────────────────────────────────────────────────────────────────────────

L["CUTSCENE_SKIPPED"] = "Cinemática omitida"
L["DELETE_INPUT"]     = "BORRAR"
L["KEY_CAPTURE"]      = "Pulsa una tecla (ESC para cancelar, SUPR para borrar)"
L["KEY_UNBOUND"]      = "Sin asignar"
L["UNTRACK"]          = "Seguimiento cancelado"
L["WB_DEPOSIT"]       = "Depósito bancario:"
L["WB_ERROR"]         = "El banco de banda de guerra tiene problemas técnicos.\nSe ha omitido la interacción con el banco para evitar cualquier incidencia."
