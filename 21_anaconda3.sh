#--------------------------------------------------------------------------------------------------
# get environment variables
. environment

#--------------------------------------------------------------------------------------------------
# Download Installer
curl -o   $ANACONDA_INSTALLER -L 'https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh'

#--------------------------------------------------------------------------------------------------
rm -rf     $ANACONDA_HOME
mkdir      $ANACONDA_HOME
chown user $ANACONDA_HOME
chgrp work $ANACONDA_HOME
chmod g+w  $ANACONDA_HOME

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0") installed"
) >>$INSTALLED_SOFTWARE