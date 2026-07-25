import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';

/// Orkestrasi lintas-fitur: mencatat pembayaran cicilan utang, yang sekaligus
/// membuat entry Pengeluaran. Repository tidak saling memanggil — koordinasi
/// ada di usecase ini yang meng-inject ketiganya.
class BayarCicilanUtang {
  final UtangRepository _utangRepository;
  final PengeluaranRepository _pengeluaranRepository;
  final KategoriRepository _kategoriRepository;

  BayarCicilanUtang(
    this._utangRepository,
    this._pengeluaranRepository,
    this._kategoriRepository,
  );

  Future<Either<Failure, void>> call(
    String utangId,
    double jumlahBayar,
    DateTime tanggal,
  ) async {
    try {
      final utang = await _utangRepository.getUtangById(utangId);
      if (utang == null) {
        return const Left(Failure('Utang tidak ditemukan'));
      }

      final kategoriId =
          await _kategoriRepository.getKategoriIdByNama(kKategoriCicilanUtang);
      if (kategoriId == null) {
        return const Left(Failure('Kategori cicilan tidak ditemukan'));
      }

      // Terbayar baru di-clamp agar tidak melebihi total (status 'lunas'
      // diturunkan otomatis di UtangModel saat update).
      final terbayarBaru =
          (utang.jumlahTerbayar + jumlahBayar).clamp(0.0, utang.jumlahTotal);

      // Langkah 1: update utang.
      final resUtang = await _utangRepository.updateUtang(
        utang.copyWith(jumlahTerbayar: terbayarBaru),
      );
      if (resUtang.isLeft()) return resUtang;

      // Langkah 2: catat pengeluaran. Kalau gagal, kompensasi balik utang
      // (best-effort) agar tidak ada progres utang tanpa catatan pengeluaran.
      final resPengeluaran = await _pengeluaranRepository.addPengeluaran(
        PengeluaranEntity(
          id: const Uuid().v4(),
          jumlah: jumlahBayar,
          kategoriId: kategoriId,
          tanggal: tanggal,
          catatan: 'Cicilan: ${utang.namaUtang}',
          utangId: utangId,
        ),
      );
      if (resPengeluaran.isLeft()) {
        await _utangRepository.updateUtang(utang); // rollback manual
        return resPengeluaran;
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
