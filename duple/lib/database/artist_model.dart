class ArtistModel {
  final String email;
  final String genre1;
  final String genre2;
  final double latitude;
  final double longitude;
  final String username;

  ArtistModel({
    required this.email,
    required this.genre1,
    required this.genre2,
    required this.latitude,
    required this.longitude,
    required this.username,
  });

  factory ArtistModel.fromJson(Map<String,dynamic> json) {
    return ArtistModel(
      email: json['email'] ?? "", 
      genre1: json['genre1'] ?? "", 
      genre2: json['genre2'] ?? "", 
      latitude: json['latitude'] ?? 0, 
      longitude: json['longitude'] ?? 0, 
      username: json['username'] ?? "",
    );
  }
}