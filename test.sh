#!/usr/bin/env bash


RED=$'\033[31m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'


DEVICES=$(dualsensectl -l 2>/dev/null | wc -l)
if [ "$DEVICES" -lt 1 ]; then
    echo "No DualSense controllers found. Please connect one!"
    exit 1
fi

DEVICES=$((DEVICES-1))

echo "${RED}Connected Controller(s): $DEVICES${RESET}"
while true; do
    OPTIONS=(
        "${RED}❌ Exit${RESET}"
        "${CYAN}🎮 Turn off Controller${RESET}"
        "${GREEN}🔧 Gaming Preset${RESET}"
        "${YELLOW}💡 Configure light bar${RESET}"
        "${MAGENTA}🎚️ Vibration Intensity${RESET}"
        "${BLUE}🔧 Adaptive Triggers${RESET}"
        "${CYAN}ℹ️ Info${RESET}"
        "defaults"
    )

  
    CHOICE=$(printf "%s\n" "${OPTIONS[@]}" | fzf --ansi --prompt="${CYAN}DualSenseTUI > ${RESET}" --height 13 --border)

    case "$CHOICE" in
        *"Turn off Controller"*) 
            dualsensectl power-off
            echo -e "${YELLOW}Controller turned off!${RESET}"
            ;;

        *"Gaming Preset"*)
            dualsensectl lightbar 0 0 255 100
            dualsensectl led-brightness 1
            dualsensectl player-leds 1
            dualsensectl microphone off
            dualsensectl microphone-led on
            dualsensectl speaker internal
            dualsensectl volume 0
            dualsensectl trigger both off
            echo -e "${GREEN}✓ Gaming preset applied! 🎮${RESET}"
            ;;

        *"Configure light bar"*)
            ONOFF=(
                "${GREEN}✅ ON${RESET}"
                "${RED}❌ OFF${RESET}"
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
                    
                    # Check if user cancelled
                    if [ -z "$COLOR_CHOICE" ]; then
                        continue
                    fi
                    
                    case "$COLOR_CHOICE" in
                        "🔴 Red") 
                            dualsensectl lightbar 255 0 0
                            echo -e "${RED}✓ Light bar set to Red${RESET}"
                            ;;
                        "🟢 Green") 
                            dualsensectl lightbar 0 255 0
                            echo -e "${GREEN}✓ Light bar set to Green${RESET}"
                            ;;
                        "🔵 Blue") 
                            dualsensectl lightbar 0 0 255
                            echo -e "${BLUE}✓ Light bar set to Blue${RESET}"
                            ;;
                        "🟡 Yellow") 
                            dualsensectl lightbar 255 255 0
                            echo -e "${YELLOW}✓ Light bar set to Yellow${RESET}"
                            ;;
                        "🟣 Purple") 
                            dualsensectl lightbar 128 0 128
                            echo -e "${MAGENTA}✓ Light bar set to Purple${RESET}"
                            ;;
                        "🟠 Orange") 
                            dualsensectl lightbar 255 165 0
                            echo -e "${YELLOW}✓ Light bar set to Orange${RESET}"
                            ;;
                        "⬜ White") 
                            dualsensectl lightbar 255 255 255
                            echo -e "✓ Light bar set to White"
                            ;;
                        "⬅️ Back") 
                            continue 
                            ;;
                    esac
                    ;;
                    
                *"OFF"*)
                    dualsensectl lightbar off
                    echo -e "${GREEN}✓ Light bar turned off${RESET}"
                    ;;
            esac
            ;;

        *"Vibration Intensity"*)
            VIB=("🔹 Low" "🔸 High" "⬅️ Back")
            VIB_CHOICE=$(printf "%s\n" "${VIB[@]}" | fzf --ansi --prompt="${CYAN}Vibration > ${RESET}")
            case "$VIB_CHOICE" in
                "🔹 Low") dualsensectl vibration low ;;
                "🔸 High") dualsensectl vibration high ;;
                "⬅️ Back") continue ;;
            esac
            ;;

        *"Adaptive Triggers"*)
            TRIG=("✅ Enable" "❌ Disable" "⬅️ Back")
            TRIG_CHOICE=$(printf "%s\n" "${TRIG[@]}" | fzf --ansi --prompt="${CYAN}Adaptive triggers > ${RESET}")
            case "$TRIG_CHOICE" in
                "✅ Enable") dualsensectl adaptive-trigger on ;;
                "❌ Disable") dualsensectl adaptive-trigger off ;;
                "⬅️ Back") continue ;;
            esac
            ;;

        *"Info"*) dualsensectl info ;;

        *"Exit"*) echo -e "${MAGENTA}Goodbye! 🎮${RESET}"; exit 0 ;;

        *) echo "No option selected or unknown choice." ;;
    esac

    read -rp "Press enter to continue..."
done
