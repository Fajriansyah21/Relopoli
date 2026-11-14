# Relopoli — Specification 01
# Turn Controller & Resolution Chain

**Status:** DRAFT — SPECIFICATION IN PROGRESS  
**Decision record:** TC-01 through TC-22A  
**Individual decision approvals:** Discussed and approved one by one in the project conversation  
**Consolidated review:** Pending  
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

## 5. Cross-Cutting Invariants

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

## 6. Open Technical Details — TBD

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

## 7. Prototype Boundary dan Non-Goals

Dokumen ini hanya menetapkan kontrak Turn Controller dan Resolution Chain. Dokumen ini tidak memperluas Prototype Scope v1.0.

Tidak ada persetujuan di sini untuk:
- implementasi penuh Property, Crown, News, Reward, Transport, atau Jail;
- Property transaction, Crown purchase, atau efek kartu News;
- Trade, Transaction, Bankruptcy, atau Victory Condition lengkap dalam prototype;
- final UI, final map, atau final art;
- menambahkan sistem, framework, atau mekanik yang tidak tercantum pada Prototype Scope.

Jika implementasi membutuhkan keputusan di luar kontrak atau scope, berhenti dan minta approval terlebih dahulu.

## 8. Status dan Next Gate

- Individual proposals TC-01 through TC-22A: approved in conversation.
- Consolidated specification review: pending.
- Final document approval / LOCKED status: pending.
- Implementation: not started by this specification.
- Testing: not performed.

Next workflow gate:
1. Complete consolidated review for consistency, missing cases, and prototype boundary.
2. Resolve or explicitly mark remaining TBD items.
3. Obtain explicit approval of the complete Specification 01.
4. Only then promote the document to LOCKED and proceed to implementation planning under the project workflow.
