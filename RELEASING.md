# Rilis & In-App Update

Alur: **push tag `vX.Y.Z`** → GitHub Actions build APK release ter-sign → lampirkan ke Release.
Aplikasi cek Release terbaru (Settings → Cek pembaruan), bandingkan versi, unduh & pasang.

## Setup sekali (kamu)

### 1. Buat keystore rilis
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Simpan file `upload-keystore.jks` dan password-nya baik-baik. **Jangan commit** (sudah di-.gitignore).

### 2. Build lokal ber-signature (opsional)
Buat `android/key.properties`:
```
storePassword=<password store>
keyPassword=<password key>
keyAlias=upload
storeFile=<path absolut ke upload-keystore.jks>
```
Tanpa file ini, build lokal otomatis fallback ke debug signing (tetap jalan).

### 3. GitHub Secrets
Repo → Settings → Secrets and variables → Actions → New secret:

| Secret | Isi |
|---|---|
| `KEYSTORE_BASE64` | `base64 -w0 upload-keystore.jks` |
| `STORE_PASSWORD` | password store |
| `KEY_PASSWORD` | password key |
| `KEY_ALIAS` | `upload` |
| `GOOGLE_SERVICES_JSON` | `base64 -w0 android/app/google-services.json` |
| `FIREBASE_OPTIONS_DART` | `base64 -w0 lib/firebase_options.dart` |

(Dua terakhir diperlukan karena config Firebase di-untrack dari repo publik.)

## Merilis versi baru
1. Naikkan `version:` di `pubspec.yaml` (mis. `1.1.0+2`).
2. Commit & push ke `master`.
3. Tag & push:
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```
4. GitHub Actions build + attach `app-release.apk` ke Release `v1.1.0`.
5. Di HP: Settings → **Cek pembaruan** → Perbarui.

> Update sideload hanya menimpa tanpa uninstall bila signature-nya sama.
> Selalu rilis dari keystore yang sama. Versi debug (dari `flutter install`)
> ber-signature berbeda, jadi transisi debug→release pertama kali mungkin
> minta uninstall dulu.
