# 🚀 PC-Config: Hyprland & Laptop Workstation Dotfiles

<div align="center">

![Hyprland](https://img.shields.io/badge/Hyprland-0.56+-00b4d8?style=for-the-badge&logo=arch-linux&logoColor=white)
![Nobara](https://img.shields.io/badge/Nobara_Linux-44_(Fedora)-c77dff?style=for-the-badge&logo=fedora&logoColor=white)
![KDE](https://img.shields.io/badge/KDE_Plasma-Breeze_Dark-1d99f3?style=for-the-badge&logo=kde&logoColor=white)
![Lua](https://img.shields.io/badge/Config-Modular_Lua-2c2d30?style=for-the-badge&logo=lua&logoColor=2c2d30)
![Wayland](https://img.shields.io/badge/Display-Wayland-e63946?style=for-the-badge&logo=wayland&logoColor=white)

<p align="center">
  <b>Fedora / Nobara 44 (KDE Plasma Edition)</b> tabanlı, hibrit grafikli oyuncu/iş laptopları için optimize edilmiş, modüler Lua yapılandırmalı <b>Hyprland</b> masaüstü ortamı.
</p>

</div>

---

## 📑 İçindekiler
- [Donanım & Sistem Mimarisi](#-donanım--sistem-mimarisi)
- [Öne Çıkan Özellikler](#-öne-çıkan-özellikler)
- [Masaüstü & Yazılım Mimarisi](#-masaüstü--yazılım-mimarisi)
- [Kurulum & Geri Yükleme (Format Sonrası)](#-kurulum--geri-yükleme-format-sonrası)
- [Önemli Kısayollar](#-önemli-kısayollar)
- [Dizin Yapısı](#-dizin-yapısı)

---

## 💻 Donanım & Sistem Mimarisi

Bu yapılandırma, taşınabilirlik, yüksek pil ömrü ve gerektiğinde maksimum GPU gücü sağlayacak şekilde optimize edilmiştir:

| Donanım / Özellik | Açıklama / Yapılandırma |
| :--- | :--- |
| **İşletim Sistemi** | Nobara Linux 44 (Fedora 44 tabanlı, KDE Plasma masaüstü paketi) |
| **Dahili Panel** | 1920x1080 @ 144Hz IPS (`eDP-1`) |
| **Birincil GPU (Masaüstü)** | AMD Cezanne Radeon iGPU (Pil dostu kompozitör yönetimi, ~2W) |
| **İkincil GPU (Yüksek Performans)** | NVIDIA GeForce RTX 3050 Ti Mobile (`prime-run` ile talep üzerine çalıştırma) |
| **Touchpad** | Elan Touchpad (Tap-to-click, Tap-and-drag, avuç içi koruması, clickfinger) |
| **Klavye** | Türkçe Q (`tr`), Alt+Shift toggle, öntanımlı açık Numlock |
| **Ses & Mikrofon** | PipeWire + EasyEffects (RNNoise + DeepFilterNet yapay zeka gürültü engelleme) |

---

## ✨ Öne Çıkan Özellikler

- **Modüler Lua Yapısı:** Klasik monolitik `.conf` dosyaları yerine, Hyprland'in modern Lua API'si ile modüler parçalara (`conf/*.lua`) ayrılmış dinamik mimari.
- **Akıllı Uyku Engelleme (Idle Inhibit):** Tam ekran video izlerken veya aktif medya pencerelerinde (Zen, MPV, VLC vb.) ekranın otomatik kararmasını engelleyen özel pencere kuralları.
- **Kapak (Lid) Yönetimi:** Laptop kapağı kapatıldığında anında `hyprlock` devreye girer; açıldığında dahili ekran kesintisiz uyanır (`dpms enable`).
- **Mikrofon Ses Koruma Kuralı:** Discord, Steam veya tarayıcıların mikrofon sesini otomatik olarak %100'e çekip patlatmasını engelleyen PipeWire kuralı (`50-no-source-volume.conf`).
- **Yerel KDE Breeze Dark Uyumu:** `QT_QPA_PLATFORMTHEME = "kde"` ve yapılandırılmış `kdeglobals` ile Dolphin ve tüm Qt uygulamalarında kesintisiz koyu tema.
- **Dahili NVIDIA Offload (`prime-run`):** NVIDIA kartını yalnızca ihtiyaç duyulan oyun veya ağır uygulamalarda tetikleyen hafif wrapper.

---

## 🖥️ Masaüstü & Yazılım Mimarisi

* **Kompozitör:** Hyprland 0.56+ (Aquamarine)
* **Üst Bar:** Quickshell / Waybar
* **Dosya Yöneticisi:** KDE Dolphin (`org.kde.dolphin.desktop`)
* **Uygulama Menüsü:** Rofi / Quickshell App Launcher
* **Kilit Ekranı:** Hyprlock
* **Boşta Bekleme Servisi:** Hypridle
* **Bildirim Yöneticisi:** SwayNC
* **Polkit Yetkilendirme:** KDE Polkit Ajanı (`plasma-polkit-agent`)
* **Pano (Clipboard):** Cliphist + wl-paste
* **İmleç Teması:** Bibata-Modern-Ice (24px)

---

## ⚡ Kurulum & Geri Yükleme (Format Sonrası)

Sistemi yeni bir kuruluma tek bir komutla geri yüklemek için `setup/install.sh` betiği mevcuttur:

```bash
# 1. Depoyu Hyprland yapılandırma dizinine klonlayın
git clone https://github.com/Mehmet-Akif-Soydal/PC-Config.git ~/.config/hypr

# 2. Kurulum klasörüne girip çalıştırma izni verin ve çalıştırın
cd ~/.config/hypr
chmod +x setup/install.sh
./setup/install.sh
```

### `install.sh` Otomatik Olarak Neler Yapar?
1. Tüm Hyprland, ses, video ve yardımcı sistem paketlerini (`dnf`) yükler.
2. `prime-run` betiğini oluşturup `~/.local/bin/prime-run` altına yerleştirir.
3. PipeWire mikrofon ses koruma kuralını uygular.
4. Dolphin'i varsayılan dosya yöneticisi olarak sisteme ve portallara kaydeder.
5. KDE Breeze Dark renk temasını ve Qt ayarlarını bağlar.
6. `tailscaled` ve `plasma-polkit-agent` servislerini etkinleştirip başlatır.

---

## ⌨️ Önemli Kısayollar

| Kısayol | İşlev |
| :--- | :--- |
| `SUPER + RETURN` | Terminali Aç |
| `SUPER + B` | Tarayıcıyı Aç |
| `SUPER + E` | Dolphin Dosya Yöneticisini Aç |
| `SUPER + C` | Hesap Makinesini Aç |
| `SUPER + CTRL + C` | Takvimi Aç / Kapat |
| `SUPER + CTRL + RETURN` | Uygulama Menüsünü Aç (Launcher) |
| `SUPER + V` | Pano Geçmişini Aç (Cliphist) |
| `SUPER + CTRL + L` | Ekranı Kilitle (Hyprlock) |
| `SUPER + PRINT` | Bölgesel Ekran Görüntüsü Al |
| `SUPER + ALT + F` | Tam Ekran Görüntüsü Al |
| `SUPER + SHIFT + W` | Rastgele Duvar Kağıdı Değiştir |
| `SUPER + CTRL + W` | Duvar Kağıdı Seçici Menüsü |
| `SUPER + CTRL + R` | Hyprland Yapılandırmasını Yenile (Reload) |
| `SUPER + ALT + G` | Oyun Modunu Aç / Kapat (Animasyonları Kapatır) |
| `SUPER + S` | Özel Çalışma Alanı (Scratchpad) |

---

## 📂 Dizin Yapısı

```
~/.config/hypr/
├── conf/                     # Modüler Lua ayar dosyaları
│   ├── autostart.lua         # Oturum başlangıç servisleri
│   ├── environment.lua       # Ortam değişkenleri (Qt, Wayland, XDG)
│   ├── keybinding.lua        # Kısayol yöneticisi
│   ├── keybindings/          # Kısayol tanımları (default.lua)
│   ├── windowrules/          # Pencere kuralları ve idle_inhibit ayarları
│   └── ...                   # Animasyon, dekorasyon, monitör profilleri
├── setup/                    # Format sonrası geri yükleme ve yardımcı araçlar
│   ├── install.sh            # Tek tıkla tam sistem kurulum betiği
│   ├── prime-run             # NVIDIA offload çalıştırıcı
│   ├── 50-no-source-volume.conf # PipeWire mikrofon koruma kuralı
│   ├── kdeglobals            # Breeze Dark renk şeması
│   └── mimeapps.list         # Varsayılan uygulama eşleştirmeleri
├── hypridle.conf             # Boşta bekleme ve güç yönetimi kuralları
├── hyprland.lua              # Ana giriş noktası (Core loader)
├── hyprlock.conf             # Kilit ekranı tasarımı
├── input.lua                 # Klavye ve touchpad ince ayarları
└── monitors.lua              # Panel çözünürlük ve yenileme hızı ayarları
```

---

<div align="center">
  <sub>Kişisel donanım optimizasyonları ve günlük masaüstü kullanım için geliştirilmiştir.</sub>
</div>
