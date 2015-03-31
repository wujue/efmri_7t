#!/bin/bash

# ANTsPATH=/data/picsl/wujue/bin/ants_march2013/
ANTsPATH=/data/jet/jtduda/bin/ants/

root=/data/picsl/wujue/efMRI/

sub=YHC$1

fix="/home/srdas/wd/7T/long/${sub}/T00_${sub}_boldref.nii.gz"
mov="${root}${sub}/output/allBlocks_noZflipping_daveContrastsPositiveNegativeNoDico.feat/mean_func.nii.gz"

fixName="Boldref"
movName="DirectDico"

outputPath=${root}/${sub}/directDicoWithBoldRef

mkdir $outputPath

transform="Rigid"

# ln -s /home/srdas/wd/7T/long/${sub}/T00_${sub}_boldref.nii.gz ${root}${sub}/

# fslroi ${root}${sub}/T00_${sub}_efmriblock1_dico_dico.nii.gz $mov 50 1

par="par1"

exe="${ANTsPATH}/antsRegistration -d 3 \
                            -r [${fix},${mov},1] \
                            -o ${outputPath}/${fixName}x${movName}_${par}_ \
			    -m MI[${fix},${mov},1,16,Regular,0.25] \
                            -t ${transform}[0.1] \
                            -f 8x4x2x1 \
                            -s 3x2x1x0 \
                            -c [500x200x100x50,1e-6,10]"
echo "$par:" >> ${outputPath}/parameters.sh 
echo "$exe" >> ${outputPath}/parameters.sh
$exe

exe="${ANTsPATH}/antsRegistration -d 3 \
                            -r ${outputPath}/${fixName}x${movName}_${par}_0GenericAffine.mat \
                            -o ${outputPath}/${fixName}x${movName}_${par}_ \
                            -m CC[${fix},${mov},1,4] \
                            -t SyN[0.1,3,0] \
			    -g 0x0x1 \
                            -f 6x4x2x1 \
                            -s 3x2x1x0 \
                            -c [100x100x80x40,1e-8,10]"
echo "$exe" >> ${outputPath}/parameters.sh
$exe

${ANTsPATH}/antsApplyTransforms -d 3 \
                               -o ${outputPath}/${movName}_Warped_${par}.nii.gz \
                               -n Linear \
                               -r $fix \
                               -i $mov \
			       -t ${outputPath}/${fixName}x${movName}_${par}_1Warp.nii.gz \
			       -t ${outputPath}/${fixName}x${movName}_${par}_0GenericAffine.mat


