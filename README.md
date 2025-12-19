# Jawaban Test SQL Developer

**Nama**: Reyga  
**Tanggal**: 20 Desember 2025  
**Database**: PostgreSQL

Terima kasih atas kesempatan mengikuti technical test ini.

## Isi Jawaban

### Knowledge Base
### 1. Create table `tabel1`
   
   ![Screenshot 2025-12-20 052133](https://github.com/user-attachments/assets/79860aec-c0a7-4d96-b92c-c2e2fbeb10d7)

   Sesuai spesifikasi soal, tabel1 dibuat dengan kolom-kolom berikut:
   - id bertipe bilangan bulat (INTEGER)
   - fullname bertipe teks dengan panjang maksimal 100 karakter (VARCHAR(100))
   - email bertipe teks dengan panjang maksimal 50 karakter (VARCHAR(50))
   
   Untuk kepraktisan dan mengikuti standar pengembangan database, kolom id didefinisikan sebagai SERIAL PRIMARY KEY sehingga nilai otomatis bertambah secara unik dan menjadi kunci utama tabel.
   Penambahan Data Dummy agare tabel memiliki isi dan dapat digunakan untuk demonstrasi subquery (No. 4), saya memasukkan 5 record contoh yang terdiri dari nama lengkap serta alamat email dengan domain beragam (Gmail, Yahoo, Hotmail).
   Data ini sengaja dibuat campuran agar subquery untuk filter email Gmail menghasilkan output yang bermakna.

### 2. Penjelasan fungsi Primary Key, Foreign Key, Index, dan Unique Constraint

   ### Penjelasan Constraint dan Index dalam Database
   
   #### A. Primary Key
   Constraint yang menjadikan satu kolom (atau kombinasi kolom) sebagai **pengidentifikasi unik** untuk setiap baris dalam tabel.
   
   - Nilai harus **unik** dan **tidak boleh NULL**
   - Hanya boleh ada **satu Primary Key** per tabel
   - Otomatis membuat **unique index** untuk mempercepat pencarian
   - Fungsi utama: Menjamin integritas data dan Memudahkan referensi antar tabel (sebagai target Foreign Key)
   
   #### B. Foreign Key
   Constraint yang menghubungkan kolom di **tabel anak (child table)** ke **Primary Key atau Unique Key** di **tabel induk (parent table)**.
   
   - Fungsi utama: Menjaga **integritas referensial** (nilai di Foreign Key harus sudah ada di tabel induk) dan Mencegah data orphan (data anak tanpa induk)
   - Dapat ditambahkan opsi seperti `ON DELETE CASCADE` (hapus data anak otomatis saat induk dihapus) atau `ON UPDATE CASCADE`
   
   #### C. Index
   **Struktur data tambahan** (bukan constraint) yang dibuat untuk **mempercepat operasi pencarian dan pengurutan**.
   
   - Mempercepat query yang melibatkan `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`
   - Jenis umum: B-tree (default), Hash, GiST, GIN, dll
   - Kelebihan: Query SELECT jauh lebih cepat pada kolom yang sering difilter
   - Kekurangan: Memperlambat operasi `INSERT`, `UPDATE`, `DELETE` dan Menggunakan ruang penyimpanan tambahan
   
   #### D. Unique Constraint
   Constraint yang memastikan semua nilai di kolom (atau kombinasi kolom) **bersifat unik** di seluruh tabel.
   
   - Boleh ada **lebih dari satu** Unique Constraint per tabel
   - **Boleh menerima nilai NULL** (berbeda dengan Primary Key, kecuali ditambah `NOT NULL`)
   - Otomatis membuat **unique index**
   - Cocok digunakan untuk kolom seperti email, nomor telepon, username, dll
   
   #### Perbandingan Singkat
   
   | Aspek                  | Primary Key                  | Unique Constraint            | Foreign Key                  | Index                        |
   |------------------------|------------------------------|------------------------------|------------------------------|------------------------------|
   | Unik                   | Ya                           | Ya                           | Tidak wajib                  | Tidak wajib                  |
   | Boleh NULL             | Tidak                        | Ya (default)                 | Ya (tergantung definisi)     | Ya                           |
   | Jumlah per tabel       | Maksimal 1                   | Bisa banyak                  | Bisa banyak                  | Bisa banyak                  |
   | Otomatis buat index    | Ya (unique)                  | Ya (unique)                  | Tidak                        | Ya (sendiri)                 |
   | Fungsi utama           | Identifier unik + integritas | Nilai unik                   | Integritas referensial       | Optimasi performance         |
   | Bisa jadi target FK    | Ya                           | Ya                           | Tidak                        | Tidak                        |

### 3. Perbedaan Inner Join dan Left Join
   Contoh dibawah adalah code yang dibuat sebagai contoh meskipun nama tabel1 diubah menjadi tabel1_No3 tapi implementasi dan outputnya tetap sesuai. Untuk memperjelas konsep perbedann Inner Join dan Left Join sesuai permintaan soal, saya membuat contoh sederhana menggunakan dua tabel

   ![Screenshot 2025-12-20 054706](https://github.com/user-attachments/assets/b392f0ee-37c6-4593-940a-6022c92dbd43)

   dummy:
      -tabel1_No_3: Berisi daftar 5 customer (Reyga, Andi, Budi, Sarah, Lisa)
      -tabel2: Berisi data order hanya dari 3 customer (Reyga, Andi, Sarah)
   
   INNER JOIN SELECT * FROM tabel1 INNER JOIN tabel2 ON tabel1_No_3.id = tabel2.id;

   ![Screenshot 2025-12-20 054821](https://github.com/user-attachments/assets/65ee1984-9b6d-459a-aaf1-8164cde2bc64)

   INNER JOIN hanya menampilkan baris yang memiliki kecocokan sempurna di kedua tabel berdasarkan kondisi ON (dalam contoh ini, kolom id).
   Customer Budi (id=3) dan Lisa (id=5) tidak muncul sama sekali karena mereka tidak memiliki data order di tabel2.
   Hasilnya adalah hanya data bersama (intersection) dari kedua tabel.

   LEFT JOIN SELECT * FROM tabel1 INNER JOIN tabel2 ON tabel1_No_3.id = tabel2.id;

   ![Screenshot 2025-12-20 055004](https://github.com/user-attachments/assets/f4c96cb3-4e6a-464f-b653-faf39e1d07fb)

   LEFT JOIN Semua 5 customer dari tabel kiri (tabel1_No_3) tetap ditampilkan.
   Untuk Budi dan Lisa yang tidak memiliki order di tabel2, kolom id dan order_total dari tabel kanan menjadi NULL.

   Kesimpulan Perbedaan

   INNER JOIN: Hanya menampilkan baris yang memiliki kecocokan di kedua tabel. Data yang tidak cocok dihilangkan sepenuhnya.
   LEFT JOIN: Menampilkan semua baris dari tabel kiri, ditambah data dari tabel kanan jika ada kecocokan. Jika tidak ada kecocokan, kolom dari tabel kanan diisi NULL.
   
   Contoh ini menunjukkan dengan sangat jelas perbedaan output kedua query sesuai permintaan soal.
   
### 4. Subquery email Gmail
   
   ![Screenshot 2025-12-20 042844](https://github.com/user-attachments/assets/099504b6-99c4-4011-b67b-52a7c4b663f4)

   Sesuai permintaan soal, query ini menggunakan subquery untuk memfilter dan menampilkan hanya email yang berdomain Gmail dari tabel tabel1.
   Penjelasan:
   Subquery bagian dalam (SELECT email FROM tabel1 WHERE email ILIKE '%@gmail.com') bertugas mencari semua email yang mengandung @gmail.com (menggunakan ILIKE agar tidak sensitif terhadap huruf besar/kecil).
   Query utama kemudian memilih email-email yang termasuk dalam hasil subquery tersebut menggunakan klausa IN. Hasil akhir hanya menampilkan email dengan domain Gmail, sementara email dari domain lain (seperti Yahoo atau Hotmail) tidak ditampilkan. Query ini telah memenuhi syarat soal        secara tepat: menggunakan subquery dan berhasil memfilter hanya email Gmail.
     
### 5. Perbedaan Procedure vs Function  
   Untuk memperjelas perbedaan antara Function dan Procedure, saya membuat contoh sederhana yang melakukan tugas sama: menghitung total pembelian seorang customer dari tabel orders.

   Function
   Function wajib mengembalikan nilai dan dapat digunakan langsung dalam query SELECT.
   Dari contoh:
   - Function hitung_total_customer menghitung total pembelian berdasarkan customer_id.
   - Dipanggil langsung dalam SELECT bersama tabel customers.

   ![Screenshot 2025-12-20 060318](https://github.com/user-attachments/assets/518b2994-6c68-46ce-b80e-84a631631f10)

   Keunggulan:
   Output berupa nilai yang bisa dijadikan kolom dalam hasil query, sehingga mudah digabungkan dengan tabel lain atau diurutkan.

   Procedure
   Procedure tidak wajib mengembalikan nilai. Ia lebih cocok untuk menjalankan proses atau menampilkan informasi melalui pesan.
   Dari contoh:
   - Procedure proses_total_customer mengambil nama customer dan total pembeliannya, lalu menampilkan informasi tersebut menggunakan RAISE NOTICE.
   - Dipanggil dengan perintah CALL.

   ![Screenshot 2025-12-20 060427](https://github.com/user-attachments/assets/3338be76-274b-4a4d-bd69-7f4cadfea675)

   Keunggulan:
   Cocok untuk proses yang memiliki efek samping (misalnya logging, menampilkan laporan, atau mengubah data), tanpa perlu menghasilkan tabel hasil.

   Kesimpulan Perbedaan Utama
   - Function: Mengembalikan nilai → dapat digunakan langsung di SELECT dan hasilnya muncul sebagai tabel.
   - Procedure: Tidak mengembalikan nilai → dipanggil dengan CALL, output biasanya berupa pesan di log/messages.
   
   Kedua contoh ini menunjukkan dengan jelas perbedaan perilaku dan cara penggunaan function serta procedure di PostgreSQL sesuai permintaan soal.
   
### Test Case
### A. Schema aplikasi pembelian (customers, products, orders, order_items)
   
  ![Screenshot 2025-12-20 050514](https://github.com/user-attachments/assets/e436723b-09a0-4c5b-9835-92f839ed6361)

  ![Screenshot 2025-12-20 050552](https://github.com/user-attachments/assets/b4e3dc84-6bda-4bd6-9369-39ba36799012)

   Untuk mendukung aplikasi pembelian sederhana, saya membuat empat tabel utama yang saling berhubungan:
   - customers: Menyimpan data pembeli/customer
   - products: Menyimpan data barang yang dijual
   - orders: Menyimpan data transaksi pembelian (header order)
   - order_items: Menyimpan detail item dalam setiap order (junction table untuk relasi many-to-many antara orders dan products)
   
   Desain ini mengikuti prinsip normalisasi (3NF) agar data tetap konsisten dan mudah dikelola.
   
   Struktur Tabel dan Data Contoh
   Setelah menjalankan script pembuatan tabel dan pengisian data, berikut isi dari masing-masing tabel (seperti terlihat pada screenshot):
   
   customers (5 pembeli):
   Menampilkan customer_id, name, email, dan address.
   
   products (5 barang):
   Menampilkan product_id, name, price, dan stock.
   
   orders (6 transaksi):
   Menampilkan order_id, customer_id, order_date, dan total_amount.
   Setiap customer memiliki minimal satu order (Reyga memiliki dua order).
   
   order_items (9 baris detail):
   Menampilkan item_id, order_id, product_id, quantity, dan subtotal.
   Menunjukkan barang apa saja yang dibeli dalam setiap order.
   
   Kelebihan Desain Ini
   - Menggunakan SERIAL PRIMARY KEY untuk ID otomatis.
   - Foreign key dengan ON DELETE CASCADE untuk menjaga integritas data.
   - Constraint CHECK pada price dan quantity untuk validasi nilai positif.
   - Index tambahan pada kolom yang sering digunakan untuk JOIN (customer_id dan product_id) agar query lebih cepat.
   - Relasi many-to-many antara order dan product diakomodasi melalui tabel order_items.
   
   Desain ini sudah siap digunakan untuk aplikasi pembelian nyata dan mendukung semua query analitik yang diminta pada bagian b.
### B. 

   1. Daftar Seluruh Pembelian/Order (lengkap detail)
   
   ![Screenshot 2025-12-20 050838](https://github.com/user-attachments/assets/f308de8a-dc1e-4d89-b9e6-9242486d0746)
   
   Query ini menampilkan setiap order beserta nama customer, waktu pembelian, nilai total, jumlah produk yang dibeli, serta daftar produk yang dibeli.
   Hasil utama:
   
   - Total 6 order ditampilkan, diurutkan dari yang terbaru.
   - Reyga memiliki dua order terpisah (15 Des dan 18 Des).
   - Setiap order menampilkan produk yang dibeli (dipisah koma) dan jumlah itemnya.

   2. Total Nilai Pembelian per Customer per Bulan

      ![Screenshot 2025-12-20 050933](https://github.com/user-attachments/assets/b2fb5173-2d54-4b23-9a45-2ffc2195d387)

   Query ini mengagregasi total pembelian setiap customer dalam satu bulan (Desember 2025).
   Hasil utama:
   
   - Reyga tertinggi dengan total Rp 27.250.000,00 (dua order).
   - Lisa Rp 25.000.000,00 (satu order besar).
   - Andi, Budi, dan Sarah dengan nilai lebih kecil.
   - Semua transaksi terjadi di bulan yang sama, sehingga hanya satu bulan yang muncul.
   
   3. 3 Produk dengan Penjualan Terbesar per Bulan

      ![Screenshot 2025-12-20 051033](https://github.com/user-attachments/assets/a83d5187-bd28-42df-bb9f-8cbda91e8b37)

   Query ini menggunakan CTE dan window function (ROW_NUMBER) untuk meranking produk berdasarkan total penjualan (sum subtotal) per bulan, lalu mengambil top 3.
   Hasil utama (Desember 2025):
   
   - Laptop Gaming ASUS ROG – Rp 50.000.000,00 (dibeli oleh Reyga dan Lisa)
   - Monitor 27" Samsung – Rp 4.500.000,00
   - Headset Razer – Rp 4.000.000,00
   
   Query ini fleksibel dan akan tetap bekerja dengan baik jika ada data dari bulan lain di masa depan.
   Ketiga query telah memenuhi semua permintaan soal:
   
   Menggunakan JOIN yang tepat untuk menghubungkan customers, orders, order_items, dan products.
   Menghasilkan informasi agregat (COUNT, SUM, STRING_AGG) dan ranking (window function).
   Output mudah dibaca dan sesuai untuk kebutuhan reporting.

Siap untuk diskusi lebih lanjut.  
Terima kasih!

Reyga
