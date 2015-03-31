
antsPath=/data/picsl/wujue/bin/ants_march2013/
oasisTplt=~srdas/wd/7T/long/T_template0.nii.gz

for i in 02 03 04 05 06 07 08 09 10;
do
  contrast=daveContrastsPositiveNegativeNoDico
  t1=../YHC${i}/T00_YHC${i}_mprage_brain.nii.gz
  xfmFlirt=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/reg/example_func2highres.mat
  xfmItk=../YHC${i}/subFieldSeg/${contrast}_example_func2highres_itkAffine.txt
  c3d_affine_tool -ref $t1 -src ../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/cluster_mask_zstat1.nii.gz $xfmFlirt -fsl2ras -oitk $xfmItk
  warpAlongSupInf=../YHC${i}/directDicoWithBoldRef/BoldrefxDirectDico_par1_1Warp.nii.gz
  tranFromTpltToT1=~srdas/wd/7T/long/YHC${i}/T00/thickness/YHC${i}TemplateToSubject
  ln -s /home/srdas/wd/7T/long/T_template0.nii.gz ../YHC${i}/directDicoWithBoldRef/oasisTplt.nii.gz

  for c in `seq 1 10`;
  do 
  # tstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/tstat$c
  # zstat=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/stats/zstat$c
  clusterMask=../YHC${i}/output/allBlocks_noZflipping_${contrast}.feat/cluster_mask_zstat${c}.nii.gz
  output=../YHC${i}/subFieldSeg/cluster_mask_zstat${c}_${contrast}_DirectDico_tpltSpace.nii.gz

  # flirt -in $clusterMask -ref $t1 -applyxfm -init $xfm -out $output
  ${antsPath}antsApplyTransforms -d 3 -i $clusterMask -r $oasisTplt -o $output -n NearestNeighbor -t ${tranFromTpltToT1}1Warp.nii.gz -t ${tranFromTpltToT1}0GenericAffine.mat -t $warpAlongSupInf -t $xfmItk
  c3d $output -thresh 1 inf 1 0 -o $output
  done
done

