#!/bin/sh
#cd "`dirname \"$0\"`"
echo "WARNING: Using scons doesn't add version nor install (which is normal for Windows). Consider using full-release.sh instead for cross-platform build."
this_python2_path=C:/Python26/python.exe
if [ ! -f "$this_python2_path" ]; then
  if [ -f "C:/Python26/python.exe" ]; then
    this_python2_path="C:/Python27/python.exe"
  fi
fi
if [ -f "$this_python2_path" ]; then
  "$this_python2_path" third-party/scons.py
else
  echo "Build using scons failed since expected cygwin on Windows where python 2.6 or 2.7 is installed so as to provide an executable path such as $this_python2_path"
fi
