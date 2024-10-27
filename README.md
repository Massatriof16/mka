wax# TWRP Builder Menggunakan Gitpod

dengan script ini anda dapat melakukan build twrp/ofrp menggunakan gitpod agar lebih cepat dan efisien serta hemat waktu dalam melakukan build. Apabila terjadi error, tidak perlu mengulangi dari awal karena semua yang informasi dari apa yang anda ingin build sebelumnya akan disimpan dan tidak perlu memasukkan ulang melakukan build serta pada saat error, script tidak mengulang sync minimal manifest sehingga melakukan clone ulang device tree dari github anda yang sudah diperbaiki lalu akan segera melakukan build.

UPDATE DATE 27 OCF 24 :
- Sekarang Bot telegram dapat memgirim notifikasi dan file pada grup yang memiliki topik


UPDATE DATE 07 OCT 24 :
- Menambahkan support Manifest twrp 14


UPDATE DATE 08 SEPT 24 :
- Anda dapat mengatur folder build



UPDATE DATE 04 AUG 24 :
- Memperbarui Kerja ReAosp dan ReOmni sekarang akan melakukan sync otomatis saat tidak ada sync manifest sebagai gantinya akan memeriksa pengaturan minimal manifest apakah sudah diatur sebelumnya.
- Mengoptimalkan kerja Menyimpan versi minimal manifest yang dimasukkan agar sesuai dengan perubahan Menu ReAosp dan ReOmni sekarang pengguna tidak bisa memasukkan selain yang ada di list versi minimal manifest tersebut.
- Omni not support build from gitpod !



UPDATE DATE 07 JUL 24 :
- Menambahkan Dukungan Build OrangeFox Recovery



UPDATE DATE 06 JUL 24 :
- Optimasi Pengecekan File Hasil Build Agar Lebih Akurat sehingga dapat mengirim file dengan benar
- Menambahkan Dukungan Upload ke Pixeldrain ( Harap Atur ApiKey pixeldrain Anda!)
-  | Daftar pixeldrain dan dapatkan apikey disini : https://pixeldrain.com/user/api_keys |
 

UPDATE DATE 01 Jul 24 :
- Menambahkan dukungan Build menggunakan Common device tree TWRP

 
RELEASE DATE 29 Jun 24 :
- Build TWRP Aosp 12.1 / 11 (Tested √)
- Build TWRP Omni ( WIP )
- Mengirim notifikasi serta files ke telegram menggunakan chat ID ( Tested √) [ Jika anda menggunakan default token bot maka kalian harus start Bot https://t.me/KingBabu_bot Agar dapat dikirim ]

-------------------------------------------------------------------------

how to use :
- git clone https://github.com/Massatrio16/mka
- cd mka
- sudo passwd (buat dan komfirmasi password baru untuk akses superuser)
- su (Masukkan password yang kamu buat)
- bash build.sh


Gambar Fitur :

![Menu](https://github.com/Massatrio16/mk/blob/main/Screenshot_20240701-091114_1.jpg)

