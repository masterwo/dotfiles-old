#!/bin/bash
################################################################################
## Global variables
################################################################################
# Always create backup of old dotfile in target directory
NO_BACKUP=false

# backupfile 
BACKUP_FILE="dotfiles.backup.tgz"

# Verbose (default is 0)
VERBOSE=false

# TARGET (default is $HOME)
TARGET=$HOME 

# DOTFILE_DIR (is this directory)
DOTFILE_DIR=$(pwd)

# All .* files except .git
DOTFILES=($(ls -A | grep "^\..*" | grep -v ".git\b"))

# BACKUP_FILE_ARR (files to backup)
BACKUP_FILE_ARR=($(ls -A $TARGET | grep "^\..*")) # Get all dotfiles
BACKUP_FILE_ARR=($(comm -1 -2 \
    <(printf '%s\n' "${DOTFILES[@]}") \
    <(printf '%s\n' "${BACKUP_FILE_ARR[@]}")))

################################################################################
## Functions
################################################################################
function show_help {
    echo "  "
    echo "  DOTFILES(install.sh):"
    echo "    "
    echo "    Installs the dotfiles while preserving your previous dotfile-setup by"
    echo "    creating a $BACKUP_FILE of your old settnigs."
    echo "    "
    echo "    -v [Verbose]"
    echo "    -t [Target] is $HOME by default"
    echo "    -U [Uninstall] removes installed files and restore your settings from"
    echo "    the $BACKUP_FILE"
    echo "  "
}
function install {
   
    cd $TARGET

    if ! $NO_BACKUP; then # Skip the following if NO_BACKUP flag is enabled
	# Existing backup indicates that the dotfiles are already setup.
	# In that case don't do anything and exit setup.
	if [ -f $TARGET/dotfiles.backup.tgz ]; then
	    echo "dotfile-project is already install."
	    exit 0
	fi
	
	# Create a backup of all the current .* files that will be replaced
	echo "  " >&3
	echo "  Creating $BACKUP_FILE of dotfiles:" >&3
	printf '    %s\n' "${BACKUP_FILE_ARR[@]/#/$TARGET/}" >&3

	tar -cpzf $BACKUP_FILE "${BACKUP_FILE_ARR[@]}"
    fi

    # Remove all the files that we just did(or didn't) backup.
    echo "  " >&3
    echo "  Removing old dotfiles:" >&3
    printf '    %s\n' "${BACKUP_FILE_ARR[@]/#/$TARGET/}" >&3

    rm -f "${BACKUP_FILE_ARR[@]}"

    # Create symbolic links in target directory to all .* files in repository.
    echo "  " >&3
    echo "  Linking to new dotfiles:" >&3
    printf '    %s\n' "${DOTFILES[@]}" >&3
    for file in ${DOTFILES[@]}; do
	echo "linking: .${DOTFILE_DIR#$TARGET}/$file" >&3
	ln -s ".${DOTFILE_DIR#$TARGET}/$file"
    done
    
    # List all newly created symbolic links in the target directory
    ls -a "${DOTFILES[@]}" >&3
    
    # Setup complete!
    echo "  " >&3
    echo "  Setup complete!" >&3
}
function uninstall {

    cd $TARGET
    rm -f "${DOTFILES[@]}"

    if [ -f $BACKUP_FILE ]; then
	tar -xpf $BACKUP_FILE
	echo "Your old dotfiles are restored"
    fi
    echo "Uninstall complete!"
}


################################################################################
## Handle scripts parameter(s)/operator(s)
################################################################################
while getopts "hvt:UB" opt; do
    case "$opt" in
	h)
	    show_help
	    exit 0
	    ;;
	v) VERBOSE=true
	    ;;
	t) TARGET=$OPTARG
	    ;;
	B) NO_BACKUP=true
	    ;;
	U) 
	    uninstall
	    exit 0
	    ;;
	esac
done

################################################################################
## Redirections for output (for verbose messages)
################################################################################
if [ "$VERBOSE" = true ]; then
    exec 4>&2 3>&1
else
    exec 4>/dev/null 3>/dev/null
fi


################################################################################
## Run the install/setup
################################################################################
install

