// To parse this JSON data, do
//
//     final spaceNewsMissionsModel = spaceNewsMissionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:intl/intl.dart';

SpaceNewsMissionsModel spaceNewsMissionsModelFromJson(String str) => SpaceNewsMissionsModel.fromJson(json.decode(str));

String spaceNewsMissionsModelToJson(SpaceNewsMissionsModel data) => json.encode(data.toJson());

class SpaceNewsMissionsModel {
  int? count;
  String? next;
  dynamic previous;
  List<Result>? results;

  SpaceNewsMissionsModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  SpaceNewsMissionsModel copyWith({
    int? count,
    String? next,
    dynamic previous,
    List<Result>? results,
  }) =>
      SpaceNewsMissionsModel(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        results: results ?? this.results,
      );

  factory SpaceNewsMissionsModel.fromJson(Map<String, dynamic> json) => SpaceNewsMissionsModel(
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

class Result implements SpaceContent {
  int? id;
  String? title;
  List<Author>? authors;
  String? url;
  String? imageUrl;
  String? newsSite;
  String? summary;
  DateTime? publishedAt;
  DateTime? updatedAt;
  bool? featured;
  List<dynamic>? launches;
  List<dynamic>? events;

  Result({
    this.id,
    this.title,
    this.authors,
    this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
    this.updatedAt,
    this.featured,
    this.launches,
    this.events,
  });

  Result copyWith({
    int? id,
    String? title,
    List<Author>? authors,
    String? url,
    String? imageUrl,
    String? newsSite,
    String? summary,
    DateTime? publishedAt,
    DateTime? updatedAt,
    bool? featured,
    List<dynamic>? launches,
    List<dynamic>? events,
  }) =>
      Result(
        id: id ?? this.id,
        title: title ?? this.title,
        authors: authors ?? this.authors,
        url: url ?? this.url,
        imageUrl: imageUrl ?? this.imageUrl,
        newsSite: newsSite ?? this.newsSite,
        summary: summary ?? this.summary,
        publishedAt: publishedAt ?? this.publishedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        featured: featured ?? this.featured,
        launches: launches ?? this.launches,
        events: events ?? this.events,
      );

  // giving values to getters of the interface
  @override
  String get idValue => id?.toString() ?? ""; // int ko string banaya

  @override
  String get titleValue => title ?? "No Title";

  @override
  String get imageUrlValue => imageUrl ?? "";

  @override
  String get newsSiteValue => newsSite ?? "Unknown Source";

  @override
  String get summaryValue => summary ?? "No Summary Available";

  @override
  DateTime get publishedAtDate => publishedAt ?? DateTime.now();

  @override
  DateTime get updatedAtDate => updatedAt ?? DateTime.now();

  @override
  String get typeValue => "news"; // News/missions ke liye

  @override
  String get formattedDate => DateFormat.yMMMd().format(publishedAt ?? DateTime.now());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    authors: json["authors"] == null ? [] : List<Author>.from(json["authors"]!.map((x) => Author.fromJson(x))),
    url: json["url"],
    imageUrl: json["image_url"],
    newsSite: json["news_site"],
    summary: json["summary"],
    publishedAt: json["published_at"] == null ? null : DateTime.parse(json["published_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    featured: json["featured"],
    launches: json["launches"] == null ? [] : List<dynamic>.from(json["launches"]!.map((x) => x)),
    events: json["events"] == null ? [] : List<dynamic>.from(json["events"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "authors": authors == null ? [] : List<dynamic>.from(authors!.map((x) => x.toJson())),
    "url": url,
    "image_url": imageUrl,
    "news_site": newsSite,
    "summary": summary,
    "published_at": publishedAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "featured": featured,
    "launches": launches == null ? [] : List<dynamic>.from(launches!.map((x) => x)),
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x)),
  };
}

class Author {
  String? name;
  Socials? socials;

  Author({
    this.name,
    this.socials,
  });

  Author copyWith({
    String? name,
    Socials? socials,
  }) =>
      Author(
        name: name ?? this.name,
        socials: socials ?? this.socials,
      );

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    name: json["name"],
    socials: json["socials"] == null ? null : Socials.fromJson(json["socials"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "socials": socials?.toJson(),
  };
}

class Socials {
  String? x;
  String? youtube;
  String? instagram;
  String? linkedin;
  String? mastodon;
  String? bluesky;

  Socials({
    this.x,
    this.youtube,
    this.instagram,
    this.linkedin,
    this.mastodon,
    this.bluesky,
  });

  Socials copyWith({
    String? x,
    String? youtube,
    String? instagram,
    String? linkedin,
    String? mastodon,
    String? bluesky,
  }) =>
      Socials(
        x: x ?? this.x,
        youtube: youtube ?? this.youtube,
        instagram: instagram ?? this.instagram,
        linkedin: linkedin ?? this.linkedin,
        mastodon: mastodon ?? this.mastodon,
        bluesky: bluesky ?? this.bluesky,
      );

  factory Socials.fromJson(Map<String, dynamic> json) => Socials(
    x: json["x"],
    youtube: json["youtube"],
    instagram: json["instagram"],
    linkedin: json["linkedin"],
    mastodon: json["mastodon"],
    bluesky: json["bluesky"],
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "youtube": youtube,
    "instagram": instagram,
    "linkedin": linkedin,
    "mastodon": mastodon,
    "bluesky": bluesky,
  };
}
