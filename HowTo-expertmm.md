
## Official How-tos
see <https://github.com/expertmm/Audiere/blob/master/examples/simple/simple.cpp>
and <https://github.com/expertmm/Audiere/blob/master/doc/faq.txt>
such as
"The OpenSound function has two modes of operation.  If the third
  argument 'streaming' is true, it just streams audio from the source.
  If 'streaming' is passed as false, it tries to load the sound into
  memory.  You probably want streaming to be true for background
  music, but false for sound effects."
and <https://github.com/expertmm/Audiere/blob/master/doc/overview.txt>
and <https://github.com/expertmm/Audiere/blob/master/doc/tutorial.txt>

## Compiling on Windows with MSVC in 32-bit and 64-bit
* You should probably use scons under cygwin (correct me if I'm wrong).
* see MSVC 32-bit/64-bit builds at: https://github.com/SethRobinson/Audiere (eventually those changes will be merged into this fork hopefully)

see also README.md at https://github.com/expertmm/Audiere

## libtool (as opposed to scons)
### recommended for cross-platform building since:
* .so file gets named and installed into your system properly
* audiere-config gets installed so your project doesn't need manual linker flags, just `audiere-config -libs` which generates the flags for you

### How to compile and install:
* First install all your build tools used below
* Open terminal
* cd to wherever you put the project such as `cd $HOME/Documents/GitHub/Audiere`
* Paste the commands below into terminal (excluding triple grave accents if you are using a text editor that sees them):
  (these steps are needed until proper autoconf data is added to repo)
	* Before you try the commands below, consider running `full-release.sh` instead.
```
./bootstrap
./configure
make
sudo make install
```

## Code::Blocks How-to
Building a project that depends on audiere, using Code::Blocks:
Project, Build options, Linker settings, Other linker options: add `audiere-config --libs` including grave accents

