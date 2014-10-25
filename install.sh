#!/bin/bash
############################
# install.sh
# This script installs all configuration files
############################

########## Variables

dir=~/dotfiles                    				            # dotfiles directory
olddir=~/dotfiles_old             				            # old dotfiles backup directory
files="zshrc gitignore gitconfig"    						# list of files/folders to symlink in homedir
ohmyzsh_repo=http://github.com/robbyrussell/oh-my-zsh.git 	#Oh my zsh repo url
zsh=~/.oh-my-zsh

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ... "
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ... "
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d "$zsh" ]]; then
        git clone $ohmyzsh_repo $zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    # If the platform is not linux, tell the user to install zsh :)
    else
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh

#copy ohmyzsh template
if [ ! -L "$zsh/themes/doubleeend.zsh-theme" ]; then
    echo "Copy zsh theme"
    ln -s $dir/zsh/doubleend.zsh-theme $zsh/themes/doubleeend.zsh-theme
fi;

#Cleanup after install
if [ -z "$(ls -A $olddir)" ]; then
    echo "Clean up"
    rm -Rf $olddir
fi;