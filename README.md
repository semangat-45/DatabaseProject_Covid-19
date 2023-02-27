# Project STA1562 Manajemen Data Statistika

Project ini merupakan tugas akhir mata kuliah STA1562 mengenai basis data (database). Database yang digunakan merupakan database COVID-19 yang berisi kasus COVID-19 di 210 negara di dunia, yang sumbernya diproleh dari:

- Johns Hopkins University
- World Health Organisation (WHO)
- European Centre for Disease Prevention and Control (ECDC)

Dari database ini akan ditampilkan jumlahan kasus COVID-19 (kasus baru, sembuh, dan meninggal) dari suatu negara pada kurun waktu tertentu. Data dalam database ini dapat di akses dalam file .sql yang telah diunggah dalam repository ini.

## Deskripsi Tabel

### 1. Tabel `country`

Merupakan tabel yang memuat daftar negara-negara di dunia beserta populasinya. Beberapa kolom di dalamnya meliputi:

- `country_id` : integer, primary key (id negara, terdiri dari 1 - 210)
- `country_name` : varchar(50) (nama negara)
- `country_code` : varchar(20) (kode negara berdasarkan aturan 3-Alpha)
- `continent` : varchar(10) (benua letak negara tersebut)
- `population` : bigint (jumlah populasi negara pada 2020)
- `convert_name` : varchar(50) (nama negara setelah dikonversi)

### 2. Tabel `source`

Merupakan tabel yang memuat daftar sumber informasi COVID-19 diperoleh. Terdiri dari:

- `source_id` : bigint, primary key (id sumber, terdiri dari 1-1423 sumber)
- `source_name` : varchar (nama sumbernya)

### 3. Tabel `day`

Merupakan tabel indikator hari (untuk digunakan dalam tabel dimensi `time`), berisi:

- `day_id` : integer, primary key (id hari, 1=senin hingga 7=minggu)
- `day_name` : char(10) (nama hari)

### 4. Tabel `month`

Merupakan tabel indikator bulan (untuk digunakan dalam tabel dimensi `time`), berisi:

- `month_id` : integer, primary key (id bulan, 1=Januari hingga 12=Desember)
- `month_name` : char(20) (nama hari)

### 5. Tabel `time`

Merupakan tabel yang berisi dimensi waktu, dengan kolom sebagai berikut:

- `time_id` : integer, primary key (ID waktu)
- `date` : date (tanggal)
- `day` : integer (satuan tanggal yang nilainya dari 1-31)
- `month` : integer, foreign key (reference ke kolom `month.month_id`)
- `year` : integer (tahun)
- `week` : integer (minggu ke berapa pada tahun tersebut)
- `day_of_week` : integer, foreign key (reference ke kolom `day.day_id`)

### 6. Tabel `country_health_index`

Berisi indeks kesehatan sebuah negara pada waktu tertentu. Kolom yang terdapat pada tabel ini antara lain:

- `country_id` : integer, foreign key (reference ke `country.country_id`)
- `time_id` : integer, foreign_key (reference ke `time.time_id`)
- `value` : double precision (indeks kesehatan negara itu pada waktu tertentu)

### 7. Tabel `country_testing_policy`

Merupakan tabel yang memuat indikator apakah negara tersebut pada waktu itu menerapkan testing atau tidak, 0 = tidak, 1 = ya.

- `country_id` : integer, foreign key (reference ke `country.country_id`)
- `time_id` : integer, foreign_key (reference ke `time.time_id`)
- `value` : char (status keterangan menerapkan testing policy)

### 8. Tabel `measurement`

Merupakan tabel kebijakan mengenai COVID-19 yang diterapkan suatu negara pada wkatu tertentu. Berisi:

- `country_id` : integer, foreign key (reference ke `country.country_id`)
- `time_id` : integer, foreign_key (reference ke `time.time_id`)
- `measure_value` : varchar(100) (nama kebijakan yang diambil)
- `note` : varchar(100) (catatan)
- `category` : varchar(50) (kategori kebijakan)
- `source_id` : integer, foreign key (reference ke `source.source_id`)

### 9. Tabel `data`

Merupakan tabel hasil observasi COVID-19 menurut negara dan waktu, serta sumber data yang diperoleh.

- `country_id` : integer, foreign key (reference ke `country.country_id`)
- `time_id` : integer, foreign_key (reference ke `time.time_id`)
- `cases` : integer (banyak kasus aktif)
- `deaths` : integer (banyak kasus meninggal)
- `recovered` : integer (banyak kasus sembuh)
- `cumulative_cases` : bigint (kumulatif kasus aktif)
- `cumulative_deaths` : bigint (kumulatif kasus meninggal)
- `cumulative_recovered` : bigint (kumulatif kasus sembuh)
- `source_id` : integer, foreign key (reference ke `source.source_id`)

## Deskripsi Role & Kontributor

1. Database Manager (Rizki Alifah Putri - G1501221005)
2. Shiny Developer (Nur Khamidah - G1501221023 (Back-end), Bayu Paramita - G1501221052 (Front-end))
3. Technical Writer (Kristuisno M. Kapiluka - G1501221034)

## Skema
<p align="center">
  <img width="1000" height="500" src="https://github.com/semangat-45/DatabaseProject_Covid-19/blob/main/SKEMA%20COVID.png">
</p>

## ERD

![ERD Covid Database](https://github.com/semangat-45/DatabaseProject_Covid-19/blob/main/covid.png?raw=true)
