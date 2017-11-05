FROM armv7/armhf-ubuntu:14.04

#Development Tools
RUN apt-get update && \
    apt-get install -y tmux \
                       wget zip unzip curl \
                       bash-completion git \
                       software-properties-common 
# Vim
RUN apt-get install -y  vim-nox && \
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh -o /tmp/install.sh
WORKDIR /tmp
RUN /bin/bash -c "sh ./install.sh" && \
    git clone https://github.com/tomasr/molokai && \
    mkdir -p ~/.vim/colors && \
    cp ./molokai/colors/molokai.vim ~/.vim/colors/
COPY .vimrc /root/.vimrc

# Tmux
WORKDIR /tmp
COPY .tmux.conf /root/.tmux.conf

# QtCreator
RUN apt-get update && apt-get install -y qtcreator

# Pycharm
RUN apt-get update && apt-get install -y openjdk-7-jdk
ADD pycharm-community-2017.2.4.tar.gz /opt
WORKDIR /opt
RUN mv pycharm-community-2017.2.4 pycharm-community && \
    touch /usr/local/bin/pycharm && \
    echo "#!/bin/bash" >> /usr/local/bin/pycharm-ros && \
    echo "bash -i -c \"/opt/pycharm-community/bin/pycharm.sh\" %f" >> /usr/local/bin/pycharm && \
    chmod u+x /usr/local/bin/pycharm


WORKDIR /root/catkin_ws
CMD ["/bin/bash"]
