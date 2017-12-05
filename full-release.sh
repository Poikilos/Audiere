#!/bin/sh
#echo "This is probably broken, don't use it. See README.md instead"
#exit 2

die() {
    echo
    echo "Error, aborting..."
    exit 1
}


BASE=audiere-1.10.1

START_FILES=$(pwd)

GIT_URL=https://github.com/expertmm/Audiere.git


git_bin_path=$(command -v git)
if [ ! -f "$git_bin_path" ]; then
  echo "Release failed since git was not installed."
  exit 2
fi


##CLONE_PARENT is not needed since release folder is used instead
#CLONE_PARENT=../audiere-build-tmp
#if [ -d "$CLONE_PARENT" ]; then
#  rm -Rf "$CLONE_PARENT"
#fi
##mkdir "$CLONE_PARENT" 
#cp -Rf "$START_FILES" "$CLONE_PARENT"
#if [ ! -d "$CLONE_PARENT" ]; then
#  echo "FAILED since cannot create '$CLONE_PARENT'. Make sure you have permission."
#  exit 4
#fi
#cd $CLONE_PARENT

#export CVSROOT=`cat CVS/Root`
#echo
#echo "Using CVSROOT: $CVSROOT"
#echo

# enter 'release' directory
mkdir -p release || die
cd release || die

# 'files' is where all of the files to be uploaded go
FILES=files
mkdir -p $FILES || die


#formerly audiere folder name was used (literally instead of variable):
MASTER_FILES=audiere

#cvs_bin_path=$(command -v cvs)
#if [ -f "$cvs_bin_path" ]; then
# check out the base CVS repository
#rm -rf audiere || die
#cvs export -D now audiere || die
#mv audiere $MASTER_FILES
#fi
if [ -d $MASTER_FILES ]; then
  rm -Rf $MASTER_FILES
fi
git clone $GIT_URL
if [ -d Audiere ]; then 
  mv Audiere $MASTER_FILES
else
  echo "ERROR: release failed since git couldn't clone $GIT_URL"
  exit 3
fi



#cp -r $MASTER_FILES audiere-unix || die
UNIX_FILES=audiere-unix
if [ -d "$UNIX_FILES" ]; then
  rm -Rf "$UNIX_FILES"
fi
#cp -r $MASTER_FILES audiere-doxygen || die
DOXYGEN_FILES=audiere-doxygen
if [ -d "$DOXYGEN_FILES" ]; then
  rm -Rf "$DOXYGEN_FILES"
fi
cp -r "$MASTER_FILES" "$UNIX_FILES" || die
cp -r "$MASTER_FILES" "$DOXYGEN_FILES" || die
echo
echo "Building binary release..."
case `uname` in
    CYGWIN*)
        echo "Platform: Win32"
        cp -r $MASTER_FILES audiere-win32 || die
        (cd audiere-win32 && ./make-release-win32.sh) || die
        cp audiere-win32/dist/$BASE-win32.zip "$FILES" || die
        ;;

    IRIX*)
        echo "Platform: SGI"
        cp -r $MASTER_FILES audiere-sgi || die
        (cd audiere-sgi && ./make-release-sgi.sh) || die
        cp audiere-sgi/dist/$BASE-sgi.tar.gz "$FILES" || die
        ;;

    *)
        echo "WARNING: Unknown platform, not building binary release"
        ;;
esac

echo
echo "Building UNIX release..."
echo

(cd "$UNIX_FILES" && ./bootstrap && ./configure && make dist) || die
cp "$UNIX_FILES/$BASE.tar.gz" "$FILES" || die

echo
echo "Building Doxygen release..."
echo

(cd $DOXYGEN_FILES/doc/doxygen && ./doxygen-dist.sh) || die
if [ -f "$DOXYGEN_FILES/doc/doxygen/$BASE-users-doxygen.chm" ]; then
  cp $DOXYGEN_FILES/doc/doxygen/$BASE-users-doxygen.chm     "$FILES" || die
fi
cp $DOXYGEN_FILES/doc/doxygen/$BASE-users-doxygen.zip     "$FILES" || die
cp $DOXYGEN_FILES/doc/doxygen/$BASE-users-doxygen.tar.bz2 "$FILES" || die
if [ -f "$DOXYGEN_FILES/doc/doxygen/$BASE-devel-doxygen.chm" ]; then
  cp $DOXYGEN_FILES/doc/doxygen/$BASE-devel-doxygen.chm     "$FILES" || die
fi
cp $DOXYGEN_FILES/doc/doxygen/$BASE-devel-doxygen.zip     "$FILES" || die
cp $DOXYGEN_FILES/doc/doxygen/$BASE-devel-doxygen.tar.bz2 "$FILES" || die

echo
echo "Building source release..."
echo

tar cfvj "$FILES/$BASE-src.tar.bz2" $MASTER_FILES
