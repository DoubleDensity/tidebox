FROM fedora

MAINTAINER Buttetsu Batou <doubledense@gmail.com>

# Install deps and audio tools

RUN dnf groupinstall -y "C Development Tools and Libraries"
RUN dnf install -y git tree zsh wget vim man sudo
RUN dnf install -y libsndfile-devel libsamplerate-devel liblo-devel jack-audio-connection-kit-devel alsa-lib-devel xz htop grep procps-ng yasm screen
RUN dnf install -y cabal-install ghc-Cabal-devel

# Install editor
RUN dnf -y install emacs emacs-haskell-mode

# Install Dirt synth
WORKDIR /repos
RUN git clone --recursive https://github.com/tidalcycles/Dirt.git
WORKDIR Dirt
RUN make install

# Install ffmpeg
WORKDIR /repos
RUN git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
WORKDIR ffmpeg
RUN ./configure --enable-indev=jack --enable-nonfree --prefix=/usr
RUN make install

# Pull Tidal Emacs binding
RUN mkdir /repos/tidal
WORKDIR /repos
WORKDIR tidal
RUN wget https://raw.github.com/yaxu/Tidal/master/tidal.el

COPY app /app
COPY tidal/hello.tidal /repos/tidal/hello.tidal

# Setup home environment
RUN useradd dev -s /bin/zsh

RUN echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

VOLUME /repos
RUN chown -R dev:dev /repos

VOLUME /logs
RUN chown -R dev:dev /logs

ENV HOME /home/dev
WORKDIR /home/dev
COPY configs/emacsrc /home/dev/.emacs
COPY configs/screenrc /home/dev/.screenrc
COPY configs/ffserver.conf /repos/ffserver.conf

RUN ln -s /repos /home/dev/repos

USER dev

# Install Tidal
RUN cabal update
RUN cabal install tidal

RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Expose port for ffserver streaming
EXPOSE 8090

ENTRYPOINT /bin/zsh