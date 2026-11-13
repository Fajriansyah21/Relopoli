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

Siap. Kita rekap **brainstorm Daftar Property + Crown** sebagai satu dokumen referensi. Aku pisahkan antara **Property per District** dan **Crown**, supaya nanti mudah dipakai sebagai source utama dan disinkronkan ke Claude.

````markdown
# RELOPOLI — PROPERTY & CROWN MASTER LIST

> Status: 🔒 LOCKED
>
> Dokumen ini merupakan daftar master Property dan Crown Relopoli.
> Property dibagi menjadi 4 District, masing-masing memiliki 7 Property.
> Setiap District memiliki tepat 1 official Set yang terdiri dari 3 designated adjacent Properties.

---

# 1. PROPERTY OVERVIEW

Relopoli memiliki:

- **4 District**
- **28 Property**
- **4 Official Set**
- **4 Crown**

Property menggunakan progression:

```text
L1 → L2 → L3 → L4 → L5
````

### Property Level

| Level | Status                               |
| ----- | ------------------------------------ |
| L1    | Empty Land / Empty Lot               |
| L2    | Small Building / Small Establishment |
| L3    | Medium Building / Growing Business   |
| L4    | Large Building / Major Development   |
| L5    | Iconic Landmark                      |

Setiap District memiliki karakter visual dan ekonomi yang berbeda.

---

# 2. DISTRICT 1 — GROWING COMMUNITY

## Theme

> Neighborhood yang berkembang menjadi vibrant community.

### Vibe

* Green
* Calm
* Friendly
* Residential
* Community
* Commercial
* Waterfront

### Property

| Tile | Property             | Category                            |
| ---: | -------------------- | ----------------------------------- |
|    1 | **Pinewood Lane**    | Residential                         |
|    2 | **Maple Row**        | Residential                         |
|    4 | **Willow Café**      | F&B / Set #1                        |
|    5 | **Sunny Market**     | Commercial / Retail / Set #1        |
|    6 | **Bloom Gardens**    | Lifestyle / Public / Set #1         |
|    8 | **Riverside Walk**   | Commercial / Lifestyle / Waterfront |
|    9 | **Harborview Hotel** | Hospitality                         |

### Official Set #1

> **Willow Café + Sunny Market + Bloom Gardens**

---

# 3. DISTRICT 2 — URBAN COMMERCIAL DISTRICT

## Theme

> Bustling urban district focused on business, shopping, and city life.

### Vibe

* Business
* Shopping
* City life
* Wider streets
* Taller buildings
* Signage
* Retail
* Plazas
* Business activity

District 2 belum menjadi super-highrise downtown.

### Property

| Tile | Property              | Category                               |
| ---: | --------------------- | -------------------------------------- |
|   11 | **Metroline Offices** | Corporate Business / Commercial Office |
|   12 | **Lantern Square**    | F&B / Lifestyle                        |
|   14 | **Grand Avenue**      | Commercial / Retail                    |
|   15 | **Velvet Theater**    | Entertainment / Performing Arts        |
|   17 | **Central Brew**      | F&B / Coffee / Set #2                  |
|   18 | **Civic Plaza**       | Lifestyle / Public / Set #2            |
|   19 | **Skyline Suites**    | Hospitality / Set #2                   |

### Official Set #2

> **Central Brew + Civic Plaza + Skyline Suites**

---

# 4. DISTRICT 3 — ENTERTAINMENT & LEISURE DISTRICT

## Theme

> The city's ultimate destination for entertainment, leisure, and big experiences.

### Vibe

* Exciting
* Playful
* Social
* Colorful
* Energetic
* Large buildings
* Expressive signage
* Giant billboards
* Decorative lighting
* Large plazas
* Entertainment venues
* Outdoor attractions
* Event banners
* Fountains / water features

### Property

| Tile | Property                | Category              |
| ---: | ----------------------- | --------------------- |
|   21 | **Pixel Plaza**         | Gaming / Set #3       |
|   22 | **Starfall Park**       | Attraction / Set #3   |
|   23 | **Starlight Arena**     | Performance / Set #3  |
|   25 | **Neon Bowl**           | Recreation            |
|   26 | **AquaVista**           | Leisure / Aquatic     |
|   28 | **Prism Cinema**        | Cinema                |
|   29 | **Grand Escape Resort** | Hospitality / Leisure |

### Official Set #3

> **Pixel Plaza + Starfall Park + Starlight Arena**

---

# 5. DISTRICT 4 — LUXURY & PRESTIGE DISTRICT

## Theme

> The most prestigious district in Relopoli.

### Focus

* Fashion
* Fine dining
* Art
* Luxury retail
* Jewelry
* Premium residences
* Premium hotels

### Vibe

* Elegant
* Aspirational
* Sophisticated
* Bright
* Stylized modern

### Property

| Tile | Property               | Category                |
| ---: | ---------------------- | ----------------------- |
|   31 | **Aurelia Maison**     | Luxury Fashion          |
|   32 | **Celestia Dining**    | Fine Dining             |
|   34 | **Opaline Gallery**    | Art / Set #4            |
|   35 | **Maison Royale**      | Luxury Retail / Set #4  |
|   36 | **Lumina Jewel House** | Jewelry / Set #4        |
|   38 | **Grand Meridian**     | Luxury Residential      |
|   39 | **Celestial Heights**  | Ultra-Premium Sky Hotel |

### Official Set #4

> **Opaline Gallery + Maison Royale + Lumina Jewel House**

---

# 6. MASTER PROPERTY LIST

| District | Tile | Property            | Set    |
| -------- | ---: | ------------------- | ------ |
| D1       |    1 | Pinewood Lane       | —      |
| D1       |    2 | Maple Row           | —      |
| D1       |    4 | Willow Café         | Set #1 |
| D1       |    5 | Sunny Market        | Set #1 |
| D1       |    6 | Bloom Gardens       | Set #1 |
| D1       |    8 | Riverside Walk      | —      |
| D1       |    9 | Harborview Hotel    | —      |
| D2       |   11 | Metroline Offices   | —      |
| D2       |   12 | Lantern Square      | —      |
| D2       |   14 | Grand Avenue        | —      |
| D2       |   15 | Velvet Theater      | —      |
| D2       |   17 | Central Brew        | Set #2 |
| D2       |   18 | Civic Plaza         | Set #2 |
| D2       |   19 | Skyline Suites      | Set #2 |
| D3       |   21 | Pixel Plaza         | Set #3 |
| D3       |   22 | Starfall Park       | Set #3 |
| D3       |   23 | Starlight Arena     | Set #3 |
| D3       |   25 | Neon Bowl           | —      |
| D3       |   26 | AquaVista           | —      |
| D3       |   28 | Prism Cinema        | —      |
| D3       |   29 | Grand Escape Resort | —      |
| D4       |   31 | Aurelia Maison      | —      |
| D4       |   32 | Celestia Dining     | —      |
| D4       |   34 | Opaline Gallery     | Set #4 |
| D4       |   35 | Maison Royale       | Set #4 |
| D4       |   36 | Lumina Jewel House  | Set #4 |
| D4       |   38 | Grand Meridian      | —      |
| D4       |   39 | Celestial Heights   | —      |

---

# 7. PROPERTY ECONOMY

## Currency

> **Rels**

## Nominal Rule

Semua nominal ekonomi menggunakan kelipatan:

> **500 Rels**

## Starting Capital

> **250,000 Rels**

---

# 8. INITIAL PURCHASE

Ketika pemain mendarat di Property yang belum dimiliki:

### Available

* Buy L1
* Buy L2
* Buy L3

### Disabled

* L4
* L5

L4 dan L5 tidak dapat menjadi initial purchase.

Purchase dan Upgrade merupakan dua sistem berbeda.

---

# 9. PROPERTY UPGRADE

Upgrade normal hanya dapat dilakukan ketika pemain:

> **Landing di Property miliknya sendiri**

Maksimal:

> **1 upgrade per turn**

Progression:

```text
L1 → L2
L1 → L3
L2 → L3
L3 → L4
L4 → L5
```

Tidak boleh:

```text
L3 → L5
```

dalam satu upgrade.

L4 membutuhkan L3.

L5 membutuhkan L4.

---

# 10. HIDDEN INSTALLMENT ECONOMY

Untuk L1 → L2 → L3:

> Upgrade bertahap lebih murah daripada membeli langsung L3.

Saving tersebut:

> **Tidak ditampilkan sebagai bonus / discount khusus.**

Player menemukan keuntungan tersebut melalui pengalaman bermain.

Tidak ada hidden installment discount untuk:

* L3 → L4
* L4 → L5

---

# 11. PROPERTY VALUE

Property memiliki beberapa nilai referensi.

### Buy Value

Untuk Property yang belum dimiliki:

> Buy Value = harga pembelian level tersebut.

### Value L4

```text
Buy L3
+
Upgrade L3 → L4
=
Value L4
```

### Value L5

```text
Value L4
+
Upgrade L4 → L5
=
Value L5
```

Value L4 dan L5 digunakan sebagai reference value untuk transaksi/property economy.

---

# 12. BUYING ANOTHER PLAYER'S PROPERTY

Ketika landing di Property milik player lain:

### L1–L4

1. Landing player membayar Rent.
2. Jika masih memiliki cukup Rels, opsi Buy Property muncul.
3. UI menampilkan Current Property Value.
4. Buyer membayar Value tersebut kepada owner.
5. Ownership berpindah.
6. Property Level tidak berubah.

### L5

> Tidak dapat dibeli melalui landing.

### Crown

> Tidak dapat dibeli melalui landing.

---

# 13. NORMAL TRADE

Property dapat berpindah melalui Trade.

Dalam normal Trade:

> **Value bukan harga wajib.**

Player dapat melakukan negosiasi dan menentukan deal sendiri.

Ownership berubah.

Property Level tetap sama.

---

# 14. SET SYSTEM

Setiap District memiliki:

> **Tepat 1 Official Set**

Setiap Set terdiri dari:

> **Tepat 3 designated adjacent Properties**

Property lain yang berdekatan tetapi tidak masuk designation:

> **Bukan bagian Set.**

### Set Completion

Jika seorang player memiliki ketiga Property:

> **Set = COMPLETE**

Set memberikan peningkatan Rent sekitar:

> **+20%**

Nilai Set Rent telah ditentukan langsung dan tetap menggunakan kelipatan 500 Rels.

Jika salah satu Property keluar dari kepemilikan:

> **Set BREAKS**

Bonus Set langsung hilang.

---

# 15. OFFICIAL SETS

| Set    | District | Property 1      | Property 2    | Property 3         |
| ------ | -------- | --------------- | ------------- | ------------------ |
| Set #1 | D1       | Willow Café     | Sunny Market  | Bloom Gardens      |
| Set #2 | D2       | Central Brew    | Civic Plaza   | Skyline Suites     |
| Set #3 | D3       | Pixel Plaza     | Starfall Park | Starlight Arena    |
| Set #4 | D4       | Opaline Gallery | Maison Royale | Lumina Jewel House |

---

# 16. CROWN SYSTEM

Setiap District memiliki:

> **1 Crown**

Total:

> **4 Crown**

Crown merupakan landmark/simbol utama masing-masing District.

Crown memiliki identitas visual dan tema yang berbeda sesuai karakter District.

---

# 17. CROWN LOCATIONS

| District | Crown                  | Tile |
| -------- | ---------------------- | ---: |
| D1       | **The Verdant Crown**  |    7 |
| D2       | **The Radiant Crown**  |   16 |
| D3       | **The Stellar Crown**  |   24 |
| D4       | **The Imperial Crown** |   33 |

---

# 18. CROWN IDENTITY

## 👑 The Verdant Crown

### District

> District 1 — Growing Community

### Theme

> **Growth**

Representasi:

> Pertumbuhan, komunitas, kehidupan, dan perkembangan kota.

Karakter visual:

* Green
* Organic
* Community-oriented
* Natural
* Calm

---

## 👑 The Radiant Crown

### District

> District 2 — Urban Commercial

### Theme

> **Ambition**

Representasi:

> Ambisi, perkembangan bisnis, aktivitas urban, dan kemajuan.

Karakter visual:

* Modern
* Urban
* Bright
* Business-oriented
* Dynamic

---

## 👑 The Stellar Crown

### District

> District 3 — Entertainment & Leisure

### Theme

> **Experience**

Representasi:

> Puncak pengalaman, hiburan, kesenangan, dan event besar di Relopoli.

Karakter visual:

* Playful
* Spectacular
* Star-inspired
* Entertainment-oriented
* Expressive

### Landmark

> **Stellar Core**

Sebuah geometric star/crystal centerpiece sebagai focal point Crown.

---

## 👑 The Imperial Crown

### District

> District 4 — Luxury & Prestige

### Theme

> **Prestige**

Representasi:

> Status, pencapaian, eksklusivitas, dan prestige tertinggi di Relopoli.

Karakter visual:

* Elegant
* Sophisticated
* Symmetrical
* Premium
* Gold / white / cream aesthetic

### Landmark

> **Imperial Halo**

Cincin monumental yang menjadi silhouette utama Crown.

---

# 19. CROWN PROGRESSION

Keempat Crown membentuk progression tematik:

```text
🌿 GROWTH
     ↓
✨ AMBITION
     ↓
⭐ EXPERIENCE
     ↓
👑 PRESTIGE
```

Dengan demikian setiap Crown memiliki fungsi identitas yang berbeda:

| Crown              | Theme      |
| ------------------ | ---------- |
| The Verdant Crown  | Growth     |
| The Radiant Crown  | Ambition   |
| The Stellar Crown  | Experience |
| The Imperial Crown | Prestige   |

---

# 20. CROWN OWNERSHIP

Crown:

> Tidak dapat dibeli melalui landing biasa.

Crown merupakan aset/sistem khusus.

Crown yang telah diperoleh player:

> Tidak dapat dijual atau ditukar melalui normal transaction.

Crown memiliki sistem economy dan victory condition tersendiri.

---

# 21. CROWN VICTORY

Mengumpulkan seluruh Crown:

> **4 Crown**

menjadi salah satu kondisi kemenangan utama:

> **Crown Victory**

Flow:

```text
Acquire Crown
    ↓
Acquire Crown
    ↓
Acquire Crown
    ↓
Acquire Crown ke-4
    ↓
4 Crown Complete
    ↓
CROWN VICTORY
```

---

# 22. CROWN ECONOMY

Crown Reward berhubungan dengan jumlah Property yang dimiliki player dalam District Crown tersebut.

Formula dasar:

```text
Property Owned in Crown District
× 1,000 Rels
```

Maximum:

> **7,000 Rels**

Karena satu District memiliki 7 Property.

---

# 23. CROWN PROSPERITY

Crown dapat memiliki:

> **Prosperity**

Prosperity memberikan:

> **+2,000 Rels**

kepada Crown Reward.

Durasi:

> **3 putaran**

Jika Prosperity diterapkan lagi pada Crown yang sama:

> **Timer refresh menjadi 3 putaran**

Bukan stacking.

---

# 24. CROWN DISRUPTION

Crown dapat mengalami:

> **Disruption**

Efek:

> **Crown Reward berikutnya = 0**

Disruption:

* Tidak menghapus Prosperity.
* Tidak menghapus timer Prosperity.
* Tidak pause timer Prosperity.

---

# 25. CROWN BREAK / CROWN DESTROYED

Jika Crown dihancurkan:

```text
Crown
 ↓
Destroyed
 ↓
Unowned
 ↓
Clean
```

Semua modifier/status Crown tersebut dihapus.

Termasuk:

* Crown Prosperity
* Crown Disruption
* Status Crown lainnya

---

# 26. PROPERTY MODIFIER & OWNERSHIP

Property Modifier mengikuti:

> **Property**

Bukan player.

Contoh:

* Premium Listing
* Falling Demand
* Half Rent
* Property Slump

Jika Property berpindah ownership:

> Modifier tetap melekat pada Property.

Timer:

> Tidak di-reset.

---

# 27. PROPERTY MENJADI UNOWNED

Jika Property dijual atau kembali menjadi Unowned:

> Semua Property Modifier dihapus.

Property kembali ke:

```text
Unowned
+
L1 / Empty Land
+
Clean State
```

Player berikutnya tidak mewarisi modifier lama.

---

# 28. PROPERTY SALE & SET

Jika Property yang dijual merupakan bagian dari Set:

> **Set langsung BREAK**

Property lain dalam Set kehilangan bonus Set.

Sistem memberikan warning sebelum transaksi.

Contoh:

> `Property ini merupakan bagian dari Set. Menjualnya akan memutus Set.`

---

# 29. PROPERTY & CROWN LIQUIDATION

Jika terjadi Asset Liquidation karena Bankruptcy:

### Property

Property dijual dengan nilai sekitar:

> **80% Current Property Value**

Nominal tetap dibulatkan ke:

> **500 Rels**

### Crown

Crown dapat dijual dalam Asset Liquidation dengan:

> **100% Crown Value**

Setelah dijual:

> Crown menjadi Unowned / Clean.

---

# 30. MASTER DISTRICT TABLE

| District | Theme                   | Properties | Set    | Crown              |
| -------- | ----------------------- | ---------: | ------ | ------------------ |
| D1       | Growing Community       |          7 | Set #1 | The Verdant Crown  |
| D2       | Urban Commercial        |          7 | Set #2 | The Radiant Crown  |
| D3       | Entertainment & Leisure |          7 | Set #3 | The Stellar Crown  |
| D4       | Luxury & Prestige       |          7 | Set #4 | The Imperial Crown |

---

# 31. MASTER BOARD STRUCTURE

```text
DISTRICT 1
1  Pinewood Lane
2  Maple Row
4  Willow Café
5  Sunny Market
6  Bloom Gardens
7  👑 The Verdant Crown
8  Riverside Walk
9  Harborview Hotel

        ↓

DISTRICT 2
11 Metroline Offices
12 Lantern Square
14 Grand Avenue
15 Velvet Theater
16 👑 The Radiant Crown
17 Central Brew
18 Civic Plaza
19 Skyline Suites

        ↓

DISTRICT 3
21 Pixel Plaza
22 Starfall Park
23 Starlight Arena
24 👑 The Stellar Crown
25 Neon Bowl
26 AquaVista
28 Prism Cinema
29 Grand Escape Resort

        ↓

DISTRICT 4
31 Aurelia Maison
32 Celestia Dining
33 👑 The Imperial Crown
34 Opaline Gallery
35 Maison Royale
36 Lumina Jewel House
38 Grand Meridian
39 Celestial Heights
```

---

# 32. TOTAL CONTENT

| Component            |        Total |
| -------------------- | -----------: |
| District             |        **4** |
| Property             |       **28** |
| Property / District  |        **7** |
| Official Set         |        **4** |
| Property / Set       |        **3** |
| Crown                |        **4** |
| Property Level       |        **5** |
| Currency             |     **Rels** |
| Minimum nominal unit | **500 Rels** |

---

# 33. FINAL PROPERTY IDENTITY

### District 1

> **Growth / Community**

### District 2

> **Ambition / Urban Business**

### District 3

> **Experience / Entertainment**

### District 4

> **Prestige / Luxury**

Progression keseluruhan:

```text
🌿 COMMUNITY
      ↓
✨ AMBITION
      ↓
⭐ EXPERIENCE
      ↓
👑 PRESTIGE
```

---

# 34. FINAL STATUS

| System                 | Status    |
| ---------------------- | --------- |
| 4 District             | 🔒 LOCKED |
| 28 Property            | 🔒 LOCKED |
| Property Names         | 🔒 LOCKED |
| Property Categories    | 🔒 LOCKED |
| 4 Official Sets        | 🔒 LOCKED |
| Set Composition        | 🔒 LOCKED |
| Property Level L1–L5   | 🔒 LOCKED |
| Initial Purchase L1–L3 | 🔒 LOCKED |
| Upgrade Progression    | 🔒 LOCKED |
| Hidden L1→L2→L3 Saving | 🔒 LOCKED |
| Property Value System  | 🔒 LOCKED |
| Property Rent Tables   | 🔒 LOCKED |
| 4 Crown                | 🔒 LOCKED |
| Crown Names            | 🔒 LOCKED |
| Crown Locations        | 🔒 LOCKED |
| Crown Themes           | 🔒 LOCKED |
| Crown Identity         | 🔒 LOCKED |
| Crown Victory          | 🔒 LOCKED |
| Crown Economy          | 🔒 LOCKED |

---

# FINAL PROPERTY & CROWN PRINCIPLE

> **Relopoli memiliki empat District yang berkembang secara tematik dari Growing Community, Urban Commercial, Entertainment & Leisure, hingga Luxury & Prestige. Setiap District memiliki tujuh Property, satu Official Set, dan satu Crown sebagai landmark utama. Property berkembang melalui lima level L1–L5, sementara Set memberikan peningkatan Rent ketika seluruh tiga Property dimiliki oleh player yang sama.**

> **Keempat Crown — The Verdant Crown, The Radiant Crown, The Stellar Crown, dan The Imperial Crown — membentuk progression tematik Growth → Ambition → Experience → Prestige dan dapat menjadi dasar Crown Victory ketika seorang player berhasil mengumpulkan seluruh empat Crown.**

**PROPERTY & CROWN — BRAINSTORM RECAP / LOCKED 🔒**

```

Untuk angka ekonomi Property, aku mempertahankan tabel yang sudah dikunci di source Property; bagian master di atas sengaja fokus pada **daftar, struktur, Set, identitas District, dan Crown**, supaya tidak menduplikasi seluruh tabel harga/rent dan mengurangi risiko dua source menjadi tidak sinkron. :contentReference[oaicite:0]{index=0}
```

Siap. Kita rekap dan **kunci hasil brainstorming Initial Property Purchase UI** dulu. Untuk bagian yang merupakan keputusan desain kita, aku pisahkan dari aturan Property yang sudah ada supaya nanti gampang dimasukkan ke source.

# Relopoli — Brainstorm Initial Property Purchase UI

## 1. Tujuan

Ketika Player mendarat pada **Property yang masih Unowned**, sistem menampilkan UI untuk memilih **Level awal Property** yang ingin dibeli.

Initial Purchase menawarkan:

* **Buy L1**
* **Buy L2**
* **Buy L3**

L4 dan L5 **tidak tersedia sebagai Initial Purchase**.

---

# 2. Konsep Visual Utama

Purchase UI menggunakan konsep:

> **Property Map / Envelope**

Map/Envelope menjadi container untuk tiga pilihan Level.

Di dalamnya terdapat **tiga Level Card yang berdiri berdampingan secara rapi**.

### Layout

```text
┌───────────────────────────────────────────────┐
│                                               │
│               PINEWOOD LANE                   │
│                                               │
│             PROPERTY ACQUISITION              │
│                                               │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ │
│  │   LEVEL 1  │ │   LEVEL 2  │ │   LEVEL 3  │ │
│  │            │ │            │ │            │ │
│  │   [IMAGE]  │ │   [IMAGE]  │ │   [IMAGE]  │ │
│  │            │ │            │ │            │ │
│  │ Empty Land │ │   Small    │ │   Medium   │ │
│  │            │ │  Building  │ │  Building  │ │
│  │            │ │            │ │            │ │
│  │ 5,000 Rels │ │ 7,000 Rels │ │ 9,500 Rels │ │
│  └────────────┘ └────────────┘ └────────────┘ │
│                                               │
│                YOUR BALANCE                   │
│                250,000 Rels                   │
│                                               │
│                    CANCEL                     │
└───────────────────────────────────────────────┘
```

### Visual direction yang dipilih

**Opsi A — Clean & Formal**

* Kartu sejajar.
* Tidak ada overlap.
* Tidak ada kartu yang ditumpuk atau diputar.
* Spacing konsisten.
* Ukuran kartu konsisten.
* Alignment rapi.
* Map/Envelope memberikan framing untuk seluruh pilihan.

Pendekatan ini juga sejalan dengan prinsip visual hierarchy: informasi utama sebaiknya mudah dipindai, sementara elemen sekunder tidak ikut bersaing mendapatkan perhatian. ([Game Developer][1])

---

# 3. Property Map / Envelope

Map bukan sekadar background.

Fungsinya adalah memberikan identitas bahwa Player sedang melihat **dokumen/pilihan pembangunan Property tertentu**.

Contoh:

```text
PROPERTY MAP

        PINEWOOD LANE

    PROPERTY ACQUISITION

   [ L1 ]  [ L2 ]  [ L3 ]

          YOUR BALANCE

             CANCEL
```

Map dapat memiliki:

* tekstur kertas/map
* identitas visual Property
* nama Property
* ornamen yang sesuai dengan tema Relopoli
* depth/shadow yang halus

Namun Map **tidak boleh terlalu dekoratif sampai mengganggu Level Cards**.

---

# 4. Level Card

Setiap Level direpresentasikan oleh satu kartu.

Struktur kartu:

```text
┌───────────────┐
│    LEVEL 2    │
│               │
│   [BUILDING]  │
│               │
│ Small Building│
│               │
│   7,000 Rels  │
└───────────────┘
```

Setiap kartu menampilkan:

1. **Level**
2. **Visual Property**
3. **Nama Level**
4. **Harga pembelian**

### Tidak ditampilkan di kartu:

* Rent
* Property Value
* Upgrade Cost
* Modifier
* Set information
* Informasi ekonomi tambahan lainnya

Tujuannya agar kartu tetap fokus pada satu pertanyaan:

> **"Aku ingin membeli Property ini mulai dari Level berapa?"**

Prinsip card UI yang menempatkan informasi penting secara hierarkis dan menghindari kepadatan informasi mendukung pendekatan ini. ([ShuffleKit][2])

---

# 5. Visual Setiap Level

Setiap Level **wajib memiliki visual Property yang berbeda**.

Visual bukan hanya dekorasi, tetapi menunjukkan progression Property.

Contoh:

### Level 1

**Empty Land**

Visual berupa lahan kosong.

### Level 2

**Small Building**

Visual berupa bangunan kecil.

### Level 3

**Medium Building**

Visual berupa bangunan yang sudah berkembang.

Sehingga:

```text
L1 → Empty Land
       ↓
L2 → Small Building
       ↓
L3 → Medium Building
```

Visual progression akan membuat perubahan Level terasa nyata, bukan hanya perubahan angka.

---

# 6. Visual Setiap Property Bisa Berbeda

Visual bangunan tidak harus generic.

Contohnya:

### Willow Café

```text
L1 → lahan kosong
L2 → café kecil
L3 → café berkembang
```

### Sunny Market

```text
L1 → lahan kosong
L2 → toko kecil
L3 → market yang lebih besar
```

### Harborview Hotel

```text
L1 → lahan kosong
L2 → hotel kecil
L3 → hotel berkembang
```

Dengan begitu, setiap Property mempunyai identitas visual sendiri.

---

# 7. Rent Tidak Ditampilkan di Level Card

**Keputusan final: Rent tidak ditampilkan pada kartu L1/L2/L3.**

Rent akan ditampilkan melalui:

> **Billboard di atas tile Property pada board.**

Dengan demikian informasi memiliki dua tempat yang berbeda:

### Purchase UI

Fokus pada:

> **Keputusan investasi**

### Board

Fokus pada:

> **Informasi operasional Property**

Contoh:

```text
              ┌───────────────┐
              │     RENT      │
              │   3,500 Rels  │
              └───────────────┘
                     │
                     ▼
              ┌───────────────┐
              │   PROPERTY    │
              │      L3       │
              └───────────────┘
```

Ini membuat Purchase UI tidak terlalu padat.

---

# 8. Player Balance

**Balance Player tetap ditampilkan di Purchase UI.**

Contoh:

> **YOUR BALANCE**
> **250,000 Rels**

Tujuannya agar Player dapat langsung memahami kemampuan finansialnya ketika membandingkan ketiga pilihan.

---

# 9. Insufficient Rels

Level yang tidak mampu dibeli tetap ditampilkan.

Misalnya:

**Balance = 6,000 Rels**

Maka:

```text
┌──────────┐ ┌──────────┐ ┌──────────┐
│   L1     │ │   L2     │ │   L3     │
│          │ │          │ │          │
│  [IMG]   │ │  [IMG]   │ │  [IMG]   │
│          │ │          │ │          │
│ Empty    │ │ Small    │ │ Medium   │
│ Land     │ │ Building │ │ Building │
│          │ │          │ │          │
│  5,000   │ │  7,000   │ │  9,500   │
│  RELS    │ │  RELS    │ │  RELS    │
│          │ │  LOCKED  │ │  LOCKED  │
└──────────┘ └──────────┘ └──────────┘
```

Kartu yang tidak mampu dibeli:

* tetap terlihat
* tetap menunjukkan harga
* tetap menunjukkan visual
* tetapi **disabled**

Tidak dibuat seolah-olah Level tersebut tidak ada.

Aturan source juga sudah menetapkan bahwa pilihan yang tidak mampu dibayar menjadi disabled. 

---

# 10. Hidden Installment Economy Tetap Hidden

Walaupun Player dapat melihat:

```text
Buy L1
Buy L2
Buy L3
```

UI **tidak memberitahukan bahwa membeli L1 → L2 → L3 lebih murah daripada langsung Buy L3**.

Tidak ada label:

* "Best Value"
* "Save 6,000 Rels"
* "Recommended"
* "Discount"
* "Cheapest Path"

Ketiga pilihan disajikan secara netral.

Sistem hidden installment economy tetap menjadi bagian dari mekanik ekonomi, bukan informasi promosi di UI.

---

# 11. Tidak Ada Recommended Level

Tidak ada:

> ⭐ Recommended

> Best Choice

> Most Popular

> Best Value

Semua Level merupakan pilihan strategis Player.

UI hanya menyajikan informasi; keputusan tetap berada pada Player.

---

# 12. Level Card Interaction States

Level Card memiliki beberapa state.

### Normal

Kartu tampil normal dan dapat dipilih.

### Hover / Focus

Kartu mendapat feedback ringan:

* sedikit membesar
* sedikit naik
* shadow lebih kuat
* highlight

Animasi tetap subtle agar tidak mengganggu pembacaan.

### Selected

Kartu yang dipilih terlihat jelas sebagai pilihan aktif.

### Disabled

Jika Rels tidak cukup:

* kartu tidak dapat dipilih
* visual tetap terlihat
* harga tetap terlihat
* status menunjukkan bahwa Player tidak memiliki Rels yang cukup

Feedback interaksi yang jelas penting supaya Player tidak bertanya-tanya apakah inputnya berhasil. ([GitHub][3])

---

# 13. Initial Purchase Flow

Flow keseluruhan sekarang:

```text
MOVEMENT COMPLETE
        ↓
START CHECK
        ↓
START REWARD
        ↓
LANDING TILE
        ↓
PROPERTY DETECTION
        ↓
PROPERTY = UNOWNED
        ↓
PROPERTY MAP
        ↓
LEVEL CARDS
        ↓
Player memilih L1 / L2 / L3
        ↓
PURCHASE CONFIRMATION
        ↓
┌───────────────────┐
│                   │
│      CONFIRM      │
│         │         │
│         ↓         │
│    TRANSACTION    │
│                   │
└───────────────────┘
        ↓
PROPERTY ACQUIRED
        ↓
LANDING RESOLUTION COMPLETE
        ↓
TURN CONTINUES
```

Pola selection → confirmation → transaksi → kembali ke konteks game juga merupakan pola yang umum digunakan untuk menjaga purchase flow tetap jelas. ([Hadjoudj Idris][4])

---

# 14. Dua Jenis Cancel

Kita membedakan dua fungsi **Cancel**.

## A. Cancel pada Purchase Confirmation

Contoh:

```text
Level 2
   ↓
Purchase Confirmation
   ↓
CANCEL
   ↓
Kembali ke Property Map
```

Player masih dapat memilih Level lain.

Contoh:

```text
Buy L2
   ↓
Cancel
   ↓
Buy L3
```

---

## B. Cancel pada Property Map

Contoh:

```text
Property Map
     ↓
CANCEL
     ↓
Purchase Flow selesai
```

Setelah ini Player **tidak dapat membuka Purchase UI kembali pada landing tersebut**.

Property tetap:

```text
UNOWNED
```

Tidak ada:

* Auction
* Forced Purchase
* Penalty
* Re-open Purchase

---

# 15. Tidak Ada Confirmation untuk Cancel Utama

Ketika Player menekan Cancel pada Property Map:

```text
CANCEL
   ↓
langsung keluar
```

Tidak perlu:

> "Are you sure?"

Cancel merupakan tindakan aman dan reversible hanya dalam arti Player belum membeli apa pun.

---

# 16. Purchase dan Upgrade Tetap Terpisah

Initial Purchase **tidak langsung membuka Upgrade**.

Contoh:

```text
Landing Unowned
       ↓
Buy L2
       ↓
Property menjadi milik Player
       ↓
Level = L2
       ↓
Purchase selesai
```

Tidak ada:

```text
Buy L2
 ↓
"Upgrade ke L3?"
```

Upgrade merupakan sistem terpisah dan dilakukan ketika Player landing pada Property miliknya sendiri sesuai aturan Upgrade.

---

# 17. Confirm Purchase = Final Transaction

Setelah Player menekan:

> **CONFIRM PURCHASE**

transaksi dianggap final.

Tidak ada:

* Undo
* Cancel transaction
* Revert
* Immediate refund

Transaksi harus diproses sebagai satu kesatuan:

```text
Validate Balance
       ↓
Deduct Rels
       ↓
Assign Ownership
       ↓
Assign Level
       ↓
Update Property State
       ↓
Update Set jika relevan
       ↓
Transaction Complete
```

Tidak boleh terjadi keadaan di mana Rels sudah berkurang tetapi ownership belum berubah, atau sebaliknya.

---

# 18. Setelah Pembelian Berhasil

Player mendapat feedback:

```text
✓ PROPERTY ACQUIRED

Pinewood Lane
Level 2

-7,000 Rels
```

Kemudian UI kembali ke board.

Property yang baru dibeli langsung menunjukkan **visual Level yang baru**.

Contoh:

```text
Purchase L3
     ↓
Confirm
     ↓
Property Acquired
     ↓
Map closes
     ↓
Board kembali terlihat
     ↓
Pinewood Lane berubah menjadi visual L3
```

Dengan demikian hasil pembelian tidak hanya terasa sebagai perubahan angka, tetapi juga terlihat langsung pada board.

---

# 🔒 STATUS: INITIAL PURCHASE UI

### Sudah dikunci

* [x] Property Map / Envelope
* [x] Tiga Level Card
* [x] Kartu berdiri berdampingan
* [x] Layout clean & formal
* [x] L1 / L2 / L3
* [x] Visual berbeda untuk setiap Level
* [x] Property-specific visual progression
* [x] Price pada kartu
* [x] Rent **tidak** pada kartu
* [x] Rent melalui billboard di board
* [x] Balance Player ditampilkan
* [x] Insufficient Rels → disabled
* [x] Hidden installment economy tetap tersembunyi
* [x] Tidak ada Recommended Level
* [x] Hover / Focus / Selected / Disabled state
* [x] Level Card → Purchase Confirmation
* [x] Confirmation Cancel → kembali ke Property Map
* [x] Property Map Cancel → mengakhiri kesempatan membeli
* [x] Tidak ada Auction
* [x] Tidak ada Re-open setelah Cancel utama
* [x] Tidak ada immediate Upgrade setelah Purchase
* [x] Confirm Purchase = transaksi final
* [x] Feedback Property Acquired
* [x] Property di board langsung berubah sesuai Level yang dibeli


Berikut rekap final **Upgrade Property UI** dalam format Markdown, siap dimasukkan ke source Relopoli.

````markdown
# 🏗️ Progress — Upgrade Property UI

**Status: 🔒 LOCKED**

---

## 1. Trigger Upgrade UI

Upgrade Property UI muncul **otomatis setelah Player mendarat di Property miliknya**.

Upgrade UI hanya muncul apabila Property tersebut masih memiliki upgrade yang valid.

Flow:

Player Movement
↓
Landing Resolution
↓
Player mendarat di Property miliknya
↓
Cek apakah Property dapat di-upgrade
↓
Jika bisa → Upgrade Property UI muncul
↓
Player memilih Upgrade / Cancel
↓
Turn selesai

### Kondisi UI tidak muncul

- Property bukan milik Player.
- Property sudah Level 5.
- Tidak ada upgrade valid yang tersedia.
- Kondisi upgrade tidak terpenuhi.

---

# 2. Timing Upgrade

Upgrade Property merupakan bagian dari **Turn yang sedang berlangsung**.

Upgrade UI muncul **sebelum Turn selesai**.

Flow:

Player mendarat
↓
Landing Resolution
↓
Upgrade Property UI
↓
Player memilih Upgrade / Cancel
↓
Turn selesai

Player tidak mendapatkan kesempatan membuka Upgrade UI kembali setelah UI ditutup pada Turn tersebut.

---

# 3. Upgrade Progression

Pilihan upgrade ditentukan berdasarkan Current Level Property.

| Current Level | Available Upgrade |
|---|---|
| **L1** | L2 atau L3 |
| **L2** | L3 |
| **L3** | L4 |
| **L4** | L5 |
| **L5** | Tidak ada upgrade |

### Important Rule

L1 dapat langsung di-upgrade ke L3.

Namun:

- L2 → hanya L3
- L3 → hanya L4
- L4 → hanya L5

Tidak ada L3 → L5 secara langsung.

---

# 4. Property Header

Upgrade UI menggunakan **Property Header**.

Header menampilkan:

- Property Name
- District
- Current Level

Contoh:

```text
MAPLE ROW
Growing Community

CURRENT LEVEL: L1
````

Current Level hanya berfungsi sebagai **label/status**.

Current Level tidak dibuat menjadi Card.

---

# 5. Available Upgrade Cards

Bagian utama UI menampilkan:

**AVAILABLE UPGRADES**

Setiap upgrade yang valid ditampilkan sebagai **Level Card**.

Card menggunakan layout **dua Card besar berdampingan** apabila terdapat dua pilihan upgrade.

Contoh L1:

```text
┌──────────────────┐    ┌──────────────────┐
│     LEVEL 2      │    │     LEVEL 3      │
│                  │    │                  │
│  [L2 PROPERTY]   │    │  [L3 PROPERTY]   │
│                  │    │                  │
│   15,000 Rels    │    │   30,000 Rels    │
│                  │    │                  │
│      SELECT      │    │      SELECT      │
└──────────────────┘    └──────────────────┘
```

Untuk Current Level yang hanya memiliki satu pilihan, Card tetap menggunakan ukuran/layout yang sama.

Contoh L2:

```text
┌──────────────────┐
│     LEVEL 3      │
│                  │
│  [L3 PROPERTY]   │
│                  │
│   30,000 Rels    │
│                  │
│      SELECT      │
└──────────────────┘
```

Card tidak diperkecil hanya karena jumlah pilihan menjadi satu.

---

# 6. Level Card Visual

Level Card menggunakan **Preview Level Berikutnya**.

Artwork yang ditampilkan adalah **visual Property pada level tujuan**, bukan visual Current Level.

Contoh:

L1 → L2

```text
LEVEL 2

[L2 PROPERTY]

15,000 Rels
```

L1 → L3

```text
LEVEL 3

[L3 PROPERTY]

30,000 Rels
```

Tujuannya agar Player dapat langsung melihat seperti apa Property setelah Upgrade.

### Card tidak menampilkan:

* Rent
* Current → Target visual comparison
* Hidden installment economy
* Recommended Level

Current Level sudah ditampilkan pada Property Header.

---

# 7. Informasi Level Card

Setiap Card menampilkan:

1. Target Level
2. Preview Property target level
3. Upgrade Cost
4. Select affordance

Contoh:

```text
LEVEL 3

[L3 PROPERTY]

30,000 Rels

SELECT
```

---

# 8. Rent

**Rent tidak ditampilkan di Upgrade Property UI.**

Rent tetap tersedia melalui **Property Billboard** di Board.

Upgrade UI hanya berfokus pada:

* Target Level
* Property Preview
* Upgrade Cost
* Player Balance
* Upgrade Interaction

---

# 9. Player Balance

Balance Player selalu terlihat di Upgrade UI.

Contoh:

```text
BALANCE
85,000 Rels
```

Balance digunakan sebagai informasi bagi Player untuk menentukan upgrade yang mampu dilakukan.

Hidden installment economy tetap tidak ditampilkan.

---

# 10. Card Interaction

Seluruh area Level Card bersifat **clickable**.

Player tidak harus menekan tulisan `SELECT` secara langsung.

Flow:

Hover
↓
Card mendapat visual emphasis
↓
Player click di area Card
↓
Card Selected
↓
Confirmation Panel muncul

Tulisan `SELECT` tetap digunakan sebagai visual affordance.

---

# 11. Hover State

Hover menghasilkan **visual emphasis ringan**.

Perubahan dapat berupa:

* Outline/frame lebih jelas
* Card sedikit lebih menonjol
* Property artwork mendapat emphasis ringan

Tidak ada perubahan informasi.

Tidak menggunakan animasi berlebihan.

---

# 12. Selected State

Card yang dipilih masuk ke **Selected State**.

Selected State menggunakan visual emphasis melalui:

* Frame / outline
* Visual emphasis yang lebih kuat

Artwork tidak berubah secara drastis.

Setelah Card dipilih, Confirmation Panel muncul.

---

# 13. Insufficient Rels

Jika Balance Player tidak mencukupi untuk suatu upgrade:

* Card tetap ditampilkan.
* Harga tetap ditampilkan.
* Artwork tetap ditampilkan.
* Card menjadi **Disabled**.
* Card tidak dapat di-hover.
* Card tidak dapat di-click.
* Card tidak dapat masuk Selected State.
* Confirmation tidak dapat dibuka.

Contoh:

```text
LEVEL 3

[L3 PROPERTY]

30,000 Rels

INSUFFICIENT RELS
```

Upgrade yang disabled tetap terlihat karena upgrade tersebut masih valid secara progression, hanya kondisi ekonominya yang belum terpenuhi.

---

# 14. Confirmation Panel

Memilih Level Card tidak langsung melakukan Upgrade.

Setelah Card dipilih, muncul **Confirmation Panel di tengah UI**.

Level Cards tetap terlihat di background.

Contoh:

```text
┌─────────────────────────────┐
│     UPGRADE PROPERTY?       │
│                             │
│       LEVEL 1 → LEVEL 3     │
│                             │
│        30,000 Rels          │
│                             │
│  [ CANCEL ]   [ CONFIRM ]  │
└─────────────────────────────┘
```

Confirmation menampilkan:

* Upgrade Property?
* Current Level → Target Level
* Upgrade Cost
* Cancel
* Confirm

Rent tidak ditampilkan.

---

# 15. Confirmation Modal Lock

Saat Confirmation Panel muncul:

* Semua Level Card di background menjadi **non-interactive**.
* Hover tidak aktif.
* Click di luar Panel tidak melakukan apa-apa.
* Player wajib memilih `Cancel` atau `Confirm`.
* Card yang sebelumnya dipilih tetap terlihat sebagai konteks.

Background tidak dapat digunakan untuk mengganti pilihan secara langsung.

---

# 16. Cancel Confirmation

Jika Player memilih:

**CANCEL**

maka:

Confirmation Panel
↓
Panel ditutup
↓
Kembali ke Upgrade Property UI
↓
Card kembali ke Normal State

Tidak ada perubahan:

* Balance
* Property Level
* Property Ownership

Player masih dapat memilih upgrade lain yang tersedia.

---

# 17. Cancel Upgrade UI

Jika Player menekan `CANCEL` pada Upgrade Property UI utama:

```text
Upgrade UI
↓
CANCEL
↓
UI ditutup
↓
Tidak ada Upgrade
↓
Turn selesai
```

Player tidak dapat membuka kembali Upgrade UI pada Turn yang sama.

---

# 18. Confirm Upgrade

Saat Player menekan `CONFIRM`, sistem melakukan **Final Validation** sebelum transaksi.

Final Validation memastikan:

* Property masih dimiliki Player.
* Target Level masih valid.
* Balance masih mencukupi.
* Upgrade masih valid berdasarkan progression.

Jika seluruh validasi berhasil:

```text
CONFIRM
↓
Final Validation
↓
Deduct Upgrade Cost
↓
Upgrade Property
```

---

# 19. Transaction Timing

Memilih Card **bukan transaksi**.

Balance hanya berubah setelah Player menekan:

**CONFIRM**

Contoh:

```text
Balance awal:
85,000 Rels

Player memilih L3:
85,000 Rels

Player Confirm:
-30,000 Rels

Balance akhir:
55,000 Rels
```

---

# 20. UI Close Setelah Confirm

Setelah Upgrade berhasil dikonfirmasi:

**Upgrade UI langsung ditutup sebelum Property Animation dimulai.**

Tidak ada Success Panel yang menahan Player.

Flow:

```text
Confirm
↓
Final Validation
↓
Deduct Rels
↓
Upgrade Property
↓
UI Close
↓
Property Animation
↓
Upgrade Feedback
↓
Turn selesai
```

---

# 21. Property Upgrade Animation

Upgrade menggunakan **Direct Transformation**.

Property melakukan transformasi langsung dari model Current Level ke model Target Level.

Contoh:

```text
L1 Property
↓
Direct Transformation
↓
L3 Property
```

Jika Player memilih L1 → L3, Property langsung bertransformasi ke visual L3.

Tidak perlu melewati visual L2 terlebih dahulu.

Animation tidak menggunakan construction sequence panjang atau cinematic building process.

Tujuan:

* Upgrade terasa cepat.
* Upgrade terasa responsif.
* Player langsung melihat hasil keputusan.
* Turn tidak terasa lambat.

---

# 22. Ownership Visual Saat Upgrade

Upgrade tidak mengubah ownership layer.

Tetap mempertahankan:

* Ownership Frame
* Player Emblem
* Roblox Player Name
* Player Color

Yang berubah:

* Property Level
* Property Artwork
* Rent Billboard

Contoh:

```text
BEFORE

Player Name
Ownership Frame
Level 2 Property
Rent Billboard


AFTER

Player Name       ← tetap
Ownership Frame   ← tetap
Level 3 Property  ← berubah
Rent Billboard    ← update
```

---

# 23. Rent Billboard

Setelah Property berhasil Upgrade:

**Rent Billboard diperbarui** sesuai level Property yang baru.

Rent tidak ditampilkan di Upgrade UI.

---

# 24. Upgrade Success Feedback

Setelah Direct Transformation selesai, Player mendapatkan feedback singkat bahwa Upgrade berhasil.

Contoh:

```text
✦ UPGRADE COMPLETE ✦

MAPLE ROW
LEVEL 3

-30,000 Rels
```

Feedback bersifat ringan.

Tidak membuka panel baru yang membutuhkan tindakan Player.

---

# 25. Level 5

Jika Property sudah berada di **L5**:

* Tidak ada Upgrade UI.
* Tidak ada Upgrade Card.
* Tidak ada Upgrade interaction.

Flow:

```text
Player mendarat
↓
Property milik Player
↓
Current Level = L5
↓
Tidak ada Upgrade UI
↓
Turn selesai
```

Tidak perlu menampilkan `MAX LEVEL` sebagai UI tambahan.

---

# 26. Final Upgrade Flow

```text
Player Movement
↓
Landing Resolution
↓
Player mendarat di Property miliknya
↓
Cek Upgrade Eligibility
↓
Property dapat di-upgrade?
├── NO → Turn selesai
│
└── YES
      ↓
Upgrade Property UI
      ↓
Property Header
      ↓
Current Level
      ↓
Available Upgrades
      ↓
Player Hover
      ↓
Visual Emphasis
      ↓
Player Click Card
      ↓
Card Selected
      ↓
Confirmation Panel
      ↓
Modal Lock
      ↓
       ┌─────────────┐
       │             │
    CANCEL         CONFIRM
       │             │
       ↓             ↓
Return UI      Final Validation
                     ↓
               Deduct Rels
                     ↓
               Upgrade Property
                     ↓
                  UI Close
                     ↓
            Direct Transformation
                     ↓
              Billboard Update
                     ↓
             Upgrade Feedback
                     ↓
                Turn selesai
```

---

# 27. Final Design Principles

Upgrade Property UI mengikuti prinsip:

* **Automatic**
* **Clean**
* **Formal**
* **Property-focused**
* **Visual progression**
* **Clear transaction**
* **No hidden economy information**
* **No Rent duplication**
* **No accidental purchase**
* **Consistent with Buy Property UI**
* **Consistent with Ownership Visual System**

---

## 🔒 STATUS

**Upgrade Property UI — LOCKED**

Seluruh keputusan utama telah ditetapkan:

* Trigger
* Timing
* Upgrade progression
* Property Header
* Current Level
* Level Cards
* Preview Level berikutnya
* Card layout
* Card interaction
* Hover
* Selected
* Disabled
* Balance
* Confirmation
* Modal Lock
* Cancel
* Final Validation
* Transaction
* Direct Transformation
* Ownership preservation
* Billboard update
* Success feedback
* L5 behavior
* Turn completion

```
```
