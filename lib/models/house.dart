class House {
  final String? id;
  final String userId;
  final String name;
  final String type;
  final String place;
  final String? status;
  final List<String>? imagesIds;
  final double? price;
  final String? description;
  House({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.place,
    required this.price,
    required this.description,
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
      'price': price,
      'description': description
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
      price: map['price'],
      description: map['description'],
      imagesIds: List<String>.from(map['imagesIds'] as List),
    );
  }
}
