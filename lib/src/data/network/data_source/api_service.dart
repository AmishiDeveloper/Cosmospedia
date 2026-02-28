import 'package:cosmospedia/src/data/network/dio_client.dart';
import 'package:flutter/material.dart';

/* ApiService is an abstract base class that cannot be instantiated directly.
It is extended by API classes so they can reuse shared dependencies (like DioClient)
without duplicating code.
*/

/// Base api service
/*ApiService is a BASE / PARENT class
- It is incomplete by design
- It exists only to be extended (inherited)
- Abstract classes cannot be instantiated
- It provides common things that all API classes need.that common thing is:
  final api = getIt<DioClient>();
  So every API class automatically gets access to DioClient.

  PROBLEM-
  However, the key problem here is there are 2 servers :-
  1.nasa
  2.space flight
  from which data will come that means there will be 2 dio client instances
  1. nasa DioClient called nasaClient
  2. space DioClient called spaceClient
  now when nasa apis are hit nasaClient has to be used otherwise spaceClient
  so, how can we declare
  final api = getIt<DioClient>();
  in this ApiService class as this line clearly does not tell-
  1. Which DioClient will this return? which will actually BREAK or pick the
  unnamed one

  SOLUTION-
  so we make a generic ApiService class which will only have a
  DioClient variable that will not be initialized. it will also
  have a parameterized constructor that will initialize the value
  of the DioClient variable.
  But this will be done from the child class that extends the
  ApiService class.
  meaning Each API class chooses its DioClient. they pass te DioClient
  they have to use via their constructors to parent class constructors
  using super keyword.
  Eg-
  class NasaApiService extends ApiService {
  NasaApiService():super(getIt<DioClient>(instanceName: 'nasaClient'));
  }

*/

abstract class ApiService {
  // Dio client object
  // protected so that this variable can be accessed by subclasses (diff api classes)that extend ApiService class
  @protected
  final DioClient api; // object of DioClient class

  ApiService(this.api); // Dio client object (api) will be initialized through child class constructor

}


//getIt<DioClient>() simply fetches the already created DioClient object stored in Service Locator. No new object is created.