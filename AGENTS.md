# AGENTS.md — uangku

## Tentang Project

**uangku** adalah aplikasi pencatat keuangan pribadi (Android, Flutter) untuk mencatat:
- **Gaji** (pemasukan)
- **Pengeluaran** (termasuk cicilan/pembayaran utang)
- **Utang** (kewajiban dengan status lunas/belum, jatuh tempo)

Developer adalah solo developer yang mengarahkan AI coding agent lewat prompt terstruktur dengan pola **checkpoint-based**: kerjakan satu langkah kecil, review, baru lanjut. Jangan mengerjakan banyak fitur sekaligus dalam satu sesi tanpa diminta.

## Prinsip Arsitektur (WAJIB DIIKUTI)

### 1. Clean Architecture — Feature First

Setiap fitur di `lib/features/{nama_fitur}/` punya 3 layer:
- `data/` — datasources (local & remote), models, repository implementation
- `domain/` — entities, repository interface (abstract), usecases
- `presentation/` — bloc, pages, widgets

**Aturan dependency:** `presentation` → `domain` ← `data`. Domain layer TIDAK BOLEH import apapun dari `data` atau `presentation`. Domain adalah pure Dart, tidak tahu soal Drift atau Firestore.

**Scope AI agent:** Kalau instruksi bilang "kerjakan fitur X", jangan sentuh file di luar `lib/features/X/` kecuali memang perlu registrasi di `core/di/injection.dart` atau routing. Kalau perlu ubah file di luar scope fitur, sebutkan eksplisit dan minta konfirmasi dulu.

### 2. Offline-First — Drift adalah Source of Truth

Pola yang dipakai (sama seperti project tokodedy milik developer):

- **Semua baca/tulis UI selalu lewat Drift (lokal) dulu.** UI tidak pernah nunggu Firestore.
- Setiap tabel Drift punya kolom `id` (UUID), `updated_at` (timestamp), `is_synced` (bool), `is_deleted` (bool, untuk soft-delete).
- Sync ke Firestore terjadi di background (fire-and-forget), dipicu oleh:
  - Perubahan data lokal (setelah insert/update/delete, trigger sync)
  - Reconnect setelah offline (`connectivity_plus` listener)
- **Konflik resolusi: Last-Write-Wins berdasarkan `updated_at`.**
- Saat pull dari Firestore, bandingkan `updated_at` remote vs lokal — yang lebih baru menang.
- Soft-delete: jangan hard-delete row. Set `is_deleted = true` lalu sync flag itu, biar device lain juga ikut menghapus saat sync.

### 3. Firestore Path Convention

Semua data user disimpan di bawah path ber-UID, TIDAK PERNAH di collection root:

```
users/{uid}/gaji/{docId}
users/{uid}/pengeluaran/{docId}
users/{uid}/utang/{docId}
```

Ini memastikan data terikat ke akun Google dan tetap ada meski aplikasi di-uninstall/reinstall, selama user login dengan akun Google yang sama. `{docId}` harus sama dengan `id` di Drift lokal (dipakai untuk matching saat sync, bukan auto-generate ID dari Firestore).

### 4. State Management — flutter_bloc

- Satu Bloc per fitur utama: `GajiBloc`, `PengeluaranBloc`, `UtangBloc`, `AuthBloc`.
- Event = kata kerja + noun: `AddGajiRequested`, `GajiListRequested`, `DeleteGajiRequested`.
- State pakai sealed pattern: `GajiInitial`, `GajiLoading`, `GajiLoaded(List<GajiEntity>)`, `GajiError(String message)`.
- Bloc TIDAK BOLEH memanggil Drift atau Firestore langsung — selalu lewat usecase → repository.

### 5. Error Handling

Pakai `Either<Failure, T>` dari package `dartz` di layer domain/data. Jangan lempar exception mentah ke presentation layer — repository menangkap exception dari datasource dan mengubahnya jadi `Failure` (lihat `core/error/failures.dart`).

### 6. Auth & Sync Lifecycle

- Login: Google Sign-In → Firebase Auth → dapat `uid` → simpan `uid` di secure storage / provider state.
- Setelah login pertama kali: trigger **initial pull sync** dari Firestore ke Drift lokal (paginated kalau data besar).
- Logout: **jangan hapus data Drift lokal** kecuali user eksplisit minta "hapus data lokal". Cukup clear session/token.
- Ganti akun Google (login akun lain di device yang sama): harus clear Drift lokal dulu sebelum pull data akun baru, supaya data tidak tercampur antar akun.

## Konvensi Penamaan

- File: `snake_case.dart`
- Class: `PascalCase`
- Bahasa UI: **Bahasa Indonesia** (label, pesan error ke user)
- Nama variabel/kode: **Bahasa Inggris** (`gajiEntity`, bukan `entitasGaji`) — kecuali istilah domain yang lebih natural dalam Indonesia (`utang`, `pengeluaran` sebagai nama fitur/entity boleh tetap Indonesia, konsisten dengan penamaan project tokodedy).

## Larangan

- Jangan generate kode yang langsung import Firestore/Drift di widget (harus lewat Bloc → usecase → repository).
- Jangan hardcode kategori pengeluaran/status utang — taruh di `core/constants/app_constants.dart` atau tabel `kategori` di Drift.
- Jangan pernah commit `google-services.json` atau `firebase_options.dart` API key ke repo publik (kalau nanti push ke GitHub, pastikan ini di-.gitignore atau pakai environment config).
- Jangan generate migration Drift yang breaking tanpa menaikkan `schemaVersion` dan menulis migration strategy.

## Checkpoint Workflow

Saat mengerjakan instruksi, ikuti pola ini:
1. Konfirmasi pemahaman scope (fitur apa, file apa yang akan disentuh)
2. Tulis/generate kode
3. Jelaskan singkat apa yang berubah dan kenapa
4. Berhenti dan tunggu review sebelum lanjut ke langkah berikutnya — jangan auto-lanjut ke fitur lain

## Referensi Project Lain (developer)

Developer punya project sejenis (`tokodedy`) dengan pola offline-first + Drift + Supabase yang sudah matang. Kalau ada ambiguitas soal pola sync, konflik resolusi, atau struktur Bloc, pola dari tokodedy adalah referensi yang valid (meski backend-nya beda: Firebase vs Supabase, prinsip offline-first-nya sama).
