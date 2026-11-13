# Relopoli — Settings UI
**Status:** Final Brainstorm / UI Specification  
**Scope:** Settings UI dan perilaku pengaturan pemain

## 1. Tujuan

Settings UI menyediakan pengaturan lokal agar pemain dapat menyesuaikan audio, kualitas visual, dan animasi selama bermain Relopoli.

UI berbentuk modal di tengah layar, mengikuti visual identity Relopoli: panel navy/blue, ornamen atau border emas, sudut membulat, dan latar gameplay/board yang dibuat blur.

Settings UI memiliki empat kategori:
1. Audio
2. Visual
3. Gameplay
4. Other

## 2. Audio

### 2.1 Music Volume
- Kontrol: slider dari 0% sampai 100%.
- Sediakan tombol mute tersendiri untuk musik.
- Default volume: **belum ditentukan**.
- Mute musik tidak memengaruhi Sound Effects.

### 2.2 Sound Effects Volume
- Kontrol: slider dari 0% sampai 100%.
- Sediakan tombol mute tersendiri untuk Sound Effects.
- Default volume: **belum ditentukan**.
- Mute Sound Effects tidak memengaruhi musik.

### Aturan Audio
- Music Volume dan Sound Effects Volume merupakan dua pengaturan independen.
- Status mute masing-masing juga independen.
- Brainstorm ini belum menetapkan nilai default volume maupun status mute default.

## 3. Visual

### 3.1 Graphics Quality
- Pilihan: **Low / Medium / High**.
- Default: **Medium**.
- Low memprioritaskan performa.
- Medium memberikan keseimbangan antara performa dan tampilan.
- High menampilkan efek dan detail visual khusus Relopoli secara maksimal.
- Pengaturan ini mengontrol efek/detail visual milik Relopoli; jangan menjanjikan bahwa pengaturan ini mengubah global graphics setting Roblox.

### 3.2 Show Other Players’ Effects
- Kontrol: **ON / OFF**.
- Default: **ON**.
- ON: efek visual pemain lain ditampilkan.
- OFF: efek visual pemain lain disembunyikan secara lokal bagi pemain yang mengubah pengaturan.
- Pengaturan ini tidak mengubah gameplay dan tidak memengaruhi tampilan yang dilihat pemain lain.

### 3.3 Camera Shake Effects
- Kontrol: **ON / OFF**.
- Default: **OFF**.
- ON: efek camera shake ditampilkan ketika digunakan oleh game.
- OFF: efek camera shake dinonaktifkan secara lokal.
- Pengaturan ini hanya memengaruhi presentasi kamera lokal, bukan mekanik gameplay.

## 4. Gameplay

Semua pengaturan animasi di kategori ini menggunakan toggle **ON / OFF** dengan default **ON**.

### 4.1 Show Dice Roll Animation
- Default: **ON**.
- ON: animasi lemparan dadu ditampilkan.
- OFF: animasi dadu dilewati atau dipersingkat agar hasil lebih cepat terlihat.
- Hasil dadu tetap ditentukan oleh server. Pengaturan ini tidak mengubah peluang maupun hasil roll.

### 4.2 Show Property Purchase Animation
- Default: **ON**.
- ON: animasi pembelian Property ditampilkan.
- OFF: animasi pembelian Property dilewati agar alur permainan lebih cepat.
- Pembelian dan perubahan ownership tetap diproses normal oleh server.

### 4.3 Show Upgrade Animation
- Default: **ON**.
- ON: animasi upgrade Property ditampilkan.
- OFF: animasi upgrade Property dilewati agar alur permainan lebih cepat.
- Biaya upgrade serta perubahan level, Value, dan Rent tetap diproses normal oleh server.

### Aturan Gameplay
Pengaturan animasi hanya mengubah presentasi yang dilihat pemain. Pengaturan ini tidak boleh mengubah hasil dadu, transaksi, ownership, biaya, level Property, Value, Rent, atau hasil mekanik gameplay lainnya.

## 5. Other

### 5.1 Reset Settings
- Sediakan tombol **Reset Settings**.
- Ketika ditekan, tampilkan dialog konfirmasi terlebih dahulu.
- **Cancel:** tutup dialog dan pertahankan semua pengaturan saat ini.
- **Confirm:** kembalikan semua pengaturan ke nilai default yang ditetapkan.

Reset Settings mengembalikan pengaturan ke default, bukan mengatur ulang progres atau data gameplay pemain.

## 6. Ringkasan Pengaturan dan Default

| Kategori | Pengaturan | Kontrol | Default |
|---|---|---|---|
| Audio | Music Volume | Slider 0–100% + mute independen | Belum ditentukan |
| Audio | Sound Effects Volume | Slider 0–100% + mute independen | Belum ditentukan |
| Visual | Graphics Quality | Low / Medium / High | Medium |
| Visual | Show Other Players’ Effects | ON / OFF | ON |
| Visual | Camera Shake Effects | ON / OFF | OFF |
| Gameplay | Show Dice Roll Animation | ON / OFF | ON |
| Gameplay | Show Property Purchase Animation | ON / OFF | ON |
| Gameplay | Show Upgrade Animation | ON / OFF | ON |
| Other | Reset Settings | Tombol + dialog konfirmasi | — |

## 7. Arahan UI/UX

- Settings dibuka sebagai modal di tengah layar.
- Gunakan gaya visual Relopoli: navy/blue, aksen emas, border dekoratif, dan sudut membulat.
- Empat kategori ditampilkan dengan jelas: Audio, Visual, Gameplay, Other.
- Tampilkan nilai volume pada slider agar pemain mengetahui tingkat volumenya.
- Status ON/OFF dan pilihan kualitas harus mudah dibaca.
- Dialog Reset Settings harus membedakan aksi **Confirm** dan **Cancel** dengan jelas.
- Pastikan pengaturan yang dimatikan hanya mengubah efek atau presentasi lokal, kecuali implementasi teknis nantinya secara eksplisit menentukan hal lain.

## 8. Hal yang Belum Ditentukan

Hal-hal berikut belum diputuskan dalam brainstorm dan perlu ditetapkan sebelum implementasi jika dibutuhkan:
- Default Music Volume.
- Default Sound Effects Volume.
- Default status mute untuk musik dan Sound Effects.
- Apakah pengaturan disimpan lintas sesi atau kembali ke default setiap kali pemain masuk.

Jangan menganggap nilai untuk hal-hal tersebut sudah disepakati sebelum ada keputusan lanjutan.