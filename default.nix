{
  pkgs ? import <nixpkgs> {}
}:

let
  kernels = [ 
    pkgs.python37Packages.ansible-kernel 
  ];
  additionalExtensions = [
    "@jupyterlab/toc"
    "jupyterlab-drawio"
    "jupyterlab-emacskeys"
  ];
in 

with import <nixpkgs> {};
  stdenv.mkDerivation rec { # new boilerplate
  name = "simpleEnv";

  buildInputs = [
    python37

    python37Packages.pip
    python37Packages.virtualenv
    python37Packages.pylint
    python37Packages.flake8
    python37Packages.jupyterlab
    python37Packages.opencv3
    python37Packages.scikitlearn
    python37Packages.scipy
    python37Packages.matplotlib
    python37Packages.pytorchWithCuda
    python37Packages.torchvision
    
    pkgs.pipenv
    pkgs.nodejs
  ];

  shellHook = ''
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      virtualenv --no-setuptools $PWD/.venv
      export PATH=$PWD/.venv/bin:$PATH

      export PIPENV_VENV_IN_PROJECT=1
      export JUPYTER_PATH="${pkgs.lib.concatMapStringsSep ":" (p: "${p}/share/jupyter/") kernels}"
      export PYTHONPATH=venv/lib/python3.7/site-packages/:$PYTHONPATH
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit_10_1}/lib:${pkgs.cudnn_cudatoolkit_10_1}/lib:${pkgs.cudatoolkit_10_1.lib}/lib:$LD_LIBRARY_PATH

      pipenv install
    '';   
}


  /*    export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      virtualenv --no-setuptools $PWD/.venv
      export PATH=$PWD/.venv/bin:$PATH
      export PIPENV_VENV_IN_PROJECT=1
      pip install --upgrade pip
      pip install --upgrade pipenv
      pipenv sync --dev

      TEMPDIR=".jupyter"
      mkdir -p $TEMPDIR
      cp -r ${pkgs.python38Packages.jupyterlab}/share/jupyter/lab/* $TEMPDIR
      chmod -R 755 $TEMPDIR
      echo "$TEMPDIR is the app directory"

      export JUPYTER_PATH="${pkgs.lib.concatMapStringsSep ":" (p: "${p}/share/jupyter/") kernels}"
      export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit_10_1}/lib:${pkgs.cudnn_cudatoolkit_10_1}/lib:${pkgs.cudatoolkit_10_1.lib}/lib:$LD_LIBRARY_PATH */
