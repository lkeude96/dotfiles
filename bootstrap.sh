#!/bin/sh

# echo ""
# echo "------------------------------"
# echo "Syncing the dev-setup repo to your local machine."
# echo "------------------------------"
# echo ""

# Ask for the administrator password upfront
sudo -v

# # Keep-alive: update existing `sudo` time stamp until has finished
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ------------------------------------------------------------------------------------------------------------------------

echo ""
echo "------------------------------"
echo "Updating macOS and installing Xcode command line tools"
echo "------------------------------"
echo ""

# Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating macOS.  If this requires a restart, run the script again."
# Install all available updates
sudo softwareupdate -ia --verbose
echo "------------------------------"
echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

# ------------------------------------------------------------------------------------------------------------------------

# # Check for Oh My Zsh and install if we don't have it
# if test ! $(which omz); then
#   echo "Installing Oh My Zsh..."
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
# fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
echo "Linking .zshrc ..."
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg

# Create a Sites directory
mkdir $HOME/Developer

# ------------------------------------------------------------------------------------------------------------------------

echo ""
echo "------------------------------"
echo "Installing Homebrew along with some common formulae and apps."
echo "This might take a while to complete, as some formulae need to be installed from source."
echo "------------------------------"
echo ""

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "------------------------------"
echo "Updating brew ..."

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $DOTFILES/Brewfile

# Set macOS preferences - we will run this last because this will reload the shell
source $DOTFILES/.macos