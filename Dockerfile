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

RUN echo "root:password" | chpasswd

# Create user
RUN    groupadd work            --gid 1000 \
    && adduser  user --uid 1000 --gid 1000 --home /HOME --disabled-password --gecos User

# Setup sudo
RUN echo "%user	ALL=(ALL:ALL) NOPASSWD:ALL"  >/etc/sudoers.d/user
RUN echo "%work	ALL=(ALL:ALL) NOPASSWD:ALL"  >/etc/sudoers.d/group

#--------------------------------------------------------------------------------------------------
FROM builder as manim

RUN apt-get install --yes libcairo2-dev libpango1.0-dev ffmpeg
RUN pip3 install manim 

#--------------------------------------------------------------------------------------------------
FROM manim as anaconda_download

ARG INSTALLER=/tmp/installer.sh
RUN curl -o $INSTALLER -L 'https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh'

#--------------------------------------------------------------------------------------------------
ARG ANACONDA3=/opt/anaconda3

FROM anaconda_download as anaconda_install
RUN mkdir      $ANACONDA3
RUN chown user $ANACONDA3

USER user

RUN  bash $INSTALLER -b -u -p $ANACONDA3

#--------------------------------------------------------------------------------------------------
FROM anaconda_install as user

USER user
WORKDIR /home/user

RUN echo '\nPATH=$PATH:/home/user/.local/bin' >>$HOME/.bashrc

#
CMD ["bash"]
