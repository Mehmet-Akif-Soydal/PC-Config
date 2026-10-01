-- Quickshell resolves app icons through Qt's icon theme, which does not follow
-- the GTK setting on its own — QS_ICON_THEME is what it reads. Take the name
-- from the GTK settings so the dock and the other shells use the selected icon
-- theme. Read once at compositor start; a theme switch applies on next login.
local gtk_settings = os.getenv("HOME") .. "/.config/gtk-3.0/settings.ini"
local settings = io.open(gtk_settings, "r")
if settings then
    for line in settings:lines() do
        local theme = line:match("^%s*gtk%-icon%-theme%-name%s*=%s*(.-)%s*$")
        if theme and theme ~= "" then
            hl.env("QS_ICON_THEME", theme)
            break
        end
    end
    settings:close()
end

-- Qt uygulamalarının GTK ikon ve renk temasını baz alması için köprü
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Hybrid GPU (AMD Cezanne iGPU primary, NVIDIA RTX 3050 Ti secondary)
hl.env("AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:05:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card")

local name = "default.lua"
load_variant(name,"environments")
