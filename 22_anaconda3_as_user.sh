#--------------------------------------------------------------------------------------------------
# get environment variables
. .env

#--------------------------------------------------------------------------------------------------
mkdir -p $HOME/.local/bin
bash $ANACONDA_INSTALLER -b -u -p $ANACONDA_HOME

PATH=$PATH:$ANACONDA_HOME/bin
echo "\nPATH=$PATH:$ANACONDA_HOME/bin"  >>$HOME/.bashrc

conda init bash

#
rm  $HOME/.jupyter/jupyter_notebook_config.py
jupyter notebook --generate-config
sed -i '1,$s/.*NotebookApp.notebook_dir.*/c.NotebookApp.notebook_dir="\/notebooks"/g'  $HOME/.jupyter/jupyter_notebook_config.py

echo "$ANACONDA_HOME/bin/jupyter notebook --no-browser --ip='*' --NotebookApp.token='' --NotebookApp.password=''" >$HOME/.local/bin/run_jupyter
chmod +x $HOME/.local/bin/run_jupyter

#RUN python3 -m pip install manim jupyter-manim

# Jupyter Extensions
(echo 'using Pkg'; echo 'Pkg.add("IJulia")') | julia

# Javascript Extensions
ijsinstall

#--------------------------------------------------------------------------------------------------
(
    echo "$(basename "$0") installed"
) >>$INSTALLED_SOFTWARE
