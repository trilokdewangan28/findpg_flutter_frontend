class OwnerDataModel {
  OwnerDataModel(
      {required this.email,
      required this.password,
      required this.hostleName,
      required this.contactNo,
      required this.address,
      required this.pincode,
      required this.selectedUserCategory,
      required this.selectedHostleCategory,
        required this.profilePic,
        required this.hostleImages
      });

  String? email;
  String? password;
  String? hostleName;
  String? contactNo;
  String? address;
  String? pincode;
  String? selectedUserCategory;
  String? selectedHostleCategory;
  String? profilePic;
  List<dynamic>? hostleImages;

  factory OwnerDataModel.fromJson(Map<String, dynamic> json) {
    return OwnerDataModel(
      email: json['email'],
      password: json['password'],
      hostleName: json['hostleName'],
      contactNo: json['contactNo'].toString(),
      address: json['address'],
      pincode: json['pincode'].toString(),
      selectedUserCategory: json['selectedUserCategory'],
      selectedHostleCategory: json['selectedHostleCategory'],
      profilePic: json['profilePic'],
      hostleImages: json['hostleImages'],
    );
  }
}
