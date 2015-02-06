
for i in 02; # 03 04 05 06 07 08 09 10;
do
  contrast=daveContrasts
  t1=../YHC${i}/T00_YHC${i}_mprage_brain.nii.gz
  xfm=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/reg/example_func2highres.mat
  for c in 1 2 3 4 5;
  do 
  tstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/tstat$c
  zstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/zstat$c

  flirt -in ${tstat}.nii.gz -ref $t1 -applyxfm -init $xfm -out ${tstat}_T1space.nii.gz

  flirt -in ${zstat}.nii.gz -ref $t1 -applyxfm -init $xfm -out ${zstat}_T1space.nii.gz 
  done
done

