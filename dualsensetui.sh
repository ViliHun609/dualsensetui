#!/usr/bin/env bash

VERSION="0.6"


RED=$'\033[31m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'
#RESET=$'\033[36m'
WHITE=$'\033[37m'



if [ "$1" = "-b" ]; then
    BATTERY_LEVEL=$(dualsensectl battery | grep -o '[0-9]\{1,3\}' | head -1)
    
    if [[ -z "$BATTERY_LEVEL" ]]; then
        echo "Error"
        exit 1
    fi
    
    echo "${BATTERY_LEVEL}%"
    exit 0
fi

DEVICES=$(dualsensectl -l 2>/dev/null | wc -l)
if [ "$DEVICES" -lt 1 ]; then
    echo "${RED}No DualSense controllers found. Please connect one!"
    echo "${RED}Closing this window in 3 seconds!"
    sleep 1
    echo "${RED}Closing this window in 2 seconds!"
    sleep 1
    echo "${RED}Closing this window in 1 seconds!"
    sleep 1
    osascript -e &
    exit
fi

DEVICES=$((DEVICES-1))

while true; do
clear
echo "${WHITE}DualSenseTUI ${VERSION}"
echo "${RED}Connected Controller(s): $DEVICES${RESET}"
    OPTIONS=(
        "${RED} Exit${RESET}"
        "${CYAN} Turn off Controller${RESET}"
        "${GREEN}󰮂 Gaming Preset${RESET}"
        "${YELLOW}󰌵 Configure light bar${RESET}"
        "${BLUE}󰖷 Test adaptive triggers${RESET}"
        "${CYAN}󰋼 Info${RESET}"
        "${RED}󰝳 Defaults"
        "${GREEN} Update dualsensectl and dualsensetui"
    )

  
    CHOICE=$(printf "%s\n" "${OPTIONS[@]}" | fzf --ansi --prompt="${CYAN}DualSenseTUI > ${RESET}" --height 13 --border)

    case "$CHOICE" in

    *"Defaults"*)
       read -p "Are you sure you want to reset your controller? (y/n): " -n 1 -r RESET_CHOICE
       echo

       if [[ $RESET_CHOICE =~ ^[Yy]$ ]]; then
           read -rp "${RESET}Press enter to confirm reset!"
           
       else
           echo "Reset cancelled."
       fi
       ;;

















        *"Turn off Controller"*) 
            dualsensectl power-off
            echo -e "${YELLOW}Controller turned off!${RESET}"
            exit 0
            ;;

        *"Gaming Preset"*)
            dualsensectl lightbar on
            dualsensectl lightbar 0 0 255 60
            dualsensectl led-brightness 1
            dualsensectl player-leds 1
            dualsensectl microphone off
            dualsensectl microphone-led on
            dualsensectl speaker internal
            dualsensectl volume 0
            dualsensectl trigger both off
            echo -e "${GREEN}✓ Gaming preset applied! 🎮${RESET}"

            read -rp "${RESET}Press enter to continue..."
            ;;         
            
        *"Configure light bar"*)
            ONOFF=(
                "${GREEN} ON${RESET}"
                "${RED} OFF${RESET}"
            )
            LIGHBARSTATE_CHOICE=$(printf "%s\n" "${ONOFF[@]}" | fzf --ansi --prompt="${CYAN}Light bar state > ${RESET}")          

            case "$LIGHBARSTATE_CHOICE" in
                *"ON"*)
                    COLORS=(
                        "⬅️ Back"
                        "🔴 Red"
                        "🟢 Green"
                        "🔵 Blue"
                        "🟡 Yellow"
                        "🟣 Purple"
                        "🟠 Orange"
                        "⬜ White"
                    )
                    COLOR_CHOICE=$(printf "%s\n" "${COLORS[@]}" | fzf --ansi --prompt="${CYAN}LED color > ${RESET}")


                    if [ -z "$COLOR_CHOICE" ]; then
                        continue
                    fi


                    if [ "$COLOR_CHOICE" = "⬅️ Back" ]; then
                        continue
                    fi


                    BRIGHTNESS_OPTIONS=(
                        "󰌍 Back"
                        "󱩎 Dim (25%)"
                        "󱩒 Medium (50%)"
                        "󱩔 Bright (75%)"
                        "󱩔 Full (100%)"
                        "󰌌 Custom..."
                    )
                    BRIGHTNESS_CHOICE=$(printf "%s\n" "${BRIGHTNESS_OPTIONS[@]}" | fzf --ansi --prompt="${CYAN}Brightness > ${RESET}")

                    if [ -z "$BRIGHTNESS_CHOICE" ]; then
                        continue
                    fi

                    case "$BRIGHTNESS_CHOICE" in
                        "󱩎 Dim (25%)")    BRIGHTNESS=25 ;;
                        "󱩒 Medium (50%)") BRIGHTNESS=50 ;;
                        "󱩔 Bright (75%)") BRIGHTNESS=75 ;;
                        "󰛨 Full (100%)")  BRIGHTNESS=100 ;;
                        "󰌌 Custom...")
                            read -p "Enter brightness (0-100): " CUSTOM_BRIGHTNESS
                            if [[ "$CUSTOM_BRIGHTNESS" =~ ^[0-9]+$ ]] && [ "$CUSTOM_BRIGHTNESS" -ge 0 ] && [ "$CUSTOM_BRIGHTNESS" -le 100 ]; then
                                BRIGHTNESS=$CUSTOM_BRIGHTNESS
                            else
                                echo -e "${RED}✗ Invalid brightness value${RESET}"
                                continue
                            fi
                            ;;
                        "󰌍 Back") 
                            continue 
                            ;;
                    esac

                    case "$COLOR_CHOICE" in
                        "🔴 Red")
                            dualsensectl lightbar 255 0 0 $BRIGHTNESS
                            echo -e "${RED}✓ Light bar set to Red at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "🟢 Green") 
                            dualsensectl lightbar 0 255 0 $BRIGHTNESS
                            echo -e "${GREEN}✓ Light bar set to Green at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "🔵 Blue") 
                            dualsensectl lightbar 0 0 255 $BRIGHTNESS
                            echo -e "${BLUE}✓ Light bar set to Blue at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "🟡 Yellow") 
                            dualsensectl lightbar 255 255 0 $BRIGHTNESS
                            echo -e "${YELLOW}✓ Light bar set to Yellow at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "🟣 Purple") 
                            dualsensectl lightbar 128 0 128 $BRIGHTNESS
                            echo -e "${MAGENTA}✓ Light bar set to Purple at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "🟠 Orange") 
                            dualsensectl lightbar 255 165 0 $BRIGHTNESS
                            echo -e "${YELLOW}✓ Light bar set to Orange at ${BRIGHTNESS_CHOICE}${RESET}"
                            ;;
                        "⬜ White") 
                            dualsensectl lightbar 255 255 255 $BRIGHTNESS
                            echo -e "✓ Light bar set to White at ${BRIGHTNESS_CHOICE}"
                            ;;
                    esac
                    ;;
                *"OFF"*)
                    dualsensectl lightbar off
                    echo -e "${GREEN}✓ Light bar turned off${RESET}"
                    ;;
            esac    
            read -rp "${RESET}Press enter to continue..."
            ;;

        *"Test adaptive triggers"*)
            dualsensectl trigger both weapon 2 6 8
            echo "Press down any trigger and feel the adaptive triggers"

            read -p "${RESET}Press enter to Remove trigger effects and return to the main page!"
            dualsensectl trigger both off
            ;;

        *"Info"*)
        BATTERY_LEVEL=$(dualsensectl battery)
        echo "$BATTERY_LEVEL"  


        BATTERY_LEVEL=$(echo "$BATTERY_LEVEL" | awk '{print substr($0,1,3)}')
        BATTERY_LEVEL=$(dualsensectl battery | grep -o '[0-9]\{1,3\}' | head -1)
        echo "Extracted: $BATTERY_LEVEL"

        dualsensectl info | awk '
        {
          lines[NR] = $0
          len = length($0)
          if (len > max) max = len
        }
        END {
          printf "┌"
          for (i = 0; i < max + 2; i++) printf "─"
          print "┐"

          for (i = 1; i <= NR; i++)
            printf "│ %-*s │\n", max, lines[i]

          printf "└"
          for (i = 0; i < max + 2; i++) printf "─"
          print "┘"
        }'

        if [[ -n "$BATTERY_LEVEL" && "$BATTERY_LEVEL" -eq 100 ]]; then
            echo "Battery: $BATTERY_LEVEL%  "
            echo -e "${GREEN}Controller is fully charged!"
        elif [[ -n "Battery: $BATTERY_LEVEL" && "$BATTERY_LEVEL" -le 20 ]]; then
            echo "${RED}Battery: $BATTERY_LEVEL%  "
            echo "${RED}Controller battery charge is low!"
        else
            echo "${YELLOW}Battery: $BATTERY_LEVEL%  "
        fi

        read -rp "${RESET}Press enter to continue..."

        ;;

        *"Exit"*)
            clear
            echo -e "${MAGENTA}Goodbye! 🎮${RESET}"
            exit 0
            ;;

        *) echo "No option selected or unknown choice." ;;
    esac


done
