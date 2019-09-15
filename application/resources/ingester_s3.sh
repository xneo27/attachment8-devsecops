#!/bin/bash

python3 -m venv $1/env
source $1/env/bin/activate
python3 -m pip install -r $1/requirements.txt
rm -fr $1/env/lib/python3.7/site-packages/*.dist-info
if [ ! -f $1/ingester.yaml ]; then
  # Generate the file
  cat > $1/ingester.yaml <<EOL
elasticsearch:
  host: https://$2:443
  index: actors
actors:
  file: actor.json
aws:
  region: $3
  bucket: $4
EOL
fi
rsync -av --progress --exclude="env" --exclude=".git" $1 $1/env/lib/python3.7/site-packages
