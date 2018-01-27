#!/bin/sh

# give help if no arguments
if [ $# -ne 2 ]; then
  echo "syntax: $0 imagefile outputdir"
  exit 1
fi

INPUT_IMAGE="$1"
FOLDER=$2

mkdir -p ${FOLDER}

sips -z 20 20 "$INPUT_IMAGE" --out "${FOLDER}/Icon-20.png"
sips -z 40 40 "$INPUT_IMAGE" --out "${FOLDER}/Icon-20@2x.png"
sips -z 60 60 "$INPUT_IMAGE" --out "${FOLDER}/Icon-20@3x.png"

sips -z 29 29 "$INPUT_IMAGE" --out "${FOLDER}/Icon-29.png"
sips -z 58 58 "$INPUT_IMAGE" --out "${FOLDER}/Icon-29@2x.png"
sips -z 87 87 "$INPUT_IMAGE" --out "${FOLDER}/Icon-29@3x.png"

sips -z 40 40 "$INPUT_IMAGE" --out "${FOLDER}/Icon-40.png"
sips -z 80 80 "$INPUT_IMAGE" --out "${FOLDER}/Icon-40@2x.png"
sips -z 120 120 "$INPUT_IMAGE" --out "${FOLDER}/Icon-40@3x.png"

sips -z 60 60 "$INPUT_IMAGE" --out "${FOLDER}/Icon-60.png"
sips -z 120 120 "$INPUT_IMAGE" --out "${FOLDER}/Icon-60@2x.png"
sips -z 180 180 "$INPUT_IMAGE" --out "${FOLDER}/Icon-60@3x.png"

sips -z 76 76 "$INPUT_IMAGE" --out "${FOLDER}/Icon-76.png"
sips -z 152 152 "$INPUT_IMAGE" --out "${FOLDER}/Icon-76@2x.png"
