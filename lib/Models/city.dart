class City {
  String? name;
  String? description;
  int? status;
  int? id;

  City({this.name, this.description, this.status, this.id});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['id'] = id;
    return data;
  }

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id!;
}