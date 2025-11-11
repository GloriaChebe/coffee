class UserProfile {
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String email;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
