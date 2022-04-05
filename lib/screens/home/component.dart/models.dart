class Mayors {
  final int id;
  final String name;
  final List<City> citys;

  Mayors({required this.name, required this.id, required this.citys});

  factory Mayors.fromJson(Map<String, dynamic> json) {
    return Mayors(
        id: json['id'],
        name: json['m_name'],
        citys:
            json['cities'].map<City>((data) => City.fromJson(data)).toList());
  }
}

class City {
  final int id;
  final String name;
  final List<Hospital> hospitals;

  City({required this.name, required this.id, required this.hospitals});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        id: json['id'],
        name: json['name'],
        hospitals: json['hospitals']
            .map<Hospital>((data) => Hospital.fromJson(data))
            .toList());
  }
}

class Hospital {
  final int id;
  final String name;

  Hospital({required this.name, required this.id});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(id: json['id'], name: json['name']);
  }
}

class User {
  int id = 0;
  String name = "";
  String address = "";
  String phone = "";
  String? gender;
  String? bloodType;
  String? age;
  String? email;
  String donating = "";
  String request = "";
  String password = "";
  int avilabelToDonate = 0;

  User({
    required this.name,
    required this.id,
    required this.address,
    required this.phone,
    required this.gender,
    required this.bloodType,
    required this.age,
    required this.email,
    required this.donating,
    required this.request,
    required this.password,
    required this.avilabelToDonate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['full_name'],
        address: json['address'],
        avilabelToDonate: json['is_avilabel_to_donate'],
        phone: json['phone'],
        email: json['email'],
        gender: json['gender'],
        age: json['age'],
        bloodType: json['blood_type'],
        donating: json['donating'],
        request: json['request'],
        password: json['password']);
  }
}
