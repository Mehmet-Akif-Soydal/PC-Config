# Hyprland Laptop Configuration (Fedora / Nobara KDE)

Bu depo, **Fedora / Nobara 44 (KDE Plasma Edition)** kurulu bir laptop için optimize edilmiş **Hyprland** masaüstü yapılandırmasını içerir.

---

## 💻 Donanım ve Sistem Mimarisi

* **İşletim Sistemi:** Nobara Linux 44 / Fedora (KDE Plasma Desktop Edition)
* **Pencere Yöneticisi:** Hyprland 0.56+ (Aquamarine arka uçlu, modüler Lua yapılandırması)
* **Ekran:** Dahili 1920x1080 @ 144Hz panel (`eDP-1`)
* **Çift Ekran Kartı (Hibrit/Optimus):**
  * **Birincil (Kompozitör ve Masaüstü):** AMD Cezanne Radeon Graphics (Yüksek pil tasarrufu, ~2W)
  * **İkincil (Oyun ve Ağır İş Yükü):** NVIDIA GeForce RTX 3050 Ti Mobile (`prime-run` ile çağrılır)
* **Dokunmatik Yüzey:** Elan Touchpad (Tap-to-click, Tap-and-drag, avuç içi koruması, clickfinger etkin)
* **Klavye:** Türkçe Q klavye (`tr`, `alt_shift_toggle`)
* **Ses Altyapısı:** PipeWire + WirePlumber + EasyEffects (RNNoise + DeepFilterNet yapay zeka gürültü engelleme)

---

## 🚀 Format Sonrası Otomatik Kurulum ve Geri Yükleme

Sıfır bir kurulumdan sonra sistemi tek bir komutla ayağa kaldırmak için:

```bash
# 1. Depoyu klonlayın
git clone https://github.com/Mehmet-Akif-Soydal/PC-Config.git ~/.config/hypr

# 2. Kurulum betiğini çalıştırın
cd ~/.config/hypr
./setup/install.sh
```

### `install.sh` Neler Yapar?
1. Tüm Hyprland, ses, video ve yardımcı sistem paketlerini (`dnf`) otomatik kurar.
2. `prime-run` NVIDIA offload betiğini oluşturup `~/.local/bin/prime-run` yoluna yerleştirir.
3. PipeWire mikrofonunun Discord veya tarayıcılar tarafından %100'e çekilmesini engelleyen kuralı uygular.
4. Varsayılan dosya yöneticisini Dolphin (`org.kde.dolphin.desktop`) olarak ayarlar.
5. KDE BreezeDark renk şemasını uygular.
6. `tailscaled` ve `plasma-polkit-agent` servislerini otomatik başlatıp etkinleştirir.

---

## 🛠️ Yapılan Özel Optimizasyonlar

1. **KDE Polkit Ajanı Entegrasyonu:**
   * GNOME bağımlılığı kaldırılarak sistemdeki yerel `/usr/libexec/kf6/polkit-kde-authentication-agent-1` servisi (`plasma-polkit-agent.service`) autostart'a bağlandı.
2. **KDE Dolphin Koyu Tema (Breeze Dark):**
   * `QT_QPA_PLATFORMTHEME = "kde"` olarak ayarlandı, `kdeglobals` bozuk stillerden temizlenerek native BreezeDark'a bağlandı.
3. **Pil ve Hibrit Kart Yönetimi:**
   * `AQ_DRM_DEVICES` değişkeni persistent `by-path` yollarıyla AMD'yi birincil, NVIDIA'yı ikincil olarak tanımladı. Masaüstünde NVIDIA'nın gereksiz güç çekmesi önlendi.
   * Oyunlar veya 3D uygulamalar için: `prime-run <uygulama>`
4. **Laptop Kapağı (Lid Switch):**
   * Kapak kapatıldığında ekran anında `hyprlock` ile kilitlenir; açıldığında dahili ekran uyandırılır (`dpms enable`).
5. **EasyEffects & KDE Connect:**
   * EasyEffects arka planda penceresiz servis modunda (`easyeffects --service-mode`), KDE Connect ise sistem tepsisi göstergesiyle (`kdeconnect-indicator`) her açılışta otomatik çalışır.
