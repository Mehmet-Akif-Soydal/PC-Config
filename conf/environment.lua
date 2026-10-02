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

-- Değişkenler bir tablo formatında tanımlanır:
local env_variables = {
    -- XDG & Session
    { "XDG_CURRENT_DESKTOP", "Hyprland" },
    { "XDG_SESSION_DESKTOP", "Hyprland" },
    { "XDG_SESSION_TYPE", "wayland" },
    { "DESKTOP_SESSION", "Hyprland" },

    -- Qt & KDE (Breeze Dark ve yerel KDE platform desteği)
    { "QT_QPA_PLATFORM", "wayland;xcb" },
    { "QT_QPA_PLATFORMTHEME", "kde" },
    { "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" },

    -- Wayland & Ozone
    { "OZONE_PLATFORM", "wayland" },
    { "ELECTRON_OZONE_PLATFORM_HINT", "wayland" },
    { "MOZ_ENABLE_WAYLAND", "1" },
    { "SDL_VIDEODRIVER", "wayland" },
    { "CLUTTER_BACKEND", "wayland" },
    { "GDK_BACKEND", "wayland,x11,*" },
    { "GDK_SCALE", "1" },

    -- Cursor
    { "XCURSOR_THEME", "Bibata-Modern-Ice" },
    { "XCURSOR_SIZE", "24" },
    { "HYPRCURSOR_SIZE", "24" },

    -- Quickshell
    { "QS_NO_RELOAD_POPUP", "1" },

    -- Hybrid GPU: Aquamarine udev üzerinden AMD iGPU (boot_vga=1) ve NVIDIA dGPU'yu
    -- otomatik olarak doğru sırada tanır. by-path içindeki ':' karakterleri Aquamarine'in
    -- ayraç ayrıştırmasını bozup çökmeye yol açtığı için elle AQ_DRM_DEVICES tanımlanmaz.
    -- { "AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:05:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card" },
}

-- Değişkenleri Hyprland ortamına uygula
for _, entry in ipairs(env_variables) do
    hl.env(entry[1], entry[2])
end

local name = "default.lua"
load_variant(name,"environments")
