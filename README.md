<div align="center">

![Logo](https://via.placeholder.com/150x150)

# Database Covid'19

[Tentang](#scroll-overview)
•
[Screenshot](#rice_scene-screenshot)
•
[Demo](#dvd-demo)
•
[Dokumentasi](#blue_book-documentation)

</div>

## :bookmark_tabs: Menu

- [Tentang](#scroll-overview)
- [Screenshot](#rice_scene-screenshot)
- [Demo](#dvd-demo)
- [Dokumentasi](#blue_book-documentation)
- [Requirements](#exclamation-requirements)
- [Skema Database](#floppy_disk-skema-database)
- [ERD](#rotating_light-erd)
- [Deskripsi Data](#heavy_check_mark-deskripsi-data)
- [Struktur Folder](#open_file_folder-stuktur-folder)
- [Tim Pengembang](#smiley_cat-tim-pengembang)

## :scroll: Tentang

Data rekaman Covid'19 yang ada di seluruh dunia dari tanggal 1 Januari 2020 - 30 Juni 2020 yang direkam dari berbagai sumber dengan memperhatikan mitigasi dan indeks kesehatan dari masing - masing negara dalam kurun waktu tertentu.  

Lorem ipsum dolor sit amet consectetur, adipisicing elit. Aut praesentium neque assumenda! Tempore culpa nihil laborum distinctio vel, illo quod veniam. Excepturi soluta beatae sed iusto sunt, impedit ducimus dignissimos?

## :rice_scene: Screenshot

![Logo](https://via.placeholder.com/750x500)

## :dvd: Demo

Di bawah ini merupakan tautan untuk mendemokan aplikasi ShinyApp 

| url                      | login          | password |
| ------------------------ | -------------- | -------- |
| http://shinyapps.io/covid| admin@mail.com | 123      |

## :blue_book: Dokumentasi 

Dokumentasi penggunaan aplikasi database. Anda dapat juga membuat dokumentasi lives menggunakan readthedocs.org (opsional).

## :exclamation: Requirements

- Cantumkan paket R yang digunakan
- PostgreSQL 
- ElephantSQL

## :floppy_disk: Skema Database

<img width="242" alt="skema update" src="https://user-images.githubusercontent.com/111562803/223139863-0f7b7950-6586-49aa-9e6c-5c756d2a0375.png">


## :rotating_light: ERD

<img width="242" alt="skema update" src="https://github.com/Kelompok4MDS/Project-Praktikum-MDS/blob/main/ERD%20Liga%20Inggris.png?raw=true">

## :heavy_check_mark: Deskripsi Data

Berisi tentang tabel-tabel yang digunakan berikut dengan sintaks SQL DDL (CREATE).

Contoh:

### 1. Tabel country

Tabel country merupakan tabel yang memuat daftar negara-negara di dunia beserta populasinya. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                     |
|:-------------|:----------------------|:--------------------------------|
| country_id   | integer, primary key  | id negara, terdiri dari 1 - 210 |
| country_name | varchar(50)           | Nama negara                     |
| country_code | varchar(20)           | Kode negara                     |
| continent    | varchar(10)           | Benua letak negara tersebut     |
| population   | bigint                | Jumlah populasi negara pada 2020|
| convert_name | varchar(50)           | Nama negara setelah dikonversi  |

### Create Table country

```sql
CREATE TABLE IF NOT EXISTS public.country
(
    country_id integer NOT NULL,
    country_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    country_code character varying(20) COLLATE pg_catalog."default",
    continent character varying(10) COLLATE pg_catalog."default",
    population bigint,
    convert_name character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (country_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country
    OWNER to postgres;
    
```

### 2. Tabel source

Tabel source merupakan tabel yang memuat daftar sumber informasi COVID-19 yang diperoleh. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                           |
|:-------------|:----------------------|:--------------------------------------|
| source_id    | bigint, primary key   | id sumber, terdiri dari 1-1423 sumber |
| source_name  | varchar               | Nama sumbernya                        |

### Create Table source

```sql
CREATE TABLE IF NOT EXISTS public.source
(
    source_id bigint NOT NULL,
    source_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT source_pkey PRIMARY KEY (source_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.source
    OWNER to postgres;
    
```
### 3. Tabel day

Tabel day merupakan tabel indikator hari (untuk digunakan dalam tabel dimensi `time`). Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                      |
|:-------------|:----------------------|:---------------------------------|
| day_id       | integer, primary key  | id hari, 1=senin hingga 7=minggu |
| day_name     | char(10)              | Nama hari                        |

### Create Table day

```sql
CREATE TABLE IF NOT EXISTS public.day
(
    day_id integer NOT NULL,
    day_name character(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT day_pkey PRIMARY KEY (day_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.day
    OWNER to postgres;
    
```
### 4. Tabel month

Tabel month merupakan tabel indikator bulan (untuk digunakan dalam tabel dimensi `time`). Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                            |
|:-------------|:----------------------|:---------------------------------------|
| month_id     | integer, primary key  | id bulan, 1=Januari hingga 12=Desember |
| month_name   | char(20)              | Nama hari                              |

### Create Table month

```sql
CREATE TABLE IF NOT EXISTS public.month
(
    month_id integer NOT NULL,
    month_name character(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT month_pkey PRIMARY KEY (month_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.month
    OWNER to postgres;
    
```
### 5. Tabel time

Tabel country merupakan tabel yang berisi dimensi waktu. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                           |
|:-------------|:----------------------|:--------------------------------------|
| time_id      | integer, primary key  | ID waktu                              |
| date         | date                  | Tanggal                               |
| day          | integer               | Satuan tanggal yang nilainya dari 1-31|
| month        | integer, foreign key  | Reference ke kolom `month.month_id`   |
| year         | integer               | Tahun                                 |
| week         | integer               | Minggu ke berapa pada tahun tersebut  |
| day_of_week  | integer, foreign key  | Reference ke kolom `day.day_id        |

### Create Table time

```sql
CREATE TABLE IF NOT EXISTS public."time"
(
    time_id integer NOT NULL,
    date date NOT NULL,
    day integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    week integer NOT NULL,
    day_of_week integer NOT NULL,
    CONSTRAINT time_pkey PRIMARY KEY (time_id),
    CONSTRAINT time_day_of_week_fkey FOREIGN KEY (day_of_week)
        REFERENCES public.day (day_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT time_month_fkey FOREIGN KEY (month)
        REFERENCES public.month (month_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."time"
    OWNER to postgres;
    
```
### 6. Tabel country_health_index

Tabel ini berisi indeks kesehatan sebuah negara pada waktu tertentu. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                                    |
|:-------------|:----------------------|:-----------------------------------------------|
| country_id   | integer, foreign key  | Reference ke `country.country_id`              |
| time_id      | integer, foreign_key  | Reference ke `time.time_id                     |
| value        | double precision      | Indeks kesehatan negara itu pada waktu tertentu|

### Create Table country_health_index

```sql
CREATE TABLE IF NOT EXISTS public.country_health_index
(
    country_id integer,
    time_id integer,
    value double precision,
    CONSTRAINT country_health_index_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT country_health_index_time_id_fkey FOREIGN KEY (time_id)
        REFERENCES public."time" (time_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country_health_index
    OWNER to postgres;
    
```
### 7. Tabel country_testing_policy

Tabel ini merupakan tabel yang memuat indikator apakah negara tersebut pada waktu itu menerapkan testing atau tidak, 0 = tidak, 1 = ya. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                                    |
|:-------------|:----------------------|:-----------------------------------------------|
| country_id   | integer, foreign key  | reference ke `country.country_id`              |
| time_id      | integer, foreign_key  | Reference ke `time.time_id                     |
| value        | char                  | status keterangan menerapkan testing policy    |

### Create Table country_testing_policy

```sql
CREATE TABLE IF NOT EXISTS public.country_testing_policy
(
    country_id integer,
    time_id integer,
    value "char",
    CONSTRAINT country_testing_policy_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT country_testing_policy_time_id_fkey FOREIGN KEY (time_id)
        REFERENCES public."time" (time_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country_testing_policy
    OWNER to postgres;
    
```

### 8. Tabel measurement

Tabel ini merupakan tabel kebijakan mengenai COVID-19 yang diterapkan suatu negara pada wkatu tertentu. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute    | Type                  | Description                                    |
|:-------------|:----------------------|:-----------------------------------------------|
| country_id   | integer, foreign key  | Reference ke `country.country_id`              |
| time_id      | integer, foreign_key  | Reference ke `time.time_id                     |
| measure_value| varchar(100)          | nama kebijakan yang diambil                    |
| note         | varchar(100)          | catatan                                        |
| category     | varchar(50)           | kategori kebijakan                             |
| source_id    | integer, foreign key  | reference ke `source.source_id                 |


### Create Table measurement

```sql
CREATE TABLE IF NOT EXISTS public.measurement
(
    country_id integer,
    time_id integer,
    measure_value character varying(100) COLLATE pg_catalog."default",
    note character varying(100) COLLATE pg_catalog."default",
    category character varying(50) COLLATE pg_catalog."default",
    source_id integer,
    CONSTRAINT measurement_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT measurement_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES public.source (source_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT measurement_time_id_fkey FOREIGN KEY (time_id)
        REFERENCES public."time" (time_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.measurement
    OWNER to postgres;
    
```
### 9. Tabel data

Tabel ini merupakan tabel hasil observasi COVID-19 menurut negara dan waktu, serta sumber data yang diperoleh. Detail atribut dan deskripsi dari masing-masing adalah sebagai berikut :

| Attribute           | Type                  | Description                       |
|:--------------------|:----------------------|:----------------------------------|
| country_id          | integer, foreign key  | Reference ke `country.country_id` |
| time_id             | integer, foreign_key  | Reference ke `time.time_id        |
| cases               | integer               | banyak kasus aktif                |
| deaths              | integer               | banyak kasus meninggal            |
| recovered           | integer               | banyak kasus sembuh               |
| cumulative_cases    | bigint                | kumulatif kasus aktif             |
| cumulative_deaths   | bigint                | kumulatif kasus meninggal         |
| cumulative_recovered| bigint                | kumulatif kasus sembuh            |
| source_id           | integer, foreign key  | reference ke `source.source_id    |


### Create Table data

```sql
CREATE TABLE IF NOT EXISTS public.data
(
    time_id integer,
    country_id integer,
    cases integer,
    deaths integer,
    recovered integer,
    cumulate_cases bigint,
    cumulate_deaths bigint,
    cumulate_recovered bigint,
    source_id integer,
    CONSTRAINT data_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT data_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES public.source (source_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT data_time_id_fkey FOREIGN KEY (time_id)
        REFERENCES public."time" (time_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.data
    OWNER to postgres;
    
```

## :open_file_folder: Struktur Folder

```
.
├── app           # ShinyApps
│   ├── css
│   │   ├── **/*.css
│   ├── server.R
│   └── ui.R
├── data 
│   ├── csv
│   │   ├── **/*.css
│   └── sql
|       └── db.sql
├── src           # Project source code
├── doc           # Doc for the project
├── .gitignore
├── LICENSE
└── README.md
```

## :smiley_cat: Tim Pengembang

- [@walternascimentobarroso](https://walternascimentobarroso.github.io/)
- Full-Stack Developer: [Alfa Nugraha](https://github.com/alfanugraha) G1501211013



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

