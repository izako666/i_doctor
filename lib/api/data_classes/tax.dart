class Tax {
  final int id;
  final String code;
  final String name;
  final int countryId;
  final String tax;

  Tax(
      {required this.id,
      required this.code,
      required this.name,
      required this.countryId,
      required this.tax});

  factory Tax.fromJson(Map<String, dynamic> data) {
    return Tax(
        id: data['id'],
        code: data['Code'],
        name: data['Name'],
        countryId: data['CountryID'],
        tax: data['Tax']);
  }
}
