class ContactClass {
  String name;
  String email;

  ContactClass(this.name, this.email);

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }

  factory ContactClass.fromJson(Map<String, dynamic> json) {
    return ContactClass(json['name'] ?? '', json['email'] ?? '');
  }
}
