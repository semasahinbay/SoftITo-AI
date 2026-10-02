-- =====================================================
-- FOREIGN KEY
-- =====================================================

-- SQLite'ta FOREIGN KEY deste?ini açar
PRAGMA foreign_keys = ON;


-- =====================================================
-- TABLOLARI OLU?TURMA
-- =====================================================

CREATE TABLE ogrenciler(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    yas INTEGER CHECK (yas > 13),
    sehir TEXT DEFAULT 'Erzincan',
    kayit TEXT DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE dersler(
    id INTEGER PRIMARY KEY,
    ad TEXT UNIQUE NOT NULL
);


CREATE TABLE notlar(
    ogrenci_id INTEGER REFERENCES ogrenciler(id) ON DELETE CASCADE,
    ders_id INTEGER REFERENCES dersler(id),
    puan REAL,
    PRIMARY KEY (ogrenci_id, ders_id)
);


-- =====================================================
-- DERSLER? EKLEME
-- =====================================================

-- Önce dersleri ekleyelim
-- ders_id'ler 1'den ba?lar

INSERT INTO dersler (id, ad) VALUES
(1, 'Matematik'),
(2, 'Fizik'),
(3, 'Kimya'),
(4, 'Biyoloji'),
(5, 'Tarih');


-- =====================================================
-- Ö?RENC?LER? EKLEME
-- =====================================================

-- 20 tane ö?renci ekleyelim
-- yas > 13 kural?na uygun

INSERT INTO ogrenciler (ad, yas, sehir) VALUES
('Ahmet Y?lmaz', 15, 'Ankara'),
('Ay?e Demir', 16, '?stanbul'),
('Mehmet Kaya', 14, 'Erzincan'),
('Fatma Çelik', 17, '?zmir'),
('Can ?ahin', 15, 'Bursa'),
('Zeynep Ayd?n', 18, 'Erzincan'),
('Ali Koç', 14, 'Antalya'),
('Elif Arslan', 16, 'Trabzon'),
('Mustafa Y?ld?z', 15, 'Erzincan'),
('?rem Öztürk', 17, 'Adana'),
('Burak Korkmaz', 19, 'Konya'),
('Merve Polat', 14, 'Erzincan'),
('Emre Do?an', 16, 'Samsun'),
('Selin Çetin', 15, 'Gaziantep'),
('Kerem Aksoy', 18, 'Kayseri'),
('Deniz Güler', 14, 'Erzincan'),
('Cemre Yalç?n', 17, 'Eski?ehir'),
('Onur Çak?r', 15, 'Mersin'),
('Gamze Tekin', 16, 'Erzincan'),
('Umut ?en', 18, 'Diyarbak?r');


-- =====================================================
-- DERS NOTLARINI EKLEME
-- =====================================================

-- Ö?rencilere ders notlar? ekleyelim
-- JOIN sorgular?n?n ç?kt? vermesi için

INSERT INTO notlar (ogrenci_id, ders_id, puan) VALUES
(1, 1, 85.5), (1, 2, 70.0),
(2, 1, 90.0), (2, 3, 78.5),
(3, 2, 65.0), (3, 4, 82.0),
(4, 1, 95.0), (4, 5, 88.0),
(5, 3, 74.0), (5, 5, 60.5),
(6, 1, 80.0), (6, 2, 92.0),
(7, 4, 76.5), (7, 5, 85.0),
(8, 2, 88.5), (8, 3, 90.0),
(9, 1, 67.0), (9, 4, 71.5),
(10, 3, 93.0), (10, 5, 84.0),
(11, 1, 55.0), (11, 2, 62.0),
(12, 2, 78.0), (12, 3, 80.0),
(13, 4, 91.0), (13, 5, 75.0),
(14, 1, 82.5), (14, 3, 89.0),
(15, 2, 73.0), (15, 4, 68.5),
(16, 1, 96.0), (16, 5, 90.0),
(17, 3, 64.0), (17, 4, 79.5),
(18, 1, 77.0), (18, 2, 83.0),
(19, 2, 85.0), (19, 5, 88.5),
(20, 3, 92.0), (20, 4, 94.5);


-- =====================================================
-- JOIN ??LEMLER?
-- =====================================================

SELECT o.ad, d.ad AS ders, n.puan
FROM notlar n
JOIN ogrenciler o ON o.id = n.ogrenci_id
JOIN dersler d ON d.id = n.ders_id;


-- =====================================================
-- GRUPLAMA VE TOPLAMA FONKS?YONLARI
-- =====================================================

SELECT
    ogrenci_id,
    AVG(puan) AS ort,
    COUNT(*) AS ders_sayisi,
    MAX(puan) AS max_puan
FROM notlar
GROUP BY ogrenci_id
HAVING AVG(puan) > 75;


-- =====================================================
-- ALT SORGU (SUBQUERY)
-- =====================================================

SELECT ad
FROM ogrenciler
WHERE id IN (
    SELECT ogrenci_id
    FROM notlar
    WHERE puan > 85
);


-- =====================================================
-- CASE
-- =====================================================

SELECT
    ad,
    puan,
    CASE
        WHEN puan >= 85 THEN 'AA'
        WHEN puan >= 70 THEN 'BB'
        ELSE 'ff'
    END AS harf
FROM notlar
JOIN ogrenciler ON ogrenciler.id = notlar.ogrenci_id;


-- =====================================================
-- ALTER TABLE - EPOSTA SÜTUNU EKLEME
-- =====================================================

-- Hocan?n verdi?i uygulama:
-- ogrenciler tablosuna eposta sütunu ekleme

ALTER TABLE ogrenciler
ADD COLUMN eposta TEXT;


-- =====================================================
-- INDEX
-- =====================================================

-- Ö?renci ad?na index olu?tur
CREATE INDEX idx_ogrenci_ad
ON ogrenciler(ad);


-- E-posta adreslerinin benzersiz olmas?n? sa?layan UNIQUE INDEX
CREATE UNIQUE INDEX idx_eposta
ON ogrenciler(eposta);