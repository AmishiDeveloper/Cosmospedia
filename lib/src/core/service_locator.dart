import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/apod_api_service/apod_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/asteroid_api_service/asteroid_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/cme_api_service/cme_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/launch_library_api_service/launch_library_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/space_flight_news_api_service/space_flight_news_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';
import 'package:cosmospedia/src/data/network/dio_factory.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/asteroid_repository/asteroid_repository.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/*
Service Locator is a central place in the app where all important objects (like Dio, API services, repositories, and Cubits)
are created and stored so that the same instance can be reused anywhere in the app.
It helps manage dependencies by :-
controlling how and when objects are created,
avoids creating multiple unnecessary instances, and
removes the need to manually pass objects between classes.
This makes the code cleaner, easier to maintain, and scalable as the app grows.
*/


//GetIt is a global container.It stores objects and gives them anywhere in the app
GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    ///dio client

    //Creates one Dio instance & stores it. Same instance is shared everywhere
    //getIt.registerSingleton(Dio());

    /* 1.getIt<Dio>() → fetches the Dio instance that is just registered and stored in getIt
    2.Passes it(Dio instance) into DioClient
    3️.Registers DioClient as singleton meaning “Create a DioClient instance using THAT SAME Dio instance, store this DioClient instance and reuse it everywhere”
    So dependency chain is:
    Dio  →  DioClient  →  API Service → Repository → Cubit

    getIt.registerSingleton(DioClient(getIt<Dio>()));*/
    // Not used because we have multiple APIs (NASA & SpaceDev)
    // Each API needs its own Dio with different baseUrl that is why both instance creation commented



    /* NASA API
      Register a Dio instance specifically configured for NASA API
    - Created using DioFactory.nasa()
    - Stored with the name 'nasa'
    - This Dio has NASA baseUrl
    - Same instance will be reused everywhere
    */
    getIt.registerSingleton<Dio>(
      DioFactory.nasa(),
      instanceName: 'nasa',
    );

    /* Register DioClient for NASA API
     - getIt<Dio>(instanceName: 'nasa') fetches the NASA Dio instance that is just registered and stored in getIt
     - Passes it(nasa Dio instance) into DioClient that wraps Dio and adds interceptors, timeouts, etc.
     - Stored with name 'nasaClient'
     - Registers nasa DioClient (nasaClient) as singleton meaning “Create a DioClient instance using THAT SAME Dio instance, store this DioClient instance and reuse it everywhere”
       So dependency chain is:
       DioFactory -> creates configured Dio instance (nasa Dio) and service locator stores it  →  nasa DioClient(nasaClient)  →  API Service uses DioCient (nasaClient)→ Repository → Cubit
    */
    getIt.registerSingleton<DioClient>(
      DioClient(getIt<Dio>(instanceName: 'nasa')),
      instanceName: 'nasaClient',
    );

    /*SpaceFlight API
    Register a Dio instance specifically configured for spaceFlightNews API
    - Created using DioFactory.theSpaceFlightNews()
    - Stored with the name 'spaceFlight'
    - This Dio has spaceFlightNews baseUrl
    - Same instance will be reused everywhere
    */
    getIt.registerSingleton<Dio>(
      DioFactory.spaceFlightNewsApi(),
      instanceName: 'spaceFlight',
    );

    /* Register DioClient for spaceFlightNews API
     - getIt<Dio>(instanceName: 'spaceFlight') fetches the space Dio instance that is just registered and stored in getIt
     - Passes it(space Dio instance) into DioClient that wraps Dio and adds interceptors, timeouts, etc.
     - Stored with name 'spaceFlightClient'
     - Registers nasa DioClient (spaceFlightClient) as singleton meaning “Create a DioClient instance using THAT SAME Dio instance, store this DioClient instance and reuse it everywhere”
       So dependency chain is:
       spaceFlightNews Dio  →  space DioClient(spaceFlightClient)  →  API Service → Repository → Cubit
    */
    getIt.registerSingleton<DioClient>(
      DioClient(getIt<Dio>(instanceName: 'spaceFlight')),
      instanceName: 'spaceFlightClient',
    );

    /*SpaceLaunchLibrary2 API
    Register a Dio instance specifically configured for launchLibrary2 API
    - Created using DioFactory.launchLibrary()
    - Stored with the name 'launchLibrary'
    - This Dio has spaceLaunchLibraryBaseUrl baseUrl
    - Same instance will be reused everywhere
    */
    getIt.registerSingleton<Dio>(
      DioFactory.launchLibrary(),
      instanceName: 'launchLibrary',
    );

    /* Register DioClient for launchLibrary2 API
     - getIt<Dio>(instanceName: 'launchLibrary') fetches the launchLibrary Dio instance that is just registered and stored in getIt
     - Passes it(launchLibrary Dio instance) into DioClient that wraps Dio and adds interceptors, timeouts, etc.
     - Stored with name 'launchLibraryClient'
     - Registers nasa DioClient (launchLibraryClient) as singleton meaning “Create a DioClient instance using THAT SAME Dio instance, store this DioClient instance and reuse it everywhere”
       So dependency chain is:
       launchLibrary Dio  →  space DioClient(launchLibraryClient)  →  API Service → Repository → Cubit
    */
    getIt.registerSingleton<DioClient>(
      DioClient(getIt<Dio>(instanceName: 'launchLibrary')),
      instanceName: 'launchLibraryClient',
    );


    ///Api Services

    // Firebase Auth instance
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

    // Firestore instance
    getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

    //apod
    getIt.registerSingleton(ApodApiService(getIt<DioClient>(instanceName: 'nasaClient')));

    //asteroid
    getIt.registerSingleton(AsteroidApiService(getIt<DioClient>(instanceName: 'nasaClient')));

    //cme
    getIt.registerSingleton(CmeApiService(getIt<DioClient>(instanceName: 'nasaClient')));

    //space flight
    getIt.registerSingleton(SpaceFlightNewsApiService(getIt<DioClient>(instanceName: 'spaceFlightClient')));

    //launch library
    getIt.registerSingleton(LaunchLibraryApiService(getIt<DioClient>(instanceName: 'launchLibraryClient')));


    /// Repository

    // Authentication Repository
    getIt.registerSingleton<AuthRepository>(
      AuthRepository(
        auth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    );


    //apod
    getIt.registerSingleton(
        ApodRepository(
          getIt<ApodApiService>(),
        ),
    );

    //asteroid
    getIt.registerSingleton(
        AsteroidRepository(
            getIt<AsteroidApiService>(),
        ),
    );

    //cme
    getIt.registerSingleton(
      CmeRepository(
        getIt<CmeApiService>(),
      ),
    );

    //space news
    getIt.registerSingleton(
        SpaceNewsRepository(
            getIt<SpaceFlightNewsApiService>(),
            getIt<LaunchLibraryApiService>(),
        ),
    );

    ///Cubits

  }
}