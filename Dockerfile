#==================================================================================================
FROM ubuntu:latest as builder

#--------------------------------------------------------------------------------------------------
# 
#--------------------------------------------------------------------------------------------------
ADD environment environment

#--------------------------------------------------------------------------------------------------
# UBUNTU CORE
#--------------------------------------------------------------------------------------------------
FROM builder as ubuntu_core
ARG SCRIPT_PREPARE=00_prepare.sh
ADD ${SCRIPT_PREPARE}    /tmp/${SCRIPT_PREPARE}
RUN bash                 /tmp/${SCRIPT_PREPARE}

ARG SCRIPT_UBUNTU=01_ubuntu.sh
ADD ${SCRIPT_UBUNTU}    /tmp/${SCRIPT_UBUNTU}
RUN bash                /tmp/${SCRIPT_UBUNTU}

#--------------------------------------------------------------------------------------------------
# LOCAL USER
#--------------------------------------------------------------------------------------------------
ARG SCRIPT_ADD_USER=02_add_user.sh
ADD ${SCRIPT_ADD_USER}  /tmp/${SCRIPT_ADD_USER}
RUN bash                /tmp/${SCRIPT_ADD_USER}

#--------------------------------------------------------------------------------------------------
# NODEJS 
#--------------------------------------------------------------------------------------------------
FROM ubuntu_core as with_nodejs

ARG SCRIPT_NODEJS=10_nodejs.sh
ADD ${SCRIPT_NODEJS}    /tmp/${SCRIPT_NODEJS}
RUN bash                /tmp/${SCRIPT_NODEJS}

#--------------------------------------------------------------------------------------------------
# JULIA
#--------------------------------------------------------------------------------------------------
FROM with_nodejs as with_julia

ARG SCRIPT_JULIA=11_julia.sh
ADD ${SCRIPT_JULIA} /tmp/${SCRIPT_JULIA}
RUN bash            /tmp/${SCRIPT_JULIA}

#--------------------------------------------------------------------------------------------------
# ANACONDA3  with Julia Extensions
#--------------------------------------------------------------------------------------------------
FROM with_julia as with_anaconda

ARG SCRIPT_ANACONDA=21_anaconda3.sh
ADD ${SCRIPT_ANACONDA} /tmp/${SCRIPT_ANACONDA}
RUN bash               /tmp/${SCRIPT_ANACONDA}

#--------------------------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------------------------
FROM with_anaconda as with_anaconda_user
ARG SCRIPT_ANACONDA_USER=22_anaconda3_as_user.sh
ADD ${SCRIPT_ANACONDA_USER} /tmp/${SCRIPT_ANACONDA_USER}
RUN cat                     /tmp/${SCRIPT_ANACONDA_USER} | su user

#--------------------------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------------------------
FROM with_anaconda_user as with_cleanup

ARG SCRIPT_CLEANUP=99_cleanup.sh
ADD ${SCRIPT_CLEANUP} /tmp/${SCRIPT_CLEANUP}
RUN bash              /tmp/${SCRIPT_CLEANUP}

#==================================================================================================
USER    user
WORKDIR /home/user

#
CMD ["bash"]
