#!/usr/bin/env bash
# ==============================================================================
# Hyprland & Laptop Desktop Environment Automated Setup / Restore Script
# Target OS: Fedora / Nobara Linux (KDE Plasma & Hyprland)
# ==============================================================================

set -eo pipefail

# Colors for terminal output
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

info()    { echo -e "${BLUE}${BOLD}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[UYARI]${NC} $1"; }
error()   { echo -e "${RED}${BOLD}[HATA]${NC} $1"; exit 1; }

# Prevent running script directly as root
if [ "$EUID" -eq 0 ]; then
    error "Bu betiği root (sudo) olarak çalıştırmayın. Gerektiğinde sudo şifresi istenecektir."
fi

echo -e "${BLUE}${BOLD}"
echo "=========================================================="
echo "   Hyprland Laptop Kurulum ve Geri Yükleme Sihirbazı     "
echo "=========================================================="
echo -e "${NC}"

# 1. Dağıtım Kontrolü
info "İşletim sistemi kontrol ediliyor..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "fedora" && "$ID" != "nobara" && "$ID_LIKE" != *"fedora"* ]]; then
        warn "Bu betik Fedora/Nobara sistemler için optimize edilmiştir. Algılanan: $NAME"
        read -p "Devam etmek istiyor musunuz? [e/H]: " confirm
        [[ "$confirm" =~ ^[eEyY]$ ]] || exit 1
    else
        success "Uyumlu işletim sistemi algılandı: $PRETTY_NAME"
    fi
else
    error "/etc/os-release dosyası bulunamadı."
fi

# 2. Gerekli Paketlerin Yüklenmesi
info "Gerekli paketler DNF ile kuruluyor..."

PACKAGES=(
    # Hyprland Ekosistemi
    hyprland
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    hyprsunset

    # Ses ve Donanım Araçları
    pipewire
    wireplumber
    pipewire-pulseaudio
    easyeffects
    brightnessctl
    playerctl

    # Ağ ve Servisler
    tailscale
    kdeconnect

    # KDE & Polkit Entegrasyonu
    kf6-polkit-kde-authentication-agent-1
    dolphin
    breeze-icon-theme

    # Arayüz ve Masaüstü Yardımcıları
    swaync
    rofi-wayland
    waybar
    wl-clipboard
    cliphist
    slurp
    grim
    jq
)

# Sudo yetkisi al
sudo -v

# Paketleri kur
sudo dnf install -y "${PACKAGES[@]}"
success "Tüm sistem paketleri başarıyla kuruldu."

# 3. Dizin Yapısının Hazırlanması
info "Kullanıcı dizinleri hazırlanıyor..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/pipewire/pipewire-pulse.conf.d"
mkdir -p "$HOME/.config/autostart"
mkdir -p "$HOME/Pictures"

# 4. prime-run (NVIDIA Offload Betiği)
info "NVIDIA Prime-Run betiği oluşturuluyor..."
cat << 'EOF' > "$HOME/.local/bin/prime-run"
#!/usr/bin/env bash
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json
exec "$@"
EOF
chmod +x "$HOME/.local/bin/prime-run"
success "prime-run (~/.local/bin/prime-run) kuruldu ve çalıştırılabilir yapıldı."

# 5. PipeWire Mikrofon Kuralı (%100 fırlamasını önleme)
info "PipeWire mikrofon kuralı yazılıyor..."
cat << 'EOF' > "$HOME/.config/pipewire/pipewire-pulse.conf.d/50-no-source-volume.conf"
# Prevent applications from altering the global microphone / source volume
pulse.rules = [
    {
        matches = [
            { application.process.binary = "Discord" }
            { application.process.binary = "discord" }
            { application.process.binary = "steam" }
            { application.process.binary = "Steam" }
            { application.name = "~.*webrtc.*" }
            { application.name = "~.*Chromium.*" }
            { application.name = "~.*Zen.*" }
            { application.name = "~.*firefox.*" }
        ]
        actions = {
            quirks = [ no-source-volume ]
        }
    }
]
EOF
success "PipeWire mikrofon kuralı yapılandırıldı."

# 6. MIME Ayarı (Dolphin'i Varsayılan Klasör Yöneticisi Yapma)
info "Varsayılan dosya yöneticisi Dolphin olarak ayarlanıyor..."
if command -v xdg-mime >/dev/null 2>&1; then
    xdg-mime default org.kde.dolphin.desktop inode/directory || true
fi
if command -v gio >/dev/null 2>&1; then
    gio mime inode/directory org.kde.dolphin.desktop || true
fi
success "Dolphin varsayılan dosya yöneticisi olarak ayarlandı."

# 7. KDE BreezeDark ve Renk Ayarları
info "KDE ve Qt için BreezeDark şeması uygulanıyor..."
if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme BreezeDark || true
fi
if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kdeglobals --group General --key ColorScheme "BreezeDark" || true
    kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle "Breeze" || true
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "breeze-dark" || true
fi
success "KDE teması BreezeDark olarak ayarlandı."

# 8. Sistem ve Kullanıcı Servislerinin Etkinleştirilmesi
info "Sistemd ve kullanıcı servisleri aktifleştiriliyor..."

# Tailscale servisi
sudo systemctl enable --now tailscaled || warn "Tailscaled servisi başlatılamadı."

# KDE Polkit servisi
systemctl --user enable plasma-polkit-agent || true
systemctl --user start plasma-polkit-agent || true

# PipeWire Pulse servisini kural için yenile
systemctl --user restart pipewire-pulse || true

success "Tüm servisler başarıyla etkinleştirildi."

echo -e "\n${GREEN}${BOLD}=========================================================="
echo "          KURULUM BAŞARIYLA TAMAMLANDI!          "
echo "==========================================================${NC}"
echo -e "Tüm paketler kuruldu, donanım optimizasyonları ve servisler hazır."
echo -e "Artık Hyprland oturumunuzu başlatabilir veya oturumu kapatıp açabilirsiniz."
