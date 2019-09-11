#!/bin/bash

python3 -m venv $1/env
source $1/env/bin/activate
python3 -m pip install -r $1/requirements.txt
rm -fr $1/env/lib/python3.7/site-packages/*.dist-info
cp $1/$2 $1/env/lib/python3.7/site-packages