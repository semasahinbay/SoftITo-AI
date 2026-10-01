-- =====================================================
-- OYUNCAK KUTUSU ALI?TIRMALARI
-- =====================================================


-- =====================================================
-- BÖLÜM 1 - TABLO KURMA
-- =====================================================

CREATE TABLE oyuncaklar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isim TEXT NOT NULL,
    cesit TEXT,
    fiyat REAL CHECK (fiyat > 0),
    renk TEXT DEFAULT 'k?rm?z?'
);


-- =====================================================
-- BÖLÜM 2 - EKLEME
-- =====================================================

-- Renk belirtilmedi?i için DEFAULT de?eri olan 'k?rm?z?' atan?r.
INSERT INTO oyuncaklar (isim, cesit, fiyat)
VALUES ('?im?ek', 'araba', 50);


-- Dört oyunca?? tek komutla ekleme
INSERT INTO oyuncaklar (isim, cesit, fiyat, renk)
VALUES
    ('Ay?c?k', 'pelu?', 80, 'kahverengi'),
    ('Kale Seti', 'lego', 150, 'gri'),
    ('Z?pz?p', 'top', 20, 'sar?'),
    ('Barbi', 'bebek', 90, 'pembe');


-- =====================================================
-- BÖLÜM 3 - BULMA
-- =====================================================

-- Kutudaki tüm oyuncaklar? göster
SELECT *
FROM oyuncaklar;


-- Fiyat? 80 TL ve üzeri olan oyuncaklar?n
-- sadece isim ve fiyat bilgilerini göster
SELECT isim, fiyat
FROM oyuncaklar
WHERE fiyat >= 80;


-- En pahal? 2 oyunca?? listele
SELECT *
FROM oyuncaklar
ORDER BY fiyat DESC
LIMIT 2;


-- ?smi Z harfiyle ba?layan oyuncaklar? bul
SELECT *
FROM oyuncaklar
WHERE isim LIKE 'Z%';


-- Sadece araba ve toplar? göster
SELECT *
FROM oyuncaklar
WHERE cesit IN ('araba', 'top');


-- Fiyat? 20 ile 60 TL aras?nda olanlar? listele
SELECT *
FROM oyuncaklar
WHERE fiyat BETWEEN 20 AND 60;


-- =====================================================
-- BÖLÜM 4 - DE???T?RME VE S?LME
-- =====================================================

-- ?im?ek'in rengini mavi yap
UPDATE oyuncaklar
SET renk = 'mavi'
WHERE isim = '?im?ek';


-- Z?pz?p'? kutudan ç?kar
DELETE FROM oyuncaklar
WHERE isim = 'Z?pz?p';


-- =====================================================
-- BÖLÜM 5 - TABLOYU DÜZENLEME
-- =====================================================

-- Tabloya kimin ad?nda yeni bir sütun ekle
ALTER TABLE oyuncaklar
ADD COLUMN kimin TEXT;


-- Kale Seti'nin sahibini Ali yap
UPDATE oyuncaklar
SET kimin = 'Ali'
WHERE isim = 'Kale Seti';


-- 'cesit' sütununun ad?n? 'tur' olarak de?i?tir
ALTER TABLE oyuncaklar
RENAME COLUMN cesit TO tur;


-- =====================================================
-- BONUS
-- =====================================================

-- DELETE FROM oyuncaklar;

-- Bu komut tablonun kendisini silmez.
-- Tablodaki TÜM kay?tlar? siler.
-- Bu nedenle yukar?daki i?lemler tamamland?ktan sonra
-- dikkatli kullan?lmal?d?r.