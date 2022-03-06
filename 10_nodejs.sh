#--------------------------------------------------------------------------------------------------
# get environment variables
. .env

#--------------------------------------------------------------------------------------------------
curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
apt-get install --yes nodejs

#
npm -g update npm
npm -g install yarn npm-check-updates
npm -g install ijavascript

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0")"
    echo "- node $(node --version)"
    echo "- npm $(npm --version)"
    echo "- ncu $(ncu --version)"
) >>$INSTALLED_SOFTWARE