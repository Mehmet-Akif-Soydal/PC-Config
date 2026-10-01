-- -----------------------------------------------------
-- Input
-- -----------------------------------------------------

hl.config({
    input = {
        kb_layout    = "tr",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "grp:alt_shift_toggle",
        kb_rules     = "",

        numlock_by_default = true,
        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll          = true,
            ["tap-to-click"]        = true,
            ["tap-and-drag"]        = true,
            disable_while_typing    = true,
            clickfinger_behavior    = true,
            middle_button_emulation = true,
        },
    },
})
