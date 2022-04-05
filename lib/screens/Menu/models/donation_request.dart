class DonationRequest {
  final int id;
  final String city;
  final String hospital;
  final String bloodType;
  final String fileNumber;
  final String contactNumber;
  final int cityId;
  final int hospitalId;
  final String date;

  DonationRequest({
    required this.id,
    required this.city,
    required this.cityId,
    required this.hospital,
    required this.hospitalId,
    required this.bloodType,
    required this.fileNumber,
    required this.contactNumber,
    required this.date,
  });

  factory DonationRequest.fromJson(Map<String, dynamic> json) {
    return DonationRequest(
        id: json['id'],
        city: json['city'],
        hospital: json['hospital'],
        bloodType: json['blood_type'],
        fileNumber: json['file_number'],
        cityId: json['city_id'],
        hospitalId: json['hospital_id'],
        contactNumber: json['contact_number'],
        date: json['date']);
  }
}
