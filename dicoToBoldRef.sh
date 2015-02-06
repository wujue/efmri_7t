#!/bin/bash

# ANTsPATH=/data/picsl/wujue/bin/ants_march2013/
ANTsPATH=/data/jet/jtduda/bin/ants/

root=/data/picsl/wujue/efMRI/

sub=YHC$1

fix="/home/srdas/wd/7T/long/${sub}/T00_${sub}_boldref.nii.gz"
mov="${root}${sub}/registerWithBoldRef/example_func_time50.nii.gz"

fixName="Boldref"
movName="Dico"

outputPath=${root}/${sub}/registerWithBoldRef

mkdir $outputPath

transform="Affine"

ln -s /home/srdas/wd/7T/long/${sub}/T00_${sub}_boldref.nii.gz ${root}${sub}/

fslroi ${root}${sub}/T00_${sub}_efmriblock1_dico_dico.nii.gz $mov 50 1

${ANTsPATH}/antsRegistration -d 3 \
                            -r [${fix},${mov},1] \
                            -o ${outputPath}/${fixName}x${movName}_ \
			    -g 0x0x1 \
                            -m CC[${fix},${mov},1,4] \
                            -t SyN[0.1,3,0] \
                            -f 6x4x2x1 \
                            -s 3x2x1x0 \
                            -c [10x0x0x0,1e-8,10] 

# apply the inverse transform to the moving space
${ANTsPATH}/antsApplyTransforms -d 3 \
                               -o ${outputPath}/${movName}_Warped.nii.gz \
                               -n Linear \
                               -r $fix \
                               -i $mov \
			       -t ${outputPath}/${fixName}x${movName}_1Warp.nii.gz 


