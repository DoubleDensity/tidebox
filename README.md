# Tidebox

[![Docker Repository on Quay](https://quay.io/repository/doubledensity/tidebox/status "Docker Repository on Quay")](https://quay.io/repository/doubledensity/tidebox)

> A complete Tidal musical live coding and audio streaming environment inside Docker

Run Tidal on any available compute node and stream the output to any target. No sound hardware or elevated permissions are required on the Docker host.
This allows for the use of very-low end hardware to control and compose the session while harnessing greater resources on remote hosts, clusters and public cloud infrastructure.

Many thanks to Tidal and the entire live coding community for making such exciting and fun software!

## Getting started

First you will want to start the container:
  
    docker run -it --net=host quay.io/doubledensity/tidebox

This container should be run in interactive terminal mode with `-it` mode so that you can interact with the Emacs session, although it is not a requirement. 
You do not need to use `--net=host` either although it may make it easier for you to reach the stream from a remote host depending on your Docker networking setup.

![Tidebox demo](demo.gif)

Then you can connect to it with any media player which supports streaming mp3 such as VLC, iTunes, MPlayer, mpg123, etc. 

Here is an example with MPlayer: 
    
    mplayer http://localhost:8090/stream.mp3
    
By default it will start to play a test Tidal audio sequence automatically within approximately ten seconds after the container has launched so you can verify audio connectivity.

## Controls

The various components of Tidebox are running in separate windows within the GNU Screen terminal window manager, and should initialize automatically. 

The Emacs Tidal environment is the default screen (0), but you can find the additional components JACK, Dirt, ffmpeg, and ffserver on windows 1-4.

Window 5 is currently set aside as an interactive shell for working with and managing Tidal files or anything else you may wish to pull down or manipulate for use in your session.

You can switch between the Screen windows using `CTRL-,` and `CTRL-.` forward and backward, or `CTRL-A` followed by the default window numbers 1-5. 

## References

- [Tidal](http://tidal.lurk.org)
- [Dirt synth](https://github.com/tidalcycles/Dirt)
- [JACK Audio Connection Kit](http://www.jackaudio.org/)
- [FFmpeg](https://www.ffmpeg.org/)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [GNU Screen](https://www.gnu.org/software/screen/)
- [TOPLAP The Home of Live Coding](http://toplap.org/)