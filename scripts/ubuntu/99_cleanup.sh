#--------------------------------------------------------------------------------------------------
# get environment variables
. environment

#--------------------------------------------------------------------------------------------------
apt-get autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0") installed"
) >>$INSTALLED_SOFTWARE