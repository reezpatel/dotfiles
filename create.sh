#/bin/sh

echo "Updating Brefile"
rm ./Brewfile
brew bundle dump

echo "Updating Npmfile"
npm list -g --depth=0 | grep -v "npm@" | sed '1d' | awk '{print $2}' | sed 's/@.*//' > Npmfile

echo "Copying new nvim config"
rm -rf ./config/nvim/*
cp -r ~/.config/nvim/* ./config/nvim/


