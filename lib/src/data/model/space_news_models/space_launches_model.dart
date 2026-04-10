// // To parse this JSON data, do
// //
// //     final spaceLaunchesModel = spaceLaunchesModelFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
// import 'package:intl/intl.dart';
//
// SpaceLaunchesModel spaceLaunchesModelFromJson(String str) => SpaceLaunchesModel.fromJson(json.decode(str));
//
// String spaceLaunchesModelToJson(SpaceLaunchesModel data) => json.encode(data.toJson());
//
// class SpaceLaunchesModel {
//   int? count;
//   String? next;
//   dynamic previous;
//   List<Result>? results;
//
//   SpaceLaunchesModel({
//     this.count,
//     this.next,
//     this.previous,
//     this.results,
//   });
//
//   SpaceLaunchesModel copyWith({
//     int? count,
//     String? next,
//     dynamic previous,
//     List<Result>? results,
//   }) =>
//       SpaceLaunchesModel(
//         count: count ?? this.count,
//         next: next ?? this.next,
//         previous: previous ?? this.previous,
//         results: results ?? this.results,
//       );
//
//   factory SpaceLaunchesModel.fromJson(Map<String, dynamic> json) => SpaceLaunchesModel(
//     count: json["count"],
//     next: json["next"],
//     previous: json["previous"],
//     results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "next": next,
//     "previous": previous,
//     "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
//   };
// }
//
// class Result implements SpaceContent{
//   String? id;
//   String? url;
//   String? name;
//   AgencyResponseMode? responseMode;
//   String? slug;
//   String? launchDesignator;
//   Status? status;
//   DateTime? lastUpdated;
//   DateTime? net;
//   dynamic netPrecision;
//   DateTime? windowEnd;
//   DateTime? windowStart;
//   Image? image;
//   dynamic infographic;
//   dynamic probability;
//   dynamic weatherConcerns;
//   String? failreason;
//   dynamic hashtag;
//   LaunchServiceProvider? launchServiceProvider;
//   Rocket? rocket;
//   Mission? mission;
//   Pad? pad;
//   bool? webcastLive;
//   List<dynamic>? program;
//   int? orbitalLaunchAttemptCount;
//   int? locationLaunchAttemptCount;
//   int? padLaunchAttemptCount;
//   int? agencyLaunchAttemptCount;
//   int? orbitalLaunchAttemptCountYear;
//   int? locationLaunchAttemptCountYear;
//   int? padLaunchAttemptCountYear;
//   int? agencyLaunchAttemptCountYear;
//
//   Result({
//     this.id,
//     this.url,
//     this.name,
//     this.responseMode,
//     this.slug,
//     this.launchDesignator,
//     this.status,
//     this.lastUpdated,
//     this.net,
//     this.netPrecision,
//     this.windowEnd,
//     this.windowStart,
//     this.image,
//     this.infographic,
//     this.probability,
//     this.weatherConcerns,
//     this.failreason,
//     this.hashtag,
//     this.launchServiceProvider,
//     this.rocket,
//     this.mission,
//     this.pad,
//     this.webcastLive,
//     this.program,
//     this.orbitalLaunchAttemptCount,
//     this.locationLaunchAttemptCount,
//     this.padLaunchAttemptCount,
//     this.agencyLaunchAttemptCount,
//     this.orbitalLaunchAttemptCountYear,
//     this.locationLaunchAttemptCountYear,
//     this.padLaunchAttemptCountYear,
//     this.agencyLaunchAttemptCountYear,
//   });
//
//   Result copyWith({
//     String? id,
//     String? url,
//     String? name,
//     AgencyResponseMode? responseMode,
//     String? slug,
//     String? launchDesignator,
//     Status? status,
//     DateTime? lastUpdated,
//     DateTime? net,
//     dynamic netPrecision,
//     DateTime? windowEnd,
//     DateTime? windowStart,
//     Image? image,
//     dynamic infographic,
//     dynamic probability,
//     dynamic weatherConcerns,
//     String? failreason,
//     dynamic hashtag,
//     LaunchServiceProvider? launchServiceProvider,
//     Rocket? rocket,
//     Mission? mission,
//     Pad? pad,
//     bool? webcastLive,
//     List<dynamic>? program,
//     int? orbitalLaunchAttemptCount,
//     int? locationLaunchAttemptCount,
//     int? padLaunchAttemptCount,
//     int? agencyLaunchAttemptCount,
//     int? orbitalLaunchAttemptCountYear,
//     int? locationLaunchAttemptCountYear,
//     int? padLaunchAttemptCountYear,
//     int? agencyLaunchAttemptCountYear,
//   }) =>
//       Result(
//         id: id ?? this.id,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         responseMode: responseMode ?? this.responseMode,
//         slug: slug ?? this.slug,
//         launchDesignator: launchDesignator ?? this.launchDesignator,
//         status: status ?? this.status,
//         lastUpdated: lastUpdated ?? this.lastUpdated,
//         net: net ?? this.net,
//         netPrecision: netPrecision ?? this.netPrecision,
//         windowEnd: windowEnd ?? this.windowEnd,
//         windowStart: windowStart ?? this.windowStart,
//         image: image ?? this.image,
//         infographic: infographic ?? this.infographic,
//         probability: probability ?? this.probability,
//         weatherConcerns: weatherConcerns ?? this.weatherConcerns,
//         failreason: failreason ?? this.failreason,
//         hashtag: hashtag ?? this.hashtag,
//         launchServiceProvider: launchServiceProvider ?? this.launchServiceProvider,
//         rocket: rocket ?? this.rocket,
//         mission: mission ?? this.mission,
//         pad: pad ?? this.pad,
//         webcastLive: webcastLive ?? this.webcastLive,
//         program: program ?? this.program,
//         orbitalLaunchAttemptCount: orbitalLaunchAttemptCount ?? this.orbitalLaunchAttemptCount,
//         locationLaunchAttemptCount: locationLaunchAttemptCount ?? this.locationLaunchAttemptCount,
//         padLaunchAttemptCount: padLaunchAttemptCount ?? this.padLaunchAttemptCount,
//         agencyLaunchAttemptCount: agencyLaunchAttemptCount ?? this.agencyLaunchAttemptCount,
//         orbitalLaunchAttemptCountYear: orbitalLaunchAttemptCountYear ?? this.orbitalLaunchAttemptCountYear,
//         locationLaunchAttemptCountYear: locationLaunchAttemptCountYear ?? this.locationLaunchAttemptCountYear,
//         padLaunchAttemptCountYear: padLaunchAttemptCountYear ?? this.padLaunchAttemptCountYear,
//         agencyLaunchAttemptCountYear: agencyLaunchAttemptCountYear ?? this.agencyLaunchAttemptCountYear,
//       );
//
//   // giving values to getters of the interface
//   @override
//   String get idValue => id ?? ""; // int ko string banaya
//
//   @override
//   String get titleValue => name ?? "Unknown Launch";
//
//   @override
//   String get imageUrlValue => image?.imageUrl ?? "";
//
//   @override
//   String get newsSiteValue => launchServiceProvider?.name?.name ?? "Unknown Source"; // second name because enum values are accessed using name // Pehla .name: LaunchServiceProvider object ke andar ka enum uthata hai
// // Doosra .name: Us enum ki string value nikalta hai (e.g., "US_NAVY")
//
//   @override
//   String get summaryValue => mission?.description ?? "No mission description available.";
//
//   @override
//   DateTime get publishedAtDate => net ?? DateTime.now();
//
//   @override
//   DateTime get updatedAtDate => lastUpdated ?? DateTime.now();
//
//   @override
//   String get typeValue => "launches"; // News/Blog ke liye type 'article'
//
//   @override
//   String get formattedDate => DateFormat.yMMMd().format(publishedAtDate ?? DateTime.now());
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     id: json["id"],
//     url: json["url"],
//     name: json["name"],
//     responseMode: json["response_mode"] == null ? null :agencyResponseModeValues.map[json["response_mode"]],
//     slug: json["slug"],
//     launchDesignator: json["launch_designator"],
//     status: json["status"] == null ? null : Status.fromJson(json["status"]),
//     lastUpdated: json["last_updated"] == null ? null : DateTime.parse(json["last_updated"]),
//     net: json["net"] == null ? null : DateTime.parse(json["net"]),
//     netPrecision: json["net_precision"],
//     windowEnd: json["window_end"] == null ? null : DateTime.parse(json["window_end"]),
//     windowStart: json["window_start"] == null ? null : DateTime.parse(json["window_start"]),
//     image: json["image"] == null ? null : Image.fromJson(json["image"]),
//     infographic: json["infographic"],
//     probability: json["probability"],
//     weatherConcerns: json["weather_concerns"],
//     failreason: json["failreason"],
//     hashtag: json["hashtag"],
//     launchServiceProvider: json["launch_service_provider"] == null ? null : LaunchServiceProvider.fromJson(json["launch_service_provider"]),
//     rocket: json["rocket"] == null ? null : Rocket.fromJson(json["rocket"]),
//     mission: json["mission"] == null ? null : Mission.fromJson(json["mission"]),
//     pad: json["pad"] == null ? null : Pad.fromJson(json["pad"]),
//     webcastLive: json["webcast_live"],
//     program: json["program"] == null ? [] : List<dynamic>.from(json["program"]!.map((x) => x)),
//     orbitalLaunchAttemptCount: json["orbital_launch_attempt_count"],
//     locationLaunchAttemptCount: json["location_launch_attempt_count"],
//     padLaunchAttemptCount: json["pad_launch_attempt_count"],
//     agencyLaunchAttemptCount: json["agency_launch_attempt_count"],
//     orbitalLaunchAttemptCountYear: json["orbital_launch_attempt_count_year"],
//     locationLaunchAttemptCountYear: json["location_launch_attempt_count_year"],
//     padLaunchAttemptCountYear: json["pad_launch_attempt_count_year"],
//     agencyLaunchAttemptCountYear: json["agency_launch_attempt_count_year"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "url": url,
//     "name": name,
//     "response_mode": agencyResponseModeValues.reverse[responseMode],
//     "slug": slug,
//     "launch_designator": launchDesignator,
//     "status": status?.toJson(),
//     "last_updated": lastUpdated?.toIso8601String(),
//     "net": net?.toIso8601String(),
//     "net_precision": netPrecision,
//     "window_end": windowEnd?.toIso8601String(),
//     "window_start": windowStart?.toIso8601String(),
//     "image": image?.toJson(),
//     "infographic": infographic,
//     "probability": probability,
//     "weather_concerns": weatherConcerns,
//     "failreason": failreason,
//     "hashtag": hashtag,
//     "launch_service_provider": launchServiceProvider?.toJson(),
//     "rocket": rocket?.toJson(),
//     "mission": mission?.toJson(),
//     "pad": pad?.toJson(),
//     "webcast_live": webcastLive,
//     "program": program == null ? [] : List<dynamic>.from(program!.map((x) => x)),
//     "orbital_launch_attempt_count": orbitalLaunchAttemptCount,
//     "location_launch_attempt_count": locationLaunchAttemptCount,
//     "pad_launch_attempt_count": padLaunchAttemptCount,
//     "agency_launch_attempt_count": agencyLaunchAttemptCount,
//     "orbital_launch_attempt_count_year": orbitalLaunchAttemptCountYear,
//     "location_launch_attempt_count_year": locationLaunchAttemptCountYear,
//     "pad_launch_attempt_count_year": padLaunchAttemptCountYear,
//     "agency_launch_attempt_count_year": agencyLaunchAttemptCountYear,
//   };
// }
//
// class Image {
//   int? id;
//   String? name;
//   String? imageUrl;
//   String? thumbnailUrl;
//   Credit? credit;
//   License? license;
//   bool? singleUse;
//   List<dynamic>? variants;
//
//   Image({
//     this.id,
//     this.name,
//     this.imageUrl,
//     this.thumbnailUrl,
//     this.credit,
//     this.license,
//     this.singleUse,
//     this.variants,
//   });
//
//   Image copyWith({
//     int? id,
//     String? name,
//     String? imageUrl,
//     String? thumbnailUrl,
//     Credit? credit,
//     License? license,
//     bool? singleUse,
//     List<dynamic>? variants,
//   }) =>
//       Image(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         imageUrl: imageUrl ?? this.imageUrl,
//         thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
//         credit: credit ?? this.credit,
//         license: license ?? this.license,
//         singleUse: singleUse ?? this.singleUse,
//         variants: variants ?? this.variants,
//       );
//
//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//     id: json["id"],
//     name: json["name"],
//     imageUrl: json["image_url"],
//     thumbnailUrl: json["thumbnail_url"],
//     credit: json["credit"] == null ? null :creditValues.map[json["credit"]],
//     license: json["license"] == null ? null : License.fromJson(json["license"]),
//     singleUse: json["single_use"],
//     variants: json["variants"] == null ? [] : List<dynamic>.from(json["variants"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "image_url": imageUrl,
//     "thumbnail_url": thumbnailUrl,
//     "credit": creditValues.reverse[credit],
//     "license": license?.toJson(),
//     "single_use": singleUse,
//     "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
//   };
// }
//
// enum Credit {
//   NASA,
//   NASA_BILL_INGALLS
// }
//
// final creditValues = EnumValues({
//   "NASA": Credit.NASA,
//   "NASA/Bill Ingalls": Credit.NASA_BILL_INGALLS
// });
//
// class License {
//   int? id;
//   LicenseName? name;
//   int? priority;
//   String? link;
//
//   License({
//     this.id,
//     this.name,
//     this.priority,
//     this.link,
//   });
//
//   License copyWith({
//     int? id,
//     LicenseName? name,
//     int? priority,
//     String? link,
//   }) =>
//       License(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         priority: priority ?? this.priority,
//         link: link ?? this.link,
//       );
//
//   factory License.fromJson(Map<String, dynamic> json) => License(
//     id: json["id"],
//     name: json["name"] == null ? null :licenseNameValues.map[json["name"]],
//     priority: json["priority"],
//     link: json["link"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": licenseNameValues.reverse[name],
//     "priority": priority,
//     "link": link,
//   };
// }
//
// enum LicenseName {
//   NASA_IMAGE_AND_MEDIA_GUIDELINES,
//   UNKNOWN
// }
//
// final licenseNameValues = EnumValues({
//   "NASA Image and Media Guidelines": LicenseName.NASA_IMAGE_AND_MEDIA_GUIDELINES,
//   "Unknown": LicenseName.UNKNOWN
// });
//
// class LaunchServiceProvider {
//   LaunchServiceProviderResponseMode? responseMode;
//   int? id;
//   String? url;
//   LaunchServiceProviderName? name;
//   LaunchServiceProviderAbbrev? abbrev;
//   TypeClass? type;
//
//   LaunchServiceProvider({
//     this.responseMode,
//     this.id,
//     this.url,
//     this.name,
//     this.abbrev,
//     this.type,
//   });
//
//   LaunchServiceProvider copyWith({
//     LaunchServiceProviderResponseMode? responseMode,
//     int? id,
//     String? url,
//     LaunchServiceProviderName? name,
//     LaunchServiceProviderAbbrev? abbrev,
//     TypeClass? type,
//   }) =>
//       LaunchServiceProvider(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         abbrev: abbrev ?? this.abbrev,
//         type: type ?? this.type,
//       );
//
//   factory LaunchServiceProvider.fromJson(Map<String, dynamic> json) => LaunchServiceProvider(
//     responseMode: json["response_mode"]== null ? null : launchServiceProviderResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     url: json["url"],
//     name: json["name"]== null ? null :launchServiceProviderNameValues.map[json["name"]],
//     abbrev: json["abbrev"] == null ? null : launchServiceProviderAbbrevValues.map[json["abbrev"]],
//     type: json["type"] == null ? null : TypeClass.fromJson(json["type"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": launchServiceProviderResponseModeValues.reverse[responseMode],
//     "id": id,
//     "url": url,
//     "name": launchServiceProviderNameValues.reverse[name],
//     "abbrev": launchServiceProviderAbbrevValues.reverse[abbrev],
//     "type": type?.toJson(),
//   };
// }
//
// enum LaunchServiceProviderAbbrev {
//   ABMA,
//   CCCP,
//   USN
// }
//
// final launchServiceProviderAbbrevValues = EnumValues({
//   "ABMA": LaunchServiceProviderAbbrev.ABMA,
//   "CCCP": LaunchServiceProviderAbbrev.CCCP,
//   "USN": LaunchServiceProviderAbbrev.USN
// });
//
// enum LaunchServiceProviderName {
//   ARMY_BALLISTIC_MISSILE_AGENCY,
//   SOVIET_SPACE_PROGRAM,
//   US_NAVY
// }
//
// final launchServiceProviderNameValues = EnumValues({
//   "Army Ballistic Missile Agency": LaunchServiceProviderName.ARMY_BALLISTIC_MISSILE_AGENCY,
//   "Soviet Space Program": LaunchServiceProviderName.SOVIET_SPACE_PROGRAM,
//   "US Navy": LaunchServiceProviderName.US_NAVY
// });
//
// enum LaunchServiceProviderResponseMode {
//   LIST
// }
//
// final launchServiceProviderResponseModeValues = EnumValues({
//   "list": LaunchServiceProviderResponseMode.LIST
// });
//
// class TypeClass {
//   int? id;
//   TypeName? name;
//
//   TypeClass({
//     this.id,
//     this.name,
//   });
//
//   TypeClass copyWith({
//     int? id,
//     TypeName? name,
//   }) =>
//       TypeClass(
//         id: id ?? this.id,
//         name: name ?? this.name,
//       );
//
//   factory TypeClass.fromJson(Map<String, dynamic> json) => TypeClass(
//     id: json["id"],
//     name: json["name"] == null ? null : typeNameValues.map[json["name"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": typeNameValues.reverse[name],
//   };
// }
//
// enum TypeName {
//   GOVERNMENT,
//   PLANET
// }
//
// final typeNameValues = EnumValues({
//   "Government": TypeName.GOVERNMENT,
//   "Planet": TypeName.PLANET
// });
//
// class Mission {
//   int? id;
//   String? name;
//   TypeEnum? type;
//   String? description;
//   dynamic image;
//   Status? orbit;
//   List<dynamic>? agencies;
//   List<dynamic>? infoUrls;
//   List<dynamic>? vidUrls;
//
//   Mission({
//     this.id,
//     this.name,
//     this.type,
//     this.description,
//     this.image,
//     this.orbit,
//     this.agencies,
//     this.infoUrls,
//     this.vidUrls,
//   });
//
//   Mission copyWith({
//     int? id,
//     String? name,
//     TypeEnum? type,
//     String? description,
//     dynamic image,
//     Status? orbit,
//     List<dynamic>? agencies,
//     List<dynamic>? infoUrls,
//     List<dynamic>? vidUrls,
//   }) =>
//       Mission(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         type: type ?? this.type,
//         description: description ?? this.description,
//         image: image ?? this.image,
//         orbit: orbit ?? this.orbit,
//         agencies: agencies ?? this.agencies,
//         infoUrls: infoUrls ?? this.infoUrls,
//         vidUrls: vidUrls ?? this.vidUrls,
//       );
//
//   factory Mission.fromJson(Map<String, dynamic> json) => Mission(
//     id: json["id"],
//     name: json["name"],
//     type: typeEnumValues.map[json["type"]]!,
//     description: json["description"],
//     image: json["image"],
//     orbit: json["orbit"] == null ? null : Status.fromJson(json["orbit"]),
//     agencies: json["agencies"] == null ? [] : List<dynamic>.from(json["agencies"]!.map((x) => x)),
//     infoUrls: json["info_urls"] == null ? [] : List<dynamic>.from(json["info_urls"]!.map((x) => x)),
//     vidUrls: json["vid_urls"] == null ? [] : List<dynamic>.from(json["vid_urls"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "type": typeEnumValues.reverse[type],
//     "description": description,
//     "image": image,
//     "orbit": orbit?.toJson(),
//     "agencies": agencies == null ? [] : List<dynamic>.from(agencies!.map((x) => x)),
//     "info_urls": infoUrls == null ? [] : List<dynamic>.from(infoUrls!.map((x) => x)),
//     "vid_urls": vidUrls == null ? [] : List<dynamic>.from(vidUrls!.map((x) => x)),
//   };
// }
//
// class Status {
//   int? id;
//   StatusName? name;
//   StatusAbbrev? abbrev;
//   CelestialBodyElement? celestialBody;
//   String? description;
//
//   Status({
//     this.id,
//     this.name,
//     this.abbrev,
//     this.celestialBody,
//     this.description,
//   });
//
//   Status copyWith({
//     int? id,
//     StatusName? name,
//     StatusAbbrev? abbrev,
//     CelestialBodyElement? celestialBody,
//     String? description,
//   }) =>
//       Status(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         abbrev: abbrev ?? this.abbrev,
//         celestialBody: celestialBody ?? this.celestialBody,
//         description: description ?? this.description,
//       );
//
//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//     id: json["id"],
//     name: json["name"] == null ? null : statusNameValues.map[json["name"]],
//     abbrev: json["abbrev"] == null ? null : statusAbbrevValues.map[json["abbrev"]],
//     celestialBody: json["celestial_body"] == null ? null : CelestialBodyElement.fromJson(json["celestial_body"]),
//     description: json["description"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": statusNameValues.reverse[name],
//     "abbrev": statusAbbrevValues.reverse[abbrev],
//     "celestial_body": celestialBody?.toJson(),
//     "description": description,
//   };
// }
//
// enum StatusAbbrev {
//   ELLIPTICAL,
//   FAILURE,
//   LEO,
//   SUCCESS
// }
//
// final statusAbbrevValues = EnumValues({
//   "Elliptical": StatusAbbrev.ELLIPTICAL,
//   "Failure": StatusAbbrev.FAILURE,
//   "LEO": StatusAbbrev.LEO,
//   "Success": StatusAbbrev.SUCCESS
// });
//
// class CelestialBodyElement {
//   LaunchServiceProviderResponseMode? responseMode;
//   int? id;
//   CelestialBodyName? name;
//
//   CelestialBodyElement({
//     this.responseMode,
//     this.id,
//     this.name,
//   });
//
//   CelestialBodyElement copyWith({
//     LaunchServiceProviderResponseMode? responseMode,
//     int? id,
//     CelestialBodyName? name,
//   }) =>
//       CelestialBodyElement(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         name: name ?? this.name,
//       );
//
//   factory CelestialBodyElement.fromJson(Map<String, dynamic> json) => CelestialBodyElement(
//     responseMode: json["response_mode"] == null ? null : launchServiceProviderResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     name: json["name"] == null ? null : celestialBodyNameValues.map[json["name"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": launchServiceProviderResponseModeValues.reverse[responseMode],
//     "id": id,
//     "name": celestialBodyNameValues.reverse[name],
//   };
// }
//
// enum CelestialBodyName {
//   EARTH,
//   REDSTONE,
//   SPUTNIK
// }
//
// final celestialBodyNameValues = EnumValues({
//   "Earth": CelestialBodyName.EARTH,
//   "Redstone": CelestialBodyName.REDSTONE,
//   "Sputnik": CelestialBodyName.SPUTNIK
// });
//
// enum StatusName {
//   ELLIPTICAL_ORBIT,
//   LAUNCH_FAILURE,
//   LAUNCH_SUCCESSFUL,
//   LOW_EARTH_ORBIT
// }
//
// final statusNameValues = EnumValues({
//   "Elliptical Orbit": StatusName.ELLIPTICAL_ORBIT,
//   "Launch Failure": StatusName.LAUNCH_FAILURE,
//   "Launch Successful": StatusName.LAUNCH_SUCCESSFUL,
//   "Low Earth Orbit": StatusName.LOW_EARTH_ORBIT
// });
//
// enum TypeEnum {
//   EARTH_SCIENCE,
//   TEST_FLIGHT
// }
//
// final typeEnumValues = EnumValues({
//   "Earth Science": TypeEnum.EARTH_SCIENCE,
//   "Test Flight": TypeEnum.TEST_FLIGHT
// });
//
// class Pad {
//   int? id;
//   String? url;
//   bool? active;
//   List<Agency>? agencies;
//   PadName? name;
//   dynamic image;
//   dynamic description;
//   dynamic infoUrl;
//   String? wikiUrl;
//   String? mapUrl;
//   double? latitude;
//   double? longitude;
//   Country? country;
//   String? mapImage;
//   int? totalLaunchCount;
//   int? orbitalLaunchAttemptCount;
//   FastestTurnaround? fastestTurnaround;
//   Location? location;
//
//   Pad({
//     this.id,
//     this.url,
//     this.active,
//     this.agencies,
//     this.name,
//     this.image,
//     this.description,
//     this.infoUrl,
//     this.wikiUrl,
//     this.mapUrl,
//     this.latitude,
//     this.longitude,
//     this.country,
//     this.mapImage,
//     this.totalLaunchCount,
//     this.orbitalLaunchAttemptCount,
//     this.fastestTurnaround,
//     this.location,
//   });
//
//   Pad copyWith({
//     int? id,
//     String? url,
//     bool? active,
//     List<Agency>? agencies,
//     PadName? name,
//     dynamic image,
//     dynamic description,
//     dynamic infoUrl,
//     String? wikiUrl,
//     String? mapUrl,
//     double? latitude,
//     double? longitude,
//     Country? country,
//     String? mapImage,
//     int? totalLaunchCount,
//     int? orbitalLaunchAttemptCount,
//     FastestTurnaround? fastestTurnaround,
//     Location? location,
//   }) =>
//       Pad(
//         id: id ?? this.id,
//         url: url ?? this.url,
//         active: active ?? this.active,
//         agencies: agencies ?? this.agencies,
//         name: name ?? this.name,
//         image: image ?? this.image,
//         description: description ?? this.description,
//         infoUrl: infoUrl ?? this.infoUrl,
//         wikiUrl: wikiUrl ?? this.wikiUrl,
//         mapUrl: mapUrl ?? this.mapUrl,
//         latitude: latitude ?? this.latitude,
//         longitude: longitude ?? this.longitude,
//         country: country ?? this.country,
//         mapImage: mapImage ?? this.mapImage,
//         totalLaunchCount: totalLaunchCount ?? this.totalLaunchCount,
//         orbitalLaunchAttemptCount: orbitalLaunchAttemptCount ?? this.orbitalLaunchAttemptCount,
//         fastestTurnaround: fastestTurnaround ?? this.fastestTurnaround,
//         location: location ?? this.location,
//       );
//
//   factory Pad.fromJson(Map<String, dynamic> json) => Pad(
//     id: json["id"],
//     url: json["url"],
//     active: json["active"],
//     agencies: json["agencies"] == null ? [] : List<Agency>.from(json["agencies"]!.map((x) => Agency.fromJson(x))),
//     name: json["name"] == null ? null :padNameValues.map[json["name"]],
//     image: json["image"],
//     description: json["description"],
//     infoUrl: json["info_url"],
//     wikiUrl: json["wiki_url"],
//     mapUrl: json["map_url"],
//     latitude: json["latitude"]?.toDouble(),
//     longitude: json["longitude"]?.toDouble(),
//     country: json["country"] == null ? null : Country.fromJson(json["country"]),
//     mapImage: json["map_image"],
//     totalLaunchCount: json["total_launch_count"],
//     orbitalLaunchAttemptCount: json["orbital_launch_attempt_count"],
//     fastestTurnaround: json["fastest_turnaround"] == null ? null : fastestTurnaroundValues.map[json["fastest_turnaround"]],
//     location: json["location"] == null ? null : Location.fromJson(json["location"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "url": url,
//     "active": active,
//     "agencies": agencies == null ? [] : List<dynamic>.from(agencies!.map((x) => x.toJson())),
//     "name": padNameValues.reverse[name],
//     "image": image,
//     "description": description,
//     "info_url": infoUrl,
//     "wiki_url": wikiUrl,
//     "map_url": mapUrl,
//     "latitude": latitude,
//     "longitude": longitude,
//     "country": country?.toJson(),
//     "map_image": mapImage,
//     "total_launch_count": totalLaunchCount,
//     "orbital_launch_attempt_count": orbitalLaunchAttemptCount,
//     "fastest_turnaround": fastestTurnaroundValues.reverse[fastestTurnaround],
//     "location": location?.toJson(),
//   };
// }
//
// class Agency {
//   AgencyResponseMode? responseMode;
//   int? id;
//   String? url;
//   String? name;
//   String? abbrev;
//   TypeClass? type;
//   bool? featured;
//   List<Country>? country;
//   String? description;
//   String? administrator;
//   int? foundingYear;
//   String? launchers;
//   String? spacecraft;
//   dynamic parent;
//   dynamic image;
//   Image? logo;
//   Image? socialLogo;
//
//   Agency({
//     this.responseMode,
//     this.id,
//     this.url,
//     this.name,
//     this.abbrev,
//     this.type,
//     this.featured,
//     this.country,
//     this.description,
//     this.administrator,
//     this.foundingYear,
//     this.launchers,
//     this.spacecraft,
//     this.parent,
//     this.image,
//     this.logo,
//     this.socialLogo,
//   });
//
//   Agency copyWith({
//     AgencyResponseMode? responseMode,
//     int? id,
//     String? url,
//     String? name,
//     String? abbrev,
//     TypeClass? type,
//     bool? featured,
//     List<Country>? country,
//     String? description,
//     String? administrator,
//     int? foundingYear,
//     String? launchers,
//     String? spacecraft,
//     dynamic parent,
//     dynamic image,
//     Image? logo,
//     Image? socialLogo,
//   }) =>
//       Agency(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         abbrev: abbrev ?? this.abbrev,
//         type: type ?? this.type,
//         featured: featured ?? this.featured,
//         country: country ?? this.country,
//         description: description ?? this.description,
//         administrator: administrator ?? this.administrator,
//         foundingYear: foundingYear ?? this.foundingYear,
//         launchers: launchers ?? this.launchers,
//         spacecraft: spacecraft ?? this.spacecraft,
//         parent: parent ?? this.parent,
//         image: image ?? this.image,
//         logo: logo ?? this.logo,
//         socialLogo: socialLogo ?? this.socialLogo,
//       );
//
//   factory Agency.fromJson(Map<String, dynamic> json) => Agency(
//     responseMode: json["response_mode"] == null ? null : agencyResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     url: json["url"],
//     name: json["name"],
//     abbrev: json["abbrev"],
//     type: json["type"] == null ? null : TypeClass.fromJson(json["type"]),
//     featured: json["featured"],
//     country: json["country"] == null ? [] : List<Country>.from(json["country"]!.map((x) => Country.fromJson(x))),
//     description: json["description"],
//     administrator: json["administrator"],
//     foundingYear: json["founding_year"],
//     launchers: json["launchers"],
//     spacecraft: json["spacecraft"],
//     parent: json["parent"],
//     image: json["image"],
//     logo: json["logo"] == null ? null : Image.fromJson(json["logo"]),
//     socialLogo: json["social_logo"] == null ? null : Image.fromJson(json["social_logo"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": agencyResponseModeValues.reverse[responseMode],
//     "id": id,
//     "url": url,
//     "name": name,
//     "abbrev": abbrev,
//     "type": type?.toJson(),
//     "featured": featured,
//     "country": country == null ? [] : List<dynamic>.from(country!.map((x) => x.toJson())),
//     "description": description,
//     "administrator": administrator,
//     "founding_year": foundingYear,
//     "launchers": launchers,
//     "spacecraft": spacecraft,
//     "parent": parent,
//     "image": image,
//     "logo": logo?.toJson(),
//     "social_logo": socialLogo?.toJson(),
//   };
// }
//
// class Country {
//   int? id;
//   CountryName? name;
//   Alpha2Code? alpha2Code;
//   Alpha3Code? alpha3Code;
//   NationalityName? nationalityName;
//   NationalityNameComposed? nationalityNameComposed;
//
//   Country({
//     this.id,
//     this.name,
//     this.alpha2Code,
//     this.alpha3Code,
//     this.nationalityName,
//     this.nationalityNameComposed,
//   });
//
//   Country copyWith({
//     int? id,
//     CountryName? name,
//     Alpha2Code? alpha2Code,
//     Alpha3Code? alpha3Code,
//     NationalityName? nationalityName,
//     NationalityNameComposed? nationalityNameComposed,
//   }) =>
//       Country(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         alpha2Code: alpha2Code ?? this.alpha2Code,
//         alpha3Code: alpha3Code ?? this.alpha3Code,
//         nationalityName: nationalityName ?? this.nationalityName,
//         nationalityNameComposed: nationalityNameComposed ?? this.nationalityNameComposed,
//       );
//
//   factory Country.fromJson(Map<String, dynamic> json) => Country(
//     id: json["id"],
//     name: json["name"] == null ? null : countryNameValues.map[json["name"]],
//     alpha2Code: json["alpha_2_code"]== null ? null : alpha2CodeValues.map[json["alpha_2_code"]],
//     alpha3Code: json["alpha_3_code"] == null ? null : alpha3CodeValues.map[json["alpha_3_code"]],
//     nationalityName: json["nationality_name"] == null ? null : nationalityNameValues.map[json["nationality_name"]],
//     nationalityNameComposed: json["nationality_name_composed"] == null ? null : nationalityNameComposedValues.map[json["nationality_name_composed"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": countryNameValues.reverse[name],
//     "alpha_2_code": alpha2CodeValues.reverse[alpha2Code],
//     "alpha_3_code": alpha3CodeValues.reverse[alpha3Code],
//     "nationality_name": nationalityNameValues.reverse[nationalityName],
//     "nationality_name_composed": nationalityNameComposedValues.reverse[nationalityNameComposed],
//   };
// }
//
// enum Alpha2Code {
//   KZ,
//   US
// }
//
// final alpha2CodeValues = EnumValues({
//   "KZ": Alpha2Code.KZ,
//   "US": Alpha2Code.US
// });
//
// enum Alpha3Code {
//   KAZ,
//   USA
// }
//
// final alpha3CodeValues = EnumValues({
//   "KAZ": Alpha3Code.KAZ,
//   "USA": Alpha3Code.USA
// });
//
// enum CountryName {
//   KAZAKHSTAN,
//   UNITED_STATES_OF_AMERICA
// }
//
// final countryNameValues = EnumValues({
//   "Kazakhstan": CountryName.KAZAKHSTAN,
//   "United States of America": CountryName.UNITED_STATES_OF_AMERICA
// });
//
// enum NationalityName {
//   AMERICAN,
//   KAZAKH
// }
//
// final nationalityNameValues = EnumValues({
//   "American": NationalityName.AMERICAN,
//   "Kazakh": NationalityName.KAZAKH
// });
//
// enum NationalityNameComposed {
//   AMERICANO,
//   KAZAKHSTANI
// }
//
// final nationalityNameComposedValues = EnumValues({
//   "Americano": NationalityNameComposed.AMERICANO,
//   "Kazakhstani": NationalityNameComposed.KAZAKHSTANI
// });
//
// enum AgencyResponseMode {
//   NORMAL
// }
//
// final agencyResponseModeValues = EnumValues({
//   "normal": AgencyResponseMode.NORMAL
// });
//
// enum FastestTurnaround {
//   P10_DT2_H1_M6_S,
//   P20_DT23_H10_M4_S,
//   PT23_H32_M33_S
// }
//
// final fastestTurnaroundValues = EnumValues({
//   "P10DT2H1M6S": FastestTurnaround.P10_DT2_H1_M6_S,
//   "P20DT23H10M4S": FastestTurnaround.P20_DT23_H10_M4_S,
//   "PT23H32M33S": FastestTurnaround.PT23_H32_M33_S
// });
//
// class Location {
//   AgencyResponseMode? responseMode;
//   int? id;
//   String? url;
//   LocationName? name;
//   LocationCelestialBody? celestialBody;
//   bool? active;
//   Country? country;
//   String? description;
//   Image? image;
//   String? mapImage;
//   double? longitude;
//   double? latitude;
//   TimezoneName? timezoneName;
//   int? totalLaunchCount;
//   int? totalLandingCount;
//
//   Location({
//     this.responseMode,
//     this.id,
//     this.url,
//     this.name,
//     this.celestialBody,
//     this.active,
//     this.country,
//     this.description,
//     this.image,
//     this.mapImage,
//     this.longitude,
//     this.latitude,
//     this.timezoneName,
//     this.totalLaunchCount,
//     this.totalLandingCount,
//   });
//
//   Location copyWith({
//     AgencyResponseMode? responseMode,
//     int? id,
//     String? url,
//     LocationName? name,
//     LocationCelestialBody? celestialBody,
//     bool? active,
//     Country? country,
//     String? description,
//     Image? image,
//     String? mapImage,
//     double? longitude,
//     double? latitude,
//     TimezoneName? timezoneName,
//     int? totalLaunchCount,
//     int? totalLandingCount,
//   }) =>
//       Location(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         celestialBody: celestialBody ?? this.celestialBody,
//         active: active ?? this.active,
//         country: country ?? this.country,
//         description: description ?? this.description,
//         image: image ?? this.image,
//         mapImage: mapImage ?? this.mapImage,
//         longitude: longitude ?? this.longitude,
//         latitude: latitude ?? this.latitude,
//         timezoneName: timezoneName ?? this.timezoneName,
//         totalLaunchCount: totalLaunchCount ?? this.totalLaunchCount,
//         totalLandingCount: totalLandingCount ?? this.totalLandingCount,
//       );
//
//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//     responseMode: json["response_mode"] == null ? null : agencyResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     url: json["url"],
//     name: locationNameValues.map[json["name"]]!,
//     celestialBody: json["celestial_body"] == null ? null : LocationCelestialBody.fromJson(json["celestial_body"]),
//     active: json["active"],
//     country: json["country"] == null ? null : Country.fromJson(json["country"]),
//     description: json["description"],
//     image: json["image"] == null ? null : Image.fromJson(json["image"]),
//     mapImage: json["map_image"],
//     longitude: json["longitude"]?.toDouble(),
//     latitude: json["latitude"]?.toDouble(),
//     timezoneName: json["timezone_name"] == null ? null : timezoneNameValues.map[json["timezone_name"]],
//     totalLaunchCount: json["total_launch_count"],
//     totalLandingCount: json["total_landing_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": agencyResponseModeValues.reverse[responseMode],
//     "id": id,
//     "url": url,
//     "name": locationNameValues.reverse[name],
//     "celestial_body": celestialBody?.toJson(),
//     "active": active,
//     "country": country?.toJson(),
//     "description": description,
//     "image": image?.toJson(),
//     "map_image": mapImage,
//     "longitude": longitude,
//     "latitude": latitude,
//     "timezone_name": timezoneNameValues.reverse[timezoneName],
//     "total_launch_count": totalLaunchCount,
//     "total_landing_count": totalLandingCount,
//   };
// }
//
// class LocationCelestialBody {
//   AgencyResponseMode? responseMode;
//   int? id;
//   CelestialBodyName? name;
//   TypeClass? type;
//   int? diameter;
//   double? mass;
//   double? gravity;
//   LengthOfDay? lengthOfDay;
//   bool? atmosphere;
//   Image? image;
//   String? description;
//   String? wikiUrl;
//   int? totalAttemptedLaunches;
//   int? successfulLaunches;
//   int? failedLaunches;
//   int? totalAttemptedLandings;
//   int? successfulLandings;
//   int? failedLandings;
//
//   LocationCelestialBody({
//     this.responseMode,
//     this.id,
//     this.name,
//     this.type,
//     this.diameter,
//     this.mass,
//     this.gravity,
//     this.lengthOfDay,
//     this.atmosphere,
//     this.image,
//     this.description,
//     this.wikiUrl,
//     this.totalAttemptedLaunches,
//     this.successfulLaunches,
//     this.failedLaunches,
//     this.totalAttemptedLandings,
//     this.successfulLandings,
//     this.failedLandings,
//   });
//
//   LocationCelestialBody copyWith({
//     AgencyResponseMode? responseMode,
//     int? id,
//     CelestialBodyName? name,
//     TypeClass? type,
//     int? diameter,
//     double? mass,
//     double? gravity,
//     LengthOfDay? lengthOfDay,
//     bool? atmosphere,
//     Image? image,
//     String? description,
//     String? wikiUrl,
//     int? totalAttemptedLaunches,
//     int? successfulLaunches,
//     int? failedLaunches,
//     int? totalAttemptedLandings,
//     int? successfulLandings,
//     int? failedLandings,
//   }) =>
//       LocationCelestialBody(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         name: name ?? this.name,
//         type: type ?? this.type,
//         diameter: diameter ?? this.diameter,
//         mass: mass ?? this.mass,
//         gravity: gravity ?? this.gravity,
//         lengthOfDay: lengthOfDay ?? this.lengthOfDay,
//         atmosphere: atmosphere ?? this.atmosphere,
//         image: image ?? this.image,
//         description: description ?? this.description,
//         wikiUrl: wikiUrl ?? this.wikiUrl,
//         totalAttemptedLaunches: totalAttemptedLaunches ?? this.totalAttemptedLaunches,
//         successfulLaunches: successfulLaunches ?? this.successfulLaunches,
//         failedLaunches: failedLaunches ?? this.failedLaunches,
//         totalAttemptedLandings: totalAttemptedLandings ?? this.totalAttemptedLandings,
//         successfulLandings: successfulLandings ?? this.successfulLandings,
//         failedLandings: failedLandings ?? this.failedLandings,
//       );
//
//   factory LocationCelestialBody.fromJson(Map<String, dynamic> json) => LocationCelestialBody(
//     responseMode: json["response_mode"] == null ? null : agencyResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     name: json["name"] == null ? null :celestialBodyNameValues.map[json["name"]],
//     type: json["type"] == null ? null : TypeClass.fromJson(json["type"]),
//     diameter: json["diameter"],
//     mass: json["mass"]?.toDouble(),
//     gravity: json["gravity"]?.toDouble(),
//     lengthOfDay: json["length_of_day"] == null ? null :lengthOfDayValues.map[json["length_of_day"]],
//     atmosphere: json["atmosphere"],
//     image: json["image"] == null ? null : Image.fromJson(json["image"]),
//     description: json["description"],
//     wikiUrl: json["wiki_url"],
//     totalAttemptedLaunches: json["total_attempted_launches"],
//     successfulLaunches: json["successful_launches"],
//     failedLaunches: json["failed_launches"],
//     totalAttemptedLandings: json["total_attempted_landings"],
//     successfulLandings: json["successful_landings"],
//     failedLandings: json["failed_landings"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": agencyResponseModeValues.reverse[responseMode],
//     "id": id,
//     "name": celestialBodyNameValues.reverse[name],
//     "type": type?.toJson(),
//     "diameter": diameter,
//     "mass": mass,
//     "gravity": gravity,
//     "length_of_day": lengthOfDayValues.reverse[lengthOfDay],
//     "atmosphere": atmosphere,
//     "image": image?.toJson(),
//     "description": description,
//     "wiki_url": wikiUrl,
//     "total_attempted_launches": totalAttemptedLaunches,
//     "successful_launches": successfulLaunches,
//     "failed_launches": failedLaunches,
//     "total_attempted_landings": totalAttemptedLandings,
//     "successful_landings": successfulLandings,
//     "failed_landings": failedLandings,
//   };
// }
//
// enum LengthOfDay {
//   THE_1000000
// }
//
// final lengthOfDayValues = EnumValues({
//   "1 00:00:00": LengthOfDay.THE_1000000
// });
//
// enum LocationName {
//   BAIKONUR_COSMODROME_REPUBLIC_OF_KAZAKHSTAN,
//   CAPE_CANAVERAL_SFS_FL_USA
// }
//
// final locationNameValues = EnumValues({
//   "Baikonur Cosmodrome, Republic of Kazakhstan": LocationName.BAIKONUR_COSMODROME_REPUBLIC_OF_KAZAKHSTAN,
//   "Cape Canaveral SFS, FL, USA": LocationName.CAPE_CANAVERAL_SFS_FL_USA
// });
//
// enum TimezoneName {
//   AMERICA_NEW_YORK,
//   ASIA_QYZYLORDA
// }
//
// final timezoneNameValues = EnumValues({
//   "America/New_York": TimezoneName.AMERICA_NEW_YORK,
//   "Asia/Qyzylorda": TimezoneName.ASIA_QYZYLORDA
// });
//
// enum PadName {
//   LAUNCH_COMPLEX_18_A,
//   LAUNCH_COMPLEX_26_A,
//   THE_15
// }
//
// final padNameValues = EnumValues({
//   "Launch Complex 18A": PadName.LAUNCH_COMPLEX_18_A,
//   "Launch Complex 26A": PadName.LAUNCH_COMPLEX_26_A,
//   "1/5": PadName.THE_15
// });
//
// class Rocket {
//   int? id;
//   Configuration? configuration;
//
//   Rocket({
//     this.id,
//     this.configuration,
//   });
//
//   Rocket copyWith({
//     int? id,
//     Configuration? configuration,
//   }) =>
//       Rocket(
//         id: id ?? this.id,
//         configuration: configuration ?? this.configuration,
//       );
//
//   factory Rocket.fromJson(Map<String, dynamic> json) => Rocket(
//     id: json["id"],
//     configuration: json["configuration"] == null ? null : Configuration.fromJson(json["configuration"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "configuration": configuration?.toJson(),
//   };
// }
//
// class Configuration {
//   LaunchServiceProviderResponseMode? responseMode;
//   int? id;
//   String? url;
//   String? name;
//   List<CelestialBodyElement>? families;
//   String? fullName;
//   String? variant;
//
//   Configuration({
//     this.responseMode,
//     this.id,
//     this.url,
//     this.name,
//     this.families,
//     this.fullName,
//     this.variant,
//   });
//
//   Configuration copyWith({
//     LaunchServiceProviderResponseMode? responseMode,
//     int? id,
//     String? url,
//     String? name,
//     List<CelestialBodyElement>? families,
//     String? fullName,
//     String? variant,
//   }) =>
//       Configuration(
//         responseMode: responseMode ?? this.responseMode,
//         id: id ?? this.id,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         families: families ?? this.families,
//         fullName: fullName ?? this.fullName,
//         variant: variant ?? this.variant,
//       );
//
//   factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
//     responseMode: json["response_mode"] == null ? null : launchServiceProviderResponseModeValues.map[json["response_mode"]],
//     id: json["id"],
//     url: json["url"],
//     name: json["name"],
//     families: json["families"] == null ? [] : List<CelestialBodyElement>.from(json["families"]!.map((x) => CelestialBodyElement.fromJson(x))),
//     fullName: json["full_name"],
//     variant: json["variant"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "response_mode": launchServiceProviderResponseModeValues.reverse[responseMode],
//     "id": id,
//     "url": url,
//     "name": name,
//     "families": families == null ? [] : List<dynamic>.from(families!.map((x) => x.toJson())),
//     "full_name": fullName,
//     "variant": variant,
//   };
// }
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }


import 'dart:convert';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:intl/intl.dart';

SpaceLaunchesModel spaceLaunchesModelFromJson(String str) => SpaceLaunchesModel.fromJson(json.decode(str));

String spaceLaunchesModelToJson(SpaceLaunchesModel data) => json.encode(data.toJson());

class SpaceLaunchesModel {
  int? count;
  String? next;
  dynamic previous;
  List<Result>? results;

  SpaceLaunchesModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory SpaceLaunchesModel.fromJson(Map<String, dynamic> json) => SpaceLaunchesModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null
        ? []
        : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result implements SpaceContent {
  String? id;
  String? url;
  String? name;
  AgencyResponseMode? responseMode;
  String? slug;
  String? launchDesignator;
  Status? status;
  DateTime? lastUpdated;
  DateTime? net;
  dynamic netPrecision;
  DateTime? windowEnd;
  DateTime? windowStart;
  Image? image;
  dynamic infographic;
  dynamic probability;
  dynamic weatherConcerns;
  String? failreason;
  dynamic hashtag;
  LaunchServiceProvider? launchServiceProvider;
  Rocket? rocket;
  Mission? mission;
  Pad? pad;
  bool? webcastLive;
  List<dynamic>? program;

  Result({
    this.id,
    this.url,
    this.name,
    this.responseMode,
    this.slug,
    this.launchDesignator,
    this.status,
    this.lastUpdated,
    this.net,
    this.netPrecision,
    this.windowEnd,
    this.windowStart,
    this.image,
    this.infographic,
    this.probability,
    this.weatherConcerns,
    this.failreason,
    this.hashtag,
    this.launchServiceProvider,
    this.rocket,
    this.mission,
    this.pad,
    this.webcastLive,
    this.program,
  });

  @override
  String get idValue => id ?? "";

  @override
  String get titleValue => name ?? "Unknown Launch";

  @override
  String get imageUrlValue => image?.imageUrl ?? "";

  @override
  String get newsSiteValue => launchServiceProvider?.name?.name ?? "Unknown Source";

  @override
  String get summaryValue => mission?.description ?? "No mission description available.";

  @override
  DateTime get publishedAtDate => net ?? DateTime.now();

  @override
  DateTime get updatedAtDate => lastUpdated ?? DateTime.now();

  @override
  String get typeValue => "launches";

  @override
  String get formattedDate => DateFormat.yMMMd().format(publishedAtDate);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"]?.toString(),
    url: json["url"],
    name: json["name"],
    responseMode: json["response_mode"] == null ? null : agencyResponseModeValues.map[json["response_mode"]],
    slug: json["slug"],
    launchDesignator: json["launch_designator"],
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    lastUpdated: json["last_updated"] == null ? null : DateTime.tryParse(json["last_updated"]),
    net: json["net"] == null ? null : DateTime.tryParse(json["net"]),
    netPrecision: json["net_precision"],
    windowEnd: json["window_end"] == null ? null : DateTime.tryParse(json["window_end"]),
    windowStart: json["window_start"] == null ? null : DateTime.tryParse(json["window_start"]),
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    infographic: json["infographic"],
    probability: json["probability"],
    weatherConcerns: json["weather_concerns"],
    failreason: json["failreason"],
    hashtag: json["hashtag"],
    launchServiceProvider: json["launch_service_provider"] == null ? null : LaunchServiceProvider.fromJson(json["launch_service_provider"]),
    rocket: json["rocket"] == null ? null : Rocket.fromJson(json["rocket"]),
    mission: json["mission"] == null ? null : Mission.fromJson(json["mission"]),
    pad: json["pad"] == null ? null : Pad.fromJson(json["pad"]),
    webcastLive: json["webcast_live"],
    program: json["program"] == null ? [] : List<dynamic>.from(json["program"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "response_mode": agencyResponseModeValues.reverse[responseMode],
    "slug": slug,
    "status": status?.toJson(),
    "last_updated": lastUpdated?.toIso8601String(),
    "net": net?.toIso8601String(),
    "image": image?.toJson(),
    "launch_service_provider": launchServiceProvider?.toJson(),
    "rocket": rocket?.toJson(),
    "mission": mission?.toJson(),
    "pad": pad?.toJson(),
  };
}

class Image {
  int? id;
  String? name;
  String? imageUrl;
  String? thumbnailUrl;
  Credit? credit;
  License? license;

  Image({this.id, this.name, this.imageUrl, this.thumbnailUrl, this.credit, this.license});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    thumbnailUrl: json["thumbnail_url"],
    credit: json["credit"] == null ? null : creditValues.map[json["credit"]],
    license: json["license"] == null ? null : License.fromJson(json["license"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_url": imageUrl,
    "credit": creditValues.reverse[credit],
  };
}

enum Credit { NASA, NASA_BILL_INGALLS }
final creditValues = EnumValues({
  "NASA": Credit.NASA,
  "NASA/Bill Ingalls": Credit.NASA_BILL_INGALLS
});

class License {
  int? id;
  LicenseName? name;
  String? link;

  License({this.id, this.name, this.link});

  factory License.fromJson(Map<String, dynamic> json) => License(
    id: json["id"],
    name: json["name"] == null ? null : licenseNameValues.map[json["name"]],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": licenseNameValues.reverse[name],
  };
}

enum LicenseName { NASA_IMAGE_AND_MEDIA_GUIDELINES, UNKNOWN }
final licenseNameValues = EnumValues({
  "NASA Image and Media Guidelines": LicenseName.NASA_IMAGE_AND_MEDIA_GUIDELINES,
  "Unknown": LicenseName.UNKNOWN
});

class LaunchServiceProvider {
  int? id;
  String? url;
  LaunchServiceProviderName? name;
  LaunchServiceProviderAbbrev? abbrev;

  LaunchServiceProvider({this.id, this.url, this.name, this.abbrev});

  factory LaunchServiceProvider.fromJson(Map<String, dynamic> json) => LaunchServiceProvider(
    id: json["id"],
    url: json["url"],
    name: json["name"] == null ? null : launchServiceProviderNameValues.map[json["name"]],
    abbrev: json["abbrev"] == null ? null : launchServiceProviderAbbrevValues.map[json["abbrev"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": launchServiceProviderNameValues.reverse[name],
  };
}

enum LaunchServiceProviderAbbrev { ABMA, CCCP, USN }
final launchServiceProviderAbbrevValues = EnumValues({
  "ABMA": LaunchServiceProviderAbbrev.ABMA,
  "CCCP": LaunchServiceProviderAbbrev.CCCP,
  "USN": LaunchServiceProviderAbbrev.USN
});

enum LaunchServiceProviderName { ARMY_BALLISTIC_MISSILE_AGENCY, SOVIET_SPACE_PROGRAM, US_NAVY }
final launchServiceProviderNameValues = EnumValues({
  "Army Ballistic Missile Agency": LaunchServiceProviderName.ARMY_BALLISTIC_MISSILE_AGENCY,
  "Soviet Space Program": LaunchServiceProviderName.SOVIET_SPACE_PROGRAM,
  "US Navy": LaunchServiceProviderName.US_NAVY
});

class Mission {
  int? id;
  String? name;
  String? description;

  Mission({this.id, this.name, this.description});

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "description": description};
}

class Status {
  int? id;
  StatusName? name;
  StatusAbbrev? abbrev;

  Status({this.id, this.name, this.abbrev});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    name: json["name"] == null ? null : statusNameValues.map[json["name"]],
    abbrev: json["abbrev"] == null ? null : statusAbbrevValues.map[json["abbrev"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": statusNameValues.reverse[name],
  };
}

enum StatusAbbrev { ELLIPTICAL, FAILURE, LEO, SUCCESS }
final statusAbbrevValues = EnumValues({
  "Elliptical": StatusAbbrev.ELLIPTICAL,
  "Failure": StatusAbbrev.FAILURE,
  "LEO": StatusAbbrev.LEO,
  "Success": StatusAbbrev.SUCCESS
});

enum StatusName { ELLIPTICAL_ORBIT, LAUNCH_FAILURE, LAUNCH_SUCCESSFUL, LOW_EARTH_ORBIT }
final statusNameValues = EnumValues({
  "Elliptical Orbit": StatusName.ELLIPTICAL_ORBIT,
  "Launch Failure": StatusName.LAUNCH_FAILURE,
  "Launch Successful": StatusName.LAUNCH_SUCCESSFUL,
  "Low Earth Orbit": StatusName.LOW_EARTH_ORBIT
});

class Pad {
  int? id;
  PadName? name;
  Location? location;

  Pad({this.id, this.name, this.location});

  factory Pad.fromJson(Map<String, dynamic> json) => Pad(
    id: json["id"],
    name: json["name"] == null ? null : padNameValues.map[json["name"]],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": padNameValues.reverse[name],
    "location": location?.toJson(),
  };
}

enum PadName { LAUNCH_COMPLEX_18_A, LAUNCH_COMPLEX_26_A, THE_15 }
final padNameValues = EnumValues({
  "Launch Complex 18A": PadName.LAUNCH_COMPLEX_18_A,
  "Launch Complex 26A": PadName.LAUNCH_COMPLEX_26_A,
  "1/5": PadName.THE_15
});

class Location {
  int? id;
  LocationName? name;

  Location({this.id, this.name});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    name: json["name"] == null ? null : locationNameValues.map[json["name"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": locationNameValues.reverse[name],
  };
}

enum LocationName { BAIKONUR_COSMODROME_REPUBLIC_OF_KAZAKHSTAN, CAPE_CANAVERAL_SFS_FL_USA }
final locationNameValues = EnumValues({
  "Baikonur Cosmodrome, Republic of Kazakhstan": LocationName.BAIKONUR_COSMODROME_REPUBLIC_OF_KAZAKHSTAN,
  "Cape Canaveral SFS, FL, USA": LocationName.CAPE_CANAVERAL_SFS_FL_USA
});

enum AgencyResponseMode { NORMAL }
final agencyResponseModeValues = EnumValues({"normal": AgencyResponseMode.NORMAL});

class Rocket {
  int? id;
  Rocket({this.id});
  factory Rocket.fromJson(Map<String, dynamic> json) => Rocket(id: json["id"]);
  Map<String, dynamic> toJson() => {"id": id};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}