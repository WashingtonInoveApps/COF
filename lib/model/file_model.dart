import 'dart:convert';

class FileModel {
  String name;
  String url;

  FileModel({
    required this.name,
    required this.url,
  });

  FileModel copyWith({
    String? name,
    String? url,
  }) {
    return FileModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source));

  @override
  String toString() => 'FileModel(name: $name, url: $url)';
}
