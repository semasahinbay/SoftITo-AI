-- =====================================================
-- SQLite Kütüphane Uygulamas?
-- DB dosyas?: kutuphane.sqlite
-- =====================================================

PRAGMA foreign_keys = ON;

-- =====================================================
-- 1. TABLO TASARIMI VE KISITLAR
-- =====================================================

CREATE TABLE uyeler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    yas INTEGER NOT NULL CHECK (yas > 13),
    sehir TEXT DEFAULT 'Erzincan',
    kayit DATETIME DEFAULT CURRENT_TIMESTAMP,
    eposta TEXT
);

CREATE TABLE kitaplar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kitap_adi TEXT NOT NULL UNIQUE
);

CREATE TABLE odunc (
    uye_id INTEGER NOT NULL,
    kitap_id INTEGER NOT NULL,
    gun INTEGER NOT NULL CHECK (gun BETWEEN 3 AND 45),

    PRIMARY KEY (uye_id, kitap_id),

    FOREIGN KEY (uye_id)
        REFERENCES uyeler(id)
        ON DELETE CASCADE,

    FOREIGN KEY (kitap_id)
        REFERENCES kitaplar(id)
);

CREATE INDEX idx_uyeler_ad
ON uyeler(ad);

CREATE UNIQUE INDEX idx_uyeler_eposta_unique
ON uyeler(eposta);

-- =====================================================
-- 2. VER? EKLEME
-- =====================================================

INSERT INTO kitaplar (kitap_adi) VALUES
('Suç ve Ceza'),
('1984'),
('Simyac?'),
('Kürk Mantolu Madonna'),
('Sefiller');

INSERT INTO uyeler (ad, yas, sehir, eposta) VALUES
('Ahmet', 25, '?stanbul', 'ahmet@example.com'),
('Mehmet', 32, 'Ankara', 'mehmet@example.com'),
('Ay?e', 19, '?zmir', 'ayse@example.com'),
('Fatma', 42, 'Erzurum', 'fatma@example.com'),
('Mert', 17, 'Bursa', 'mert@example.com');

-- ?ehir belirtilmezse varsay?lan olarak Erzincan atan?r.
INSERT INTO uyeler (ad, yas, eposta) VALUES
('Zeynep', 24, 'zeynep@example.com'),
('Can', 30, 'can@example.com'),
('Elif', 16, 'elif@example.com'),
('Burak', 35, 'burak@example.com'),
('Deniz', 22, 'deniz@example.com');

-- CHECK testi: çal??t?r?l?rsa hata verir.
-- INSERT INTO uyeler (ad, yas) VALUES ('Çocuk Üye', 10);

-- FK testi: çal??t?r?l?rsa hata verir.
-- INSERT INTO odunc (uye_id, kitap_id, gun) VALUES (99, 1, 15);

INSERT INTO odunc (uye_id, kitap_id, gun) VALUES
(1, 1, 10),
(1, 2, 35),
(2, 2, 25),
(2, 3, 40),
(3, 3, 12),
(3, 4, 32),
(4, 4, 20),
(4, 5, 45),
(5, 5, 8),
(5, 1, 18),
(6, 1, 30),
(6, 3, 38),
(7, 2, 15),
(7, 4, 42),
(8, 3, 6),
(8, 5, 28),
(9, 4, 34),
(9, 1, 22),
(10, 5, 14),
(10, 2, 37);

-- =====================================================
-- 3. JOIN
-- =====================================================

-- Üye ad?, kitap ad? ve gün say?s?
SELECT
    u.ad AS uye,
    k.kitap_adi AS kitap,
    o.gun
FROM odunc o
JOIN uyeler u ON u.id = o.uye_id
JOIN kitaplar k ON k.id = o.kitap_id;

-- 30 günden uzun tutulan kitaplar
SELECT
    u.ad AS uye,
    k.kitap_adi AS kitap,
    o.gun
FROM odunc o
JOIN uyeler u ON u.id = o.uye_id
JOIN kitaplar k ON k.id = o.kitap_id
WHERE o.gun > 30;

-- Sadece Erzincan'daki üyelerin ödünç ald??? kitaplar
SELECT
    u.ad AS uye,
    k.kitap_adi AS kitap,
    o.gun
FROM uyeler u
JOIN odunc o ON u.id = o.uye_id
JOIN kitaplar k ON k.id = o.kitap_id
WHERE u.sehir = 'Erzincan';

-- Hiç kitap almam?? üyeleri de göstermek için LEFT JOIN
SELECT
    u.ad AS uye,
    k.kitap_adi AS kitap,
    o.gun
FROM uyeler u
LEFT JOIN odunc o ON u.id = o.uye_id
LEFT JOIN kitaplar k ON k.id = o.kitap_id;

-- =====================================================
-- 4. GRUPLAMA VE TOPLAMA FONKS?YONLARI
-- =====================================================

-- Her üyenin ortalama süresi, kitap say?s?, en uzun süresi
SELECT
    u.id,
    u.ad,
    AVG(o.gun) AS ortalama_gun,
    COUNT(o.kitap_id) AS kitap_sayisi,
    MAX(o.gun) AS en_uzun_sure
FROM uyeler u
JOIN odunc o ON u.id = o.uye_id
GROUP BY u.id, u.ad;

-- Ortalamas? 20 günün üzerinde olan üyeler
SELECT
    u.id,
    u.ad,
    AVG(o.gun) AS ortalama_gun,
    COUNT(o.kitap_id) AS kitap_sayisi,
    MAX(o.gun) AS en_uzun_sure
FROM uyeler u
JOIN odunc o ON u.id = o.uye_id
GROUP BY u.id, u.ad
HAVING AVG(o.gun) > 20;

-- HAVING, GROUP BY sonras? olu?an gruplar? filtreler.
-- WHERE ise gruplamadan önce sat?rlar? filtreler.

-- Her kitab?n kaç kez ödünç al?nd???
SELECT
    k.kitap_adi,
    COUNT(o.uye_id) AS odunc_sayisi
FROM kitaplar k
LEFT JOIN odunc o ON k.id = o.kitap_id
GROUP BY k.id, k.kitap_adi
ORDER BY odunc_sayisi DESC;

-- ?ehirlere göre üye say?s?
SELECT
    sehir,
    COUNT(*) AS uye_sayisi
FROM uyeler
GROUP BY sehir
ORDER BY uye_sayisi DESC;

-- =====================================================
-- 5. ALT SORGU
-- =====================================================

-- En az bir kitab? 30 günden uzun tutmu? üyeler
SELECT ad
FROM uyeler
WHERE id IN (
    SELECT uye_id
    FROM odunc
    WHERE gun > 30
);

-- Hiç ödünç al?nmam?? kitaplar
SELECT *
FROM kitaplar
WHERE id NOT IN (
    SELECT kitap_id
    FROM odunc
);

-- Genel ortalaman?n üzerinde süre tutulan kay?tlar
SELECT *
FROM odunc
WHERE gun > (
    SELECT AVG(gun)
    FROM odunc
);

-- =====================================================
-- 6. CASE
-- =====================================================

-- Ödünç durumlar?
SELECT
    uye_id,
    kitap_id,
    gun,
    CASE
        WHEN gun > 30 THEN 'Gecikmi?'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyar?'
        ELSE 'Normal'
    END AS durum
FROM odunc;

-- Üyeleri ya??na göre etiketleme
SELECT
    id,
    ad,
    yas,
    CASE
        WHEN yas <= 18 THEN 'Genç'
        ELSE 'Yeti?kin'
    END AS yas_grubu
FROM uyeler;

-- Her durumdan kaç kay?t var?
SELECT
    CASE
        WHEN gun > 30 THEN 'Gecikmi?'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyar?'
        ELSE 'Normal'
    END AS durum,
    COUNT(*) AS kayit_sayisi
FROM odunc
GROUP BY
    CASE
        WHEN gun > 30 THEN 'Gecikmi?'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyar?'
        ELSE 'Normal'
    END;

-- =====================================================
-- 7. INDEX
-- =====================================================

-- idx_uyeler_ad özellikle ada göre aramalar? h?zland?r?r:
SELECT *
FROM uyeler
WHERE ad = 'Ahmet';

-- UNIQUE index nedeniyle a?a??daki i?lem hata verir:
-- UPDATE uyeler
-- SET eposta = 'ahmet@example.com'
-- WHERE id = 2;

-- =====================================================
-- S?LME DAVRANI?I
-- =====================================================

-- Bir üye silinirse, ON DELETE CASCADE nedeniyle
-- o üyeye ait odunc kay?tlar? da silinir.

-- Bir kitap odunc tablosunda kullan?l?yorsa ve silinmeye çal???l?rsa
-- ON DELETE CASCADE tan?ml? olmad??? için FOREIGN KEY hatas? al?n?r.