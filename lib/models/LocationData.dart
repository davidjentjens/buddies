class LocationData {
  String formattedAddress;
  double latitude;
  double longitude;
  String postalCode;

  LocationData({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
  });

  factory LocationData.fromMap(Map data) {
    return LocationData(
      formattedAddress: data['formattedAddress'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      postalCode: data['postalCode'],
    );
  }
}
