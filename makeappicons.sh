#!/bin/sh

INPUT_IMAGE="$1"
FOLDER=$2

mkdir -p ${FOLDER}

sips -z 57 57 "$INPUT_IMAGE" --out "${FOLDER}/Icon.png"
sips -z 114 114 "$INPUT_IMAGE" --out "${FOLDER}/Icon@2x.png"
sips -z 120 120 "$INPUT_IMAGE" --out "${FOLDER}/Icon-60@2x.png"
sips -z 29 29 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small.png"
sips -z 58 58 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small@2x.png"
sips -z 40 40 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small-40.png"
sips -z 80 80 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small-40@2x.png"
sips -z 50 50 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small-50.png"
sips -z 100 100 "$INPUT_IMAGE" --out "${FOLDER}/Icon-Small-50@2x.png"
sips -z 72 72 "$INPUT_IMAGE" --out "${FOLDER}/Icon-72.png"
sips -z 144 144 "$INPUT_IMAGE" --out "${FOLDER}/Icon-72@2x.png"
sips -z 76 76 "$INPUT_IMAGE" --out "${FOLDER}/Icon-76.png"
sips -z 152 152 "$INPUT_IMAGE" --out "${FOLDER}/Icon-76@2x.png"
