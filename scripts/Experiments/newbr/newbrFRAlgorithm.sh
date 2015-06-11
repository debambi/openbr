EYE_POINTS="30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47"
NOSE_POINTS="48,49,50,51,52,53,54,55,56,57"
MOUTH_POINTS="59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76"
EYEBROW_POINTS="16,17,18,19,20,21,22,23,24,25,26,27"

EYES="CropFromLandmarks([$EYE_POINTS],paddingVertical=.8,paddingHorizontal=.2)+Resize(24,48)"
EYEBROWS="CropFromLandmarks([$EYEBROW_POINTS],paddingVertical=.8,paddingHorizontal=.2)+Resize(240,480)"
MOUTH="CropFromLandmarks([$MOUTH_POINTS])+Resize(24,48)"
NOSE="CropFromLandmarks([$NOSE_POINTS],padding=3)+Resize(36,36)"

FR_DETECT="FaceDetection+Stasm+Rename(StasmLeftEye,Affine_1,true)+Rename(StasmRightEye,Affine_0,true)+Affine(88,88,0.25,0.35,warpPoints=true)"
FR_REPRESENT="(DenseSIFT/DenseLBP)+LDA(.98)+Normalize(L2)"

FR_EYES="${FR_DETECT}+${EYES}+${FR_REPRESENT}:Dist(L2)"
FR_EYEBROWS="${FR_DETECT}+${EYEBROWS}+${FR_REPRESENT}:Dist(L2)"
FR_MOUTH="${FR_DETECT}+${MOUTH}+${FR_REPRESENT}:Dist(L2)"
FR_NOSE="${FR_DETECT}+${NOSE}+${FR_REPRESENT}:Dist(L2)"
FR_FACE="${FR_DETECT}+${FR_REPRESENT}:Dist(L2)"
FR_NEWBR="${FR_DETECT}+(${FR_EYES}+${FR_REPRESENT})/(${FR_EYEBROWS}+${FR_REPRESENT})/(${FR_NOSE}+${FR_REPRESENT})/(${FR_MOUTH}+${FR_REPRESENT})/(${FR_FACE}+${FR_REPRESENT})/(${FACE}+${FR_REPRESENT})+Cat+LDA(768)+Normalize(L2):Dist(L2)"

