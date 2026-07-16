#! /bin/sh

#check network connection, connect to network if not connected
set counter = 0
net_connect(){
    if [ $counter -lt 5 ]; then
        echo "Attempting to connect to network..."
        iwctl station wlan0 connect FangAndClaw 
        sleep 5
        counter=$((counter + 1))
        net_check
    else
        echo "Failed to connect to network after 5 attempts."
    fi
}

net_check(){
    if ip route get 1.1.1.1 | grep -q "wlan0"; then
        echo "Connected to network"
    else
        echo "Not connected to network, connecting..."
        net_connect
    fi
}

net_check

# Set desktop backgrounds
cd ~/dotfiles
if git branch --show-current | grep -q "nsfw"; then
    echo "dotfiles on correct branch"
else
    echo "dotfiles not on correct branch, switching to nsfw"
    git checkout nsfw
fi
git fetch
git pull

# wallswitcher must be called twice in succession
cd ~
wallswitcher.sh
wallswitcher.sh

# open some software
