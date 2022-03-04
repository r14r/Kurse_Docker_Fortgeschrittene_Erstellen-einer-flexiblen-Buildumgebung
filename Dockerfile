#--------------------------------------------------------------------------------------------------
FROM ubuntu:latest as builder

ENV TZ 'Europe/Berlin'

RUN echo $TZ > /etc/timezone 

RUN    apt-get update                                       \
    && apt-get install -y tzdata                            \
    && rm /etc/localtime                                    \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime       \
    && dpkg-reconfigure -f noninteractive tzdata            \
    && apt-get clean

RUN apt-get install --yes build-essential lsb-release curl sudo vim python3-pip
#RUN python3 install --upgrade pip

#
RUN echo "root:password" | chpasswd

#--------------------------------------------------------------------------------------------------
# Create user
ARG USER_NAME=user
ARG USER_HOME=/home/user

RUN    groupadd work            --gid 1000 \
    && adduser  user --uid 1000 --gid 1000 --home $USER_HOME --disabled-password --gecos User

#--------------------------------------------------------------------------------------------------
# Setup sudo
RUN echo "%work	ALL=(ALL:ALL) NOPASSWD:ALL"  >/etc/sudoers.d/group

#--------------------------------------------------------------------------------------------------
FROM builder as manim_install

RUN apt-get install --yes libcairo2-dev libpango1.0-dev ffmpeg
RUN pip3 install manim 

#--------------------------------------------------------------------------------------------------
FROM manim_install as julia_download

ARG INSTALLER=/tmp/installer.tar.gz
RUN curl -o  $INSTALLER -L 'https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz'

#--------------------------------------------------------------------------------------------------
FROM julia_download as julia_install

ARG JULIA172=/opt/julia-1.7.2
RUN tar xvfz $INSTALLER -C /opt
RUN chown user $JULIA172
RUN chgrp work $JULIA172
RUN chmod g+w  $JULIA172

#--------------------------------------------------------------------------------------------------
FROM julia_install as anaconda_download

ARG INSTALLER=/tmp/installer.sh
RUN curl -o   $INSTALLER -L 'https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh'

#--------------------------------------------------------------------------------------------------
FROM anaconda_download as anaconda_install

ARG ANACONDA3=/opt/anaconda3
RUN mkdir      $ANACONDA3
RUN chown user $ANACONDA3
RUN chgrp work $ANACONDA3
RUN chmod g+w  $ANACONDA3

#--------------------------------------------------------------------------------------------------
USER user

RUN mkdir -p $USER_HOME/.local/bin
RUN bash $INSTALLER -b -u -p $ANACONDA3

#
RUN $ANACONDA3/bin/jupyter notebook --generate-config
RUN sed -i '1,$s/.*NotebookApp.notebook_dir.*/c.NotebookApp.notebook_dir="\/notebooks"/g'  $USER_HOME/.jupyter/jupyter_notebook_config.py

#
RUN echo "$ANACONDA3/bin/jupyter notebook --no-browser --ip='*' --NotebookApp.token='' --NotebookApp.password=''" >>$USER_HOME/.local/bin/run_jupyter
RUN chmod +x $USER_HOME/.local/bin/run_jupyter

# Jupyter Extensions
RUN (echo 'using Pkg'; echo 'Pkg.add("IJulia")') | $JULIA172/bin/julia

#--------------------------------------------------------------------------------------------------
FROM anaconda_install as user

USER    $USER_NAME
WORKDIR $USER_HOME

RUN echo "\nPATH=$PATH:$USER_HOME/.local/bin:$ANACONDA3/bin:$JULIA172/bin" >>$HOME/.bashrc

#
CMD ["bash"]
