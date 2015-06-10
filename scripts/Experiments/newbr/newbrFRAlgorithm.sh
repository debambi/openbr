FR_ALG="FaceDetection+Stasm+Rename(StasmLeftEye,Affine_1,true)+Rename(StasmRightEye,Affine_0,true)+Affine(88,88,0.25,0.35)+(Mask+DenseSIFT/DenseLBP+DownsampleTraining(PCA(0.95),instances=1)+Normalize(L2)+Cat)+(Dup(12)+RndSubspace(0.05,1)+DownsampleTraining(LDA(0.98),instances=-2)+Cat+DownsampleTraining(PCA(768),instances=1))+(Normalize(L2)+Quantize)+SetMetadata(AlgorithmID,-1):Dist(L2)"

echo br -gui -algorithm "FaceDetection+Stasm+SelectPoints([$EYES])+CropFromLandmarks"  -enroll $METADATA/BLUFR/split1/probe1.xml Out
EYE_POINTS="30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47"
NOSE_POINTS="48,49,50,51,52,53,54,55,56,57"
MOUTH_POINTS="59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76"
EYEBROW_POINTS="16,17,18,19,20,21,22,23,24,25,26,27"

FR_DETECT="FaceDetection+Stasm"

EYES="CropFromLandmarks([$EYE_POINTS])+Resize(48,24)"
EYEBROWS="CropFromLandmarks([$EYEBROW_POINTS])+Resize(48,24)"
MOUTH="CropFromLandmarks([$EYEBROW_POINTS])+Resize(48,24)"
NOSE="CropFromLandmarks([$EYEBROW_POINTS])+Resize(36,36)"
FACE="Rename(StasmLeftEye,Affine_1,true)+Rename(StasmRightEye,Affine_0,true)+Affine(88,88,0.25,0.35)"

FR_REPRESENT="(DenseSIFT/DenseLBP)+(Dup(12)+RndSubspace(0.05,1)+DownsampleTraining(LDA(0.98),instances=-2)+Cat+DownsampleTraining(PCA(768),instances=1))"

#(Normalize(L1)+Quantize)+SetMetadata(AlgorithmID,-1):Unit(ByteL1)"

