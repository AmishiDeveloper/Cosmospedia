class Endpoints{
  static const String nasaBaseUrl = "https://api.nasa.gov/";
  static const String nasaScienceBaseUrl = "https://science.nasa.gov/";//wp-json/wp/v2/apod-basic";
  static const String nasaApiKey = 'C2Di06dBWBfgrxjprDE6NIuYeGFcbUbSWaCkmS4r';
  static const String spaceFlightNewsBaseUrl = "https://api.spaceflightnewsapi.net/v4/";
  static const String spaceLaunchLibraryBaseUrl = "https://ll.thespacedevs.com/2.3.0/";

  // nasa endpoints
  //static String apod = "planetary/apod";
  static String apod = "wp-json/wp/v2/apod-basic";
  static String asteroidFeed = "neo/rest/v1/feed";
  static String asteroidLookup = "neo/rest/v1/neo";
  static String cme = "DONKI/CME";
  static String cmeAnalysis = "DONKI/CMEAnalysis";

 // spacedev endpoints
   static String newsArticles = "articles/";
   static String missions = "blogs/";
   static String events = "events/";
   static String launches = "launches/";
}