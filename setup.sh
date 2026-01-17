#Verify script run as root
if sudo -l &> /dev/null; then
	echo "This script will install necessary components..."
else
	echo "This script must be run as root, use the sudo command..."
	exit 1
fi

#Check for and create XDG path
echo "Setting up environment variables...."
if [[ ! -d "$XDG_CONFIG_HOME" ]] then
	XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ ! -d "$ZDOTDIR" ]] then
	ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

#Clone zsh plugins 
echo "Installing zsh plugins...."
if [[ ! -d "$ZDOTDIR/plugins" ]] then
	mkdir "$ZDOTDIR/plugins"
fi

echo "Cloning Auto Suggestions, by zsh-users"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZDOTDIR/plugins/"
echo "Cloning F-Sy-H (Syntax Highlighting) by z-shell."
git clone https://github.com/z-shell/F-Sy-H.git "$ZDOTDIR/plugins/"
echo "Cloning History Substring Search, by zsh-users"
git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZDOTDIR/plugins/"

#Install stow if not installed
echo "Installing stow."
if [[ ! command -v stow ]] then
	sudo apt install stow -y
fi


