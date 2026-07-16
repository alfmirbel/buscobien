// To parse this JSON data, do
//
//     final googlemapPlace = googlemapPlaceFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final googlemapPlace = googlemapPlaceFromJson(jsonString);

GooglemapPlace googlemapPlaceFromJson(String str) =>
    GooglemapPlace.fromJson(json.decode(str));

String googlemapPlaceToJson(GooglemapPlace data) => json.encode(data.toJson());

class GooglemapPlace {
  final PlusCode plusCode;
  final List<Result> results;
  final String status;

  const GooglemapPlace({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  factory GooglemapPlace.fromJson(Map<String, dynamic> json) => GooglemapPlace(
    plusCode: json["plus_code"] == null
        ? PlusCode(compoundCode: "", globalCode: "")
        : PlusCode.fromJson(json["plus_code"]),
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "plus_code": plusCode.toJson(),
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "status": status,
  };
}

class PlusCode {
  final String compoundCode;
  final String globalCode;

  const PlusCode({required this.compoundCode, required this.globalCode});

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}

class Result {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final List<NavigationPoint>? navigationPoints;
  final String placeId;
  final List<String> types;
  final PlusCode? plusCode;

  const Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    this.navigationPoints,
    required this.placeId,
    required this.types,
    this.plusCode,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: List<AddressComponent>.from(
      json["address_components"].map((x) => AddressComponent.fromJson(x)),
    ),
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    // Optimización: Manejo seguro de nulos manteniendo la lógica original
    navigationPoints: json["navigation_points"] == null
        ? []
        : List<NavigationPoint>.from(
            json["navigation_points"]!.map((x) => NavigationPoint.fromJson(x)),
          ),
    placeId: json["place_id"],
    types: List<String>.from(json["types"].map((x) => x)),
    plusCode: json["plus_code"] == null
        ? null
        : PlusCode.fromJson(json["plus_code"]),
  );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(
      addressComponents.map((x) => x.toJson()),
    ),
    "formatted_address": formattedAddress,
    "geometry": geometry.toJson(),
    "navigation_points": navigationPoints == null
        ? []
        : List<dynamic>.from(navigationPoints!.map((x) => x.toJson())),
    "place_id": placeId,
    "types": List<dynamic>.from(types.map((x) => x)),
    "plus_code": plusCode?.toJson(),
  };
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  const AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class Geometry {
  final NortheastClass location;
  final String locationType;
  final Viewport viewport;
  final Viewport? bounds;

  const Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: NortheastClass.fromJson(json["location"]),
    locationType: json["location_type"],
    viewport: Viewport.fromJson(json["viewport"]),
    bounds: json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "location_type": locationType,
    "viewport": viewport.toJson(),
    "bounds": bounds?.toJson(),
  };
}

class Viewport {
  final NortheastClass northeast;
  final NortheastClass southwest;

  const Viewport({required this.northeast, required this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: NortheastClass.fromJson(json["northeast"]),
    southwest: NortheastClass.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}

class NortheastClass {
  final double lat;
  final double lng;

  const NortheastClass({required this.lat, required this.lng});

  factory NortheastClass.fromJson(Map<String, dynamic> json) => NortheastClass(
    // Uso de 'num' para seguridad si la API devuelve int en vez de double
    lat: (json["lat"] as num).toDouble(),
    lng: (json["lng"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}

class NavigationPoint {
  final NavigationPointLocation location;

  const NavigationPoint({required this.location});

  factory NavigationPoint.fromJson(Map<String, dynamic> json) =>
      NavigationPoint(
        location: NavigationPointLocation.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {"location": location.toJson()};
}

class NavigationPointLocation {
  final double latitude;
  final double longitude;

  const NavigationPointLocation({
    required this.latitude,
    required this.longitude,
  });

  factory NavigationPointLocation.fromJson(Map<String, dynamic> json) =>
      NavigationPointLocation(
        // Uso de 'num' para seguridad
        latitude: (json["latitude"] as num).toDouble(),
        longitude: (json["longitude"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
