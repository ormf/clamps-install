#!/bin/bash
#
# Installation script for clamps into a working
# emacs/sbcl/sly/quicklisp setup.
#
pushd .
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    pip3 install --update pip
    pip3 install python-osc
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "installing python-osc into Inkscape."
    cd /Applications/Inkscape.app/Contents/Frameworks/Python.framework/Versions/Current/bin
    ./python3 -m pip --update pip
    ./python3 -m pip install python-osc
fi
cd /tmp/clamps-install
echo "copying inkscape extension to ~/.config/inkscape"
mkdir -p $HOME/.config/inkscape/extensions/
cp inkscape-play-selection/* $HOME/.config/inkscape/extensions/
pushd .
if [ -d $HOME/.emacs.d ]; then
    echo "$HOME/.emacs.d exists, aborting"
    exit 1
fi
mkdir -p $HOME/.emacs.d/
echo "copying emacs.d to ~/.emacs.d/"
cp -Rv emacs.d/* $HOME/.emacs.d/
# echo "copying sbclrc to ~/.sbclrc"
# cp -f sbclrc ~/.sbclrc
if [ -d $HOME/.cminit.lisp ]; then
    echo "$HOME/.cminit.lisp exists, aborting"
    exit 1
fi
echo "copying cminit.lisp to ~/.cminit.lisp"
cp -f cminit.lisp ~/.cminit.lisp
if [ -d $HOME/.incudinerc ]; then
    echo "$HOME/.incudinerc exists, aborting"
    exit 1
fi
echo "copying incudinerc to ~/.incudinerc"
cp -f incudinerc ~/.incudinerc
mkdir -p $HOME/.config/common-lisp
cd $HOME/.config/common-lisp
if [ ! -d "cltl2" ]; then
    echo "downloading cltl2 to ~/.config/common-lisp/cltl2"
    git clone https://github.com/ormf/cltl2-docs
fi
mv cltl2-docs cltl2
popd
sbcl --noinform --non-interactive --eval '(ql:quickload :clhs)'
cp $HOME/quicklisp/dists/quicklisp/software/clhs-*/clhs-use-local.el $HOME/quicklisp/
cd $HOME/quicklisp/local-projects
echo "downloading incudine..."
git clone https://github.com/titola/incudine.git
echo "downloading cm"
git clone https://github.com/ormf/cm
echo "downloading fomus..."
git clone https://github.com/ormf/fomus
echo "downloading ats-cuda..."
git clone https://github.com/ormf/ats-cuda
echo "downloading clamps..."
git clone https://github.com/ormf/clamps
