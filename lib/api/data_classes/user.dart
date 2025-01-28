class User {
  User(
      {required this.id,
      required this.custArbName,
      required this.nationalityId,
      required this.email,
      required this.mobile,
      required this.countryId,
      required this.gender,
      required this.dateOfBirth,
      required this.cityId});
  final int id;
  final String custArbName;
  final String nationalityId;
  final String email;
  final String mobile;
  final String countryId;
  final String gender;
  final String dateOfBirth;
  final String cityId;

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        id: data['id'] ?? 0,
        custArbName: data['CustArbName'] ?? '',
        nationalityId: data['NationalityID'] ?? 0,
        email: data['email'],
        mobile: data['Mobile'],
        countryId: data['CountryID'] ?? 0,
        cityId: data['CityID'] ?? 0,
        gender: data['Gender'] ?? '',
        dateOfBirth: data['DOB']);
  }
}
