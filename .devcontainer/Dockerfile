FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ARG REMOTE_USER
ARG REMOTE_UID
ARG REMOTE_GID

RUN apt-get update -y && apt-get install -y grep nano git sudo build-essential cmake ghdl-mcode gtkwave gdb zip

RUN groupadd --gid $REMOTE_GID $REMOTE_USER && \
    useradd --uid $REMOTE_UID --gid $REMOTE_GID -m $REMOTE_USER -s /bin/bash && \
    echo $REMOTE_USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$REMOTE_USER && \
    chmod 0440 /etc/sudoers.d/$REMOTE_USER 
