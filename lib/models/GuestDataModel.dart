class GuestDataModel{
  GuestDataModel({        //----------------------------CONSTRUCTOR FUNCTION
    required this.email,
    required this.password,
    required this.fname,
    required this.lname,
    required this.contactNo,
    required this.adharNo,
    required this.profession,
    required this.clgName,
    required this.address,
    required this.pincode,
    required this.selectedUserCategory,
    required this.profilePic
  });
  final String?  email;
  final String? password;
  final String? fname;
  final String? lname;
  final String? contactNo;
  final String? adharNo;
  final String? profession;
  final String? clgName;
  final String? address;
  final String? pincode;
  final String? selectedUserCategory;
  final String? profilePic;
}