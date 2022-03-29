import 'dart:ui';

class Wallpaper {
  final int? photographer_id;
  final int id, height, width;
  final String averageColor, alt;
  final String? photographer_name;
  final String original, portrait;

  Wallpaper(
      {required this.id,
      required this.height,
      required this.width,
      required this.averageColor,
      required this.alt,
      required this.original,
      required this.portrait,
      this.photographer_id,
      this.photographer_name});

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
        id: json["id"],
        height: json["height"],
        width: json["width"],
        averageColor: json["avg_color"],
        alt: json["alt"],
        original: json["src"]["original"],
        portrait: json["src"]["portrait"],
        photographer_id: json["photographer_id"] ?? null,
        photographer_name: json["photographer"] ?? null,
      );

  static List<Wallpaper> decode(List<dynamic> wallpapers) => wallpapers.map((_) => Wallpaper.fromJson(_)).toList();
}
