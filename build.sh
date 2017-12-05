#!/bin/sh
#cd "`dirname \"$0\"`"
echo "WARNING: Using scons doesn't add version nor install (which is normal for Windows). Consider using full-release.sh instead for cross-platform build."
C:/Python26/python.exe third-party/scons.py
