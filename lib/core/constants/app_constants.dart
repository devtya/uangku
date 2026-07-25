/// Konstanta domain yang dipakai lintas fitur.
class UtangStatus {
  const UtangStatus._();

  static const belumLunas = 'belum_lunas';
  static const lunas = 'lunas';
}

/// Nama kategori pengeluaran khusus untuk pencatatan pembayaran cicilan utang.
/// Selalu dipastikan ada di KategoriTable saat startup (lihat injection.dart).
const kKategoriCicilanUtang = 'Cicilan/Utang';
