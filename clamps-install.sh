#!/bin/bash
pushd .
mkdir -p $HOME/.emacs.d/
echo "copying emacsd to ~/.emacs.d/"
cp -Rv emacsd/* $HOME/.emacs.d/
echo "copying sbclrc to ~/.sbclrc"
cp -f sbclrc ~/.sbclrc
echo "copying cminit.lisp to ~/.cminit.lisp"
cp -f cminit.lisp ~/.cminit.lisp
echo "copying incudinerc to ~/.incudinerc"
cp -f incudinerc ~/.incudinerc
mkdir -p $HOME/.config/common-lisp
cd $HOME/.config/common-lisp
if [ ! -d "cltl2-docs" ]; then
    echo "downloading cltl2 to ~/.config/common-lisp/cltl2-docs"
    git clone https://github.com/ormf/cltl2-docs
fi
popd
sbcl --noinform --non-interactive --load quicklisp.lisp --eval \
        '(quicklisp-quickstart:install :path "~/quicklisp/")' && \
sbcl --noinform --non-interactive --load ~/quicklisp/setup.lisp --eval \
        '(ql-util:without-prompting (ql:add-to-init-file))'
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
