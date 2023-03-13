<div align="center">

<img src="https://github.com/semangat-45/DatabaseProject_Covid-19/blob/main/docs/logo.PNG" width="150" height="150">

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
Project ini merupakan tugas akhir mata kuliah STA1562 mengenai basis data (database). Database yang digunakan merupakan database COVID-19 yang berisi kasus COVID-19 di 210 negara di dunia, yang sumbernya diproleh dari:

- Johns Hopkins University
- World Health Organisation (WHO)
- European Centre for Disease Prevention and Control (ECDC)

Dari database ini akan ditampilkan jumlahan kasus COVID-19 (kasus baru, sembuh, dan meninggal) dari suatu negara pada kurun waktu tertentu yaitu dari tanggal 1 Januari 2020 - 30 Juni 2020 . yang direkam dari berbagai sumber dengan memperhatikan mitigasi dan indeks kesehatan dari masing - masing negara. Data dalam database ini dapat di akses dalam file .sql yang telah diunggah dalam repository ini.


## :rice_scene: Screenshot

<img src="https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/screenshot_home.png" width="750">

## :dvd: Demo

Di bawah ini merupakan tautan untuk mendemokan aplikasi ShinyApp 

| url                      | 
| ------------------------ | 
| https://nur-khamidah.shinyapps.io/covid_database_project/| 

## :blue_book: Dokumentasi 

Dokumentasi penggunaan aplikasi database dapat diakses pada [link ini.](https://github.com/semangat-45/DatabaseProject_Covid-19/blob/main/docs/documentations.pdf)

## :exclamation: Requirements

- PostgreSQL 
- ElephantSQL
- RStudio 2022.12.0+353

## :floppy_disk: Skema Database

<img src="https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/skema.png" width="750">

## :rotating_light: ERD

<img src="https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/Untitled.png" width="750">

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
| day_of_week  | integer, foreign key  | Reference ke kolom `day.day_id`       |

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
| time_id      | integer, foreign_key  | Reference ke `time.time_id`                    |
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
| time_id      | integer, foreign_key  | Reference ke `time.time_id`                    |
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
| time_id      | integer, foreign_key  | Reference ke `time.time_id`                    |
| measure_value| varchar(100)          | nama kebijakan yang diambil                    |
| note         | varchar(100)          | catatan                                        |
| category     | varchar(50)           | kategori kebijakan                             |
| source_id    | integer, foreign key  | reference ke `source.source_id`                |


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
| time_id             | integer, foreign_key  | Reference ke `time.time_id`       |
| cases               | integer               | banyak kasus aktif                |
| deaths              | integer               | banyak kasus meninggal            |
| recovered           | integer               | banyak kasus sembuh               |
| cumulative_cases    | bigint                | kumulatif kasus aktif             |
| cumulative_deaths   | bigint                | kumulatif kasus meninggal         |
| cumulative_recovered| bigint                | kumulatif kasus sembuh            |
| source_id           | integer, foreign key  | reference ke `source.source_id`   |


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
│   ├── rsconnect/shinyapps.io/nur-khamidah
│   │   ├── covid_database_project.dcf
│   ├── server.R
│   └── ui.R
├── data           # Data for the project
│   ├── R-syntax-for-postgresql-connect.Rmd
│   ├── R_syntax_for_postgresql_connect.Rmd
|   ├── R_syntax_plot_test.Rmd
|   ├── covid.sql
│   ├── create_covid.txt
|   ├── create_sql_for_rshinny.txt
│   └── data_migration_local_to_server.R
├── docs           # Project documents
│   ├── BE.png
│   ├── DBM.png
|   ├── FE.png
|   ├── TW.png
|   ├── Untitled.png        # ERD
│   ├── covid.png           # Image for ShinyApps Home
|   ├── documentations.pdf
|   ├── logo.PNG
│   ├── screenshot_home.png
│   └── skema.png
├── .DS_store           
├── .gitignore
├── Covid_19_Database.Rproj
└── README.md
```

## :smiley_cat: Tim Pengembang

1. Rizki Alifah Putri (G1501221005 - rizkialifah@apps.ipb.ac.id) as Database Manager
2. Nur Khamidah (G1501221023 - nur.khamidah@apps.ipb.ac.id) as Back-end Shiny Developer
3. Bayu Paramita (G1501222052 - bayu.paramita@apps.ipb.ac.id) as Front-end Shiny Developer
4. Kristuisno M. Kapiluka (G1501221034 - kris009kapiluka@apps.ipb.ac.id) as Technical Writer
