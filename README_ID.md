# Aman-Geh

> **Alat watermark offline sederhana untuk foto dokumen.**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart" />
  <img src="https://img.shields.io/badge/Lisensi-MIT-green" />
  <img src="https://img.shields.io/badge/Privasi-100%25_Offline-brightgreen" />
</p>

## Tentang

**Aman-Geh** membantu menambahkan watermark ke foto dokumen sebelum dibagikan. Aplikasi berjalan sepenuhnya di perangkat, tanpa unggahan, tanpa pelacakan, dan tanpa ketergantungan ke layanan eksternal.

> *"Aman"* berarti **safe** dalam Bahasa Indonesia.

## Fitur

- 📷 **Kamera & Galeri** — Ambil foto baru atau pilih dari perpustakaan Anda
- 🎨 **Watermark Kustom** — Teks, opasitas, ukuran, rotasi, warna, dan pola berulang
- ⚡ **Preview Real-time** — Lihat watermark Anda diterapkan secara instan
- 📤 **Bagikan Hasil** — Bagikan gambar hasil melalui menu berbagi sistem
- 🌙 **Tema Terang & Gelap** — Gunakan mode sistem, terang, atau gelap
- 🌐 **Multi-bahasa** — Bahasa Inggris & Indonesia (Easy Localization)
- 🔒 **100% Offline** — Tidak perlu koneksi internet, selamanya

## Arsitektur

Proyek ini mengikuti pola **MVVM (Model-View-ViewModel)** dengan struktur berbasis fitur:

```
lib/
├── main.dart
├── app_router.dart
├── core/
│   ├── constants/       # Konstanta aplikasi
│   ├── theme/           # Tema Material 3 (terang & gelap)
│   ├── image_engine/    # Rendering watermark (dart:ui Canvas)
│   └── utils/           # Helper file & berbagi
└── features/
    ├── watermarker/
    │   ├── model/       # Kelas data (WatermarkSettings)
    │   ├── data/        # Sumber data & repository
    │   ├── viewmodel/   # Notifier Riverpod (manajemen state)
    │   └── view/        # Layar & widget
    └── settings/
        ├── viewmodel/   # State tema & bahasa
        └── view/        # Layar Pengaturan & Tentang
```

### Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | Flutter & Dart |
| Manajemen State | Riverpod (Notifier) |
| Navigasi | GoRouter |
| Internasionalisasi | Easy Localization |
| Rendering Gambar | dart:ui Canvas API |
| Berbagi | share_plus |

## Memulai

```bash
# Clone repository
git clone <repo-url>
cd aman_geh

# Install dependensi
flutter pub get

# Jalankan aplikasi
flutter run
```

## Privasi

- **Semua pemrosesan gambar dilakukan secara lokal di perangkat**
- **Tidak perlu koneksi internet**
- **Tidak ada pengumpulan data atau telemetri**
- **Tidak ada analytics, tidak ada iklan**
- Gambar diproses di dalam sandbox aplikasi; hasil watermark tidak disimpan ke galeri publik kecuali Anda memilih untuk membagikannya
- Anda yang menentukan apakah hasil akan dibagikan dan ke mana

## Bahasa yang Didukung

| Bahasa | Kode |
|---|---|
| Inggris | `en` |
| Indonesia | `id` |

## Lisensi

Proyek ini dilisensikan di bawah **Lisensi MIT** — lihat file [LICENSE](LICENSE) untuk detail.

---

<p align="center">Dibuat dengan ❤ di Indonesia</p>
