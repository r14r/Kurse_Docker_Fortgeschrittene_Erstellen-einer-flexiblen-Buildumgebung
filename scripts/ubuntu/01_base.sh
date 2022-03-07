#--------------------------------------------------------------------------------------------------
# get environment variables
. environment

#--------------------------------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
export TZ='Europe/Berlin'

echo $TZ > /etc/timezone 

apt-get update                                       
apt-get install --yes apt-utils

#
apt-get -y install tzdata

rm /etc/localtime
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

#
apt-get install --yes --no-install-recommends build-essential lsb-release curl sudo  python3-pip    && \
rm -rf /var/lib/apt/lists/* to same layer
#apt-get install --yes vim


#
echo "root:password" | chpasswd

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0"):"
    echo "- curl sudo vim python pip"
) >>$INSTALLED_SOFTWARE