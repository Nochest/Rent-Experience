class House {
  final String? id;
  final String userId;
  final String name;
  final String type;
  final String place;
  final String? status;
  final List<String>? imagesIds;

  House({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.place,
    this.status,
    this.imagesIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'type': type,
      'place': place,
      'status': status,
      'imagesIds': imagesIds,
    };
  }

  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      id: map['\$id'],
      userId: map['userId'],
      name: map['name'],
      type: map['type'],
      place: map['place'],
      status: map['status'],
      imagesIds: List<String>.from(map['imagesIds'] as List),
    );
  }
}
