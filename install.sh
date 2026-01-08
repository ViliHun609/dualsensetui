#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/ViliHun609/dualsensetui/master/dualsensetui.sh"
INSTALL_PATH="/usr/local/bin/dualsensetui"

# Colors (from dualsensetui.sh)
RED=$'\033[31m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'
#RESET=$'\033[36m'
WHITE=$'\033[37m'

echo "${Green} Installing DualSenseTUI"

# Check if dualsensectl is installed
