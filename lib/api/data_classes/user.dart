class User {
  User(
      {required this.id,
      required this.custArbName,
      required this.custEngName,
      required this.nationalityId,
      required this.email,
      required this.mobile,
      required this.countryId,
      required this.gender,
      required this.dateOfBirth,
      required this.cityId});
  final int id;
  final String custArbName;
  final String custEngName;
  final int nationalityId;
  final String email;
  final String mobile;
  final int countryId;
  final int gender;
  final String dateOfBirth;
  final int cityId;
  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        id: data['id'] ?? 0,
        custArbName: data['Name1'] ?? '',
        custEngName: data['Name2'] ?? '',
        nationalityId: data['NationalityID'] ?? -1,
        email: data['email'],
        mobile: data['Mobile'],
        countryId: data['CountryID'] ?? -1,
        cityId: data['CityID'] ?? -1,
        gender: data['Gender'] ?? -1,
        dateOfBirth: data['DOB']);
  }
}
