class DonateRequest {
  final int id;
  final String hospital;
  final String phone;
  final String fileNumber;
  final int isAccepted;
  // final String? long;

  DonateRequest({
    required this.hospital,
    required this.id,
    required this.phone,
    required this.fileNumber,
    required this.isAccepted,
  });

  factory DonateRequest.fromJson(Map<String, dynamic> json) {
    return DonateRequest(
        id: json['id'],
        hospital: json['hospital'],
        fileNumber: json['file_number'],
        phone: json['contact_number'],
        isAccepted: json['is_accepted']);
  }
}
