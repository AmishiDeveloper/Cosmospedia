import 'package:cosmospedia/src/data/network/data_source/nasa/apod_api_service/apod_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/asteroid_api_service/asteroid_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';
import 'package:cosmospedia/src/data/network/dio_factory.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/asteroid_repository/asteroid_repository.dart';
import 'package:dio/dio.dart';
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

    /*SpaceFlight / TheSpaceDev API
    Register a Dio instance specifically configured for spaceDev API
    - Created using DioFactory.theSpaceDev()
    - Stored with the name 'space'
    - This Dio has space flight baseUrl
    - Same instance will be reused everywhere
    */
    getIt.registerSingleton<Dio>(
      DioFactory.theSpaceDev(),
      instanceName: 'space',
    );

    /* Register DioClient for spaceDev API
     - getIt<Dio>(instanceName: 'space') fetches the space Dio instance that is just registered and stored in getIt
     - Passes it(space Dio instance) into DioClient that wraps Dio and adds interceptors, timeouts, etc.
     - Stored with name 'spaceClient'
     - Registers nasa DioClient (spaceClient) as singleton meaning “Create a DioClient instance using THAT SAME Dio instance, store this DioClient instance and reuse it everywhere”
       So dependency chain is:
       space Dio  →  space DioClient(spaceClient)  →  API Service → Repository → Cubit
    */
    getIt.registerSingleton<DioClient>(
      DioClient(getIt<Dio>(instanceName: 'space')),
      instanceName: 'spaceClient',
    );


    ///Api Services
    getIt.registerSingleton(ApodApiService(getIt<DioClient>(instanceName: 'nasaClient')));
    getIt.registerSingleton(AsteroidApiService(getIt<DioClient>(instanceName: 'nasaClient')));

    /// Repository
    getIt.registerSingleton(ApodRepository(getIt<ApodApiService>()));
    getIt.registerSingleton(AsteroidRepository(getIt<AsteroidApiService>()));

    ///Cubits

  }
}