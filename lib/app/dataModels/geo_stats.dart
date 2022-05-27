// To parse this JSON data, do
//
//     final geoStats = geoStatsFromJson(jsonString);

import 'dart:convert';

List<GeoStats> geoStatsFromJson(String str) =>
    List<GeoStats>.from(json.decode(str).map((x) => GeoStats.fromJson(x)));

String geoStatsToJson(List<GeoStats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeoStats {
  GeoStats({
    required this.a,
    required this.b,
  });

  double a;
  double b;

  factory GeoStats.fromJson(Map<String, dynamic> json) => GeoStats(
        a: json["a"].toDouble(),
        b: json["b"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "a": a,
        "b": b,
      };
}
