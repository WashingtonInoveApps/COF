import 'dart:convert';
import 'dart:typed_data';

class FileModel {
  String id;
  String name;
  String url;

  Uint8List? data;

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    this.data,
  });

  FileModel copyWith({
    String? id,
    String? name,
    String? url,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
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
