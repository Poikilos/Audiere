#!/bin/sh

HHC="C:/Program Files/HTML Help Workshop/hhc"

hhc_path=$(command -v chmcmd)
chmcmd_path=$(command -v chmcmd)

if [ -f "$hhc_path" ]; then
  HHC="$hhc_path"
else
  if [ -f "$chmcmd_path" ]; then
    HHC="$chmcmd_path"
  fi
fi

die() {
    echo "Aborting..."
    exit 1
}

archive() {
    VERSION=1.10.1
    AUDIENCE=$1
    BASE=audiere-$VERSION-$AUDIENCE-doxygen

    rm -rf "$AUDIENCE" || die
    doxygen audiere-$AUDIENCE.doxy || die
    (cd "$AUDIENCE" && \
     cp -r html $BASE && \
     zip -r -q ../$BASE.zip $BASE && \
     tar cfj ../$BASE.tar.bz2 $BASE) || die
  if [ -f "$HHC" ]; then
    (cd $AUDIENCE/html && "$HHC" index.hhp)
    mv $AUDIENCE/html/index.chm $BASE.chm || die
  else
    echo "Compiling help FAILED since could not find a hhp (HTML Help Workshop project) compiler (such as hhc or chmcmd).";
  fi
}

archive users
archive devel
