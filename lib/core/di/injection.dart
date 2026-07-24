import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uangku/core/database/app_database.dart';
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
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => AppDatabase());

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
  sl.registerLazySingleton(() => DeleteKategori(sl()));

  // Seed kategori default (jalan sekali kalau tabel masih kosong).
  await sl<KategoriLocalDataSource>().seedDefaultsIfEmpty();
}
