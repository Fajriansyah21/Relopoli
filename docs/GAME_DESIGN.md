# Relopoli — Game Design Overview

Dokumen ini adalah pintu masuk untuk memahami rancangan game secara keseluruhan. Dokumen ini merangkum arah desain, bukan menggantikan aturan detail pada Master Source of Truth dan dokumen sistem.

## 1. Konsep inti

Relopoli adalah game multiplayer bergaya board game 3D yang berlangsung di sebuah kota fiktif bernama Relopoli. Pemain bergerak di sepanjang board, berinteraksi dengan tile dan pemain lain, mengelola Balance, memperoleh serta mengembangkan Property, dan bersaing mencapai kondisi kemenangan.

Arah pengalaman yang dituju:
- Casual, fun, bright, friendly, playful, dan aspirational.
- Kompetitif dan strategis tanpa atmosfer agresif atau menegangkan.
- Kota terasa hidup dan layak dijelajahi, sementara board tetap menjadi pusat keterbacaan gameplay.

Sumber: [Visual Direction](visual/VISUAL_VIBE_MASTER.md) dan [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md).

## 2. Gameplay loop utama

Alur normal satu giliran:

1. Turn Start dan News Phase.
2. Pemain melakukan Roll.
3. Dice Resolution menentukan hasil gerakan.
4. Movement Engine menjalankan perpindahan.
5. Sistem memeriksa Start / First Lap bila relevan.
6. Landing Resolution memproses tile tujuan.
7. Special Resolution atau blocking UI diselesaikan.
8. Global Victory Check dijalankan.
9. Extra Roll diperiksa.
10. Turn End dilakukan jika tidak ada proses lanjutan.

Turn Controller adalah pemilik alur giliran. Sistem domain mengembalikan hasil resolusi dan tidak mengambil alih Turn End secara diam-diam.

## 3. Aktivitas dan strategi pemain

Pemain dapat berinteraksi dengan ekonomi dan kepemilikan melalui:
- Membeli dan mengembangkan Property.
- Mengelola Balance, kewajiban pembayaran, dan Bankruptcy.
- Mengumpulkan Set dan bersaing atas Crown.
- Menggunakan News, Transport, dan mekanik khusus lainnya.
- Melakukan Trade dan Transaction dengan pemain lain sesuai validasi final server.

Detail biaya, syarat, urutan resolusi, modifier, dan edge case berada pada dokumen sistem terkait. Ringkasan ini tidak mengubah angka atau aturan sumber.

## 4. Kondisi kemenangan

Master Source of Truth mencatat empat jalur kemenangan:
1. Last Player Standing.
2. Crown Victory.
3. Set Victory.
4. L5 Property Victory.

Global Victory Check menjadi pemeriksa kondisi kemenangan. Detail syarat dan prioritasnya mengikuti Master Source of Truth serta Master Flow.

## 5. Prinsip pengalaman dan aturan

- Server adalah sumber kebenaran gameplay.
- UI hanya merepresentasikan state dan menerima intent pemain; UI tidak menentukan aturan.
- Game End adalah hard stop untuk gameplay mutation berikutnya.
- Operasi yang sudah selesai tidak boleh dijalankan ulang atau di-rollback.
- Resolution Chain dan blocking UI harus mengikuti Turn Controller.
- Aturan terbaru yang secara eksplisit dikunci menjadi acuan; riwayat progress lama tetap disimpan.

## 6. Dokumen lanjutan

- [Game Systems](GAME_SYSTEMS.md): peta sistem dan dokumen detail.
- [Map Design](MAP_DESIGN.md): arah board, kota, distrik, dan bahasa visual.
- [Development Log](DEVELOPMENT_LOG.md): riwayat progress dan status rancangan.
- [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md): aturan gameplay kanonis.
- [Architecture Review Index](ARCHITECTURE_INDEX.md): keputusan arsitektur dan validasi.

## 7. Batas status dokumen

Dokumen desain yang sudah disusun bukan bukti bahwa fitur telah dibuat di Roblox Studio. Status implementasi dan pengujian harus dicatat terpisah di Development Log.
