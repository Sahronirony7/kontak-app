class Contact {
  int? id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String address;
  String photo;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'photo': photo,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
      photo: map['photo'],
    );
  }
}
