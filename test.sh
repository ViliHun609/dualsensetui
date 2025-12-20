#!/usr/bin/env bash

# ANSI colors using $'...' so fzf interprets them correctly
RED=$'\033[31m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'

while true; do
    # Main menu options with colors and icons
    OPTIONS=(
        "${CYAN}🎮 Turn off Controller${RESET}"
        "${GREEN}🔧 Gaming Preset${RESET}"
        "${YELLOW}💡 Change LED color${RESET}"
        "${MAGENTA}🎚️ Vibration Intensity${RESET}"
        "${BLUE}🔧 Adaptive Triggers${RESET}"
        "${CYAN}ℹ️ Info${RESET}"
        "${RED}❌ Exit${RESET}"
    )

    # Show menu with fzf and ANSI support
    CHOICE=$(printf "%s\n" "${OPTIONS[@]}" | fzf --ansi --prompt="${CYAN}DualSenseCtl > ${RESET}" --height 15 --border)

    case "$CHOICE" in
        *"Turn off Controller"*) 
            dualsensectl power-off
            echo -e "${YELLOW}Controller turned off!${RESET}"
            ;;

        *"Gaming Preset"*)
            # Example preset: blue light, triggers on, high vibration
            dualsensectl lightbar 0 0 255
            dualsensectl adaptive-trigger on
            dualsensectl vibration high
            echo -e "${GREEN}Gaming preset applied! 🎮${RESET}"
            ;;

        *"Change LED color"*)
            COLORS=(
                "🔴 Red"
                "🟢 Green"
                "🔵 Blue"
                "⬅️ Back"
            )
            COLOR_CHOICE=$(printf "%s\n" "${COLORS[@]}" | fzf --ansi --prompt="${CYAN}LED color > ${RESET}")
            case "$COLOR_CHOICE" in
                "🔴 Red") dualsensectl lightbar 255 0 0 ;;
                "🟢 Green") dualsensectl lightbar 0 255 0 ;;
                "🔵 Blue") dualsensectl lightbar 0 0 255 ;;
                "⬅️ Back") continue ;;
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
