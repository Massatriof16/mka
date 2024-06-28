current_directory = ${pwd}

echo "Memanggil Konfigurasi yang Tersimpan"

echo "Ingin ubah konfigurasi tersimpan?"
echo "1. Ya"
echo "2. Tidak"
echo "Pilih: "
read settings

if [ "${settings}" = 1 ]; then
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

    sed -i "s/Device_tree=.*/Device_tree=$Device_tree/" ${current_directory}/save_settings.txt
 
sed -i "s/Branch_dt_twrp=.*/Branch_dt_twrp=$Branch_dt_twrp/" ${current_directory}/save_settings.txt


sed -i "s/Device_Path=.*/Device_Path=$Device_Path/" ${current_directory}/save_settings.txt

sed -i "s/Device_Name=.*/Device_Name=$Device_Name/" ${current_directory}/save_settings.txt

sed -i "s/Build_Target=.*/Build_Target=$Build_Target/" ${current_directory}/save_settings.txt
echo " Dipeebarui!"
sleep 1

    source ${current_directory}/save_settings.txt
    
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

elif [ "${settings}" = 2 ]; then
    source ${current_directory}/save_settings.txt
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

else
    echo "Input tidak valid. Perintah dibatalkan."
    exit 1
fi

chmod a+x TWRP_${Device_Name}_${Build_Target}.img

# Menampilkan nilai variabel Device_tree
