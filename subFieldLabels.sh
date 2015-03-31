
sub=$1
subFieldSegT2=/home/srdas/wd/7T/long/${sub}/T00_${sub}_subseg.nii.gz
T1=/data/picsl/wujue/efMRI/${sub}/T00_${sub}_mprage.nii.gz
T2_to_T1_xfm=/home/srdas/wd/7T/long/${sub}/T00/sfsegutrecht/flirt_t2_to_t1/flirt_t2_to_t1_ITK.txt
subFieldSegT1=/data/picsl/wujue/efMRI/${sub}/subFieldSeg/T00_${sub}_subseg_t1Space.nii.gz
c3d=/share/apps/c3d/c3d-1.0.0-Linux-x86_64/bin/c3d

mkdir /data/picsl/wujue/efMRI/${sub}/subFieldSeg/

$c3d $T1 $subFieldSegT2 -interpolation NearestNeighbor -reslice-itk ${T2_to_T1_xfm} -o $subFieldSegT1


