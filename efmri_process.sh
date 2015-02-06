#!/bin/bash

c3d="/share/apps/c3d/c3d-1.0.0-Linux-x86_64/bin/c3d"

function checkfile
{
    local file=$1
    if [ ! -f $file ]
    then
        echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        echo $file 'DOES NOT EXIST!!!'
        echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	echo exiting
    exit
    fi
}

# collect all input nifti files: fmri, t1, event_timing
function collect_files
{
  local i=$1 
  local destDir=$2
  niftiSourceDir=/data/picsl/srdas/wd/7T/long/
  # event timing is fixed for all subjects
  events_c=/data/picsl/wujue/efMRI/YHC02/blockAll_event_c.tab
  events_o=/data/picsl/wujue/efMRI/YHC02/blockAll_event_o.tab
  ### check if necessary files exist
  for session in 1 2 3 4;
  # for session in 2 3 4;
  do 
    checkfile ${niftiSourceDir}/${i}/T00_${i}_efmriblock${session}_dico.nii.gz
    checkfile ${niftiSourceDir}/${i}/T00_${i}_efmriblock${session}_dico_dico.nii.gz
  done
  checkfile ${niftiSourceDir}/${i}/T00_${i}_mprage.nii.gz
  checkfile ${events_c}
  checkfile ${events_o}
  checkfile ${niftiSourceDir}/${i}/T00/thickness/${i}BrainExtractionMask.nii.gz
  echo Good. All files are available
  
  ## make soft links to all above files that were checked
  for session in 1 2 3 4;
  #for session in 2 3 4;
  do
    ln -s ${niftiSourceDir}/${i}/T00_${i}_efmriblock${session}_dico.nii.gz ${destDir}/
    ln -s ${niftiSourceDir}/${i}/T00_${i}_efmriblock${session}_dico_dico.nii.gz ${destDir}/
  done
  ln -s ${niftiSourceDir}/${i}/T00_${i}_mprage.nii.gz ${destDir}/
  ln -s ${events_c} ${destDir}/
  ln -s ${events_o} ${destDir}/
  $c3d ${destDir}/T00_${i}_mprage.nii.gz ${niftiSourceDir}/${i}/T00/thickness/${i}BrainExtractionMask.nii.gz -times ${destDir}/T00_${i}_mprage_brain.nii.gz
  
  echo file collection completed.
}

function stringUpAllBlocks
{
  local i=$1
  local destDir=$2
  for session in 1 2 3 4; # block number
  #for session in 2 3 4;
  do

  fslsplit ${destDir}/T00_${i}_efmriblock${session}_dico_dico.nii.gz ${destDir}/chopping/block${session}_dico -t

  # delete the 11 volumes at the end 0104-0114
  rm ${destDir}/chopping/block${session}_dico0104.nii.gz ${destDir}/chopping/block${session}_dico0105.nii.gz  ${destDir}/chopping/block${session}_dico0106.nii.gz  ${destDir}/chopping/block${session}_dico0107.nii.gz ${destDir}/chopping/block${session}_dico0108.nii.gz  ${destDir}/chopping/block${session}_dico0109.nii.gz  ${destDir}/chopping/block${session}_dico0110.nii.gz ${destDir}/chopping/block${session}_dico0111.nii.gz  ${destDir}/chopping/block${session}_dico0112.nii.gz  ${destDir}/chopping/block${session}_dico0113.nii.gz ${destDir}/chopping/block${session}_dico0114.nii.gz

  fslmerge -t ${destDir}/chopping/block${session}_dico_11chopped.nii.gz ${destDir}/chopping/block${session}_dico0*

  done
  
  rm ${destDir}/chopping/block?_dico0*.nii.gz

  fslmerge -t ${destDir}/chopping/blockAllStrung_noZflipping.nii.gz ${destDir}/chopping/block?_dico_11chopped.nii.gz

  ln -s ${destDir}/chopping/blockAllStrung_noZflipping.nii.gz ${destDir}/
}

function stringUpAllBlocksNoDico
{
  local i=$1
  local destDir=$2
  for session in 1 2 3 4; # block number
  #for session in 2 3 4;
  do

  fslsplit ${destDir}/T00_${i}_efmriblock${session}_dico.nii.gz ${destDir}/chopping/block${session}_dico -t

  # delete the 11 volumes at the end 0104-0114
  rm ${destDir}/chopping/block${session}_dico0104.nii.gz ${destDir}/chopping/block${session}_dico0105.nii.gz  ${destDir}/chopping/block${session}_dico0106.nii.gz  ${destDir}/chopping/block${session}_dico0107.nii.gz ${destDir}/chopping/block${session}_dico0108.nii.gz  ${destDir}/chopping/block${session}_dico0109.nii.gz  ${destDir}/chopping/block${session}_dico0110.nii.gz ${destDir}/chopping/block${session}_dico0111.nii.gz  ${destDir}/chopping/block${session}_dico0112.nii.gz  ${destDir}/chopping/block${session}_dico0113.nii.gz ${destDir}/chopping/block${session}_dico0114.nii.gz

  fslmerge -t ${destDir}/chopping/block${session}_noDico_11chopped.nii.gz ${destDir}/chopping/block${session}_dico0*

  done
  
  rm ${destDir}/chopping/block?_dico0*.nii.gz

  fslmerge -t ${destDir}/chopping/blockAllStrung_noZflipping_noDico.nii.gz ${destDir}/chopping/block?_noDico_11chopped.nii.gz

  ln -s ${destDir}/chopping/blockAllStrung_noZflipping_noDico.nii.gz ${destDir}/
}

function setupDesignFile
{
  # set fmri(outputdir)
  # set feat_files(1) : input 4D data
  # set highres_files(1): t1_brain

  local id=$1
  local destinationDir=$2

  sed "s/YHC03/${id}/g" ${destinationDir}/../YHC03/output/allBlocks_noZflipping_cVother.feat/design.fsf > ${destinationDir}/output/design.fsf
  return
}

for id in YHC03;
do
  destinationDir=/data/picsl/wujue/efMRI/${id}
  
  mkdir -p ${destinationDir}/output
  mkdir -p ${destinationDir}/chopping
  
  collect_files $id $destinationDir
 
  stringUpAllBlocksNoDico $id $destinationDir

  ### setupDesignFile first; 
  setupDesignFile $id $destinationDir

  feat ${destinationDir}/output/design.fsf

done


