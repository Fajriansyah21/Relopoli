# Relopoli — Specification 01
# Turn Controller & Resolution Chain

**Status:** DRAFT — SPECIFICATION IN PROGRESS  
**Decision record:** TC-01 through TC-60  
**Individual decision approvals:** TC-01 through TC-60 discussed and approved one by one in the project conversation  
**Consolidated review:** Pending (TC-01 through TC-60)  
**Implementation status:** Not Implemented / Not Tested  
**Scope:** Core Gameplay Prototype, Turn Controller and Resolution Chain contracts

> Dokumen ini adalah checkpoint dokumentasi dari keputusan yang telah disetujui satu per satu selama penyusunan Specification 01. Dokumen ini belum menjadi spesifikasi final yang LOCKED. Jangan mulai implementasi hanya berdasarkan dokumen ini sebelum consolidated review dan approval selesai.

## 1. Purpose

Menetapkan kontrak antara Turn Controller, Parent Turn Resolution Chain, dan sistem gameplay yang berpartisipasi dalam satu giliran.

Tujuan utamanya:
- Turn Controller tetap menjadi satu-satunya authority untuk Turn Flow.
- Sistem gameplay mengerjakan tanggung jawab domain dan mengembalikan hasil.
- Satu giliran memiliki satu Parent Turn Chain.
- Resolution berjalan sequential, tervalidasi, dan tidak menghasilkan efek ganda.
- Blocking UI dapat menangguhkan Chain tanpa mengambil alih Turn State.
- Kegagalan teknis tidak boleh membuat giliran berpindah secara diam-diam.

Dokumen ini melengkapi, bukan menggantikan:
- [Master Source of Truth](../MASTER_SOURCE_OF_TRUTH.md)
- [Progress 19 — Master Flow](../progress/PROGRESS_19_MASTER_FLOW.md)
- [Progress 20 — Edge Case & Exploit Audit](../audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md)
- [Core Gameplay Prototype Scope v1.0](../CORE_GAMEPLAY_PROTOTYPE_SCOPE.md)

Jika ditemukan konflik, aturan gameplay dan source hierarchy pada dokumen kanonis tetap berlaku. Setiap konflik atau kebutuhan perubahan harus dibahas, bukan diselesaikan dengan asumsi implementasi.

## 2. Core Authority

### TC-01 — Turn Controller Authority

Hanya Turn Controller yang boleh:
- memajukan Turn Phase;
- menyelesaikan atau mengakhiri Turn;
- menentukan pemain berikutnya.

Sistem lain hanya boleh mengembalikan Resolution Result atau sinyal penyelesaian proses kepada Turn Controller. Sistem lain tidak boleh mengambil alih pergantian Turn secara independen.

### TC-02 — One Active Parent Turn Chain

Hanya boleh ada satu Parent Turn Resolution Chain aktif pada satu waktu dalam satu match.

Ketika Parent Turn Chain pemain aktif sedang berjalan atau suspended, pemain lain tidak boleh memulai Parent Turn Chain baru.

Batas ini hanya berlaku untuk Parent Turn Resolution Chain. Operasi asynchronous independen seperti Trade dan Transaction tidak termasuk ke dalam batas tersebut.

### TC-02A — Parent Turn Chain vs Independent Async Operations

1. Batas satu Chain aktif berlaku hanya untuk Parent Turn Resolution Chain.
2. Trade dan Transaction tetap asynchronous dan tidak terikat pada giliran aktif.
3. Trade dan Transaction tidak boleh mengambil alih, menangguhkan, atau memajukan Turn Controller.
4. Perubahan state dari Trade atau Transaction diproses sesuai server sequencing, final validation terhadap state terbaru, atomic operation, dan Global Victory Check.
5. Ketika GAME_END terjadi, seluruh proposal Trade dan Transaction yang masih pending dibatalkan. Operasi yang telah selesai tidak di-rollback.

### TC-03A — Match Game State dan Startup Gate

1. Game State tetap menggunakan RUNNING dan ENDED.
2. Persiapan match dan penantian kondisi awal ditangani sebagai startup gate, bukan Game State baru.
3. Kegagalan teknis tidak otomatis membuat Game State ABORTED. Kegagalan teknis ditangani terpisah dari Game State.
4. Turn Controller hanya boleh memulai giliran pertama setelah startup gate berhasil dilewati.

### TC-04A — Parent Turn Chain Lifecycle dan Technical Failure

Lifecycle Parent Turn Chain menggunakan status berikut:

| Status | Makna |
|---|---|
| ACTIVE | Chain sedang menjalankan Resolution secara normal. |
| SUSPENDED | Chain menunggu proses sah yang belum selesai, misalnya Blocking UI. |
| FAILED | Kegagalan teknis membuat Chain tidak aman untuk dilanjutkan. |
| ABORTED | Chain dihentikan oleh hasil terminal seperti PLAYER_ELIMINATED atau GAME_END. |
| COMPLETED | Giliran selesai secara normal dan Chain ditutup. |

Jika Chain FAILED:
1. Turn Controller menghentikan pemrosesan lanjutan.
2. Sistem tidak otomatis mengulang proses yang berpotensi menghasilkan efek ganda.
3. State terakhir yang telah berhasil diproses tetap dipertahankan.
4. Turn tidak boleh diam-diam diselesaikan atau dipindahkan ke pemain berikutnya.
5. Kegagalan dicatat untuk diagnosis dan pemulihan aman.

### TC-05A — Suspension dan Resume

1. Ketika Chain SUSPENDED, Turn Controller mempertahankan identitas Chain dan posisi Resolution terakhir yang valid.
2. Setelah kondisi penangguhan selesai, Chain dilanjutkan dari titik tersebut.
3. Resolution yang telah berhasil diselesaikan tidak boleh dijalankan ulang.
4. Setiap Resolution memiliki identitas unik dalam Parent Turn Chain.
5. Resume tidak membuat Parent Turn Chain baru.
6. Jika PLAYER_ELIMINATED atau GAME_END terjadi selama penangguhan, hasil terminal tersebut mengikuti prioritas yang berlaku dan menghentikan kelanjutan normal.

### TC-06A — Deferred Turn End

Jika TURN_END dihasilkan ketika Blocking UI yang wajib tetap terbuka masih tampil:
1. Turn Controller mencatat TURN_END sebagai pending.
2. Parent Turn Chain menjadi SUSPENDED.
3. Extra Roll dibatalkan.
4. Tidak ada giliran baru yang dimulai selama UI tersebut belum diselesaikan.
5. Setelah UI selesai, Turn Controller menyelesaikan TURN_END tepat satu kali.
6. GAME_END dan PLAYER_ELIMINATED tetap mengalahkan TURN_END.

### TC-06B — Parent Turn Chain Lifecycle per Turn

1. Parent Turn Chain dibuat ketika Turn Controller memulai giliran seorang pemain.
2. Chain mencakup seluruh rangkaian giliran, termasuk News Phase, Roll, Movement, Landing Resolution, Special Resolution, dan Extra Roll.
3. Extra Roll tetap berada di Parent Turn Chain yang sama.
4. Chain berakhir ketika Turn Controller menyelesaikan giliran, pemain tereliminasi, atau Game End terjadi.
5. Chain yang telah berakhir tidak boleh diaktifkan kembali.
6. Giliran pemain berikutnya menggunakan Parent Turn Chain dengan ID baru.

### TC-07A — Resolution Result Contract

Sistem gameplay mengembalikan salah satu Resolution Result berikut kepada Turn Controller:

| Result | Makna |
|---|---|
| CONTINUE | Melanjutkan ke Resolution berikutnya. |
| EXTRA_ROLL | Meminta Turn Controller mengevaluasi kelayakan Extra Roll. |
| TURN_END | Meminta Turn Controller menyelesaikan giliran. |
| PLAYER_ELIMINATED | Menghentikan Chain pemain yang tereliminasi. |
| GAME_END | Menghentikan seluruh gameplay. |

Priority tetap:

`GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE`

Aturan:
1. Sistem gameplay tidak mengubah Turn Phase secara langsung.
2. Sistem gameplay tidak menentukan pemain berikutnya.
3. Turn Controller memvalidasi dan mengevaluasi setiap Result.
4. Result dengan prioritas lebih tinggi mengalahkan Result berprioritas lebih rendah.
5. EXTRA_ROLL baru dievaluasi setelah Resolution yang sedang berjalan selesai.
6. Result tidak boleh menyebabkan efek yang telah berhasil diproses dijalankan ulang.

### TC-08A — Result Validation dan Stale Result Protection

1. Setiap Result membawa ParentTurnChainID dan identitas Resolution asal.
2. Turn Controller hanya menerima Result dari Chain yang masih aktif dan sesuai konteks.
3. Result dari Chain lama, Chain yang telah selesai, atau Chain yang telah di-abort ditolak.
4. Result duplikat dari Resolution yang sama tidak boleh menghasilkan efek atau perubahan fase tambahan.
5. Result dengan prioritas lebih tinggi mengalahkan Result berprioritas lebih rendah.
6. Result tidak valid tidak boleh menghasilkan perubahan state.

### TC-09A — Sequential Resolution Execution

1. Parent Turn Chain hanya menjalankan satu Resolution aktif pada satu waktu.
2. Turn Controller menunggu Resolution aktif menyelesaikan proses dan mengembalikan hasil sebelum memulai Resolution berikutnya.
3. Setiap State Change harus selesai secara atomic sebelum proses berikutnya dimulai.
4. State Change yang dapat memengaruhi Victory Condition diikuti Global Victory Check setelah perubahan selesai.
5. Jika Global Victory Check menghasilkan GAME_END, Resolution berikutnya dibatalkan.
6. Resolution yang sedang menjalankan Atomic Operation tidak boleh dipotong di tengah operasi tersebut.
7. Resolution tidak boleh dijalankan paralel hanya untuk mempercepat gameplay.

### TC-10A — Blocking UI Contract

1. Blocking UI adalah media interaksi pemain, bukan pemilik alur Turn.
2. Kebutuhan Blocking UI dapat menyebabkan Parent Turn Chain masuk SUSPENDED melalui alur server yang sah.
3. UI tidak boleh mengubah Turn Phase, mengakhiri giliran, atau menentukan pemain berikutnya.
4. Setelah interaksi valid selesai, hasil interaksi dikirim ke server.
5. Server memvalidasi hasil sebelum Turn Controller melakukan Resume.
6. UI yang ditutup secara tidak sah atau mengirim respons duplikat tidak boleh menyelesaikan Resolution.
7. PLAYER_ELIMINATED atau GAME_END membersihkan UI sesuai prioritas terminal.
8. Jika TURN_END sudah pending, UI diselesaikan terlebih dahulu sesuai Deferred Turn End, kecuali hasil terminal yang lebih tinggi terjadi.

### TC-11A — Turn Phase Authority

1. Hanya Turn Controller yang boleh menetapkan dan mengubah Turn Phase.
2. Sistem lain hanya mengirim Resolution Result atau sinyal penyelesaian proses.
3. Perpindahan fase mengikuti Master Flow dan Special Turn Flow yang berlaku.
4. Turn Controller boleh melewati fase yang tidak relevan untuk alur khusus; keputusan tersebut tetap milik Turn Controller.
5. Sistem lain tidak boleh memaksa perpindahan fase dengan mengirim event langsung ke fase berikutnya.
6. Setiap perpindahan fase divalidasi terhadap Parent Turn Chain aktif.
7. Jika Chain SUSPENDED, fase tidak boleh maju secara normal.
8. Jika Chain FAILED, ABORTED, atau COMPLETED, tidak boleh ada perpindahan fase lanjutan.

## 3. Turn Initialization dan Gameplay Flow

### TC-12A — Turn Start dan Player Selection

1. Turn Controller menentukan pemain aktif berdasarkan urutan match.
2. Setiap giliran baru mendapatkan TurnID dan ParentTurnChainID yang unik.
3. Pemain ELIMINATED tidak boleh mendapatkan giliran.
4. Pemain disconnect diproses melalui Player Leave/Elimination sebelum penentuan giliran berikutnya.
5. Turn Controller memvalidasi Game State dan Player State sebelum memulai giliran.
6. Jika Game State ENDED, tidak boleh ada giliran baru.
7. Jika hanya tersisa satu pemain aktif, Global Victory Check dilakukan sebelum giliran berikutnya dimulai.
8. Pemain berikutnya ditentukan oleh Turn Controller.

TurnID mengidentifikasi giliran. ParentTurnChainID mengidentifikasi rangkaian Resolution dalam giliran tersebut.

### TC-13A — Turn Initialization

1. Setelah pemain aktif ditentukan, Turn Controller membuat TurnID dan ParentTurnChainID.
2. Turn Controller menetapkan pemain tersebut sebagai pemilik giliran aktif.
3. Inisialisasi aturan per-turn dilakukan sebelum fase gameplay pertama.
4. Double Counter di-reset pada awal giliran baru.
5. Batas penggunaan aksi per-turn, termasuk Stored News, mengikuti aturan sistem terkait.
6. Setelah inisialisasi berhasil, Turn Controller masuk ke News Phase.
7. Jika inisialisasi gagal, giliran tidak boleh dimulai setengah jalan. Chain masuk FAILED dan tidak boleh diam-diam berpindah ke pemain berikutnya.

Turn Controller mengatur kapan inisialisasi berlangsung. Detail reset setiap mekanik tetap menjadi tanggung jawab sistem terkait.

### TC-14A — News Phase Contract

1. News Phase dimulai setelah Turn Initialization berhasil.
2. Turn Controller menentukan kapan News Phase dimulai dan selesai.
3. Pemain dapat memilih Roll atau menggunakan Stored News jika tersedia dan memenuhi aturan.
4. Jika Stored News digunakan, News Resolution harus selesai sebelum Roll normal dimulai.
5. News System mengembalikan Resolution Result kepada Turn Controller.
6. TURN_END, PLAYER_ELIMINATED, dan GAME_END mengikuti Result Priority.
7. Jika News Phase selesai tanpa hasil terminal, Turn Controller melanjutkan ke Roll.
8. News System tidak boleh memulai Roll secara langsung.

**Prototype constraint:** sesuai Prototype Scope v1.0, belum ada Stored News yang tersedia dan efek kartu ditunda. News Phase prototype otomatis melanjutkan ke Roll.

### TC-15A — Roll Phase Contract

1. Turn Controller memulai Roll Phase setelah News Phase selesai.
2. Hanya pemain aktif yang boleh melakukan Roll.
3. Dice System bertanggung jawab atas proses physical dice dan validasi hasil kedua dadu.
4. Hasil dadu divalidasi server sebelum dianggap sebagai Roll sah.
5. Dice System mengembalikan hasil Roll kepada Turn Controller.
6. Roll tidak valid tidak menghasilkan Movement, Double Counter, atau Landing.
7. Dice System tidak boleh memulai Movement sendiri.
8. Jika hasil Roll valid, Turn Controller melanjutkan ke Dice Resolution.

Dice System menghasilkan hasil dadu; Dice System tidak menentukan alur permainan setelah dadu berhenti.

### TC-16A — Dice Resolution Contract

1. Turn Controller menerima hasil Roll yang telah divalidasi server.
2. Turn Controller meminta Dice Resolution memproses hasil tersebut.
3. Dice Resolution menentukan total langkah dan apakah hasilnya Double.
4. Double Counter diperbarui berdasarkan hasil Roll valid.
5. Double ketiga berturut-turut dalam satu giliran menghasilkan TRIPLE DOUBLE.
6. Triple Double menghasilkan alur Jail tanpa Movement dan Landing Resolution.
7. Jika bukan Triple Double, Turn Controller melanjutkan ke Movement.
8. Dice Resolution tidak menjalankan Movement atau mengakhiri giliran secara langsung.
9. Roll invalid atau dibatalkan tidak meningkatkan Double Counter.

### TC-17A — Movement Contract

1. Turn Controller memulai Movement setelah menerima Dice Resolution valid yang bukan Triple Double.
2. Movement Engine menjadi satu-satunya sistem yang menjalankan pergerakan karakter.
3. Movement Engine menerima instruksi Movement beserta sumber dan tujuan pergerakan.
4. Server menjadi authority untuk posisi, arah, jalur, dan tujuan akhir pemain.
5. Movement Engine menangani Path, Direction, Character Movement, Movement Speed, Smooth Turning, Destination, Arrival, dan Movement Completion.
6. Movement Engine tidak menentukan Landing Resolution atau mengakhiri giliran.
7. Setelah pergerakan selesai, Movement Engine mengembalikan hasil penyelesaian kepada Turn Controller.
8. Jika Movement gagal secara teknis, Parent Turn Chain masuk FAILED dan tidak melanjutkan ke Start atau Landing.

### TC-18A — Movement Completion dan Start Detection

1. Movement Engine melaporkan Movement Complete setelah pemain mencapai tujuan.
2. Turn Controller memulai Start Detection setelah Movement selesai.
3. Start System memeriksa apakah pemain melewati atau mendarat di Tile Start.
4. Start System memproses reward sesuai Prototype Scope:
   - Pass Start: 20K.
   - Landing Start: 30K.
   - First Lap: 100K total, termasuk reward Start.
5. First Lap hanya diproses satu kali per pemain.
6. Start System mengembalikan hasil penyelesaian kepada Turn Controller.
7. Landing Resolution baru dimulai setelah Start Detection dan reward relevan selesai.
8. Start System tidak memulai Landing Resolution atau mengakhiri Turn sendiri.

Perhitungan menggunakan hasil Movement authoritative server, bukan animasi atau posisi sementara karakter.

### TC-19A — Landing Resolution Contract

1. Landing Resolution hanya dimulai setelah Movement Complete dan Start Detection selesai.
2. Turn Controller meminta Landing Resolution memeriksa tile tujuan berdasarkan posisi authoritative pemain.
3. Landing Resolution mengidentifikasi kategori tile.
4. Landing Resolution meneruskan proses ke handler kategori yang sesuai.
5. Handler menyelesaikan tanggung jawabnya dan mengembalikan hasil kepada Landing Resolution.
6. Landing Resolution mengembalikan Resolution Result kepada Turn Controller.
7. Handler tidak mengubah Turn Phase, memulai giliran baru, atau menentukan pemain berikutnya.
8. Tile yang hanya dilewati selama Movement tidak diproses sebagai Landing.
9. Landing yang sama tidak diproses dua kali untuk satu Movement Resolution.

Kategori handler:
- Property
- Crown
- News
- Reward
- Transport
- Jail

### TC-20A — Special Resolution Contract

1. Category Handler boleh menghasilkan Resolution lanjutan sesuai mekanik tile.
2. Resolution lanjutan tetap berada dalam Parent Turn Chain yang sama.
3. Turn Controller menentukan kapan Resolution lanjutan dijalankan.
4. Jika handler membutuhkan Blocking UI, Parent Turn Chain masuk SUSPENDED.
5. Jika handler menghasilkan Movement tambahan, Movement tetap menggunakan Movement Engine yang sama.
6. TURN_END, PLAYER_ELIMINATED, dan GAME_END mengikuti Result Priority.
7. Handler tidak membuat Parent Turn Chain baru untuk proses lanjutan.
8. Resolution lanjutan tidak mengulang efek yang telah berhasil diproses.
9. Jika Special Resolution selesai tanpa hasil terminal, Turn Controller mengevaluasi apakah masih ada Resolution yang harus dijalankan.

## 4. Victory dan Extra Roll

### TC-21A — Global Victory Check Contract

1. Turn Controller mengatur kapan Global Victory Check dipanggil dalam Parent Turn Chain.
2. Global Victory Check menggunakan kondisi game authoritative terbaru dari server.
3. Pemeriksaan dilakukan setelah State Change relevan selesai secara atomic.
4. Jika Victory terpenuhi, hasilnya GAME_END.
5. Jika GAME_END terjadi, seluruh Resolution Chain dihentikan.
6. Jika tidak ada Victory, Turn Controller dapat melanjutkan Resolution berikutnya.
7. State Change yang berpotensi menghasilkan Victory tidak boleh melewati Global Victory Check.
8. Global Victory Check tidak mengubah urutan pemain atau mengakhiri giliran secara independen.

Global Victory Check menentukan apakah permainan berakhir. Turn Controller menjalankan konsekuensinya terhadap alur giliran.

### TC-22A — Extra Roll Contract

1. Extra Roll hanya dapat diberikan berdasarkan hasil Roll valid yang memenuhi aturan Double.
2. EXTRA_ROLL adalah permintaan evaluasi, bukan perintah langsung untuk melakukan Roll.
3. Turn Controller mengevaluasi Extra Roll setelah seluruh Resolution dalam giliran selesai.
4. Extra Roll tetap menggunakan Parent Turn Chain dan TurnID yang sama.
5. Sebelum memberikan Extra Roll, Turn Controller memastikan tidak ada hasil berprioritas lebih tinggi.
6. TURN_END, PLAYER_ELIMINATED, dan GAME_END membatalkan Extra Roll yang belum dijalankan.
7. Jika Blocking UI masih menunggu penyelesaian, Extra Roll tidak boleh dimulai.
8. Triple Double langsung menghasilkan Jail dan TURN_END, tanpa Movement atau Extra Roll.
9. Dice System tidak memulai Extra Roll sendiri.

## 5. Turn Completion, Terminal Outcomes, and Player Continuity

### TC-23 — Turn Completion dan Player Handoff

1. TURN_END hanya diproses setelah Resolution aktif selesai.
2. Tidak boleh ada Resolution lanjutan wajib, Blocking UI tertunda, atau Extra Roll yang masih memenuhi syarat.
3. Turn Controller melakukan pemeriksaan akhir terhadap hasil terminal.
4. Jika tidak ada hasil terminal yang menghalangi, Turn diselesaikan tepat satu kali.
5. Parent Turn Chain ditandai COMPLETED dan tidak boleh diaktifkan kembali.
6. Turn Controller menentukan pemain berikutnya sesuai urutan match dan membuat TurnID serta ParentTurnChainID baru.
7. Sistem lain tidak boleh memulai handoff atau Turn berikutnya secara langsung.

### TC-24 — Player Elimination dan Turn Handoff

1. PLAYER_ELIMINATED yang tervalidasi menghentikan Resolution lanjutan milik pemain tersebut.
2. Parent Turn Chain pemain yang tereliminasi ditandai ABORTED, bukan COMPLETED.
3. Resolution yang belum dimulai dibatalkan; Resolution yang telah selesai tidak dijalankan ulang.
4. Blocking UI pemain tersebut dibersihkan dan respons setelah eliminasi ditolak.
5. Turn Controller memastikan status ELIMINATED sebelum memilih pemain berikutnya.
6. Global Victory Check dijalankan menggunakan state terbaru.
7. GAME_END menghentikan match; jika tetap RUNNING, pemain aktif berikutnya dipilih menurut urutan match.
8. Eliminasi tidak menghasilkan TURN_END tambahan untuk Chain yang sama.
9. TC-24 mengatur dampak eliminasi pada Turn Flow, bukan mekanisme penyebab eliminasi atau perhitungan Bankruptcy.

### TC-25 — Game End dan Match Shutdown

1. GAME_END tervalidasi membuat Game State menjadi ENDED.
2. Seluruh Parent Turn Chain aktif atau suspended dihentikan dan ditandai ABORTED.
3. Tidak boleh ada Turn, Roll, Movement, Landing Resolution, atau Special Resolution baru setelah Game End.
4. Blocking UI dan interaksi gameplay tertunda dibersihkan atau dinonaktifkan.
5. Proposal Trade dan Transaction yang pending dibatalkan; operasi yang sudah selesai tidak di-rollback.
6. Respons atau Result setelah Game End ditolak tanpa perubahan gameplay.
7. Gameplay biasa tidak boleh mengubah Game State kembali menjadi RUNNING.
8. Game End diproses satu kali; notifikasi duplikat tidak menghasilkan efek tambahan.
9. Turn Controller memastikan penghentian gameplay sebelum menyerahkan informasi hasil Match kepada UI.
10. Layar kemenangan, animasi Game Over, rematch, dan statistik berada di luar kontrak ini.

### TC-26 — Player Leave di Luar Giliran Aktif

1. Disconnect pemain nonaktif diproses melalui Player Leave/Elimination.
2. Parent Turn Chain pemain aktif tidak dihentikan atau di-reset hanya karena pemain lain disconnect.
3. Status pemain yang keluar diperbarui menjadi ELIMINATED setelah Player Leave berhasil.
4. Pemain ELIMINATED tidak dipilih untuk Turn berikutnya.
5. Global Victory Check dilakukan setelah perubahan status selesai.
6. Jika GAME_END terjadi, TC-25 berlaku; jika tetap RUNNING, pemain aktif melanjutkan tanpa mengulang Resolution yang selesai.
7. Trade/Transaction pending pemain tersebut mengikuti kontrak sistem Trade/Transaction dan tidak mengambil alih Turn Controller.
8. Pemain yang bergabung kembali tidak otomatis masuk ke Match aktif.

### TC-27 — Character Reset / Death During Active Turn

1. Reset atau Death saat Movement membuat Parent Turn Chain SUSPENDED sampai Recovery siap.
2. Movement yang berjalan dibatalkan dan karakter dikembalikan ke tile valid terakhir sebelum Movement dimulai.
3. Roll Result dan destination sah yang telah divalidasi server dipertahankan.
4. Movement dilanjutkan ke destination yang sama tanpa Roll ulang.
5. Start Reward dan Landing Resolution hanya dijalankan setelah Movement berhasil selesai.
6. Reward dan Landing Resolution yang telah berhasil diproses tidak dijalankan ulang.
7. Turn tetap milik pemain yang sama; Reset/Death tidak membuat Turn baru atau pergantian pemain.
8. Jika Recovery gagal secara teknis, Parent Turn Chain menjadi FAILED tanpa mengakhiri Turn atau memindahkan pemain secara diam-diam.
9. Detail Recovery harus tetap sesuai Prototype Scope v1.0.

### TC-28 — Active Player Disconnect During Resolution

1. Jika pemain aktif disconnect, server menghentikan penerimaan aksi baru dari pemain tersebut.
2. Parent Turn Chain aktif dihentikan dan ditandai ABORTED setelah Player Leave/Elimination tervalidasi.
3. Pending Blocking UI dibersihkan.
4. Resolution yang sudah selesai tidak diulang; Resolution yang belum dimulai dibatalkan.
5. Pemain dipastikan berstatus ELIMINATED dan dikeluarkan dari daftar pemain aktif.
6. Global Victory Check dijalankan menggunakan state terbaru.
7. Jika Match tetap RUNNING, Turn Controller memilih pemain aktif berikutnya sesuai urutan match.
8. Rejoin tidak memulihkan giliran atau status aktif secara otomatis.
9. Disconnect bukan Character Reset dan tidak menggunakan Movement Recovery.

### TC-29 — Stale Player Action dan Late Response Protection

1. Setiap aksi gameplay Client divalidasi server sebelum diproses.
2. Server memvalidasi pengirim, hak aksi, Game State, pemain aktif, Turn Phase, dan Parent Turn Chain.
3. Aksi dari Turn lama, Chain tertutup, atau Resolution selesai ditolak.
4. Respons UI setelah UI dibersihkan, pemain tereliminasi, atau Game End tidak menghasilkan perubahan.
5. Aksi duplikat tidak menghasilkan efek atau State Change tambahan.
6. Aksi tidak valid menghasilkan zero side effect.
7. Status UI atau state lokal Client bukan bukti bahwa aksi masih sah.
8. Perlindungan berlaku untuk Roll, Blocking UI, dan Resolution lanjutan.
9. Mekanisme ID, nonce, atau token tetap TBD.

### TC-30 — Concurrent Event Arbitration

1. Event yang memengaruhi Turn Controller diproses melalui validasi dan sequencing server.
2. Event tidak boleh mengubah Turn State secara paralel atau melewati authority Turn Controller.
3. Event yang tiba hampir bersamaan dievaluasi berdasarkan state authoritative terbaru.
4. Priority tetap GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE.
5. Atomic Operation yang sudah dimulai diselesaikan utuh sebelum event lain diproses pada batas aman berikutnya.
6. Event terminal yang lebih tinggi prioritasnya menghentikan Resolution lanjutan setelah batas aman.
7. Event yang tidak relevan akibat perubahan state, eliminasi, atau Game End ditolak.
8. Event duplikat tidak menghasilkan perubahan tambahan.
9. Jika urutan atau validitas state tidak dapat dipastikan, Chain menjadi FAILED.
10. Detail sequencing, queue, dan arbitration teknis tetap TBD.

### TC-31 — Match Termination When No Active Players Remain

1. Game State hanya menggunakan RUNNING dan ENDED.
2. Jika satu pemain aktif tersisa, Match berakhir dengan hasil Last Player Standing.
3. Jika tidak ada pemain aktif tersisa, Match berakhir dengan hasil tanpa pemenang.
4. Kedua kondisi menghasilkan Game State ENDED; ABORTED tidak digunakan sebagai Game State.
5. Match Outcome dan alasan berakhirnya Match dicatat terpisah dari Game State.
6. Jika tidak ada pemain aktif, tidak ada Turn baru.
7. Seluruh konsekuensi Game End mengikuti TC-25.
8. **Scope reconciliation required:** Prototype Scope v1.0 saat ini menyebut Game State ABORTED untuk nol pemain aktif. Keputusan TC-31 menyetujui perubahan menjadi ENDED tanpa pemenang. Prototype Scope dan dokumen terkait wajib direvisi melalui workflow dokumentasi dan approval sebelum implementasi; perubahan tidak boleh dilakukan diam-diam.

### TC-32 — Player Order Consistency After Elimination

1. Urutan awal Match tetap menjadi dasar urutan giliran.
2. Eliminasi tidak mengacak atau membangun ulang urutan pemain.
3. Turn Controller melewati pemain ELIMINATED dan memilih pemain eligible berikutnya.
4. Contoh: P1 → P2 → P3 → P4 menjadi P1 → P3 → P4 → P1 setelah P2 tereliminasi.

### TC-33 — Late Join dan Rejoin During Active Match

1. Pemain yang bergabung setelah Game State RUNNING tidak masuk roster Match aktif.
2. Pemain tersebut tidak memperoleh TurnID atau ParentTurnChainID untuk Match aktif.
3. Pemain yang disconnect lalu rejoin tidak otomatis memperoleh kembali slot atau status sebelumnya.
4. Rejoin tidak mengubah urutan pemain, Turn Order, atau jumlah pemain aktif.
5. Pemain di luar roster tidak boleh mengirim aksi gameplay untuk Match tersebut.
6. Pemain tersebut hanya dapat mengikuti Match berikutnya melalui proses persiapan yang sah.
7. Spectator, lobby, dan matchmaking berada di luar kontrak ini.

## 6. Resolution Execution, Failure, and Result Integrity

### TC-34 — Turn Initialization Failure Handling

1. Turn Initialization harus selesai sebelum News Phase.
2. Jika Initialization gagal, Parent Turn Chain menjadi FAILED.
3. Roll, Movement, Landing Resolution, dan fase gameplay lain tidak boleh dimulai.
4. Pemain berikutnya tidak otomatis dipilih.
5. Turn tidak dianggap berhasil dimulai jika Initialization belum selesai.
6. State terakhir yang berhasil diproses dipertahankan; state setengah jadi tidak boleh dianggap Initialization berhasil.
7. Kegagalan dicatat untuk diagnosis.
8. Initialization tidak otomatis diulang jika sebagian proses mungkin sudah menghasilkan perubahan.
9. Recovery hanya setelah state diverifikasi dan prosedur dinyatakan aman.
10. Jika keamanan Recovery belum dapat dipastikan, Match tidak boleh dipaksakan melanjutkan atau memindahkan pemain.

### TC-35 — Resolution Failure dan Partial Completion Protection

1. Resolution hanya dilaporkan berhasil setelah seluruh pekerjaan tanggung jawabnya selesai.
2. Setiap State Change dalam Resolution diselesaikan secara atomic sesuai kontraknya.
3. Kegagalan sebelum State Change berhasil membuat Resolution gagal dan Chain FAILED.
4. State Change yang sudah berhasil sebelum kegagalan berikutnya tetap dipertahankan.
5. State Change yang berhasil tidak boleh dijalankan ulang akibat kegagalan berikutnya.
6. Resolution yang masih memiliki pekerjaan wajib belum selesai tidak boleh dilaporkan COMPLETED.
7. Turn Controller menghentikan Resolution lanjutan dan tidak memulai Turn berikutnya.
8. Perubahan yang berhasil tidak di-rollback kecuali kontrak sistem terkait secara eksplisit mengizinkannya.
9. Kegagalan dicatat dengan identitas Parent Turn Chain, Resolution, dan State Change terkait.
10. Retry atau Recovery hanya setelah kondisi terakhir diverifikasi dan prosedurnya dinyatakan aman.
11. Checkpoint, idempotency key, dan mekanisme Recovery teknis tetap TBD.

### TC-36 — Resolution Completion Confirmation

1. Resolution mengirim sinyal COMPLETED hanya setelah seluruh tanggung jawab wajib selesai.
2. State Change terkait harus berhasil dan mencapai kondisi yang dapat diverifikasi.
3. Resolution yang membutuhkan Blocking UI menunggu respons valid server sesuai TC-10A.
4. Resolution tidak selesai jika proses wajib masih tertunda.
5. Sinyal penyelesaian membawa ParentTurnChainID dan identitas Resolution.
6. Turn Controller memvalidasi identitas dan status Resolution sebelum menerima sinyal.
7. Sinyal duplikat tidak memulai Resolution berikutnya atau menghasilkan efek tambahan.
8. Sinyal dari Resolution FAILED, ABORTED, atau COMPLETED ditolak.
9. Setelah penyelesaian valid diterima, Turn Controller mengevaluasi Result dan menentukan langkah berikutnya.
10. Kegagalan sebelum konfirmasi mengikuti TC-35.
11. COMPLETED menandakan pekerjaan selesai, bukan sekadar script berhenti berjalan.

### TC-37 — Resolution Result Finalization

1. Resolution yang selesai memberikan satu Resolution Result valid kepada Turn Controller.
2. Result ditetapkan setelah pekerjaan wajib selesai.
3. Result mencerminkan hasil gameplay authoritative server, bukan status sementara Client.
4. Satu Resolution hanya memiliki satu Result final yang diterima.
5. Result yang telah diterima tidak dapat diganti oleh Result lain dari Resolution yang sama.
6. Jika beberapa kondisi Result muncul, priority TC-07A diterapkan.
7. Jika Resolution selesai tetapi tidak dapat menghasilkan Result valid, Chain menjadi FAILED.
8. Result dengan identitas atau status tidak sesuai ditolak tanpa side effect.
9. Result tidak langsung menjalankan fase berikutnya; Turn Controller mengevaluasi dan menentukan transisi.
10. COMPLETED dan TURN_END adalah konsep berbeda.

### TC-38 — Follow-up Resolution Scheduling dan Ordering

1. Resolution boleh menghasilkan permintaan Follow-up Resolution sesuai mekanik yang berlaku.
2. Follow-up tetap dalam Parent Turn Chain dan TurnID yang sama.
3. Hanya Turn Controller yang menjadwalkan dan menentukan kapan Follow-up dijalankan.
4. Follow-up tidak berjalan sebelum Resolution induk selesai dan Result-nya divalidasi.
5. Setiap Follow-up memiliki identitas unik dan hubungan dengan Resolution asal.
6. Jika ada beberapa Follow-up, urutannya mengikuti aturan sistem dan Master Flow.
7. Follow-up berjalan sequential, bukan paralel.
8. Efek yang sudah berhasil diproses tidak boleh diulang.
9. Result terminal membatalkan Follow-up yang belum dijalankan sesuai priority.
10. Jika urutan atau validitas tidak dapat dipastikan, Chain menjadi FAILED.
11. TC-38 tidak mengizinkan mekanik Follow-up baru di luar aturan yang disetujui.

### TC-39 — Resolution Cancellation dan Pending Work Cleanup

1. GAME_END atau PLAYER_ELIMINATED tervalidasi menghentikan penjadwalan Resolution baru dalam Chain terkait.
2. Follow-up yang belum dimulai dibatalkan.
3. Resolution aktif dihentikan pada batas aman tanpa memotong Atomic Operation.
4. State Change yang sudah berhasil tetap dipertahankan.
5. Blocking UI yang tidak relevan dibersihkan; respons berikutnya ditolak.
6. Hasil pekerjaan yang dibatalkan tidak boleh menghasilkan State Change.
7. Pekerjaan selesai tidak diulang atau di-rollback hanya karena Chain dihentikan.
8. PLAYER_ELIMINATED membatalkan pekerjaan dalam Chain pemain tersebut; Match dapat berlanjut jika tidak GAME_END.
9. GAME_END menghentikan seluruh pekerjaan gameplay pending sesuai TC-25.
10. Status pekerjaan yang tidak dapat dipastikan tidak boleh dianggap berhasil atau aman diulang.
11. Trade/Transaction mengikuti TC-02A; pembatalan Chain tidak me-rollback operasi yang telah selesai.

### TC-40 — Queued Resolution Validation

1. Setiap Follow-up yang dijadwalkan tercatat sebagai pekerjaan pending dalam Parent Turn Chain.
2. Status pending tidak otomatis berarti Resolution masih valid.
3. Sebelum dijalankan, Turn Controller memvalidasi ParentTurnChainID, TurnID, Game State, status pemain, status penyelesaian/pembatalan, dan prasyarat gameplay.
4. Jika prasyarat tidak terpenuhi, Resolution pending tidak dijalankan.
5. Resolution yang tidak relevan dibatalkan tanpa State Change.
6. Urutan Resolution tidak boleh diubah sepihak oleh Category Handler atau sistem lain.
7. Resolution pending dijalankan sequential sesuai urutan yang divalidasi.
8. Result terminal membatalkan pekerjaan pending sesuai TC-39.
9. Resolution yang dibatalkan tidak dapat diaktifkan kembali oleh Client atau event terlambat.
10. Jika validitas tidak dapat dipastikan, Chain menjadi FAILED.
11. Mekanisme teknis queue tetap TBD.

### TC-41 — Gameplay System Authority dan State Ownership

1. Turn Controller memiliki kewenangan atas Turn Flow, Turn Phase, Parent Turn Chain, dan pemilihan pemain.
2. Setiap Gameplay System bertanggung jawab atas mekanik dan State domainnya.
3. Gameplay System hanya mengubah State dalam batas domainnya.
4. Gameplay System memvalidasi kondisi dan otorisasi sebelum State Change.
5. State Change diproses secara atomic sesuai kontrak sistem terkait.
6. Gameplay System tidak mengubah Turn Phase, mengakhiri Turn, atau menentukan pemain berikutnya.
7. Gameplay System tidak memerintahkan Gameplay System lain menjalankan Resolution langsung; permintaan lanjutan dikembalikan kepada Turn Controller.
8. Turn Controller tidak mengambil alih perhitungan mekanik internal domain system.
9. Hasil dikembalikan melalui Resolution Result atau sinyal penyelesaian tervalidasi.
10. Perubahan State di luar kewenangan harus melalui sistem pemilik State.
11. Pelanggaran kewenangan tidak boleh menghasilkan State Change.
12. Kepemilikan State yang belum ditentukan atau konflik kewenangan harus dihentikan untuk meminta keputusan.
13. Pembagian Module dan nama script Luau tetap TBD.

### TC-42 — State Change Notification dan Turn Controller Awareness

1. Gameplay System memberi tahu Turn Controller ketika State Change memengaruhi kelanjutan Parent Turn Chain.
2. Notifikasi dikirim setelah State Change berhasil diselesaikan secara atomic.
3. Notifikasi mengidentifikasi ParentTurnChainID dan Resolution terkait jika perubahan berasal dari Resolution aktif.
4. Notifikasi bukan perintah langsung untuk mengubah Turn Phase atau mengakhiri Turn.
5. Turn Controller memvalidasi notifikasi terhadap Chain dan Resolution yang berlaku.
6. Jika State Change berpotensi memicu Victory Condition, Global Victory Check dilakukan sesuai TC-21A.
7. Notifikasi duplikat tidak menghasilkan pemrosesan atau efek tambahan.
8. Notifikasi dari Chain ABORTED, FAILED, atau COMPLETED tidak memulai kembali gameplay.
9. Trade/Transaction independen mengikuti TC-02A.
10. Jika notifikasi wajib tidak dapat dikonfirmasi atau hubungannya dengan State Change tidak dapat diverifikasi, proses tidak dianggap selesai secara aman.
11. Mekanisme event/callback/queue tetap TBD.

### TC-43 — External State Change During Active Turn

1. State Change dari operasi independen tidak otomatis menjadi bagian Parent Turn Chain aktif.
2. Turn Controller tetap memiliki giliran aktif.
3. Operasi independen memvalidasi State terbaru sebelum perubahan.
4. State Change independen diselesaikan secara atomic.
5. Jika perubahan memengaruhi Victory Condition, Global Victory Check wajib dilakukan.
6. GAME_END mengikuti TC-25.
7. Jika tidak GAME_END, Parent Turn Chain dapat melanjutkan berdasarkan State terbaru tervalidasi.
8. Resolution yang belum dijalankan memvalidasi ulang prasyarat jika State terkait berubah.
9. Operasi independen tidak memaksa Turn Phase, Turn End, atau giliran pemain lain.
10. Resolution aktif yang tidak lagi valid tidak diteruskan berdasarkan State lama.
11. State Change yang telah berhasil tidak di-rollback hanya karena memengaruhi giliran aktif.
12. Detail konflik Trade/Transaction dengan gameplay mengikuti spesifikasi sistem terkait.

### TC-44 — Authoritative State Revalidation Before Resolution

1. Sebelum setiap Resolution, Turn Controller memastikan konteks Chain dan Turn masih valid.
2. Gameplay System menggunakan State authoritative terbaru dari server.
3. Data yang dibaca sebelumnya tidak dianggap tetap valid setelah perubahan relevan.
4. Prasyarat diperiksa kembali sebelum State Change.
5. Jika prasyarat tidak lagi terpenuhi, Resolution tidak memaksakan proses berdasarkan kondisi lama.
6. Jalur alternatif hanya boleh digunakan jika telah ditetapkan aturan gameplay.
7. Jika tidak ada jalur sah atau State tidak dapat diverifikasi, Chain menjadi FAILED.
8. State Change yang berhasil tetap dipertahankan dan tidak diulang.
9. Global Victory Check tetap berjalan setelah State Change relevan sesuai TC-21A.
10. Turn Controller memutuskan apakah Chain boleh melanjutkan.
11. Cache, snapshot, locking, dan database transaction tetap TBD.

### TC-45 — Resolution Preconditions dan Invalid State Handling

1. Setiap Resolution memenuhi prasyarat gameplay sebelum dijalankan.
2. Prasyarat diperiksa menggunakan State authoritative server.
3. Jika prasyarat tidak terpenuhi, State Change yang bergantung padanya tidak dijalankan.
4. Kondisi gameplay tidak terpenuhi tidak otomatis berarti kegagalan teknis.
5. Hasil alternatif hanya digunakan jika aturan gameplay mengizinkannya.
6. Jika tidak ada hasil alternatif yang ditetapkan, proses tidak membuat hasil berdasarkan asumsi.
7. Jika kondisi State tidak dapat diverifikasi karena kegagalan teknis, Chain menjadi FAILED.
8. Penolakan Resolution tidak menghasilkan side effect dari proses yang tidak sah.
9. State Change yang sudah berhasil sebelum kondisi berubah tetap dipertahankan.
10. Turn Controller mengevaluasi hasil valid dan menentukan kelanjutan Chain.

### TC-46 — Resolution Skip dan Not-Applicable Handling

1. Resolution hanya dilewati jika aturan gameplay secara eksplisit mengizinkan.
2. Untuk kondisi normal yang memang boleh dilewati, Gameplay System mengembalikan CONTINUE.
3. Resolution yang dilewati tidak menghasilkan State Change atau side effect yang tidak diizinkan.
4. Turn Controller mencatat Resolution telah dilewati agar tidak dijalankan ulang.
5. Resolution berikutnya hanya dimulai setelah hasil divalidasi Turn Controller.
6. Jika prasyarat tidak terpenuhi dan aturan tidak menentukan tindakan sah, proses tidak memilih hasil berdasarkan asumsi.
7. Jika kondisi runtime tidak memiliki keputusan yang dapat digunakan, Chain menjadi FAILED.
8. CONTINUE tidak boleh menyamarkan kegagalan teknis atau melewati validasi wajib.
9. Tidak ada Resolution Result baru yang ditambahkan; tetap lima Result TC-07A.

### TC-47 — Single Final Result per Resolution

1. Setiap Resolution hanya menghasilkan satu Result final yang diterima Turn Controller.
2. Resolution boleh mengalami beberapa perubahan kondisi internal, tetapi hasil akhirnya satu Result.
3. Jika beberapa kondisi Result terpenuhi, priority TC-07A diterapkan.
4. Result yang diterima tidak dapat diganti Result berikutnya dari Resolution yang sama.
5. Result duplikat tidak menghasilkan pemrosesan tambahan.
6. Result yang saling bertentangan sebelum finalisasi tidak boleh diselesaikan berdasarkan tebakan.
7. Jika konflik tidak dapat diselesaikan melalui priority yang disetujui, Chain menjadi FAILED.
8. Follow-up adalah Resolution terpisah dengan identitas sendiri, bukan Result tambahan dari Resolution induk.
9. Resolution tanpa satu Result final valid tidak dianggap COMPLETED.

### TC-48 — Result Submission Timing dan Finalization Boundary

1. Resolution mengirim Result final setelah seluruh tanggung jawab wajib selesai.
2. Result sementara selama Resolution berjalan bukan Result final.
3. Kondisi terminal yang muncul selama Resolution berjalan dilaporkan melalui jalur tervalidasi, tanpa menganggap Resolution selesai sebelum batas aman.
4. Atomic Operation diselesaikan utuh sebelum Result terminal diterapkan pada alur Chain.
5. Setelah batas aman tercapai, Turn Controller mengevaluasi kondisi terminal sesuai TC-07A.
6. Result sebelum batas final tidak memulai Resolution berikutnya.
7. Result terlambat atau dari Resolution tertutup ditolak sesuai TC-08A.
8. Satu Resolution tetap hanya memiliki satu Result final.
9. Jika batas finalisasi tidak dapat diverifikasi, Chain menjadi FAILED.
10. Mekanisme teknis sinyal terminal saat Resolution aktif tetap TBD; Gameplay System tidak mengubah Turn Phase langsung.

### TC-49 — Active Resolution Ownership dan Execution Lock

1. Satu Parent Turn Chain hanya memiliki satu Resolution aktif pada satu waktu.
2. Turn Controller menetapkan Resolution aktif dan berwenang memulai Resolution berikutnya.
3. Resolution baru menunggu Resolution sebelumnya selesai, gagal, atau dibatalkan secara sah.
4. Sistem lain tidak mengambil alih kepemilikan eksekusi Resolution aktif.
5. Sinyal penyelesaian berasal dari Resolution yang tercatat aktif.
6. Result dari Resolution tanpa kepemilikan eksekusi ditolak tanpa State Change.
7. Setelah Resolution selesai valid, Turn Controller menutup status aktif sebelum menjadwalkan berikutnya.
8. Chain FAILED, ABORTED, atau berakhir tidak memulai Resolution baru.
9. Suspension mempertahankan identitas dan kepemilikan Resolution yang menunggu.
10. Jika kepemilikan tidak dapat diverifikasi, Chain menjadi FAILED.
11. Mutex, semaphore, atau queue belum dipilih.

## 7. Identity, Match Lifecycle, and Turn Activation

### TC-50 — Resolution Identity dan Uniqueness

1. Setiap Resolution memiliki identitas unik dalam Parent Turn Chain.
2. Identitas terhubung dengan ParentTurnChainID dan TurnID.
3. Identitas tidak digunakan ulang oleh Resolution lain dalam Chain yang sama.
4. Follow-up mendapatkan identitas baru.
5. Resume mempertahankan identitas Resolution yang sama.
6. Resolution baru setelah proses sebelumnya selesai menggunakan identitas berbeda.
7. Result dan sinyal penyelesaian membawa identitas Resolution asal.
8. Turn Controller memvalidasi identitas sebelum menerima Result atau sinyal penyelesaian.
9. Identitas tidak cocok, duplikat, atau berasal dari Chain tidak berlaku ditolak tanpa side effect.
10. Jika keunikan atau hubungan identitas tidak dapat diverifikasi, Chain menjadi FAILED.
11. Format ID, generator, dan penyimpanan tetap TBD.

### TC-51 — Turn Identity Lifecycle

1. Setiap giliran memiliki satu TurnID unik dalam satu Match.
2. TurnID dibuat Turn Controller ketika Turn baru berhasil diinisialisasi.
3. Satu Turn memiliki satu ParentTurnChainID.
4. Seluruh Resolution, Follow-up, dan Extra Roll memakai TurnID yang sama.
5. Suspension dan Resume tidak membuat TurnID baru.
6. Character Reset/Death Recovery tidak membuat TurnID baru.
7. TurnID tidak digunakan ulang untuk Turn lain dalam Match yang sama.
8. Turn normal yang berakhir menutup identitas bersama Parent Turn Chain COMPLETED.
9. Eliminasi atau Game End menghentikan Turn terkait; identitas tidak digunakan kembali.
10. Aksi, Result, atau respons dari Turn tertutup ditolak.
11. Turn Controller memvalidasi hubungan TurnID dan ParentTurnChainID.
12. Jika hubungan identitas tidak dapat diverifikasi, Chain menjadi FAILED.
13. Format ID, generator, dan penyimpanan tetap TBD.

### TC-52 — Match Identity dan Match Scope

1. Setiap Match memiliki MatchID unik.
2. MatchID mengidentifikasi satu sesi pertandingan.
3. TurnID dan ParentTurnChainID terhubung dengan satu MatchID.
4. Setiap Resolution berasal dari Match yang sama dengan Parent Turn Chain-nya.
5. Identitas dari Match berbeda tidak boleh saling digunakan atau diterima.
6. Pemain di luar roster Match aktif tidak boleh mengirim aksi untuk Match tersebut.
7. Setelah Game State ENDED, MatchID tidak digunakan untuk gameplay baru.
8. Match baru memiliki MatchID baru.
9. Rejoin atau disconnect tidak membuat identitas Match baru untuk mengubah konteks Match berjalan.
10. Jika hubungan identitas Match tidak dapat diverifikasi, proses ditolak tanpa side effect.
11. Format MatchID, generator, penyimpanan, dan persistence tetap TBD.

### TC-53 — Match Lifecycle dan Startup Authorization

1. Match dimulai melalui proses startup yang sah.
2. Turn Controller tidak membuat Turn sebelum startup gate berhasil dilewati.
3. MatchID ditetapkan sebelum Turn pertama dibuat.
4. Roster awal ditentukan dan divalidasi sebelum gameplay.
5. Satu Match hanya memiliki satu sesi gameplay aktif untuk MatchID tersebut.
6. Game State menjadi RUNNING setelah seluruh persyaratan startup terpenuhi.
7. Jika startup gagal, tidak ada Turn atau Parent Turn Chain yang dimulai.
8. Match ENDED tidak kembali menjadi RUNNING.
9. Match baru melewati startup gate sendiri dan mendapat MatchID baru.
10. Jika validitas startup tidak dapat dipastikan, gameplay tidak dimulai.
11. Detail matchmaking, lobby, teleport, dan persistence di luar kontrak ini.

### TC-54 — Match Roster Integrity

1. Roster awal ditetapkan sebelum Game State RUNNING.
2. Setiap pemain roster memiliki identitas unik dalam Match.
3. Pemain di luar roster tidak memperoleh hak gameplay dalam Match aktif.
4. Disconnect atau eliminasi mengubah status pemain, bukan menghapus identitas historisnya.
5. Urutan awal pemain dipertahankan sesuai TC-32.
6. Pemain ELIMINATED tidak dipilih untuk Turn berikutnya.
7. Rejoin tidak mengembalikan status aktif atau hak gameplay secara otomatis.
8. Perubahan roster hanya melalui proses Player Leave/Elimination yang sah.
9. Turn Controller memvalidasi roster sebelum memilih pemain berikutnya.
10. Jika integritas roster tidak dapat diverifikasi, Turn baru tidak dimulai dan kegagalan ditangani sesuai kontrak.
11. Penyimpanan roster/persistence tetap TBD.

### TC-55 — Active Player Eligibility Validation

1. Sebelum Turn baru, Turn Controller memvalidasi kelayakan pemain.
2. Pemain harus terdaftar dalam roster Match aktif.
3. Pemain harus aktif dan belum ELIMINATED.
4. Pemain harus masih terhubung dengan sesi Match yang berlaku.
5. Pemain yang tidak memenuhi syarat tidak menerima Turn.
6. Jika pemain terpilih tidak eligible, Turn Controller melewatinya dan memeriksa pemain berikutnya menurut urutan awal.
7. Urutan roster tidak berubah.
8. Jika tidak ada pemain eligible, Turn Controller menjalankan Global Victory Check.
9. Jika tidak ada pemain aktif tersisa, Game State menjadi ENDED tanpa pemenang sesuai TC-31.
10. Jika kelayakan tidak dapat diverifikasi, Turn baru tidak dipaksakan dan kegagalan ditangani sesuai kontrak.
11. Detail deteksi koneksi dan penyimpanan status pemain tetap TBD.

### TC-56 — Turn Start Authorization

1. Turn baru hanya dimulai jika Game State RUNNING.
2. Tidak boleh ada Parent Turn Chain lain yang masih ACTIVE atau SUSPENDED.
3. Turn sebelumnya harus COMPLETED atau dihentikan secara sah melalui jalur terminal.
4. Pemain penerima Turn harus lolos validasi TC-55.
5. MatchID, TurnID baru, dan ParentTurnChainID baru harus memiliki hubungan identitas valid.
6. Seluruh pemeriksaan diselesaikan sebelum pemain ditetapkan sebagai pemilik giliran aktif.
7. Jika pemeriksaan gagal, Turn baru tidak dimulai.
8. Kegagalan otorisasi teknis membuat proses FAILED, bukan melewati validasi.
9. Tidak ada dua Turn aktif dalam satu Match.
10. Jika Game End terjadi sebelum otorisasi selesai, proses Turn Start dibatalkan.
11. Detail teknis pembuatan ID dan scheduling tetap TBD.

### TC-57 — Duplicate Turn Start Protection

1. Satu giliran hanya memiliki satu proses Turn Start yang sah.
2. Turn Controller memvalidasi apakah pemain sudah memiliki Turn aktif sebelum memulai Turn baru.
3. Permintaan Turn Start duplikat tidak membuat TurnID atau ParentTurnChainID tambahan.
4. Inisialisasi aturan per-turn hanya berhasil satu kali untuk setiap Turn.
5. Reset Double Counter dan inisialisasi lain tidak diulang akibat Turn Start duplikat.
6. Turn Start yang berhasil tidak diaktifkan kembali.
7. Permintaan dari Chain atau Match tidak berlaku ditolak tanpa side effect.
8. Jika status keberhasilan Turn Start sebelumnya tidak dapat dipastikan, proses tidak diulang berdasarkan asumsi; Chain menjadi FAILED jika keamanan State tidak dapat diverifikasi.
9. Mekanisme teknis pencegahan duplikasi tetap TBD.

### TC-58 — Turn Start Failure After Partial Initialization

1. Turn Start berhasil hanya setelah seluruh Initialization wajib selesai.
2. Jika sebagian Initialization berhasil lalu proses berikutnya gagal, Turn tidak dianggap berhasil dimulai.
3. Perubahan yang sudah berhasil diproses tetap dipertahankan.
4. Initialization yang sudah berhasil tidak diulang otomatis.
5. Turn Controller tidak membuat Turn pengganti tanpa validasi kondisi sebelumnya.
6. Parent Turn Chain terkait menjadi FAILED.
7. News Phase dan Roll tidak dimulai.
8. Pemain berikutnya tidak otomatis menerima giliran.
9. Kegagalan dicatat menggunakan identitas Match, Turn, Parent Turn Chain, dan proses Initialization terkait.
10. Recovery hanya setelah seluruh State diverifikasi dan prosedur dinyatakan aman.
11. Rollback, retry, dan Recovery teknis tetap TBD.

### TC-59 — Turn Activation dan Initialization Commit Boundary

1. Turn dengan TurnID dan ParentTurnChainID belum otomatis aktif.
2. Turn baru diaktifkan setelah seluruh proses Turn Initialization wajib berhasil.
3. Sebelum aktivasi berhasil, pemain belum memiliki hak melakukan aksi gameplay untuk Turn tersebut.
4. Turn Controller menetapkan Turn aktif hanya setelah seluruh hasil Initialization diverifikasi.
5. Aktivasi menjadi batas resmi dimulainya hak pemain menjalankan giliran.
6. Setelah aktivasi berhasil, Turn Controller memulai News Phase.
7. Jika aktivasi gagal, Parent Turn Chain menjadi FAILED.
8. Turn gagal aktivasi tidak dianggap aktif dan tidak berlanjut ke Roll.
9. Aktivasi duplikat tidak mengulang Turn Start atau Initialization.
10. Jika status aktivasi tidak dapat diverifikasi, aksi gameplay tidak diterima berdasarkan asumsi.
11. Detail commit, penyimpanan, dan atomic publication tetap TBD.

### TC-60 — Turn Activation dan First Phase Transition

1. Setelah Turn berhasil diaktifkan sesuai TC-59, Turn Controller memulai News Phase.
2. News Phase adalah fase gameplay pertama setiap Turn normal.
3. Tidak ada Roll atau aksi gameplay berikutnya sebelum transisi News Phase berhasil ditetapkan.
4. Hanya Turn Controller yang melakukan transisi Turn Activation menuju News Phase.
5. Transisi hanya dilakukan satu kali untuk setiap Turn.
6. Permintaan transisi duplikat tidak mengulang News Phase atau membuat Resolution tambahan.
7. News Phase menggunakan TurnID dan ParentTurnChainID yang sama dengan Turn aktif.
8. Jika transisi News Phase gagal secara teknis, Parent Turn Chain menjadi FAILED.
9. GAME_END atau PLAYER_ELIMINATED sebelum News Phase dimulai mengalahkan transisi normal.
10. Setelah News Phase dimulai, kelanjutannya mengikuti TC-14A.
11. Prototype News Phase tetap otomatis melanjutkan ke Roll karena Stored News belum tersedia dan efek kartu ditunda.

## 8. Cross-Cutting Invariants

Implementasi yang kelak mengikuti spesifikasi final wajib mempertahankan invariant berikut:
- Turn Controller adalah satu-satunya authority Turn Phase, Turn End, dan player selection.
- Maksimal satu Parent Turn Chain aktif dalam satu match.
- Trade dan Transaction tetap asynchronous dan berada di luar Parent Turn Chain.
- Satu giliran menggunakan satu TurnID dan satu ParentTurnChainID.
- Satu Parent Turn Chain hanya menjalankan satu Resolution aktif pada satu waktu.
- Resolution berjalan sequential.
- Atomic Operation tidak dipotong oleh Victory Check.
- Result hanya diterima dari Chain dan Resolution yang valid.
- Result duplikat atau stale tidak menghasilkan side effect.
- Efek yang telah berhasil diproses tidak dijalankan ulang saat Resume.
- Blocking UI tidak memiliki gameplay authority.
- GAME_END adalah hard stop untuk gameplay.
- FAILED tidak boleh otomatis mengakhiri giliran atau memindahkan pemain.
- Prototype Scope v1.0 tetap menjadi batas fitur implementasi.

## 9. Open Technical Details — TBD

Keputusan berikut belum ditetapkan oleh kontrak ini dan tidak boleh diisi dengan asumsi:
- Bentuk data dan mekanisme pembuatan TurnID, ParentTurnChainID, dan Resolution ID.
- Representasi internal Turn Phase dan lifecycle Chain dalam Luau.
- Mekanisme server-side sequencing/queue dan batas atomic operation yang dapat dibuktikan pada Roblox.
- Cara menyimpan checkpoint/resume cursor agar tidak menggandakan side effect.
- Timeout, observability, logging, dan prosedur pemulihan untuk Chain FAILED.
- Detail validasi dan lifecycle RemoteEvent/RemoteFunction untuk intent serta UI response.
- Cara menangani kegagalan proses saat operasi eksternal atau persistence terlibat.
- Bukti feasibility dan failure-injection test pada Roblox Studio.

Setiap detail di atas harus ditetapkan melalui specification/review lanjutan atau prototype teknis yang terukur. Jangan menambahkan framework, retry policy, timeout, atau recovery mechanism tanpa keputusan yang disetujui.

## 10. Prototype Boundary dan Non-Goals

Dokumen ini hanya menetapkan kontrak Turn Controller dan Resolution Chain. Dokumen ini tidak memperluas Prototype Scope v1.0.

Tidak ada persetujuan di sini untuk:
- implementasi penuh Property, Crown, News, Reward, Transport, atau Jail;
- Property transaction, Crown purchase, atau efek kartu News;
- Trade, Transaction, Bankruptcy, atau Victory Condition lengkap dalam prototype;
- final UI, final map, atau final art;
- menambahkan sistem, framework, atau mekanik yang tidak tercantum pada Prototype Scope.

Jika implementasi membutuhkan keputusan di luar kontrak atau scope, berhenti dan minta approval terlebih dahulu.

## 11. Status dan Next Gate

- Individual proposals TC-01 through TC-60: approved in conversation.
- Consolidated specification review for TC-01 through TC-60: pending.
- Final document approval / LOCKED status: pending.
- Implementation: not started by this specification.
- Testing: not performed.

Next workflow gate:
1. Complete consolidated review for consistency, missing cases, and prototype boundary, including the TC-31 Prototype Scope reconciliation.
2. Resolve or explicitly mark remaining TBD items.
3. Obtain explicit approval of the complete Specification 01.
4. Update affected canonical documents through the approved documentation workflow, including the TC-31 change from ABORTED to ENDED for zero active players.
5. Only then promote the document to LOCKED and proceed to implementation planning under the project workflow.
