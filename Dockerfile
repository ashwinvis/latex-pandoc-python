FROM blang/latex:ctanbasic

# https://tug.org/texlive/upgrade.html
RUN mv -f /usr/local/texlive/2017 /usr/local/texlive/2019
RUN ln -s /usr/local/texlive/2019 /usr/local/texlive/2017
#  RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh -O /tmp/update-tlmgr-latest.sh
ADD http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh /tmp/update-tlmgr-latest.sh
RUN sh /tmp/update-tlmgr-latest.sh -- --upgrade
RUN tlmgr update --self --all
RUN tlmgr install biblatex biber xcolor lineno etoolbox fvextra fancyvrb upquote ifplatform xstring framed caption outlines booktabs enumitem babel-swedish microtype csquotes logreq setspace type1cm minted epstopdf texliveonfly
RUN apt update -q
RUN apt install -qy \
	make build-essential libssl-dev zlib1g-dev libbz2-dev \
	libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
	xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
	ghostscript

ENV PANDOC_VERSION=2.7.2
RUN wget https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux.tar.gz -qO /tmp/pandoc.tar.gz
RUN wget https://github.com/jgm/pandoc/archive/$PANDOC_VERSION.tar.gz -qO /tmp/pandoc-archive.tar.gz
RUN tar -C /tmp/ -xf /tmp/pandoc.tar.gz
RUN tar -C /tmp/ -xf /tmp/pandoc-archive.tar.gz

RUN mkdir -p /usr/share/pandoc
WORKDIR /tmp/pandoc-$PANDOC_VERSION
RUN cp -R bin share /usr/
RUN cp -R data COPYRIGHT MANUAL.txt /usr/share/pandoc/

RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.4.1/linux-pandoc_2_7_2.tar.gz -qO /tmp/pandoc-crossref.tar.gz
RUN tar -C /usr/bin -xf /tmp/pandoc-crossref.tar.gz

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

# Root password for debugging
RUN echo root:rootpass | chpasswd

# RUN useradd -m appuser
# WORKDIR /home/appuser
# USER appuser
# ENV HOME /home/$USER
WORKDIR /root
USER root
ENV HOME /root

ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
RUN pyenv install 3.6.8
RUN pyenv global 3.6.8
RUN pyenv rehash
