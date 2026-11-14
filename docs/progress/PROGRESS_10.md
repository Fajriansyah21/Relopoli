# RELOPOLI — RECAP HASIL BRAINSTORM
## Economy, Rent Modifier, Bankruptcy & Master Turn Flow

> Status: **LOCKED**
>
> Rekap khusus hasil obrolan ini.

---

# 1. Rent Calculation

## Urutan Perhitungan Rent

Urutan final:

1. **Property Slump Check**
2. **Base Rent**
3. **Set Bonus**
4. **Rent Multipliers**
5. **Final Rounding**
6. **Half Rent Split** jika aktif

### 1.1 Property Slump

Jika Property sedang **Inactive karena Property Slump**:

- Rent = **0**
- Modifier Rent lainnya tidak dihitung.
- Tidak ada Half Rent distribution.
- Modifier lain tidak otomatis terhapus.

---

### 1.2 Base Rent

Ambil Rent dasar berdasarkan:

- Property
- Level Property

---

### 1.3 Set Bonus

Jika Property merupakan bagian dari Set lengkap:

> **Rent × 1.2**

atau:

> **+20% Rent**

---

### 1.4 Rent Multipliers

Semua modifier multiplier yang aktif di-stack.

Modifier saat ini:

| Modifier | Multiplier |
|---|---:|
| Reward | ×2 / ×3 |
| Premium Listing | ×1.5 |
| Falling Demand | ×0.5 |

Modifier multiplier lain di masa depan juga masuk ke tahap ini.

### Contoh

```text
Base Rent = 10.000

× 1.2 Set
× 3 Reward
× 1.5 Premium Listing
× 0.5 Falling Demand

= 27.000 Rels
