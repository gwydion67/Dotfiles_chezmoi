# hyprscreenshot — QuickShell wrapper for hyprshot

A Spectacle-style screenshot GUI for Hyprland, built with QuickShell.
Styled to match Caelestia / Catppuccin Mocha by default.

```
┌─────────────────────────────────┐
│  󰹑  Screenshot   hyprshot wrpr  ✕ │
├─────────────────────────────────┤
│  CAPTURE MODE                   │
│  ┌──────────┐  ┌──────────┐     │
│  │ 󰩬 Region │  │ 󱂬 Window │     │
│  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐     │
│  │ 󰖯 Active │  │ 󰍹 Full   │     │
│  └──────────┘  └──────────┘     │
│  DELAY                          │
│  [ 0 ] [ 1s ] [ 2s ] [ 3s ] … │
│  POST-CAPTURE EDITOR            │
│  ┌──────────┐  ┌──────────┐     │
│  │  Satty   │  │  Swappy  │     │
│  └──────────┘  └──────────┘     │
│  ╔═══════════════════════════╗  │
│  ║      󰹑  Capture Now       ║  │
│  ╚═══════════════════════════╝  │
└─────────────────────────────────┘
```

## Dependencies

```bash
# Required
hyprshot        # screen capture backend
satty           # post-capture editor (default)    — paru -S satty
# or
swappy          # alternative post-capture editor  — paru -S swappy

# QuickShell (if not already installed via Caelestia)
paru -S quickshell-git
```

Nerd Fonts are expected for icons (JetBrainsMono Nerd Font or any Symbols NF).

---

## Install

```bash
mkdir -p ~/.config/quickshell/hyprscreenshot
cp shell.qml ~/.config/quickshell/hyprscreenshot/shell.qml
```

Test it:

```bash
quickshell -p ~/.config/quickshell/hyprscreenshot
```

---

## Hyprland keymaps

Add to your `~/.config/hypr/hyprland.conf` (or the relevant keybinds file
inside your Caelestia dots, usually `~/.config/hypr/keybinds.conf`):

```ini
# Screenshot GUI  (Super + Shift + S  or  PrintScreen)
bind = $mod SHIFT, S,     exec, quickshell -p ~/.config/quickshell/hyprscreenshot
bind =       , Print,     exec, quickshell -p ~/.config/quickshell/hyprscreenshot

# Optional: quick region capture without the GUI  (Super + Shift + P)
bind = $mod SHIFT, P,     exec, hyprshot -m region -o /tmp -f "qs-$(date +%s).png" --freeze && satty --filename /tmp/qs-*.png
```

If you keep your Caelestia keybinds modular (e.g. `extraKeybinds.conf`):

```ini
# in ~/.config/hypr/extraKeybinds.conf
bind = $mod SHIFT, S, exec, quickshell -p ~/.config/quickshell/hyprscreenshot
```

Then in `hyprland.conf`:

```ini
source = ~/.config/hypr/extraKeybinds.conf
```

---

## Adapting colors to your Caelestia/matugen theme

In `shell.qml`, find the `QtObject { id: col … }` block and replace the
hex values with your Caelestia `Colours` singleton references, e.g.:

```qml
// Before (hardcoded)
readonly property color accent: "#cba6f7"

// After (Caelestia Colours singleton — adjust import path to your dots)
import "root:/" as Root          // or wherever your Colours singleton lives
readonly property color accent: Root.Colours.m3.primary
readonly property color base:   Root.Colours.m3.surface
```

If you use matugen directly, map `m3.primary` → accent, `m3.surface` → base,
`m3.onSurface` → text, etc.

---

## Behavior

| Step               | What happens                                               |
| ------------------ | ---------------------------------------------------------- |
| Click **Capture**  | Window hides immediately (or after countdown)              |
| Delay > 0          | A countdown is shown in the window; **Cancel** aborts      |
| hyprshot runs      | Screen freezes for region/window selection                 |
| Capture done       | satty **or** swappy opens for annotation                   |
| **Save in editor** | File is kept; otherwise `/tmp/hyprshot-*.png` is discarded |

> ⚠️ The screenshot is written to `/tmp` and is **not auto-saved**.
> You must hit Save inside satty/swappy to keep it.

---

## Keyboard shortcuts inside the GUI

| Key      | Action                          |
| -------- | ------------------------------- |
| `Escape` | Cancel countdown / close window |
