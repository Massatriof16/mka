current_directory = ${pwd}
 
  
echo "Link Device tree twrp : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    exit 1
fi
echo "Branch Device_tree_twrp : "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    exit 1
fi
echo "Device Path : "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    exit 1
fi
echo "Device Name : "
read Device_Name
if [ -z "{$Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    exit 1
fi
echo "Build Target (recovery,boot,vendorboot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    exit 1
fi


rm -rf /.workspace/twrp/device

cd /.workspace/twrp
echo " "
echo "Cloning Device Tree "
echo " "
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
echo " "
echo " Building recovery "
echo " "
sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
   
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     

        cd ${current_directory}
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
