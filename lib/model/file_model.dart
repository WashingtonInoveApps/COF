import 'dart:convert';
import 'dart:typed_data';

class FileModel {
  String id;
  String name;
  String url;
  String path;

  Uint8List? data;

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    required this.path,
    this.data,
  });

  FileModel copyWith({
    String? id,
    String? name,
    String? url,
    String? path,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'path': path,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      path: map['path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source));

  @override
  String toString() => 'FileModel(name: $name, url: $url)';
}
