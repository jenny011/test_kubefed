# !/bin/bash

# cocktail
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
conda install -c conda-forge cupy nccl cudatoolkit=11.8

pip install transformers==4.21.1
pip install datasets
pip install netifaces
pip install zstandard
pip install wandb

git clone https://github.com/DS3Lab/CocktailSGD.git ~/CocktailSGD