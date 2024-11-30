CREATE DATABASE Universitas;

USE Universitas;


-- Tabel Fakultas
CREATE TABLE Fakultas (
    Kode_Fakultas VARCHAR(10) PRIMARY KEY,
    Nama_Fakultas VARCHAR(100) NOT NULL
);

-- Tabel Jurusan
CREATE TABLE Jurusan (
    Kode_Jurusan VARCHAR(10) PRIMARY KEY,
    Nama_Jurusan VARCHAR(100) NOT NULL,
    Kode_Fakultas VARCHAR(10) REFERENCES Fakultas(Kode_Fakultas)
);

-- Tabel Mahasiswa
CREATE TABLE Mahasiswa (
    NIM INT PRIMARY KEY,
    Nama_Mahasiswa VARCHAR(100) NOT NULL,
    Alamat VARCHAR(255),
    Kode_Jurusan VARCHAR(10) REFERENCES Jurusan(Kode_Jurusan)
);

-- Tabel Mata Kuliah
CREATE TABLE Mata_Kuliah (
    Kode_Mata_Kuliah VARCHAR(10) PRIMARY KEY,
    Nama_Mata_Kuliah VARCHAR(100) NOT NULL,
    SKS INT NOT NULL
);

-- Tabel Mengambil
CREATE TABLE Mengambil (
    NIM INT REFERENCES Mahasiswa(NIM),
    Kode_Mata_Kuliah VARCHAR(10) REFERENCES Mata_Kuliah(Kode_Mata_Kuliah),
    Nilai INT NOT NULL,
    PRIMARY KEY (NIM, Kode_Mata_Kuliah)
);



-- Tambahkan data ke tabel Fakultas
INSERT INTO Fakultas (Kode_Fakultas, Nama_Fakultas)
VALUES
    ('F01', 'Fakultas Ilmu Komputer'),
    ('F02', 'Fakultas Ekonomi Bisnis'),
    ('F03', 'Fakultas Teknik');

SELECT * FROM Fakultas 

-- Tambahkan data ke tabel Jurusan
INSERT INTO Jurusan (Kode_Jurusan, Nama_Jurusan, Kode_Fakultas)
VALUES
    ('J01', 'Sistem Informasi', 'F01'),
    ('J02', 'Bisnis Digital', 'F02'),
    ('J03', 'Teknik Informatika', 'F03');

SELECT * FROM Jurusan 

-- Tambahkan data ke tabel Mahasiswa
INSERT INTO Mahasiswa (NIM, Nama_Mahasiswa, Alamat, Kode_Jurusan)
VALUES
    (101, 'Karina Puspita', 'Purwokerto', 'J01'),
    (102, 'Kyle Smith', 'Cilacap', 'J02'),
    (103, 'Aycel Kanaya', 'Banyumas', 'J03');
    
    SELECT  * FROM Mahasiswa 

-- Tambahkan data ke tabel MataKuliah
INSERT INTO Mata_Kuliah (Kode_Mata_Kuliah, Nama_Mata_Kuliah, SKS)
VALUES
    ('MK01', 'Pemrograman Basis Data', 3),
    ('MK02', 'Pengantar Bisnis', 2),
    ('MK03', 'Matematika Diskrit', 3);
    
    SELECT * FROM Mata_Kuliah

-- Tambahkan data ke tabel Mengambil
INSERT INTO Mengambil (NIM, Kode_Mata_Kuliah, Nilai)
VALUES
    (101, 'MK01', 85),
    (101, 'MK02', 78),
    (102, 'MK02', 90),
    (103, 'MK03', 88);
    
    SELECT * FROM Mengambil 


--Mengambil daftar mahasiswa beserta informasi jurusan dan fakultas

SELECT m.NIM, m.Nama_Mahasiswa, m.Alamat, j.Nama_Jurusan, f.Nama_Fakultas
FROM Mahasiswa m
JOIN Jurusan j ON m.Kode_Jurusan = j.Kode_Jurusan
JOIN Fakultas f ON j.Kode_Fakultas = f.Kode_Fakultas;
 


-- Mengambil daftar mata kuliah beserta jumlah mahasiswa yang mengambil masing-masing mata kuliah

 SELECT mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, mk.SKS, COUNT(m.NIM) AS Jumlah_Mahasiswa
FROM Mata_Kuliah mk
LEFT JOIN Mengambil m ON mk.Kode_Mata_Kuliah = m.Kode_Mata_Kuliah
GROUP BY mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, mk.SKS;



-- Mengambil nilai rata-rata mahasiswa pada setiap mata kuliah

SELECT mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, AVG(m.Nilai) AS RataRataNilai
FROM Mata_Kuliah mk
LEFT JOIN Mengambil m ON mk.Kode_Mata_Kuliah = m.Kode_Mata_Kuliah
GROUP BY mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah;



-- Mengambil daftar mahasiswa dan mata kuliah yang diambil oleh mahasiswa tertentu:

SELECT m.NIM, m.Nama_Mahasiswa, mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, ma.Nilai
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
JOIN Mata_Kuliah mk ON ma.Kode_Mata_Kuliah = mk.Kode_Mata_Kuliah
WHERE m.NIM = 101;


-- Mengambil daftar mahasiswa yang belum mengambil mata kuliah tertentu

SELECT m.NIM, m.Nama_Mahasiswa
FROM Mahasiswa m
WHERE NOT EXISTS (
    SELECT 1
    FROM Mata_Kuliah mk
    WHERE NOT EXISTS (
        SELECT 1
        FROM Mengambil ma
        WHERE m.NIM = ma.NIM AND mk.Kode_Mata_Kuliah = ma.Kode_Mata_Kuliah
    )
);


-- Mengambil daftar mahasiswa dan total SKS yang diambil oleh setiap mahasiswa

SELECT m.NIM, m.Nama_Mahasiswa, SUM(mk.SKS) AS TotalSKS
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
JOIN Mata_Kuliah mk ON ma.Kode_Mata_Kuliah = mk.Kode_Mata_Kuliah
GROUP BY m.NIM, m.Nama_Mahasiswa;


-- Menghitung rata-rata nilai dari semua mata kuliah 

SELECT AVG(Nilai) AS RataRataNilai
FROM Mengambil;


-- Memperbarui data nilai mahasiswa untuk mata kuliah tertentu 

UPDATE Mengambil
SET Nilai = 95
WHERE NIM = 102 AND Kode_Mata_Kuliah = 'MK02';

SELECT * FROM Mengambil 



-- Menampilkan daftar mahasiswa beserta nama fakultas dan jurusan yang diambil 

SELECT m.Nama_Mahasiswa, f.Nama_Fakultas, j.Nama_Jurusan
FROM Mahasiswa m
JOIN Jurusan j ON m.Kode_Jurusan = j.Kode_Jurusan
JOIN Fakultas f ON j.Kode_Fakultas = f.Kode_Fakultas;



-- Menghapus mata kuliah yang tidak diambil oleh mahasiswa

DELETE FROM Mata_Kuliah
WHERE NOT EXISTS (
    SELECT 1
    FROM Mengambil ma
    WHERE Mata_Kuliah.Kode_Mata_Kuliah = ma.Kode_Mata_Kuliah
);

SELECT * FROM Mata_Kuliah


-- Menampilkan daftar fakultas beserta jumlah mahasiswa yang ada di setiap fakultas 

SELECT f.Nama_Fakultas, COUNT(m.NIM) AS JumlahMahasiswa
FROM Fakultas f
JOIN Jurusan j ON f.Kode_Fakultas = j.Kode_Fakultas
JOIN Mahasiswa m ON j.Kode_Jurusan = m.Kode_Jurusan
GROUP BY f.Nama_Fakultas;


-- Menampilkan daftar mahasiswa dan mata kuliah yang diambil beserta nilai dalam satu kueri

SELECT m.NIM, m.Nama_Mahasiswa, mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, ma.Nilai
FROM Mahasiswa m
LEFT JOIN Mengambil ma ON m.NIM = ma.NIM
LEFT JOIN Mata_Kuliah mk ON ma.Kode_Mata_Kuliah = mk.Kode_Mata_Kuliah;




-- Menampilkan mahasiswa dengan nilai tertinggi dalam suatu mata kuliah

SELECT TOP 1 m.Nama_Mahasiswa, ma.Nilai
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
WHERE ma.Kode_Mata_Kuliah = 'MK01'
ORDER BY ma.Nilai DESC;


-- Menampilkan total SKS dan IPK dari setiap mahasiswa

SELECT m.NIM, m.Nama_Mahasiswa,
       SUM(mk.SKS) AS TotalSKS,
       SUM(ma.Nilai * mk.SKS) / SUM(mk.SKS) AS IPK
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
JOIN Mata_Kuliah mk ON ma.Kode_Mata_Kuliah = mk.Kode_Mata_Kuliah
GROUP BY m.NIM, m.Nama_Mahasiswa;


-- Menghitung rata-rata nilai mahasiswa pada tiap mata kuliah dengan nilai di atas batas tertentu

SELECT mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah, AVG(ma.Nilai) AS RataRataNilai
FROM Mata_Kuliah mk
JOIN Mengambil ma ON mk.Kode_Mata_Kuliah = ma.Kode_Mata_Kuliah
WHERE ma.Nilai > 70
GROUP BY mk.Kode_Mata_Kuliah, mk.Nama_Mata_Kuliah;


-- Menghitung total SKS dan nilai rata-rata mahasiswa pada setiap fakultas

SELECT f.Nama_Fakultas, COUNT(m.NIM) AS JumlahMahasiswa,
       SUM(mk.SKS) AS TotalSKS, AVG(ma.Nilai) AS RataRataNilai
FROM Fakultas f
JOIN Jurusan j ON f.Kode_Fakultas = j.Kode_Fakultas
JOIN Mahasiswa m ON j.Kode_Jurusan = m.Kode_Jurusan
LEFT JOIN Mengambil ma ON m.NIM = ma.NIM
LEFT JOIN Mata_Kuliah mk ON ma.Kode_Mata_Kuliah = mk.Kode_Mata_Kuliah
GROUP BY f.Nama_Fakultas;


-- Menampilkan daftar mahasiswa dan jumlah mata kuliah yang diambil oleh setiap mahasiswa

SELECT m.NIM, m.Nama_Mahasiswa, COUNT(ma.Kode_Mata_Kuliah) AS Jumlah_Mata_Kuliah
FROM Mahasiswa m
LEFT JOIN Mengambil ma ON m.NIM = ma.NIM
GROUP BY m.NIM, m.Nama_Mahasiswa;


-- Menampilkan daftar mahasiswa yang mengambil lebih dari satu mata kuliah

SELECT m.NIM, m.Nama_Mahasiswa
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
GROUP BY m.NIM, m.Nama_Mahasiswa
HAVING COUNT(ma.Kode_Mata_Kuliah) > 1;


-- Menampilkan mahasiswa dengan nilai terendah dalam suatu mata kuliah 

SELECT m.Nama_Mahasiswa, ma.Nilai
FROM Mahasiswa m
JOIN Mengambil ma ON m.NIM = ma.NIM
WHERE ma.Kode_Mata_Kuliah = 'MK01'
ORDER BY ma.Nilai ASC; 


-- Menampilkan daftar mata kuliah yang belum diambil oleh mahasiswa tertentu

SELECT Kode_Mata_Kuliah, Nama_Mata_Kuliah, SKS
FROM Mata_Kuliah
WHERE Kode_Mata_Kuliah NOT IN (
    SELECT Kode_Mata_Kuliah
    FROM Mengambil
    WHERE NIM = 102
);


-- Mengganti nama fakultas untuk suatu jurusan 

UPDATE Fakultas
SET Nama_Fakultas = 'Fakultas Manajemen'
WHERE Kode_Fakultas = 'F02';

SELECT * FROM Fakultas
