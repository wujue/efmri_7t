
for i in 02 03 04 05 06 07 08 09 10;
do

  t1=../YHC${i}/T00_YHC${i}_mprage_brain.nii.gz
  subFieldSeg=../YHC${i}/subFieldSeg/T00_YHC${i}_subseg_t1Space.nii.gz

  echo YHC$i
  for c in `seq 1 10`;
  do
  activation=../YHC${i}/subFieldSeg/cluster_mask_zstat${c}_daveContrastsPositiveNegative
  
  noDico=(`c3d $subFieldSeg -thresh 1 inf 1 0 ${activation}NoDico_t1Space.nii.gz -times -dup -lstat | grep " 1 "`)  
  Dico=(`c3d $subFieldSeg -thresh 1 inf 1 0 ${activation}_t1Space.nii.gz -times -dup -lstat | grep " 1 "`)
  furtherDico=(`c3d $subFieldSeg -thresh 1 inf 1 0 ${activation}_furtherDistCorr_t1Space.nii.gz -times -dup -lstat | grep " 1 "`)

  if [ -z ${noDico[5]} ]; then # string not empty
    echo -n 0
  else
    echo -n ${noDico[5]}
  fi

  if [ -z ${Dico[5]} ]; then # string not empty
    echo -ne "\t0"
  else
    echo -ne "\t${Dico[5]}"
  fi

  if [ -z ${furtherDico[5]} ]; then # string not empty
    echo -e "\t0"
  else
    echo -e "\t${furtherDico[5]}"
  fi
  done
done

