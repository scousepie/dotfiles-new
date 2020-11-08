#!/bin/bash
set -e
################################################################################
#                                                                                        #
#           DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.               #
#                                                                                        #
################################################################################

install_zsh () {
# Test to see if zshell is installed.
if [ -f /bin/shell -o -f /usr/bin/zsh ]; then
	# Set the default shell to zsh 
	if [ ! $(echo $SHELL) == $(which zsh) ]; then
		chsh -s $(which zsh)
	fi
else
	# Install zsh
	sudo pacman -S zsh
	sudo pacman -S zsh-completions
	sudo pacman -S grml-zsh-config
	install_zsh
fi
}

install_zsh
