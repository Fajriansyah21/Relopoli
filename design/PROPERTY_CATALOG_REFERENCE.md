# RELOPOLI — PROPERTY ECONOMY D1–D4

**Status:** LOCKED
**Starting Capital:** 100,000 Rels
**Currency:** Rels
**Nominal Rule:** Semua nominal ekonomi menggunakan kelipatan **500 Rels**.

---

# 1. GENERAL PROPERTY SYSTEM

## 1.1 Property Levels

Setiap Property memiliki 5 Level:

| Level  | Status                               |
| ------ | ------------------------------------ |
| **L1** | Empty Land / Empty Lot               |
| **L2** | Small Building / Small Establishment |
| **L3** | Medium Building / Growing Business   |
| **L4** | Large Building / Major Development   |
| **L5** | Iconic Landmark                      |

Progression harus terasa **visual dan substantif**, bukan sekadar memperbesar bangunan.

---

## 1.2 Initial Property Purchase

Ketika pemain mendarat di Property yang **belum dimiliki**:

* Jika memiliki cukup Rels, Purchase UI muncul.
* UI menawarkan:

  * **Buy L1**
  * **Buy L2**
  * **Buy L3**
* **L4 dan L5 disabled** untuk initial purchase.
* Pemain dapat langsung membeli L1, L2, atau L3.
* Jika Rels tidak cukup untuk suatu level, pilihan tersebut tidak dapat dibeli.

**Purchase dan Upgrade adalah dua sistem yang berbeda.**

---

# 2. PROPERTY UPGRADE SYSTEM

## 2.1 Upgrade Hanya Saat Mendarat di Property Sendiri

Ketika pemain mendarat di Property miliknya sendiri:

* Price cards muncul kembali.
* Pemain dapat melakukan upgrade.
* Maksimal **1 upgrade per turn**.

Available progression:

* L1 → L2
* L1 → L3
* L2 → L3
* L3 → L4
* L4 → L5

Tidak boleh melewati requirement:

* L4 membutuhkan L3.
* L5 membutuhkan L4.

---

## 2.2 Hidden Installment Economy

Untuk setiap Property:

> **L1 → L2 → L3 lebih murah daripada langsung membeli L3.**

Pemain tidak diberi tahu secara eksplisit mengenai hidden saving ini.

Tujuannya agar pemain dapat menemukan melalui pengalaman bahwa investasi bertahap lebih efisien.

Tidak ada hidden installment discount untuk:

* L3 → L4
* L4 → L5

---

# 3. PROPERTY VALUE SYSTEM

Terdapat tiga konsep utama:

### Buy Value L1/L2/L3

Untuk Property yang belum dimiliki:

> Buy Value = harga pembelian level tersebut.

### Value L4

> **Value L4 = Buy L3 + Upgrade L3→L4**

Value L4 digunakan sebagai reference value untuk:

* pembelian Property L4 melalui landing;
* trade/transaction reference.

### Value L5

> **Value L5 = Value L4 + Upgrade L4→L5**

L5 **tidak dapat dibeli melalui landing**, tetapi Value L5 tetap dicatat sebagai reference value untuk trade/transaction.

---

# 4. BUYING ANOTHER PLAYER'S PROPERTY

Ketika pemain mendarat di Property milik pemain lain:

### Jika Property L1–L4:

1. Landing player membayar Rent kepada owner.
2. Jika landing player masih memiliki cukup Rels, opsi **Buy Property** muncul.
3. UI menampilkan current Property Value.
4. Buyer membayar Value tersebut kepada owner.
5. Ownership berpindah.
6. Level Property **tidak berubah**.

### Jika Property L5:

* Tidak dapat dibeli melalui landing.

### Crown:

* Tidak dapat dibeli melalui landing.

---

# 5. NORMAL TRADE

Property dapat berpindah melalui Trade/Transaction.

**Value bukan harga wajib dalam normal Trade.**

Players dapat melakukan negosiasi dengan harga/deal yang disepakati.

Property Level tidak berubah hanya karena ownership berpindah.

---

# 6. SET SYSTEM

Setiap District memiliki **tepat 1 official Set**.

Set terdiri dari **tepat 3 designated adjacent Properties**.

Property lain yang berdekatan tetapi tidak termasuk designation **tidak menjadi bagian Set**.

## Set Completion

Jika satu pemain memiliki seluruh 3 Property dalam sebuah Set:

> Set menjadi COMPLETE.

Set memberikan peningkatan Rent sekitar **+20%**.

Namun bonus **tidak dihitung menggunakan formula +20% secara kaku**.

Nilai Set Rent ditentukan langsung dan dibulatkan/diatur agar tetap menggunakan kelipatan **500 Rels**.

Jika salah satu dari 3 Property keluar dari kepemilikan pemain:

> Set BREAKS dan bonus Set hilang.

---

# 7. DISTRICT 1 — GROWING COMMUNITY

## Theme

Neighborhood yang berkembang menjadi vibrant community.

Vibe:

* green
* calm
* friendly
* residential/community
* commercial
* waterfront

## Properties

| Tile | Property         | Category                            |
| ---: | ---------------- | ----------------------------------- |
|    1 | Pinewood Lane    | Residential                         |
|    2 | Maple Row        | Residential                         |
|    4 | Willow Café      | F&B / Set #1                        |
|    5 | Sunny Market     | Commercial / Retail / Set #1        |
|    6 | Bloom Gardens    | Lifestyle / Public / Set #1         |
|    8 | Riverside Walk   | Commercial / Lifestyle / Waterfront |
|    9 | Harborview Hotel | Hospitality                         |

## Set #1

**Willow Café + Sunny Market + Bloom Gardens**

---

## 7.1 D1 Buy Value

| Tile | Property         | Buy L1 | Buy L2 | Buy L3 |
| ---: | ---------------- | -----: | -----: | -----: |
|    1 | Pinewood Lane    |  5,000 |  7,000 |  9,500 |
|    2 | Maple Row        |  5,500 |  7,500 | 10,500 |
|    4 | Willow Café      |  6,500 |  8,500 | 12,000 |
|    5 | Sunny Market     |  7,000 |  9,000 | 13,000 |
|    6 | Bloom Gardens    |  7,500 |  9,500 | 14,000 |
|    8 | Riverside Walk   |  8,500 | 10,500 | 15,000 |
|    9 | Harborview Hotel |  9,500 | 11,500 | 16,000 |

---

## 7.2 D1 Hidden Upgrade Cost

| Property         | L1→L2 | L2→L3 | Total from L1 |
| ---------------- | ----: | ----: | ------------: |
| Pinewood Lane    | 1,500 | 2,000 |         8,500 |
| Maple Row        | 1,500 | 2,500 |         9,500 |
| Willow Café      | 1,500 | 3,000 |        10,500 |
| Sunny Market     | 2,000 | 3,500 |        12,000 |
| Bloom Gardens    | 2,000 | 4,000 |        13,500 |
| Riverside Walk   | 2,000 | 4,000 |        14,500 |
| Harborview Hotel | 2,000 | 4,000 |        15,500 |

All are cheaper than direct Buy L3.

**Total Direct Buy L3:** 90,000 Rels
**Total via L1→L2→L3:** 84,000 Rels
**Total Hidden Saving:** 6,000 Rels

---

## 7.3 D1 L3→L4 & L4→L5

| Tile | Property         |  L3→L4 |  L4→L5 |
| ---: | ---------------- | -----: | -----: |
|    1 | Pinewood Lane    | 11,500 | 16,000 |
|    2 | Maple Row        | 13,000 | 18,000 |
|    4 | Willow Café      | 15,000 | 20,000 |
|    5 | Sunny Market     | 16,500 | 22,000 |
|    6 | Bloom Gardens    | 18,000 | 24,000 |
|    8 | Riverside Walk   | 18,500 | 26,000 |
|    9 | Harborview Hotel | 20,000 | 28,000 |

---

## 7.4 D1 Value L4/L5

| Property         | Value L4 | Value L5 |
| ---------------- | -------: | -------: |
| Pinewood Lane    |   21,000 |   37,000 |
| Maple Row        |   23,500 |   41,500 |
| Willow Café      |   27,000 |   47,000 |
| Sunny Market     |   29,500 |   51,500 |
| Bloom Gardens    |   32,000 |   56,000 |
| Riverside Walk   |   33,500 |   59,500 |
| Harborview Hotel |   36,000 |   64,000 |

---

## 7.5 D1 Rent Normal

| Tile | Property         |    L1 |    L2 |    L3 |     L4 |     L5 |
| ---: | ---------------- | ----: | ----: | ----: | -----: | -----: |
|    1 | Pinewood Lane    | 1,000 | 2,000 | 3,500 |  6,000 | 10,000 |
|    2 | Maple Row        | 1,000 | 2,000 | 4,000 |  6,500 | 11,000 |
|    4 | Willow Café      | 1,500 | 2,500 | 4,500 |  7,500 | 12,000 |
|    5 | Sunny Market     | 1,500 | 3,000 | 5,000 |  8,000 | 13,000 |
|    6 | Bloom Gardens    | 1,500 | 3,000 | 5,000 |  8,500 | 14,000 |
|    8 | Riverside Walk   | 2,000 | 4,000 | 5,500 |  9,000 | 15,000 |
|    9 | Harborview Hotel | 2,000 | 4,000 | 6,000 | 10,000 | 16,000 |

---

## 7.6 D1 Set #1 Rent

| Property      | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| ------------- | -----: | -----: | -----: | -----: | -----: |
| Willow Café   |  2,000 |  3,000 |  5,500 |  9,000 | 14,500 |
| Sunny Market  |  2,000 |  3,500 |  6,000 |  9,500 | 15,500 |
| Bloom Gardens |  2,000 |  3,500 |  6,000 | 10,000 | 17,000 |

---

# 8. DISTRICT 2 — URBAN COMMERCIAL DISTRICT

## Theme

Bustling urban district focused on:

* business
* shopping
* city life
* wider streets
* taller buildings
* signage
* retail
* plazas
* business activity

Not yet super-highrise downtown.

## Properties

| Tile | Property          | Category                               |
| ---: | ----------------- | -------------------------------------- |
|   11 | Metroline Offices | Corporate Business / Commercial Office |
|   12 | Lantern Square    | F&B / Lifestyle                        |
|   14 | Grand Avenue      | Commercial / Retail                    |
|   15 | Velvet Theater    | Entertainment / Performing Arts        |
|   17 | Central Brew      | F&B / Coffee / Set #2                  |
|   18 | Civic Plaza       | Lifestyle / Public / Set #2            |
|   19 | Skyline Suites    | Hospitality / Set #2                   |

## Set #2

**Central Brew + Civic Plaza + Skyline Suites**

---

## 8.1 D2 Buy Value

| Tile | Property          | Buy L1 | Buy L2 | Buy L3 |
| ---: | ----------------- | -----: | -----: | -----: |
|   11 | Metroline Offices | 11,500 | 14,000 | 17,000 |
|   12 | Lantern Square    | 12,500 | 15,000 | 18,500 |
|   14 | Grand Avenue      | 13,500 | 16,000 | 20,000 |
|   15 | Velvet Theater    | 14,000 | 17,000 | 22,000 |
|   17 | Central Brew      | 15,000 | 18,000 | 24,000 |
|   18 | Civic Plaza       | 16,000 | 19,000 | 26,000 |
|   19 | Skyline Suites    | 17,000 | 20,000 | 28,500 |

---

## 8.2 D2 Hidden Upgrade Cost

| Tile | Property          | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ----------------- | ----: | ----: | ------------: | ------------: | ------------: |
|   11 | Metroline Offices | 2,000 | 2,500 |        16,000 |        17,000 |         1,000 |
|   12 | Lantern Square    | 2,000 | 3,500 |        18,000 |        18,500 |           500 |
|   14 | Grand Avenue      | 2,000 | 3,500 |        19,000 |        20,000 |         1,000 |
|   15 | Velvet Theater    | 2,500 | 4,500 |        21,000 |        22,000 |         1,000 |
|   17 | Central Brew      | 2,500 | 5,500 |        23,000 |        24,000 |         1,000 |
|   18 | Civic Plaza       | 3,000 | 5,000 |        24,000 |        26,000 |         2,000 |
|   19 | Skyline Suites    | 3,000 | 6,000 |        26,000 |        28,500 |         2,500 |

**Total Direct Buy L3:** 156,000 Rels
**Total via L1→L2→L3:** 147,000 Rels
**Total Hidden Saving:** 9,000 Rels

---

## 8.3 D2 L3→L4 & L4→L5

| Tile | Property          |  L3→L4 |  L4→L5 |
| ---: | ----------------- | -----: | -----: |
|   11 | Metroline Offices | 20,000 | 28,000 |
|   12 | Lantern Square    | 21,500 | 29,500 |
|   14 | Grand Avenue      | 23,000 | 31,500 |
|   15 | Velvet Theater    | 25,000 | 34,000 |
|   17 | Central Brew      | 27,000 | 36,500 |
|   18 | Civic Plaza       | 29,000 | 39,000 |
|   19 | Skyline Suites    | 31,500 | 42,000 |

---

## 8.4 D2 Value L4/L5

| Tile | Property          | Value L4 | Value L5 |
| ---: | ----------------- | -------: | -------: |
|   11 | Metroline Offices |   37,000 |   65,000 |
|   12 | Lantern Square    |   40,000 |   69,500 |
|   14 | Grand Avenue      |   43,000 |   74,500 |
|   15 | Velvet Theater    |   47,000 |   81,000 |
|   17 | Central Brew      |   51,000 |   87,500 |
|   18 | Civic Plaza       |   55,000 |   94,000 |
|   19 | Skyline Suites    |   60,000 |  102,000 |

---

## 8.5 D2 Rent Normal

| Tile | Property          |    L1 |    L2 |    L3 |     L4 |     L5 |
| ---: | ----------------- | ----: | ----: | ----: | -----: | -----: |
|   11 | Metroline Offices | 2,000 | 3,000 | 5,000 |  8,000 | 13,000 |
|   12 | Lantern Square    | 2,000 | 3,000 | 5,000 |  8,500 | 14,000 |
|   14 | Grand Avenue      | 2,500 | 3,500 | 5,500 |  9,000 | 15,000 |
|   15 | Velvet Theater    | 2,500 | 4,000 | 6,000 | 10,000 | 16,000 |
|   17 | Central Brew      | 3,000 | 4,500 | 6,500 | 10,500 | 17,000 |
|   18 | Civic Plaza       | 3,000 | 5,000 | 7,000 | 11,500 | 18,500 |
|   19 | Skyline Suites    | 3,500 | 5,500 | 7,500 | 12,500 | 20,000 |

---

## 8.6 D2 Set #2 Rent

| Property       | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| -------------- | -----: | -----: | -----: | -----: | -----: |
| Central Brew   |  3,500 |  5,500 |  8,000 | 12,500 | 20,500 |
| Civic Plaza    |  3,500 |  6,000 |  8,500 | 14,000 | 22,000 |
| Skyline Suites |  4,500 |  6,500 |  9,000 | 15,000 | 24,000 |

---

# 9. DISTRICT 3 — ENTERTAINMENT & LEISURE DISTRICT

## Theme

> The city's ultimate destination for entertainment, leisure, and big experiences.

Vibe:

* exciting
* playful
* social
* colorful
* energetic
* large buildings
* expressive signage
* giant billboards
* decorative lighting
* large plazas
* entertainment venues
* outdoor attractions
* event banners
* fountains/water features

## Properties

| Tile | Property            | Category              |
| ---: | ------------------- | --------------------- |
|   21 | Pixel Plaza         | Gaming / Set #3       |
|   22 | Starfall Park       | Attraction / Set #3   |
|   23 | Starlight Arena     | Performance / Set #3  |
|   25 | Neon Bowl           | Recreation            |
|   26 | AquaVista           | Leisure / Aquatic     |
|   28 | Prism Cinema        | Cinema                |
|   29 | Grand Escape Resort | Hospitality / Leisure |

## Set #3

**Pixel Plaza + Starfall Park + Starlight Arena**

---

## 9.1 D3 Buy Value

| Tile | Property            | Buy L1 | Buy L2 | Buy L3 |
| ---: | ------------------- | -----: | -----: | -----: |
|   21 | Pixel Plaza         | 18,500 | 22,000 | 26,000 |
|   22 | Starfall Park       | 19,500 | 23,000 | 28,000 |
|   23 | Starlight Arena     | 20,500 | 24,500 | 30,000 |
|   25 | Neon Bowl           | 21,000 | 25,000 | 31,500 |
|   26 | AquaVista           | 22,000 | 26,500 | 33,000 |
|   28 | Prism Cinema        | 23,500 | 28,000 | 35,000 |
|   29 | Grand Escape Resort | 25,000 | 29,500 | 36,500 |

---

## 9.2 D3 Hidden Upgrade Cost

| Tile | Property            | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ------------------- | ----: | ----: | ------------: | ------------: | ------------: |
|   21 | Pixel Plaza         | 2,500 | 4,000 |        25,000 |        26,000 |         1,000 |
|   22 | Starfall Park       | 2,500 | 4,500 |        26,500 |        28,000 |         1,500 |
|   23 | Starlight Arena     | 3,000 | 4,500 |        28,000 |        30,000 |         2,000 |
|   25 | Neon Bowl           | 3,000 | 5,000 |        29,000 |        31,500 |         2,500 |
|   26 | AquaVista           | 3,000 | 5,500 |        30,500 |        33,000 |         2,500 |
|   28 | Prism Cinema        | 3,500 | 6,000 |        31,500 |        35,000 |         3,500 |
|   29 | Grand Escape Resort | 3,500 | 6,500 |        35,000 |        36,500 |         1,500 |

**Total Direct Buy L3:** 220,000 Rels
**Total via L1→L2→L3:** 205,500 Rels
**Total Hidden Saving:** 14,500 Rels

---

## 9.3 D3 L3→L4 & L4→L5

| Tile | Property            |  L3→L4 |  L4→L5 |
| ---: | ------------------- | -----: | -----: |
|   21 | Pixel Plaza         | 30,000 | 40,000 |
|   22 | Starfall Park       | 32,000 | 43,000 |
|   23 | Starlight Arena     | 34,000 | 46,000 |
|   25 | Neon Bowl           | 36,000 | 48,000 |
|   26 | AquaVista           | 38,000 | 51,000 |
|   28 | Prism Cinema        | 40,000 | 54,000 |
|   29 | Grand Escape Resort | 42,000 | 57,000 |

---

## 9.4 D3 Value L4/L5

| Tile | Property            | Value L4 | Value L5 |
| ---: | ------------------- | -------: | -------: |
|   21 | Pixel Plaza         |   56,000 |   96,000 |
|   22 | Starfall Park       |   60,000 |  103,000 |
|   23 | Starlight Arena     |   64,000 |  110,000 |
|   25 | Neon Bowl           |   67,500 |  115,500 |
|   26 | AquaVista           |   71,000 |  122,000 |
|   28 | Prism Cinema        |   75,000 |  129,000 |
|   29 | Grand Escape Resort |   78,500 |  135,500 |

---

## 9.5 D3 Rent Normal

| Tile | Property            |    L1 |    L2 |     L3 |     L4 |     L5 |
| ---: | ------------------- | ----: | ----: | -----: | -----: | -----: |
|   21 | Pixel Plaza         | 3,500 | 5,000 |  7,500 | 12,000 | 19,000 |
|   22 | Starfall Park       | 3,500 | 5,500 |  8,000 | 13,000 | 21,000 |
|   23 | Starlight Arena     | 4,000 | 6,000 |  8,500 | 14,000 | 23,000 |
|   25 | Neon Bowl           | 4,000 | 6,000 |  9,000 | 15,000 | 24,500 |
|   26 | AquaVista           | 4,500 | 6,500 |  9,500 | 16,000 | 26,000 |
|   28 | Prism Cinema        | 4,500 | 7,000 | 10,000 | 17,000 | 28,000 |
|   29 | Grand Escape Resort | 5,000 | 7,500 | 11,000 | 18,000 | 30,000 |

---

## 9.6 D3 Set #3 Rent

| Property        | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| --------------- | -----: | -----: | -----: | -----: | -----: |
| Pixel Plaza     |  4,000 |  6,000 |  9,000 | 14,500 | 23,000 |
| Starfall Park   |  4,000 |  6,500 |  9,500 | 15,500 | 25,500 |
| Starlight Arena |  5,000 |  7,000 | 10,000 | 17,000 | 28,000 |

---

# 10. DISTRICT 4 — LUXURY & PRESTIGE DISTRICT

## Theme

The most prestigious district.

Focus:

* fashion
* fine dining
* art
* luxury retail
* jewelry
* premium residences
* premium hotels

Vibe:

* elegant
* aspirational
* sophisticated
* bright
* stylized modern

## Properties

| Tile | Property           | Category                |
| ---: | ------------------ | ----------------------- |
|   31 | Aurelia Maison     | Luxury Fashion          |
|   32 | Celestia Dining    | Fine Dining             |
|   34 | Opaline Gallery    | Art / Set #4            |
|   35 | Maison Royale      | Luxury Retail / Set #4  |
|   36 | Lumina Jewel House | Jewelry / Set #4        |
|   38 | Grand Meridian     | Luxury Residential      |
|   39 | Celestial Heights  | Ultra-Premium Sky Hotel |

## Set #4

**Opaline Gallery + Maison Royale + Lumina Jewel House**

---

## 10.1 D4 Buy Value

| Tile | Property           | Buy L1 | Buy L2 | Buy L3 |
| ---: | ------------------ | -----: | -----: | -----: |
|   31 | Aurelia Maison     | 26,000 | 30,000 | 34,000 |
|   32 | Celestia Dining    | 27,000 | 31,500 | 37,000 |
|   34 | Opaline Gallery    | 28,500 | 33,000 | 40,000 |
|   35 | Maison Royale      | 30,000 | 35,000 | 42,500 |
|   36 | Lumina Jewel House | 31,500 | 37,000 | 45,000 |
|   38 | Grand Meridian     | 33,000 | 38,000 | 46,500 |
|   39 | Celestial Heights  | 34,000 | 39,000 | 48,000 |

---

## 10.2 D4 Hidden Upgrade Cost

| Tile | Property           | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ------------------ | ----: | ----: | ------------: | ------------: | ------------: |
|   31 | Aurelia Maison     | 3,000 | 4,000 |        33,000 |        34,000 |         1,000 |
|   32 | Celestia Dining    | 3,000 | 5,000 |        35,000 |        37,000 |         2,000 |
|   34 | Opaline Gallery    | 3,500 | 6,000 |        38,000 |        40,000 |         2,000 |
|   35 | Maison Royale      | 3,500 | 6,500 |        40,000 |        42,500 |         2,500 |
|   36 | Lumina Jewel House | 4,000 | 6,500 |        42,000 |        45,000 |         3,000 |
|   38 | Grand Meridian     | 4,000 | 7,000 |        44,000 |        46,500 |         2,500 |
|   39 | Celestial Heights  | 4,000 | 7,500 |        45,500 |        48,000 |         2,500 |

**Total Direct Buy L3:** 293,000 Rels
**Total via L1→L2→L3:** 277,500 Rels
**Total Hidden Saving:** 15,500 Rels

---

## 10.3 D4 L3→L4 & L4→L5

| Tile | Property           |  L3→L4 |  L4→L5 |
| ---: | ------------------ | -----: | -----: |
|   31 | Aurelia Maison     | 38,000 | 52,000 |
|   32 | Celestia Dining    | 41,000 | 55,000 |
|   34 | Opaline Gallery    | 44,000 | 58,000 |
|   35 | Maison Royale      | 47,000 | 62,000 |
|   36 | Lumina Jewel House | 50,000 | 66,000 |
|   38 | Grand Meridian     | 52,000 | 69,000 |
|   39 | Celestial Heights  | 54,000 | 72,000 |

---

## 10.4 D4 Value L4/L5

| Tile | Property           | Value L4 | Value L5 |
| ---: | ------------------ | -------: | -------: |
|   31 | Aurelia Maison     |   72,000 |  124,000 |
|   32 | Celestia Dining    |   78,000 |  133,000 |
|   34 | Opaline Gallery    |   84,000 |  142,000 |
|   35 | Maison Royale      |   89,500 |  151,500 |
|   36 | Lumina Jewel House |   95,000 |  161,000 |
|   38 | Grand Meridian     |   98,500 |  167,500 |
|   39 | Celestial Heights  |  102,000 |  174,000 |

---

## 10.5 D4 Rent Normal

| Tile | Property           |    L1 |    L2 |     L3 |     L4 |     L5 |
| ---: | ------------------ | ----: | ----: | -----: | -----: | -----: |
|   31 | Aurelia Maison     | 4,500 | 6,000 |  9,000 | 15,000 | 24,000 |
|   32 | Celestia Dining    | 4,500 | 6,500 |  9,500 | 16,000 | 26,000 |
|   34 | Opaline Gallery    | 5,000 | 7,000 | 10,000 | 17,000 | 28,000 |
|   35 | Maison Royale      | 5,000 | 7,500 | 10,500 | 18,000 | 30,000 |
|   36 | Lumina Jewel House | 5,500 | 8,000 | 11,500 | 19,000 | 32,000 |
|   38 | Grand Meridian     | 5,500 | 8,500 | 12,000 | 20,000 | 35,000 |
|   39 | Celestial Heights  | 6,000 | 9,000 | 13,000 | 22,000 | 38,000 |

---

## 10.6 D4 Set #4 Rent

| Property           | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| ------------------ | -----: | -----: | -----: | -----: | -----: |
| Opaline Gallery    |  6,000 |  8,500 | 12,000 | 20,500 | 34,000 |
| Maison Royale      |  6,000 |  9,000 | 12,500 | 22,000 | 36,000 |
| Lumina Jewel House |  6,500 |  9,500 | 14,000 | 23,000 | 39,000 |

---

# 11. ECONOMIC PROGRESSION AUDIT

## Starting Capital

**100,000 Rels**

This allows:

* D1 purchases to be relatively accessible.
* D2 purchases to become meaningful investment decisions.
* D3 purchases to require greater capital management.
* D4 purchases to become high-value strategic decisions.

---

## District Buy Progression

| District |  Buy L1 Range |  Buy L2 Range |  Buy L3 Range |
| -------- | ------------: | ------------: | ------------: |
| D1       |   5,000–9,500 |  7,000–11,500 |  9,500–16,000 |
| D2       | 11,500–17,000 | 14,000–20,000 | 17,000–28,500 |
| D3       | 18,500–25,000 | 22,000–29,500 | 26,000–36,500 |
| D4       | 26,000–34,000 | 30,000–39,000 | 34,000–48,000 |

Overall progression:

> **Growing Community → Urban Commercial → Entertainment & Leisure → Luxury & Prestige**

---

## Hidden Saving Progression

| District | Direct L3 Total | Staged L3 Total | Hidden Saving |
| -------- | --------------: | --------------: | ------------: |
| D1       |          90,000 |          84,000 |         6,000 |
| D2       |         156,000 |         147,000 |         9,000 |
| D3       |         220,000 |         205,500 |        14,500 |
| D4       |         293,000 |         277,500 |        15,500 |

The staged path is always cheaper than Direct Buy L3.

---

## Highest Normal Rent by District

| District | Property            |    L1 |     L3 |     L5 |
| -------- | ------------------- | ----: | -----: | -----: |
| D1       | Harborview Hotel    | 2,000 |  6,000 | 16,000 |
| D2       | Skyline Suites      | 3,500 |  7,500 | 20,000 |
| D3       | Grand Escape Resort | 5,000 | 11,000 | 30,000 |
| D4       | Celestial Heights   | 6,000 | 13,000 | 38,000 |

Rent progression clearly increases from D1 toward D4.

---

# 12. FINAL PROPERTY ECONOMY STATUS

**28 Properties:** COMPLETE

Each Property has:

* Buy Value L1
* Buy Value L2
* Buy Value L3
* Hidden L1→L2 cost
* Hidden L2→L3 cost
* L3→L4 cost
* L4→L5 cost
* Value L4
* Value L5
* Normal Rent L1–L5
* Set Rent L1–L5 where applicable

## Four Official Sets

1. **Set #1 — D1:** Willow Café + Sunny Market + Bloom Gardens
2. **Set #2 — D2:** Central Brew + Civic Plaza + Skyline Suites
3. **Set #3 — D3:** Pixel Plaza + Starfall Park + Starlight Arena
4. **Set #4 — D4:** Opaline Gallery + Maison Royale + Lumina Jewel House

## Locked Economic Principles

* Starting Capital = **100,000 Rels**
* All economic values use **500 Rels increments**
* L1/L2/L3 can be directly purchased when landing on an unowned Property
* L4/L5 cannot be initially purchased
* Maximum 1 upgrade per turn
* L1 can upgrade directly to L3
* Hidden saving exists only through L1→L2→L3
* L4 requires L3
* L5 requires L4
* L1–L4 can be purchased from another player upon landing
* L5 cannot be purchased through landing
* Crown cannot be purchased through landing
* Property ownership transfer does not change Property Level
* Normal Trade allows negotiated deals
* Property Value is a reference, not a mandatory Trade price
* Complete Set gives approximately +20% Rent
* Set bonus disappears when the Set is broken
* Exactly one official Set exists per District

**PROPERTY ECONOMY D1–D4: LOCKED.**