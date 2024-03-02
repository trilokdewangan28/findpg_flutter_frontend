class HostleListDataModel {
  HostleListDataModel(
      {
        required this.hostleName,
        required this.contactNo,
        required this.address,
        required this.pincode,
        required this.selectedHostleCategory,
        required this.hostleImages
      });

  String hostleName;
  String contactNo;
  String address;
  String pincode;
  String selectedHostleCategory;
  List<dynamic> hostleImages;
}
