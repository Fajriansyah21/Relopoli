# Relopoli — Map Design Guide

Dokumen ini merangkum arah rancangan board dan kota berdasarkan Visual Direction serta Property Catalog. Ini adalah panduan desain tingkat tinggi, bukan peta koordinat final atau spesifikasi ukuran Roblox Studio.

## 1. World concept

Relopoli adalah kota universal fiktif. Kota tidak boleh menjadi salinan langsung Jakarta, Bali, New York, Tokyo, atau kota nyata lainnya. Referensi kota modern boleh menginspirasi bentuk dan suasana, tetapi identitas akhirnya harus terasa orisinal.

Board diposisikan sebagai pusat gameplay di dalam kota 3D yang hidup. Lingkungan sekitar memberi konteks dan rasa tempat, tetapi tidak boleh mengalahkan keterbacaan board.

## 2. Visual hierarchy

Urutan prioritas visual:
1. Player dan gameplay feedback.
2. Board.
3. Property dan landmark.
4. Lingkungan kota.
5. Siluet kota di kejauhan.

Board harus tetap terbaca dari kamera utama. Lingkungan kota berfungsi membingkai board, bukan menjadi distraksi.

Arah visual: stylized 3D, Roblox-inspired, isometric atau elevated third-person presentation, bentuk bersih dan approachable, warna cerah, pencahayaan daytime yang lembut, serta detail lingkungan yang kaya tetapi tidak berantakan.

## 3. District identity

Property Catalog membagi kota ke empat distrik utama:

| District | Tema | Bahasa visual |
|---|---|---|
| D1 — Growing Community | Neighborhood, residential, community, waterfront | Hijau, tenang, ramah, taman, area hunian dan usaha lokal |
| D2 — Urban Commercial District | Business, shopping, city life | Jalan lebih lebar, bangunan lebih tinggi, retail, signage, plaza, kantor |
| D3 — Entertainment & Leisure District | Hiburan dan pengalaman sosial | Warna ekspresif, venue besar, billboard, event banner, lighting dekoratif, fountain |
| D4 — Luxury & Prestige District | Fashion, fine dining, art, luxury retail, premium residences | Elegan, aspirational, sophisticated, modern stylized |

Nama Property, kategori, dan Set tetap mengacu pada [Property Catalog Reference](../design/PROPERTY_CATALOG_REFERENCE.md).

## 4. Property progression

Lima level pengembangan Property harus terlihat jelas dari jauh dan tidak hanya berarti bangunan menjadi lebih besar:

**Empty Land → Small Establishment → Growing Business → Major Development → Iconic Landmark**

Setiap Property perlu identitas melalui silhouette, fitur arsitektur utama, signage, warna, landscaping, props, tema, dan progres level.

Level 5 seharusnya terasa cukup penting untuk menjadi landmark yang dikenali dari bagian board lain.

## 5. Special visual identity

- **Crown:** harus lebih prestisius dan langka dibanding Property biasa. Gunakan arsitektur, platform, landscaping, lighting, dan efek yang mudah dikenali.
- **Dice:** merupakan elemen gameplay yang memiliki arahan visual tersendiri pada Visual Direction.
- **Player:** karakter stylized dengan siluet yang terbaca di atas board.
- **Environment:** kota dapat memuat mid-rise buildings, tower di kejauhan, neighborhood, café, retail, taman, waterfront, bridge, marina, street furniture, pedestrian, kendaraan, dan landmark.

## 6. Prinsip layout dan readability

- Jangan biarkan bangunan latar menutupi tile atau token pemain.
- Bedakan area gameplay dengan lingkungan dekoratif.
- Beri identitas visual berbeda pada tiap distrik.
- Pastikan upgrade Property dan status Crown dapat dikenali tanpa harus membaca teks kecil.
- Efek, signage, dan dekorasi tidak boleh mengaburkan informasi penting.

## 7. Belum ditetapkan dalam sumber

Dokumen sumber yang tersedia belum menetapkan secara final:
- ukuran dunia dan dimensi board;
- koordinat atau footprint setiap bangunan;
- tinggi kamera dan nilai field of view final;
- ukuran tile dan jarak antartile;
- layout final landmark pusat;
- daftar asset 3D final dan optimasi performanya.

Hal-hal tersebut perlu diputuskan saat blockout dan prototype di Roblox Studio. Jangan menganggapnya sudah LOCKED hanya karena tercantum di panduan visual.
