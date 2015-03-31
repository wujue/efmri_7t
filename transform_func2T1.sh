
for i in 02 03 04 05 06 07 08 09 10;
do
  contrast=daveContrastsPositiveNegativeNoDico
  t1=../YHC${i}/T00_YHC${i}_mprage_brain.nii.gz
  xfm=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/reg/example_func2highres.mat
  for c in `seq 1 10`;
  do 
  # tstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/tstat$c
  # zstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/zstat$c
  clusterMask=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/cluster_mask_zstat${c}.nii.gz
  output=../YHC${i}/subFieldSeg/cluster_mask_zstat${c}_${contrast}_t1Space.nii.gz

  # flirt -in ${tstat}.nii.gz -ref $t1 -applyxfm -init $xfm -out ${tstat}_T1space.nii.gz
  # flirt -in ${zstat}.nii.gz -ref $t1 -applyxfm -init $xfm -out ${zstat}_T1space.nii.gz 
  flirt -in $clusterMask -ref $t1 -interp nearestneighbour -applyxfm -init $xfm -out $output
  c3d $output -thresh 1 inf 1 0 -o $output
  done
done

