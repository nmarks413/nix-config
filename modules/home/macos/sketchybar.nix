{
  pkgs,
  lib,
  config,
  host,
  ...
}:
let
  # folder = "${config.home.homeDirectory}.dotfiles/files/sketchybar";
  # folder = "~/.dotfiles/files/sketchybar";
  folder = ../../../files/sketchybar;
in
lib.mkIf (host.darwin) {
  home.file =
    lib.attrsets.mapAttrs
      (
        file: value: (lib.attrsets.overrideExisting value { enable = config.shared.darwin.tiling.enable; })
      )
      {
        sketchybarrc = {
          executable = true;
          target = ".config/sketchybar/sketchybarrc";
          text = ''
            #!/usr/bin/env sh

            source "$HOME/.config/sketchybar/colors.sh" # Loads all defined colors
            source "$HOME/.config/sketchybar/icons.sh" # Loads all defined icons

            ITEM_DIR="$HOME/.config/sketchybar/items" # Directory where the items are configured
            PLUGIN_DIR="$HOME/.config/sketchybar/plugins" # Directory where all the plugin scripts are stored

            FONT="SF Pro" # Needs to have Regular, Bold, Semibold, Heavy and Black variants
            PADDINGS=3 # All paddings use this value (icon, label, background)

            # Setting up and starting the helper process
            HELPER=git.felix.helper
            killall helper
            cd $HOME/.config/sketchybar/helper && make
            $HOME/.config/sketchybar/helper/helper $HELPER > /dev/null 2>&1 &

            # Unload the macOS on screen indicator overlay for volume change
            # launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist > /dev/null 2>&1 &

            # Setting up the general bar appearance and default values
            ${pkgs.sketchybar}/bin/sketchybar --bar     height=40                                         \
                                                        color=$BAR_COLOR                                  \
                                                        shadow=off                                        \
                                                        position=top                                      \
                                                        sticky=on                                         \
                                                        padding_right=0                                   \
                                                        padding_left=0                                    \
                                                        corner_radius=12                                  \
                                                        y_offset=0                                        \
                                                        margin=2                                          \
                                                        blur_radius=0                                     \
                                                        notch_width=0                                     \
                                              --default updates=when_shown                                \
                                                        icon.font="$FONT:Bold:14.0"                       \
                                                        icon.color=$ICON_COLOR                            \
                                                        icon.padding_left=$PADDINGS                       \
                                                        icon.padding_right=$PADDINGS                      \
                                                        label.font="$FONT:Semibold:13.0"                  \
                                                        label.color=$LABEL_COLOR                          \
                                                        label.padding_left=$PADDINGS                      \
                                                        label.padding_right=$PADDINGS                     \
                                                        background.padding_right=$PADDINGS                \
                                                        background.padding_left=$PADDINGS                 \
                                                        background.height=26                              \
                                                        background.corner_radius=9                        \
                                                        popup.background.border_width=2                   \
                                                        popup.background.corner_radius=11                 \
                                                        popup.background.border_color=$POPUP_BORDER_COLOR \
                                                        popup.background.color=$POPUP_BACKGROUND_COLOR    \
                                                        popup.background.shadow.drawing=on

            # Left
            source "$ITEM_DIR/apple.sh"
            source "$ITEM_DIR/spaces.sh"
            source "$ITEM_DIR/front_app.sh"

            # Center
            # source "$ITEM_DIR/spotify.sh"
            source "$ITEM_DIR/calendar.sh"

            # Right
            # source "$ITEM_DIR/brew.sh"
            # source "$ITEM_DIR/github.sh"
            source "$ITEM_DIR/volume.sh"
            # source "$ITEM_DIR/divider.sh"
            # source "$ITEM_DIR/cpu.sh"

            # Forcing all item scripts to run (never do this outside of sketchybarrc)
            ${pkgs.sketchybar}/bin/sketchybar --update

            echo "sketchybar configuation loaded.."
          '';
        };
        icons = {
          executable = true;
          target = ".config/sketchybar/icons.sh";
          source = folder + /icons.sh;
        };
        colors = {
          executable = true;
          target = ".config/sketchybar/colors.sh";
          text = ''
            #!/usr/bin/env sh
            # Color Palette
            export BLACK=0xff4c4f69
            export WHITE=0xffeff1f5
            export RED=0xffd20f39
            export GREEN=0xff40a02b
            export BLUE=0xff1e66f5
            export YELLOW=0xffdf8e1d
            export ORANGE=0xfffe640b
            export MAGENTA=0xffea76cb
            export GREY=0xff9ca0b0
            export TRANSPARENT=0xff000000
            export BLUE2=0xff7287fd
            export FLAMINGO=0xffdd7878

            # General bar colors
            export BAR_COLOR=0xeff1f5ff # Color of the bar
            export ICON_COLOR=0xff4c4f69
            export LABEL_COLOR=0xff4c4f69 # Color of all labels
            export BACKGROUND_1=0xffbcc0cc
            export BACKGROUND_2=0xffbcc0cc

            export POPUP_BACKGROUND_COLOR=$BLACK
            export POPUP_BORDER_COLOR=$WHITE

            export SHADOW_COLOR=$BLACK
          '';
        };
        items_apple = {
          executable = true;
          target = ".config/sketchybar/items/apple.sh";
          source = folder + /items/executable_apple.sh;
        };
        items_brew = {
          executable = true;
          target = ".config/sketchybar/items/brew.sh";
          source = folder + /items/executable_brew.sh;
        };
        items_calendar = {
          executable = true;
          target = ".config/sketchybar/items/calendar.sh";
          text = ''
            #!/usr/bin/env sh

            sketchybar --add item     calendar center                   \
                       --set calendar icon=cal                          \
                                      display=1                         \
                                      icon.font="$FONT:Black:12.0"      \
                                      icon.padding_right=0              \
                                      label.width=50                    \
                                      label.align=right                 \
                                      background.padding_left=15        \
                                      update_freq=30                    \
                                      script="$PLUGIN_DIR/calendar.sh"  \
                                      click_script="$PLUGIN_DIR/zen.sh"
          '';
        };
        items_cpu = {
          executable = true;
          target = ".config/sketchybar/items/cpu.sh";
          source = folder + /items/executable_cpu.sh;
        };
        items_divider = {
          executable = true;
          target = ".config/sketchybar/items/divider.sh";
          source = folder + /items/executable_divider.sh;
        };
        items_front_app = {
          executable = true;
          target = ".config/sketchybar/items/front_app.sh";
          text = ''
            #!/usr/bin/env sh
            FRONT_APP_SCRIPT='sketchybar --set $NAME label="$INFO"'
            sketchybar --add       event            window_focus                  \
                       --add       event            windows_on_spaces             \
                       --add       item             system.aerospace left         \
                       --set       system.aerospace script="$PLUGIN_DIR/aerospace.sh" \
                                                    icon.font="$FONT:Bold:16.0"   \
                                                    label.drawing=off             \
                                                    icon.width=30                 \
                                                    icon=$YABAI_GRID              \
                                                    icon.color=$BLACK             \
                                                    updates=on                    \
                                                    display=active                \
                       --subscribe system.aerospace window_focus                  \
                                                    windows_on_spaces             \
                                                    mouse.clicked                 \
                       --add       item             front_app left                \
                       --set       front_app        script="$FRONT_APP_SCRIPT"    \
                                                    icon.drawing=off              \
                                                    background.padding_left=0     \
                                                    background.padding_right=10   \
                                                    label.color=$BLACK            \
                                                    label.font="$FONT:Black:12.0" \
                                                    display=active                \
                       --subscribe front_app        front_app_switched
          '';
        };
        items_github = {
          executable = true;
          target = ".config/sketchybar/items/github.sh";
          source = folder + /items/executable_github.sh;
        };
        items_spaces = {
          executable = true;
          target = ".config/sketchybar/items/spaces.sh";
          # label.background.color=$BACKGROUND_2
          text = ''
            ${pkgs.sketchybar}/bin/sketchybar --add event aerospace_workspace_change
            ${pkgs.sketchybar}/bin/sketchybar --add event aerospace_mode_change
            for sid in $(${pkgs.aerospace}/bin/aerospace list-workspaces --all); do
              ${pkgs.sketchybar}/bin/sketchybar --add item space.$sid left                          \
                                                --subscribe space.$sid aerospace_workspace_change   \
                                                --subscribe space.$sid aerospace_mode_change        \
                                                --set space.$sid                                    \
                                                  icon=$sid                                         \
                                                  icon.padding_left=22                              \
                                                  icon.padding_right=22                             \
                                                  icon.highlight_color=$WHITE                       \
                                                  icon.highlight=off                                \
                                                  icon.color=0xff4c566a                             \
                                                  background.padding_left=-8                        \
                                                  background.padding_right=-8                       \
                                                  background.color=$BACKGROUND_1                    \
                                                  background.drawing=on                             \
                                                  script="$PLUGIN_DIR/aerospace.sh $sid"            \
                                                  click_script="aerospace workspace $sid"           \
                                                  label.font="Iosevka Nerd Font:Regular:16.0" \
                                                  label.padding_right=33                            \
                                                  label.background.height=26                        \
                                                  label.background.drawing=on                       \
                                                  label.background.corner_radius=9                  \
                                                  label.drawing=off
            done
            ${pkgs.sketchybar}/bin/sketchybar --add item      separator left                                   \
                                              --set separator icon=                                           \
                                                              icon.font="Iosevka Nerd Font:Regular:16.0" \
                                                              background.padding_left=26                       \
                                                              background.padding_right=15                      \
                                                              label.drawing=off                                \
                                                              display=active                                   \
                                                              icon.color=$GREEN
          '';
        };
        items_spotify = {
          executable = true;
          target = ".config/sketchybar/items/spotify.sh";
          source = folder + /items/executable_spotify.sh;
        };
        items_volume = {
          executable = true;
          target = ".config/sketchybar/items/volume.sh";
          text = ''
            INITIAL_WIDTH=$(osascript -e 'set ovol to output volume of (get volume settings)')
            ${pkgs.sketchybar}/bin/sketchybar --add item volume right                     \
                                              --subscribe volume volume_change            \
                                              --set volume script="$PLUGIN_DIR/volume.sh" \
                                                updates=on                                \
                                                icon.background.drawing=on                \
                                                icon.background.color=$FLAMINGO           \
                                                icon.background.height=8                  \
                                                icon.background.corner_radius=3           \
                                                icon.width=$INITIAL_WIDTH                 \
                                                width=100                                 \
                                                icon.align=right                          \
                                                label.drawing=off                         \
                                                background.drawing=on                     \
                                                background.color=$BACKGROUND_2            \
                                                background.height=8                       \
                                                background.corner_radius=3                \
                                                align=left

            ${pkgs.sketchybar}/bin/sketchybar --add alias "Control Center,Sound" right     \
                                              --rename "Control Center,Sound" volume_alias \
                                              --set volume_alias icon.drawing=off          \
                                                label.drawing=off                          \
                                                alias.color=$BLUE2                         \
                                                background.padding_right=0                 \
                                                background.padding_left=5                  \
                                                width=50                                   \
                                                align=right                                \
                                                click_script="$PLUGIN_DIR/volume_click.sh"

          '';
        };
        plugins_brew = {
          executable = true;
          target = ".config/sketchybar/plugins/brew.sh";
          source = folder + /plugins/executable_brew.sh;
        };
        plugins_calendar = {
          executable = true;
          target = ".config/sketchybar/plugins/calendar.sh";
          source = folder + /plugins/executable_calendar.sh;
        };
        plugins_github = {
          executable = true;
          target = ".config/sketchybar/plugins/github.sh";
          source = folder + /plugins/executable_github.sh;
        };
        plugins_icon_map = {
          executable = true;
          target = ".config/sketchybar/plugins/icon_map.sh";
          source = folder + /plugins/executable_icon_map.sh;
        };
        plugins_space = {
          executable = true;
          target = ".config/sketchybar/plugins/space.sh";
          source = folder + /plugins/executable_space.sh;
        };
        plugins_spotify = {
          executable = true;
          target = ".config/sketchybar/plugins/spotify.sh";
          source = folder + /plugins/executable_spotify.sh;
        };
        plugins_volume = {
          executable = true;
          target = ".config/sketchybar/plugins/volume.sh";
          text = ''
            #!/usr/bin/env sh
            WIDTH=100

            volume_change() {
              # INITIAL_WIDTH=$(${pkgs.sketchybar}/bin/sketchybar --query $NAME | ${pkgs.jq}/bin/jq ".icon.width")
              # if [ "$INITIAL_WIDTH" -eq "0" ]; then
              #   ${pkgs.sketchybar}/bin/sketchybar --animate tanh 30 --set $NAME width=$WIDTH icon.width=$INFO
              # else
              #   ${pkgs.sketchybar}/bin/sketchybar --set $NAME icon.width=$INFO width=$WIDTH
              # fi
              ${pkgs.sketchybar}/bin/sketchybar --set $NAME icon.width=$INFO


              # sleep 5
              # FINAL_WIDTH=$(${pkgs.sketchybar}/bin/sketchybar --query $NAME | ${pkgs.jq}/bin/jq ".icon.width")
              # if [ "$FINAL_WIDTH" -eq "$INFO" ]; then
              #   ${pkgs.sketchybar}/bin/sketchybar --animate tanh 30 --set $NAME width=0 icon.width=0
              # fi
            }

            case "$SENDER" in
              "volume_change") volume_change
              ;;
            esac
          '';
        };
        plugins_volume_click = {
          executable = true;
          target = ".config/sketchybar/plugins/volume_click.sh";
          text = ''
            #!/usr/bin/env sh
            MUTED=$(osascript -e 'output muted of (get volume settings)')
            if [ "$MUTED" = "false" ]; then
              osascript -e 'set volume output muted true'
            else
              osascript -e 'set volume output muted false'
            fi
          '';
        };
        plugins_zen = {
          executable = true;
          target = ".config/sketchybar/plugins/zen.sh";
          source = folder + /plugins/executable_zen.sh;
        };
        plugins_aerospace = {
          executable = true;
          target = ".config/sketchybar/plugins/aerospace.sh";
          text = ''
            #!/usr/bin/env bash
            source "$HOME/.config/sketchybar/colors.sh" # Loads all defined colors

            highlight_focused_workspace() {
              if [[ "$1" = "$FOCUSED_WORKSPACE" ]]
              then
                ${pkgs.sketchybar}/bin/sketchybar --animate tanh 20 --set $NAME icon.highlight=on label.width=0
              else
                ${pkgs.sketchybar}/bin/sketchybar --animate tanh 20 --set $NAME icon.highlight=off label.width=dynamic
              fi
            }

            illuminate_mode() {
              if [[ "$mode" = "service" ]]
              then
                ${pkgs.sketchybar}/bin/sketchybar --animate tanh 20 --set $NAME background.color=$ORANGE
              elif [[ "$mode" = "resize" ]]
              then
                ${pkgs.sketchybar}/bin/sketchybar --animate tanh 20 --set $NAME background.color=$GREEN
              else
                ${pkgs.sketchybar}/bin/sketchybar --animate tanh 20 --set $NAME background.color=$BACKGROUND_1
              fi
            }
            case "$SENDER" in
              "aerospace_workspace_change")
                highlight_focused_workspace $1
                ;;
              "aerospace_mode_change")
                illuminate_mode
                ;;
            esac
          '';
        };
      };
}
