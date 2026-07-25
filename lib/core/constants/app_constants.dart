/// Konstanta domain yang dipakai lintas fitur.
class UtangStatus {
  const UtangStatus._();

  static const belumLunas = 'belum_lunas';
  static const lunas = 'lunas';
}

/// Nama kategori pengeluaran khusus untuk pencatatan pembayaran cicilan utang.
/// Selalu dipastikan ada di KategoriTable saat startup (lihat injection.dart).
const kKategoriCicilanUtang = 'Cicilan/Utang';

/// Jenis utang.
class UtangJenis {
  const UtangJenis._();

  static const bulat = 'bulat'; // bayar bebas, bukan cicilan terjadwal
  static const cicilan = 'cicilan'; // tenor + bunga, jadwal per bulan
}

/// Transaksi berulang.
class RecurringTipe {
  const RecurringTipe._();
  static const pendapatan = 'pendapatan';
  static const pengeluaran = 'pengeluaran';
}

class RecurringFrekuensi {
  const RecurringFrekuensi._();
  static const harian = 'harian';
  static const mingguan = 'mingguan';
  static const bulanan = 'bulanan';
}
