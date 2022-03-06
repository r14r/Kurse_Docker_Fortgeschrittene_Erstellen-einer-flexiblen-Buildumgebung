#--------------------------------------------------------------------------------------------------
# get environment variables
. .env

#--------------------------------------------------------------------------------------------------
groupadd $GRP_NAME             --gid 1000
adduser  $USR_NAME  --uid 1000 --gid 1000 --home $USR_HOME --disabled-password --gecos User

#--------------------------------------------------------------------------------------------------
# Setup sudo
echo "%$GRP_NAME ALL=(ALL:ALL) NOPASSWD:ALL"  >/etc/sudoers.d/group

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0"):"
    echo "- add user 'user' and group 'work'"
    echo "- allow sudo for 'user'"
) >>$INSTALLED_SOFTWARE