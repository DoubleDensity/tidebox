FROM fedora

MAINTAINER Buttetsu Batou <doubledense@gmail.com>

# Install dependencies and audio tools

RUN dnf groupinstall -y "C Development Tools and Libraries"
RUN dnf install -y git zsh wget man sudo
RUN dnf install -y libsndfile-devel libsamplerate-devel liblo-devel jack-audio-connection-kit-devel jack-audio-connection-kit-example-clients alsa-lib-devel xz htop grep procps-ng yasm screen
RUN dnf install -y cabal-install ghc-Cabal-devel

# Install editor
RUN dnf -y install emacs-nox emacs-haskell-mode

# Build Dirt synth
WORKDIR /repos
RUN git clone --recursive https://github.com/tidalcycles/Dirt.git
WORKDIR Dirt
RUN make

# Build & Install libmp3lame
WORKDIR /repos
RUN git clone https://github.com/rbrito/lame.git
WORKDIR lame
RUN ./configure --prefix=/usr
RUN make install
WORKDIR /repos
RUN rm -fr lame

# Build & Install ffmpeg, ffserver
WORKDIR /repos
RUN git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
WORKDIR ffmpeg
RUN ./configure --enable-indev=jack --enable-libmp3lame --enable-nonfree --prefix=/usr
RUN make install
WORKDIR /repos
RUN rm -fr ffmpeg

# Expose port for ffserver streaming
EXPOSE 8090

# Pull Tidal Emacs binding
RUN mkdir /repos/tidal
WORKDIR /repos
WORKDIR tidal
RUN wget https://raw.github.com/yaxu/Tidal/master/tidal.el

# Setup home environment
RUN useradd tidal -s /bin/zsh

RUN echo "tidal ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Volume for source repos and building
VOLUME /repos
RUN chown -R tidal:tidal /repos

# Volume for Tidal files, etc.
VOLUME /work
RUN chown -R tidal:tidal /work

USER tidal

ENV HOME /home/tidal
WORKDIR /home/tidal

RUN ln -s /repos /home/tidal/repos
RUN ln -s /work /home/tidal/work

# Install Tidal
RUN cabal update
RUN cabal install tidal

# Install startup scripts & default configurations
COPY scripts /home/tidal/scripts

COPY configs/emacsrc /home/tidal/.emacs
COPY configs/screenrc /home/tidal/.screenrc
COPY configs/ffserver.conf /home/tidal/ffserver.conf
COPY configs/zshrc /home/tidal/.zshrc

COPY tidal/hello.tidal /home/tidal/work/hello.tidal

ENTRYPOINT /bin/zsh