#!/bin/bash
# Colors
RED="\033[0;31m"
ORANGE="\033[0;33m"
GREEN="\033[0;32m"
NC="\033[0m"

# Messages
OK="[OK]"
FAIL="[FAIL]"
STEP_1="Copying to oh-my-zsh theme folder..."
STEP_2="Finding zsh theme option..."
STEP_3="Replacing theme..."

# Config
ZSH_THEME_OPTION="ZSH_THEME"

# Other
SUCCESS_COUNT=0
SUCCESS_EXPECTED=3
THEME_CONFIG_LINE="$(grep -n $ZSH_THEME_OPTION ~/.zshrc -m 1| cut -d: -f 1)"

printResult() {
    if [ "$1" == true ]; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        printf "\n\\e%s%s\\e%s%s\\n""$GREEN $OK $NC $2"
    else
        SUCCESS_COUNT=$((SUCCESS_COUNT - 1))
        printf "\n\\e%s%s \\e%s%s""$RED $FAIL $NC $2"
    fi
}
installTheme() {
    THEME_NAME="random-movie-quotes"
    # Welcome message
    printf "\\e%s %s""$GREEN $(cat credits)"
    printf "\\e%s""$NC"   
    printf "\\nInstalling %s theme:""$THEME_NAME"
    if cp $THEME_NAME.zsh-theme ~/.oh-my-zsh/themes/ && cp -r $THEME_NAME-data ~/.oh-my-zsh/themes/; then
        printResult true "$STEP_1"
    else
        printResult false "$STEP_1"
    fi
    if [[ "$THEME_CONFIG_LINE" -gt 0 ]]; then
        printResult true "$STEP_2"
        if sed -E -i .bak "s/${ZSH_THEME_OPTION}=\"(.*)\"/${ZSH_THEME_OPTION}=\"${THEME_NAME}\"/" ~/.zshrc; then
            printResult true "$STEP_3"
        else
            printResult false "$STEP_3"
        fi
    else
        printResult false "$STEP_2" 
    fi 
    if [[ "$SUCCESS_COUNT" -eq "$SUCCESS_EXPECTED" ]]; then 
        echo "\n\nTheme $THEME_NAME has been"
        echo "uccessfully installed!" 
        echo "To start using this theme run:"
        echo "$ORANGEsource ~/.zshrc$NC"
        echo "or open a new terminal tab/window"
    else
        echo "It looks like there was an error"
        echo "please feel free to post an issue on:"
        echo "https://github.com/tmjoseantonio/random-movie-quotes/issues/new"
    fi

    echo "------------------------------------------"
}
installTheme
