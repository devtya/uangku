import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/core/settings/theme_cubit.dart';
import 'package:uangku/core/sync/sync_service.dart';
import 'package:uangku/core/update/update_service.dart';
import 'package:uangku/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:uangku/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uangku/features/auth/domain/repositories/auth_repository.dart';
import 'package:uangku/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:uangku/features/auth/domain/usecases/sign_out.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/gaji/data/datasources/gaji_local_datasource.dart';
import 'package:uangku/features/gaji/data/repositories/gaji_repository_impl.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';
import 'package:uangku/features/gaji/domain/usecases/add_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/delete_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/update_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/watch_all_gaji.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_bloc.dart';
import 'package:uangku/features/pengeluaran/data/datasources/kategori_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/repositories/kategori_repository_impl.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/add_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/delete_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/update_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/data/datasources/pengeluaran_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/repositories/pengeluaran_repository_impl.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/add_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/delete_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/update_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_all_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import 'package:uangku/features/utang/data/datasources/utang_local_datasource.dart';
import 'package:uangku/features/utang/data/repositories/utang_repository_impl.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/features/utang/domain/usecases/add_utang.dart';
import 'package:uangku/features/utang/domain/usecases/bayar_cicilan_utang.dart';
import 'package:uangku/features/utang/domain/usecases/watch_cicilan_by_utang.dart';
import 'package:uangku/features/utang/domain/usecases/delete_utang.dart';
import 'package:uangku/features/utang/domain/usecases/update_utang.dart';
import 'package:uangku/features/utang/domain/usecases/watch_all_utang.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_bloc.dart';
import 'package:uangku/features/recurring/data/datasources/recurring_local_datasource.dart';
import 'package:uangku/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:uangku/features/recurring/domain/usecases/add_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/delete_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/generate_due_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/update_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/watch_recurring.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => SyncService(sl(), sl(), sl()));
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => UpdateService());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(firebaseAuth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
    ),
  );

  sl.registerLazySingleton(() => GajiLocalDataSource(sl()));

  sl.registerLazySingleton<GajiRepository>(
    () => GajiRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => WatchAllGaji(sl()));
  sl.registerLazySingleton(() => AddGaji(sl()));
  sl.registerLazySingleton(() => UpdateGaji(sl()));
  sl.registerLazySingleton(() => DeleteGaji(sl()));

  sl.registerFactory(
    () => GajiBloc(
      watchAllGaji: sl(),
      addGaji: sl(),
      updateGaji: sl(),
      deleteGaji: sl(),
    ),
  );

  sl.registerLazySingleton(() => KategoriLocalDataSource(sl()));

  sl.registerLazySingleton<KategoriRepository>(
    () => KategoriRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => WatchKategoriPengeluaran(sl()));
  sl.registerLazySingleton(() => AddKategori(sl()));
  sl.registerLazySingleton(() => UpdateKategori(sl()));
  sl.registerLazySingleton(() => DeleteKategori(sl()));

  sl.registerLazySingleton(() => PengeluaranLocalDataSource(sl()));

  sl.registerLazySingleton<PengeluaranRepository>(
    () => PengeluaranRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => WatchAllPengeluaran(sl()));
  sl.registerLazySingleton(() => AddPengeluaran(sl()));
  sl.registerLazySingleton(() => UpdatePengeluaran(sl()));
  sl.registerLazySingleton(() => DeletePengeluaran(sl()));

  sl.registerFactory(
    () => PengeluaranBloc(
      watchAllPengeluaran: sl(),
      addPengeluaran: sl(),
      updatePengeluaran: sl(),
      deletePengeluaran: sl(),
    ),
  );

  sl.registerLazySingleton(() => UtangLocalDataSource(sl()));

  sl.registerLazySingleton<UtangRepository>(
    () => UtangRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => WatchAllUtang(sl()));
  sl.registerLazySingleton(() => AddUtang(sl()));
  sl.registerLazySingleton(() => UpdateUtang(sl()));
  sl.registerLazySingleton(() => DeleteUtang(sl()));

  // Orkestrasi lintas-fitur: inject Utang + Pengeluaran + Kategori repository.
  sl.registerLazySingleton(() => BayarCicilanUtang(sl(), sl(), sl()));
  sl.registerLazySingleton(() => WatchCicilanByUtang(sl()));

  sl.registerFactory(
    () => UtangBloc(
      watchAllUtang: sl(),
      addUtang: sl(),
      updateUtang: sl(),
      deleteUtang: sl(),
      bayarCicilanUtang: sl(),
    ),
  );

  sl.registerLazySingleton(() => RecurringLocalDataSource(sl()));
  sl.registerLazySingleton<RecurringRepository>(
    () => RecurringRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => WatchRecurring(sl()));
  sl.registerLazySingleton(() => AddRecurring(sl()));
  sl.registerLazySingleton(() => UpdateRecurring(sl()));
  sl.registerLazySingleton(() => DeleteRecurring(sl()));
  sl.registerLazySingleton(() => GenerateDueRecurring(sl(), sl(), sl()));

  // Seed kategori default (jalan sekali kalau tabel masih kosong)...
  await sl<KategoriLocalDataSource>().seedDefaultsIfEmpty();
  // ...lalu pastikan kategori sistem 'Cicilan/Utang' selalu ada (idempotent),
  // termasuk untuk instalasi lama yang tabelnya sudah terisi.
  await sl<KategoriLocalDataSource>().ensureKategori(kKategoriCicilanUtang);

  // Muat preferensi tema tersimpan sebelum app dibangun.
  await sl<ThemeCubit>().load();

  // Generate transaksi berulang yang terlewat (catch-up saat app dibuka).
  try {
    await sl<GenerateDueRecurring>()();
  } catch (_) {}
}
