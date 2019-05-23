FROM blang/latex:ctanbasic

# https://tug.org/texlive/upgrade.html
RUN mv -f /usr/local/texlive/2017 /usr/local/texlive/2019
RUN ln -s /usr/local/texlive/2019 /usr/local/texlive/2017
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh -O /tmp/update-tlmgr-latest.sh
RUN sh /tmp/update-tlmgr-latest.sh -- --upgrade
RUN tlmgr update --self --all
RUN tlmgr install minted

RUN apt update -q
RUN apt install -qy \
	pandoc pandoc-citeproc \
	make build-essential libssl-dev zlib1g-dev libbz2-dev \
	libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
	xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

RUN rm -rf /var/lib/apt/lists/*
RUN useradd -m appuser
RUN WORKDIR /home/appuser
RUN USER appuser
RUN ENV HOME /home/appuser
RUN ENV PYENV_ROOT /home/appuser/.pyenv
RUN ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
RUN pyenv install 3.6.8
RUN pyenv global 3.6.8
RUN pyenv rehash
