FROM ubuntu:18.04 as proper
LABEL maintainer="FengZijian <fzjalfred@gmail.com>"

# base
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y  && apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    ca-certificates openssl \
    gnupg \
    curl &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# development
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    curl "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    apt-get update && apt-get install -y \
    xterm tmux iputils-clockdiff ptpd ntp ntpdate vim iputils-ping nginx aptitude gitg meld net-tools wget git sudo zsh unzip zip screen \
    gcc gdb cppcheck libboost-all-dev cmake libxss1 \
    code &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# python3
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3 && \
    apt-get install -y python3-setuptools  python3-pip
    
#set user
RUN adduser fzjalfred --gecos "" --disabled-password && \
    echo "abcd\nabcd" | passwd fzjalfred && \
    chsh -s /bin/zsh fzjalfred && \
    adduser fzjalfred sudo && \
    mkdir fzjalfred && \
    chown -R fzjalfred:fzjalfred fzjalfred && \
    su fzjalfred

RUN echo 'alias python='/usr/bin/python3'' >>/home/fzjalfred/.bashrc && \
    echo 'alias pip='/usr/bin/pip3'' >>/home/fzjalfred/.bashrc && \
    /bin/bash -c "source /home/fzjalfred/.bashrc"

RUN pip install aiohttp

# huobi_api install
COPY . /home/fzjalfred/huobi_python
RUN cd /home/fzjalfred/huobi_python && \
    python3 setup.py build && \
    python3 setup.py install && \
    cd .. && \
    rm -rf huobi_python


VOLUME ["/home/fzjalfred/huobi_python"]
USER fzjalfred
WORKDIR /home/fzjalfred
CMD "/bin/bash"