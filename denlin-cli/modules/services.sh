#!/bin/bash

# Menu: Services
# Description: Create Docker Compose YAML files with a wizard


# ASCII Art Banner
display_banner() {
    echo -e "                                                                 "
    echo -e "    _____     ______     __   __     __         __     __   __   "
    echo -e "   /\\  __-.  /\\  ___\\   /\\ \"-.\\ \\   /\\ \\       /\\ \\   /\\ \"-.\\ \\  "
    echo -e "   \\ \\ \\/\\ \\ \\ \\  __\\   \\ \\ \\-.  \\  \\ \\ \\____  \\ \\ \\  \\ \\ \\-.  \\ "
    echo -e "    \\ \\____-  \\ \\_____\\  \\ \\_ \\\"\\_\\  \\ \\_____\\  \\ \\_\\  \\ \\_\\ \"\\_\\"
    echo -e "     \\/____/   \\/_____/   \\/_/ \\/_/   \\/_____/   \\/_/   \\/_/ \\/_/"
    echo -e ""
    echo -e "   ______     ______     ______     __   __   __     ______     ______     ______    "
    echo -e "  /\  ___\   /\  ___\   /\  == \   /\ \ / /  /\ \   /\  ___\   /\  ___\   /\  ___\   "
    echo -e "  \ \___  \  \ \  __\   \ \  __<   \ \ \'/   \ \ \  \ \ \____  \ \  __\   \ \___  \  "
    echo -e "   \/\_____\  \ \_____\  \ \_\ \_\  \ \__|    \ \_\  \ \_____\  \ \_____\  \/\_____\ "
    echo -e "    \/_____/   \/_____/   \/_/ /_/   \/_/      \/_/   \/_____/   \/_____/   \/_____/ "
    echo -e "                                                                 "                  
    echo -e "                                                                 "
}

display_banner