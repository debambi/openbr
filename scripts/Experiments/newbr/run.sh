
source newbrFRAlgorithm.sh
#br -gui -algorithm "FaceDetection+Stasm+CropFromLandmarks([$EYEBROW])+Show"  -enroll $METADATA/BLUFR/split1/probe1.xml Out
br -gui -algorithm "$FR_DETECT+($EYES+Show)/($NOSE+Show)"  -enroll temp.xml

