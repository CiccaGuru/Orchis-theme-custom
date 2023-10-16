#! /usr/bin/env bash

REPO_DIR="$(dirname "$(readlink -m "${0}")")"
source "${REPO_DIR}/core.sh"

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)

  -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|nord|all] (Default: blue)
  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants)s)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)

  -l, --libadwaita        Link installed Orchis gtk-4.0 theme to config folder for all libadwaita app use Orchis theme

  --round                 Change theme round corner border-radius [Input the px value you want] (Suggested: 2px < value < 16px)
                          1. 3px
                          2. 4px
                          3. 5px
                          ...
                          13. 15px

  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed themes

  --tweaks                Specify versions for tweaks [solid|compact|black|primary|macos|submenu|(nord/dracula)] (Options can mix [nord and dracula can not mix use!])
                          1. solid:              No transparency panel variant
                          2. compact:            No floating panel variant
                          3. black:              Full black variant
                          4. primary:            Change radio icon checked color to primary theme color (Default is Green)
                          5. macos:              Change window buttons to MacOS style
                          6. submenu:            Theme sub-menus, by Default submenus contrast
                          7. [nord|dracula]:     Nord/dracula colorscheme themes

  --shell                 install gnome-shell version [38|40|42]
                          1. 38:                 Gnome-shell version < 40.0
                          2. 40:                 Gnome-shell version = 40.0
                          3. 42:                 Gnome-shell version >= 42.0

  -h, --help              Show help
EOF
}


dest="$HOME/.local/share/themes"
mkdir -p "$dest"
libadwaita="true"

_name="CiccaOrchis"
name="CiccaOrchis"
shell="42-0"
opacity="solid"
panel="compact"
primary="true"
accent='true'


themes=("-Red")
colors=("" "-Dark")
sizes=("")
othemes=("")
ocolors=("")
osizes=("")
lcolors=("")

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -r|--remove|-u|--uninstall)
      remove="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done


if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

if [[ "${#sizes[@]}" -eq 0 ]] ; then
  sizes=("${SIZE_VARIANTS[@]}")
fi

if [[ "${#othemes[@]}" -eq 0 ]] ; then
  othemes=("${OLD_THEME_VARIANTS[@]}")
fi

if [[ "${#ocolors[@]}" -eq 0 ]] ; then
  ocolors=("${OLD_COLOR_VARIANTS[@]}")
fi

if [[ "${#osizes[@]}" -eq 0 ]] ; then
  osizes=("${OLD_SIZE_VARIANTS[@]}")
fi

if [[ "${#lcolors[@]}" -eq 0 ]] ; then
  lcolors=("${COLOR_VARIANTS[1]}")
fi


clean_theme

if [[ ${remove} == 'true' ]]; then
  if [[ "$libadwaita" == 'true' ]]; then
    uninstall_link
  elif [[ "$all" == 'true' ]]; then
    uninstall_theme && uninstall_link
  else
    uninstall_theme
  fi
else
  install_theme

  if [[ "$libadwaita" == 'true' ]]; then
    link_theme
  fi
fi

echo
echo "Done."
