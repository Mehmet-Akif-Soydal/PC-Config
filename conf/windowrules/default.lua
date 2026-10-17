-- Video ve odak bazlı işlemler için tam ekran uygulamalarda uykuyu engelle
hl.window_rule({
    match = { class = ".*" },
    idle_inhibit = "fullscreen"
})

-- Zen Browser açık olduğu sürece (toplantı, ders, video vb.) ekranın kapanmasını engelle
hl.window_rule({
    match = { class = ".*zen.*" },
    idle_inhibit = "always"
})

-- Diğer tarayıcılar ve medya oynatıcılar için odak kuralı
hl.window_rule({
    match = { class = "^(firefox|chromium|mpv|vlc|Google-chrome)$" },
    idle_inhibit = "focus"
})
