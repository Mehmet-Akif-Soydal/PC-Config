-- Video ve odak bazlı işlemler için tam ekran uygulamalarda uykuyu engelle
hl.window_rule({
    match = { class = ".*" },
    idle_inhibit = "fullscreen"
})

-- Sadece aktif pencerelerde (odaklı) uyku engelleyici opsiyonel kural
hl.window_rule({
    match = { class = "^(zen-alpha|firefox|chromium|mpv|vlc|Google-chrome)$" },
    idle_inhibit = "focus"
})
