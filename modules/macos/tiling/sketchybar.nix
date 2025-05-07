{config,pkgs, ...}: {
  services.sketchybar = {
    enable = config.shared.darwin.tiling.enable;
    config = ''
      # This is a demo config to showcase some of the most important commands.
      # It is meant to be changed and configured, as it is intentionally kept sparse.
      # For a (much) more advanced configuration example see my dotfiles:
      # https://github.com/FelixKratz/dotfiles

      PLUGIN_DIR="$CONFIG_DIR/plugins"

      ##### Bar Appearance #####
      # Configuring the general appearance of the bar.
      # These are only some of the options available. For all options see:
      # https://felixkratz.github.io/SketchyBar/config/bar
      # If you are looking for other colors, see the color picker:
      # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

      sketchybar --bar position=top height=40 blur_radius=30 color=0x04313244

      # Colours
      SURFACE=0xff313244

      ##### Changing Defaults #####
      # We now change some default values, which are applied to all further items.
      # For a full list of all available item properties see:
      # https://felixkratz.github.io/SketchyBar/config/items

      default=(
        padding_left=5
        padding_right=5
        icon.font="Hack Nerd Font:Bold:17.0"
        label.font="Hack Nerd Font:Bold:14.0"
        icon.color=0xffcdd6f4
        label.color=0xffcdd6f4
        icon.padding_left=8
        icon.padding_right=4
        label.padding_left=4
        label.padding_right=8
        background.padding_left=2
        background.padding_right=2
        background.color=$SURFACE \
        background.corner_radius=10 \
        background.height=30 \
        background.border_width=1 \
      )
      sketchybar --default "$\{default[@]}"

      sketchybar --add event aerospace_workspace_change

      for sid in $(aerospace list-workspaces --all); do
          sketchybar --add item space.$sid left \
              --subscribe space.$sid aerospace_workspace_change \
              --set space.$sid \
              background.border_width=1 \
              background.border_color=0xffb4befe \
              background.corner_radius=5 \
              background.height=20 \
              icon.padding_left=0 \
              icon.padding_right=0 \
              label.padding_right=6 \
              label="$sid" \
              click_script="aerospace workspace $sid" \
              script="$CONFIG_DIR/plugins/aerospace.sh $sid"
      done

      ##### Adding Left Items #####
      # We add some regular items to the left side of the bar, where
      # only the properties deviating from the current defaults need to be set

      sketchybar --add item chevron left \
                 --set chevron icon= label.drawing=off background.drawing=off \
                 icon.color=0xfff5e0dc \
                 --add item front_app left \
                 --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
                 label.color=0xff94e2d5 \
                 label.padding_left=8 \
                 background.border_color=0xff94e2d5 \
                 --subscribe front_app front_app_switched

      ##### Adding Right Items #####
      # In the same way as the left items we can add items to the right side.
      # Additional position (e.g. center) are available, see:
      # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

      # Some items refresh on a fixed cycle, e.g. the clock runs its script once
      # every 10s. Other items respond to events they subscribe to, e.g. the
      # volume.sh script is only executed once an actual change in system audio
      # volume is registered. More info about the event system can be found here:
      # https://felixkratz.github.io/SketchyBar/config/events

      sketchybar --add item clock right \
                 --set clock update_freq=10 icon=󰃰 script="$PLUGIN_DIR/clock.sh" \
                 icon.color=0xfffab387 \
                 label.color=0xffcdd6f4 \
                 background.color=$SURFACE \
                 background.corner_radius=10 \
                 background.height=30 \
                 --add item volume right \
                 --set volume script="$PLUGIN_DIR/volume.sh" \
                 label.color=0xffcdd6f4 \
                 background.color=$SURFACE \
                 background.corner_radius=10 \
                 background.height=30 \
                 --subscribe volume volume_change \
                 --add item battery right \
                 --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
                 label.color=0xffcdd6f4 \
                 background.color=$SURFACE \
                 background.corner_radius=10 \
                 background.height=30 \
                 --subscribe battery system_woke power_source_change

      sketchybar -m --add item mullvad right \
                 --set mullvad icon= \
                 icon.color=0xfff38ba8 \
                 background.color=$SURFACE \
                 background.corner_radius=10 \
                 background.height=30 \
                 background.border_width=1 \
                 background.border_color=0xfff38ba8 \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 icon.padding_left=6 \
                 update_freq=5 \
                 script="$PLUGIN_DIR/mullvad.sh"

      # Add event
                 sketchybar -m --add event song_update com.apple.iTunes.playerInfo

      # Add Music Item
                 sketchybar -m --add item music right \
                     --set music script="$PLUGIN_DIR/music.sh" \
                     click_script="$PLUGIN_DIR/music_click.sh" \
                     label.padding_right=10 \
                     label.color=0xffcdd6f4 \
                     background.color=$SURFACE \
                     background.corner_radius=10 \
                     background.height=30 \
                     background.border_width=1 \
                     background.border_color=0xfff38ba8 \
                     drawing=off \
                     --subscribe music song_update

      ##### Force all scripts to run the first time (never do this in a script) #####
                     sketchybar --update

    '';
  };
}
