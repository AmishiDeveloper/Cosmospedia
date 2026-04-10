// To parse this JSON data, do
//
//     final spaceEventsModel = spaceEventsModelFromJson(jsonString);

import 'dart:convert';

import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:intl/intl.dart';

SpaceEventsModel spaceEventsModelFromJson(String str) => SpaceEventsModel.fromJson(json.decode(str));

String spaceEventsModelToJson(SpaceEventsModel data) => json.encode(data.toJson());

class SpaceEventsModel {
  int? count;
  String? next;
  dynamic previous;
  List<Result>? results;

  SpaceEventsModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  SpaceEventsModel copyWith({
    int? count,
    String? next,
    dynamic previous,
    List<Result>? results,
  }) =>
      SpaceEventsModel(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        results: results ?? this.results,
      );

  factory SpaceEventsModel.fromJson(Map<String, dynamic> json) => SpaceEventsModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result implements SpaceContent{
  int? id;
  String? url;
  String? name;
  List<InfoUrl>? infoUrls;
  List<VidUrl>? vidUrls;
  Image? image;
  DateTime? date;
  String? slug;
  Type? type;
  String? description;
  bool? webcastLive;
  Location? location;
  dynamic datePrecision;
  ResponseMode? responseMode;
  dynamic duration;
  List<dynamic>? updates;
  DateTime? lastUpdated;

  Result({
    this.id,
    this.url,
    this.name,
    this.infoUrls,
    this.vidUrls,
    this.image,
    this.date,
    this.slug,
    this.type,
    this.description,
    this.webcastLive,
    this.location,
    this.datePrecision,
    this.responseMode,
    this.duration,
    this.updates,
    this.lastUpdated,
  });

  Result copyWith({
    int? id,
    String? url,
    String? name,
    List<InfoUrl>? infoUrls,
    List<VidUrl>? vidUrls,
    Image? image,
    DateTime? date,
    String? slug,
    Type? type,
    String? description,
    bool? webcastLive,
    Location? location,
    dynamic datePrecision,
    ResponseMode? responseMode,
    dynamic duration,
    List<dynamic>? updates,
    DateTime? lastUpdated,
  }) =>
      Result(
        id: id ?? this.id,
        url: url ?? this.url,
        name: name ?? this.name,
        infoUrls: infoUrls ?? this.infoUrls,
        vidUrls: vidUrls ?? this.vidUrls,
        image: image ?? this.image,
        date: date ?? this.date,
        slug: slug ?? this.slug,
        type: type ?? this.type,
        description: description ?? this.description,
        webcastLive: webcastLive ?? this.webcastLive,
        location: location ?? this.location,
        datePrecision: datePrecision ?? this.datePrecision,
        responseMode: responseMode ?? this.responseMode,
        duration: duration ?? this.duration,
        updates: updates ?? this.updates,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  // giving values to getters of the interface
  @override
  String get idValue => id?.toString() ?? ""; // int ko string banaya

  @override
  String get titleValue => name ?? "No Title";

  @override
  String get imageUrlValue => image?.imageUrl ?? "";

  @override
  String get newsSiteValue {

    // Pheli priority Credit ko (agar location nahi hai)
    if (infoUrls != null && infoUrls!.isNotEmpty) {
      final String? infoSource = infoUrls![0].source;
      if (infoSource != null && infoSource.isNotEmpty) {
        return infoSource; // Ye aapko "NASA" ya "ESA" jaisa clean naam dega
      }
    }

    // 2. Doosri priority: Video Source ya Publisher
    if (vidUrls != null && vidUrls!.isNotEmpty) {
      final String? vSource = vidUrls![0].source;
      final String? vPub = vidUrls![0].publisher;

      if (vSource != null && vSource.isNotEmpty) return vSource;
      if (vPub != null && vPub.isNotEmpty) return vPub;
    }

    // 3. Teesri priority: Image Credit (Lekin split ke saath taaki lamba na ho)
    final String? imgCredit = image?.credit;
    if (imgCredit != null && imgCredit.isNotEmpty) {
      // ESA/ATG medialab... ko ESA banane ke liye split
      return imgCredit.split('/').first.trim();
    }

    return "Space Source";
  }

  @override
  String get summaryValue =>description ?? "No description available for this event.";

  @override
  DateTime get publishedAtDate => date ?? DateTime.now();

  @override
  DateTime get updatedAtDate => lastUpdated ?? DateTime.now();

  @override
  String get typeValue => "events"; // News/Blog ke liye type 'article'

  @override
  String get formattedDate => DateFormat.yMMMd().format(publishedAtDate ?? DateTime.now());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    url: json["url"],
    name: json["name"],
    infoUrls: json["info_urls"] == null ? [] : List<InfoUrl>.from(json["info_urls"]!.map((x) => InfoUrl.fromJson(x))),
    vidUrls: json["vid_urls"] == null ? [] : List<VidUrl>.from(json["vid_urls"]!.map((x) => VidUrl.fromJson(x))),
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    slug: json["slug"],
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    description: json["description"],
    webcastLive: json["webcast_live"],
    location: json["location"] == null ? null : locationValues.map[json["location"]],
    datePrecision: json["date_precision"],
    responseMode: json["response_mode"] == null ? null : responseModeValues.map[json["response_mode"]],
    duration: json["duration"],
    updates: json["updates"] == null ? [] : List<dynamic>.from(json["updates"]!.map((x) => x)),
    lastUpdated: json["last_updated"] == null ? null : DateTime.parse(json["last_updated"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "info_urls": infoUrls == null ? [] : List<dynamic>.from(infoUrls!.map((x) => x.toJson())),
    "vid_urls": vidUrls == null ? [] : List<dynamic>.from(vidUrls!.map((x) => x.toJson())),
    "image": image?.toJson(),
    "date": date?.toIso8601String(),
    "slug": slug,
    "type": type?.toJson(),
    "description": description,
    "webcast_live": webcastLive,
    "location": locationValues.reverse[location],
    "date_precision": datePrecision,
    "response_mode": responseModeValues.reverse[responseMode],
    "duration": duration,
    "updates": updates == null ? [] : List<dynamic>.from(updates!.map((x) => x)),
    "last_updated": lastUpdated?.toIso8601String(),
  };
}

class Image {
  int? id;
  String? name;
  String? imageUrl;
  String? thumbnailUrl;
  String? credit;
  License? license;
  bool? singleUse;
  List<dynamic>? variants;

  Image({
    this.id,
    this.name,
    this.imageUrl,
    this.thumbnailUrl,
    this.credit,
    this.license,
    this.singleUse,
    this.variants,
  });

  Image copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? thumbnailUrl,
    String? credit,
    License? license,
    bool? singleUse,
    List<dynamic>? variants,
  }) =>
      Image(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        credit: credit ?? this.credit,
        license: license ?? this.license,
        singleUse: singleUse ?? this.singleUse,
        variants: variants ?? this.variants,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    thumbnailUrl: json["thumbnail_url"],
    credit: json["credit"],
    license: json["license"] == null ? null : License.fromJson(json["license"]),
    singleUse: json["single_use"],
    variants: json["variants"] == null ? [] : List<dynamic>.from(json["variants"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "thumbnail_url": thumbnailUrl,
    "credit": credit,
    "license": license?.toJson(),
    "single_use": singleUse,
    "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
  };
}

class License {
  int? id;
  String? name;
  int? priority;
  String? link;

  License({
    this.id,
    this.name,
    this.priority,
    this.link,
  });

  License copyWith({
    int? id,
    String? name,
    int? priority,
    String? link,
  }) =>
      License(
        id: id ?? this.id,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        link: link ?? this.link,
      );

  factory License.fromJson(Map<String, dynamic> json) => License(
    id: json["id"],
    name: json["name"],
    priority: json["priority"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "priority": priority,
    "link": link,
  };
}

class InfoUrl {
  int? priority;
  String? source;
  String? title;
  String? description;
  dynamic featureImage;
  String? url;
  dynamic type;
  Language? language;

  InfoUrl({
    this.priority,
    this.source,
    this.title,
    this.description,
    this.featureImage,
    this.url,
    this.type,
    this.language,
  });

  InfoUrl copyWith({
    int? priority,
    String? source,
    String? title,
    String? description,
    dynamic featureImage,
    String? url,
    dynamic type,
    Language? language,
  }) =>
      InfoUrl(
        priority: priority ?? this.priority,
        source: source ?? this.source,
        title: title ?? this.title,
        description: description ?? this.description,
        featureImage: featureImage ?? this.featureImage,
        url: url ?? this.url,
        type: type ?? this.type,
        language: language ?? this.language,
      );

  factory InfoUrl.fromJson(Map<String, dynamic> json) => InfoUrl(
    priority: json["priority"],
    source: json["source"],
    title: json["title"],
    description: json["description"],
    featureImage: json["feature_image"],
    url: json["url"],
    type: json["type"],
    language: json["language"] == null ? null : Language.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "priority": priority,
    "source": source,
    "title": title,
    "description": description,
    "feature_image": featureImage,
    "url": url,
    "type": type,
    "language": language?.toJson(),
  };
}

class Language {
  int? id;
  String? name;
  String? code;

  Language({
    this.id,
    this.name,
    this.code,
  });

  Language copyWith({
    int? id,
    String? name,
    String? code,
  }) =>
      Language(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
      );

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
  };
}

enum Location {
  BOCA_CHICA_TEXAS,
  INTERNATIONAL_SPACE_STATION,
  THE_24000000_KM_FROM_SUN
}

final locationValues = EnumValues({
  "Boca Chica, Texas": Location.BOCA_CHICA_TEXAS,
  "International Space Station": Location.INTERNATIONAL_SPACE_STATION,
  "24,000,000 km from Sun.": Location.THE_24000000_KM_FROM_SUN
});

enum ResponseMode {
  NORMAL
}

final responseModeValues = EnumValues({
  "normal": ResponseMode.NORMAL
});

class Type {
  int? id;
  String? name;

  Type({
    this.id,
    this.name,
  });

  Type copyWith({
    int? id,
    String? name,
  }) =>
      Type(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class VidUrl {
  int? priority;
  String? source;
  String? publisher;
  String? title;
  String? description;
  String? featureImage;
  String? url;
  Type? type;
  Language? language;
  DateTime? startTime;
  DateTime? endTime;
  bool? live;

  VidUrl({
    this.priority,
    this.source,
    this.publisher,
    this.title,
    this.description,
    this.featureImage,
    this.url,
    this.type,
    this.language,
    this.startTime,
    this.endTime,
    this.live,
  });

  VidUrl copyWith({
    int? priority,
    String? source,
    String? publisher,
    String? title,
    String? description,
    String? featureImage,
    String? url,
    Type? type,
    Language? language,
    DateTime? startTime,
    DateTime? endTime,
    bool? live,
  }) =>
      VidUrl(
        priority: priority ?? this.priority,
        source: source ?? this.source,
        publisher: publisher ?? this.publisher,
        title: title ?? this.title,
        description: description ?? this.description,
        featureImage: featureImage ?? this.featureImage,
        url: url ?? this.url,
        type: type ?? this.type,
        language: language ?? this.language,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        live: live ?? this.live,
      );

  factory VidUrl.fromJson(Map<String, dynamic> json) => VidUrl(
    priority: json["priority"],
    source: json["source"],
    publisher: json["publisher"],
    title: json["title"],
    description: json["description"],
    featureImage: json["feature_image"],
    url: json["url"],
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    language: json["language"] == null ? null : Language.fromJson(json["language"]),
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    live: json["live"],
  );

  Map<String, dynamic> toJson() => {
    "priority": priority,
    "source": source,
    "publisher": publisher,
    "title": title,
    "description": description,
    "feature_image": featureImage,
    "url": url,
    "type": type?.toJson(),
    "language": language?.toJson(),
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "live": live,
  };
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
