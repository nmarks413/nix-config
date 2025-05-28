{
  pkgs,
  lib,
  config,
  host,
  ...
}: {
  home.file =
    {}
    // lib.optionalAttrs host.darwin (
      lib.attrsets.mapAttrs (file: value: (
        lib.attrsets.overrideExisting value {enable = config.shared.darwin.tiling.enable;}
      )) {
        sketchybarrc = {
          executable = true;
          target = ".config/sketchybar/sketchybarrc";
          text = ''
            #!/usr/bin/env sh

            source "$HOME/.config/sketchybar/colors.sh" # Loads all defined colors

            ITEM_DIR="$HOME/.config/sketchybar/items" # Directory where the items are configured
            PLUGIN_DIR="$HOME/.config/sketchybar/plugins" # Directory where all the plugin scripts are stored

            FONT="SF Pro" # Needs to have Regular, Bold, Semibold, Heavy and Black variants
            PADDINGS=3 # All paddings use this value (icon, label, background)


            # Setting up the general bar appearance and default values
            ${pkgs.sketchybar}/bin/sketchybar --bar     height=40                                         \
                                                        blur_radius=30 \
                                                        position=top \
                                                        sticky=on \
                                                        padding_left=10 \
                                                        padding_right=10


            ${pkgs.sketchybar}/bin/sketchybar --default icon.font="SF Pro:Semibold:12.0" \
                                                                icon.color=$ITEM_COLOR \
                                                                label.font="SF Pro:Semibold:12.0" \
                                                                label.color=$ITEM_COLOR \
                                                                background.color=$ACCENT_COLOR \
                                                                background.corner_radius=10 \
                                                                background.height=20 \
                                                                padding_left=4 \
                                                                padding_right=4 \
                                                                icon.padding_left=6 \
                                                                icon.padding_right=3 \
                                                                label.padding_left=3 \
                                                                label.padding_right=6


            # Left
            # source "$ITEM_DIR/apple.sh"
            source "$ITEM_DIR/spaces.sh"
            source "$ITEM_DIR/front_app.sh"

            # Center
            # source "$ITEM_DIR/spotify.sh"
            source "$ITEM_DIR/calendar.sh"

            # Right
            source $ITEM_DIR/calendar.sh
            source $ITEM_DIR/wifi.sh
            source $ITEM_DIR/battery.sh
            source $ITEM_DIR/volume.sh

            # Forcing all item scripts to run (never do this outside of sketchybarrc)
            ${pkgs.sketchybar}/bin/sketchybar --update

            echo "sketchybar configuation loaded.."
          '';
        };
        icons = {
          executable = true;
          target = ".config/sketchybar/plugins/icons.sh";
          text = ''
            #!/usr/bin/env sh

            # Source the icon map with all the application icons
            source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

            # Create a cache directory if it doesn't exist
            CACHE_DIR="$HOME/.cache/sketchybar"
            mkdir -p "$CACHE_DIR"

            # Cache file for icon mappings
            ICON_CACHE="$CACHE_DIR/icon_cache.txt"

            # Create the cache file if it doesn't exist
            if [ ! -f "$ICON_CACHE" ]; then
              touch "$ICON_CACHE"
            fi

            # Check if the app is already in cache
            APP_NAME=$(if [ "$1" = "Zen" ]; then echo "Zen Browser"; else echo "$1"; fi)

            CACHED_ICON=$(grep "^$APP_NAME|" "$ICON_CACHE" | cut -d '|' -f2)

            if [ -n "$CACHED_ICON" ]; then
              # Cache hit, return the icon
              echo "$CACHED_ICON"
              exit 0
            fi

            # Get icon from the mapping function
            __icon_map "$APP_NAME"

            if [ -n "$icon_result" ]; then
              echo "$APP_NAME|$icon_result" >>"$ICON_CACHE"
            fi

            echo "$icon_result"
          '';
        };
        colors = {
          executable = true;
          target = ".config/sketchybar/colors.sh";
          text = ''

            export TRANSPARENT=0x00ffffff

            # -- Gray Scheme --
            export ITEM_COLOR=0xff000000
            export ACCENT_COLOR=0xffc3c6cb

            # -- White Scheme --
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xffffffff

            # -- Teal Scheme --
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xff2cf9ed

            # -- Purple Scheme --
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xffeb46f9

            # -- Red Scheme ---
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xffff2453

            # -- Blue Scheme ---
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xff15bdf9

            # -- Green Scheme --
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xff1dfca1

            # -- Orange Scheme --
            # export ITEM_COLOR=0xffffffff
            # export ACCENT_COLOR=0xfff97716

            # -- Yellow Scheme --
            # export ITEM_COLOR=0xff000000
            # export ACCENT_COLOR=0xfff7fc17
          '';
        };
        items_wifi = {
          executable = true;
          target = ".config/sketchybar/items/wifi.sh";
          text = ''
            #!/usr/bin/env/ sh

            sketchybar --add item wifi right \
              --set wifi \
              icon="􀙥" \
              label="Updating..." \
              script="$PLUGIN_DIR/wifi.sh" \
              --subscribe wifi wifi_change
          '';
        };
        items_battery = {
          executable = true;
          target = ".config/sketchybar/items/battery.sh";
          text = ''
            #!/usr/bin/env/ sh
            sketchybar --add item battery right \
                --set battery update_freq=180 \
                script="$PLUGIN_DIR/battery.sh" \
                --subscribe battery system_woke power_source_change
          '';
        };
        items_calendar = {
          executable = true;
          target = ".config/sketchybar/items/calendar.sh";
          text = ''
            #!/usr/bin/env sh
            sketchybar --add item calendar right \
              --set calendar icon=􀧞 \
              update_freq=15 \
              script="$PLUGIN_DIR/calendar.sh"
          '';
        };
        items_front_app = {
          executable = true;
          target = ".config/sketchybar/items/front_app.sh";
          text = ''
            #!/usr/bin/env sh

            sketchybar --add item front_app left \
                --set front_app background.color=$ACCENT_COLOR \
                icon.color=$ITEM_COLOR \
                label.color=$ITEM_COLOR \
                icon.font="sketchybar-app-font:Regular:12.0" \
                label.font="SF Pro:Semibold:12.0" \
                script="$PLUGIN_DIR/front_app.sh" \
                --subscribe front_app front_app_switched
          '';
        };
        items_spaces = {
          executable = true;
          target = ".config/sketchybar/items/spaces.sh";
          text = ''
            sketchybar --add event aerospace_workspace_change

            sketchybar --add item aerospace_dummy left \
              --set aerospace_dummy display=0 \
              script="$PLUGIN_DIR/spaces.sh" \
              --subscribe aerospace_dummy aerospace_workspace_change

            for m in $(aerospace list-monitors | awk '{print $1}'); do
              for sid in $(aerospace list-workspaces --monitor $m); do
                sketchybar --add space space.$sid left \
                  --set space.$sid space=$sid \
                  icon=$sid \
                  background.color=$TRANSPARENT \
                  label.color=$ACCENT_COLOR \
                  icon.color=$ACCENT_COLOR \
                  display=$m \
                  label.font="sketchybar-app-font:Regular:12.0" \
                  icon.font="SF Pro:Semibold:12.0" \
                  label.padding_right=10 \
                  label.y_offset=-1 \
                  click_script="$PLUGIN_DIR/space_click.sh $sid"

                apps=$(aerospace list-windows --monitor "$m" --workspace "$sid" |
                  awk -F '|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}')

                icon_strip=""
                if [ "''${apps}" != "" ]; then
                  while read -r app; do
                    icon_strip+=" $($PLUGIN_DIR/icons.sh "$app")"
                  done <<<"''${apps}"
                else
                  icon_strip=" —"
                fi

                sketchybar --set space.$sid label="$icon_strip"

              done

              for empty_space in $(aerospace list-workspaces --monitor $m --empty); do
                sketchybar --set space.$empty_space display=0
              done
              for focus in $(aerospace list-workspaces --focused); do
                sketchybar --set space.$focus background.drawing=on \
                  background.color=$ACCENT_COLOR \
                  label.color=$ITEM_COLOR \
                  icon.color=$ITEM_COLOR
              done
            done
          '';
        };

        items_volume = {
          executable = true;
          target = ".config/sketchybar/items/volume.sh";
          text = ''
            #/usr/bin/env sh

            sketchybar --add item volume right \
              --set volume script="$PLUGIN_DIR/volume.sh" \
              --subscribe volume volume_change
          '';
        };
        plugins_wifi = {
          executable = true;
          target = ".config/sketchybar/plugins/wifi.sh";
          text = ''
                     #/usr/bin/env sh

            SSID=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }')

                     if [ "$SSID" = "" ]; then
                       sketchybar --set $NAME icon="􀙈" label="Disconnected"
                     else
                       sketchybar --set $NAME icon="􀙇" label="$SSID"
                     fi

          '';
        };
        plugins_calendar = {
          executable = true;
          target = ".config/sketchybar/plugins/calendar.sh";

          text = ''
            #/usr/bin/env sh

            sketchybar --set $NAME label="$(date +'%a %d %b %I:%M %p')"
          '';
        };
        plugins_spaces = {
          executable = true;
          target = ".config/sketchybar/plugins/spaces.sh";
          text = ''
            #!/usr/bin/env sh

            source "$CONFIG_DIR/colors.sh"

            update_workspace_appearance() {
              local sid=$1
              local is_focused=$2

              if [ "$is_focused" = "true" ]; then
                sketchybar --set space.$sid background.drawing=on \
                  background.color=$ACCENT_COLOR \
                  label.color=$ITEM_COLOR \
                  icon.color=$ITEM_COLOR
              else
                sketchybar --set space.$sid background.drawing=off \
                  label.color=$ACCENT_COLOR \
                  icon.color=$ACCENT_COLOR
              fi
            }

            update_icons() {
              m=$1
              sid=$2

              apps=$(aerospace list-windows --monitor "$m" --workspace "$sid" \
              | awk -F '|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}' \
              | sort)

              icon_strip=""
              if [ "''${apps}" != "" ]; then
                while read -r app; do
                  icon_strip+=" $($CONFIG_DIR/plugins/icons.sh "$app")"
                done <<<"''${apps}"
              else
                icon_strip=" —"
              fi

              sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
            }

            update_workspace_appearance "$PREV_WORKSPACE" "false"
            update_workspace_appearance "$FOCUSED_WORKSPACE" "true"

            for m in $(aerospace list-monitors | awk '{print $1}'); do
              for sid in $(aerospace list-workspaces --monitor $m --visible); do
                sketchybar --set space.$sid display=$m

                update_icons "$m" "$sid"

                update_icons "$m" "$PREV_WORKSPACE"

                apps=$(aerospace list-windows --monitor "$m" --workspace "$sid" | wc -l)
                if [ "''${apps}" -eq 0 ]; then
                  sketchybar --set space.$sid display=0
                fi
              done
            done
          '';
        };

        plugins_space_click = {
          executable = true;
          target = ".config/sketchybar/plugins/space_click.sh";
          text = ''
            #/usr/bin/env/ sh

            apps=$(aerospace list-windows --workspace $1 | awk -F '|' '{gsub(/^ *| *$/, "", $2); print $2}')
            focused=$(aerospace list-workspaces --focused)

            if [ "''${apps}" = "" ] && [ "''${focused}" != "$1" ]; then
              sketchybar --set space.$1 display=0
            else
              aerospace workspace $1
            fi
          '';
        };
        plugins_volume = {
          executable = true;
          target = ".config/sketchybar/plugins/volume.sh";
          text = ''
                      #!/usr/bin/env sh

                      # The volume_change event supplies a $INFO variable in which the current volume
            # percentage is passed to the script.

            if [ "$SENDER" = "volume_change" ]; then

              VOLUME=$INFO

              case $VOLUME in
              [6-9][0-9] | 100)
                ICON="􀊩"
                ;;
              [3-5][0-9])
                ICON="􀊥"
                ;;
              [1-9] | [1-2][0-9])
                ICON="􀊡"
                ;;
              *) ICON="􀊣" ;;
              esac

              sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
            fi
          '';
        };
        plugins_front_app = {
          executable = true;
          target = ".config/sketchybar/plugins/front_app.sh";
          text = ''
            # Some events send additional information specific to the event in the $INFO
            # variable. E.g. the front_app_switched event sends the name of the newly
            # focused application in the $INFO variable:
            # https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

            app_switched() {
              for m in $(aerospace list-monitors | awk '{print $1}'); do
                for sid in $(aerospace list-workspaces --monitor $m --visible); do

                  apps=$( (echo "$INFO"; aerospace list-windows --monitor "$m" --workspace "$sid" \
                  | awk -F '|' '{gsub(/^ *| *$/, "", $2); print $2}') \
                  | awk '!seen[$0]++' | sort)

                  icon_strip=""
                  if [ "''${apps}" != "" ]; then
                    while read -r app; do
                      icon_strip+=" $($CONFIG_DIR/plugins/icons.sh "$app")"
                    done <<<"''${apps}"
                  else
                    icon_strip=" —"
                  fi

                  sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
                done
              done
            }

            if [ "$SENDER" = "front_app_switched" ]; then

              sketchybar --set $NAME label="$INFO" icon="$($CONFIG_DIR/plugins/icons.sh "$INFO")"

              app_switched
            fi
          '';
        };
        plugins_battery = {
          executable = true;
          target = ".config/sketchybar/plugins/battery.sh";
          text = ''
            #!/usr/bin/env sh
            source "$CONFIG_DIR/colors.sh"

            PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
            CHARGING=$(pmset -g batt | grep 'AC Power')

            if [ $PERCENTAGE = "" ]; then
              exit 0
            fi

            case ''${PERCENTAGE} in
            9[0-9] | 100)
              ICON="􀛨"
              COLOR=$ITEM_COLOR
              ;;
            [6-8][0-9])
              ICON="􀺸"
              COLOR=$ITEM_COLOR
              ;;
            [3-5][0-9])
              ICON="􀺶"
              COLOR="0xFFd97706"
              ;;
            [1-2][0-9])
              ICON="􀛩"
              COLOR="0xFFf97316"
              ;;
            *)
              ICON="􀛪"
              COLOR="0xFFef4444"
              ;;
            esac

            if [[ $CHARGING != "" ]]; then
              ICON="􀢋"
              COLOR=$ITEM_COLOR
            fi

            # The item invoking this script (name $NAME) will get its icon and label
            # updated with the current battery status
            sketchybar --set $NAME icon="$ICON" label="''${PERCENTAGE}%" icon.color="$COLOR"
          '';
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
      }
    );
}
