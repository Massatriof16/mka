current_directory = ${pwd}
 
   echo "DEVICE TREE : "
 read DEVICE_TREE
 echo "Branch device tree twrp : "
 read Branch_dt_twrp
 echo "Device Path : "
 read Device_Path
 echo "Device Name : "
 read Device_Name
 echo "Build Target (recovery,boot,vendorboot) : "
 read Build_Target


rm -rf /.workspace/twrp/device

cd /.workspace/twrp
echo " "
echo " Cloning Device tree "
echo " "

git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " BUILDING TWRP "
        echo " "
        sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
       if [ "${Build_Target}" = "vendorboot" ]; then
    Build_Target = vendor_boot
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
mv recovery.img TWRP_${Device_Name}.img
