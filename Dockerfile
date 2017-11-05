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

# VS Code
WORKDIR /tmp
RUN apt-get install -y apt-transport-https && \
    wget -O - https://code.headmelted.com/installers/apt.sh > install-vscode.sh && \
    chmod +x install-vscode.sh && \
    ./install-vscode.sh &&\
    rm install-vscode.sh
RUN touch /usr/local/bin/code-oss-as-root && \
    echo "#!/bin/bash" >> /usr/local/bin/code-oss-as-root && \
    echo "code-oss --user-data-dir=\"~/\" \$@" >> /usr/local/bin/code-oss-as-root && \
    chmod +x /usr/local/bin/code-oss-as-root

WORKDIR /root
CMD ["/bin/bash"]
