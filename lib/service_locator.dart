import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_local_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_remote_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/repo/photo_repository_impl.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/repo/photo_repository.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/usecases/get_photos.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/presentation/providers/photo_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final sl = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final http.Client client = http.Client();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => client);

  //! Data sources
  sl.registerLazySingleton<PhotoLocalDataSource>(
        () => PhotoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<PhotoRemoteDataSource>(
        () => PhotoRemoteDataSourceImpl(client: sl()),
  );

  //! Repositories
  sl.registerLazySingleton<PhotoRepository>(
        () => PhotoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(() => GetPhotosUseCase(sl()));

  //! Providers
  sl.registerFactory(
        () => PhotoProvider(
       getPhotosUseCase: sl(),
    ),
  );
}
