#--------------------------------------------------------------------------------------------------
# get environment variables
. .env

#--------------------------------------------------------------------------------------------------
curl -o  $JULIA_INSTALLER -L 'https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz'

tar xfz $JULIA_INSTALLER -C /opt

chown user $JULIA_HOME
chgrp work $JULIA_HOME
chmod g+w  $JULIA_HOME

PATH=$PATH:$JULIA_HOME/bin
echo "\nPATH=$PATH:$JULIA_HOME/bin"  >>$HOME/.bashrc

rm $JULIA_INSTALLER

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0"):"
    echo "- julia $(julia --version | awk '{print $3}')"
) >>$INSTALLED_SOFTWARE