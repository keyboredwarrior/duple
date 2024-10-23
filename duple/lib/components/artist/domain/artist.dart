class Artist {
  final String email;
  final String username;
  final double latitude;
  final double longitude;
  final String genre1;
  final String genre2;

  Artist({
    required this.email,
    required this.username,
    required this.latitude,
    required this.longitude,
    required this.genre1,
    required this.genre2
  });

  Artist copyWith({String? genre1, genre2}){
    return Artist(email: email, username: username, latitude: latitude, longitude: longitude, genre1: genre1 ?? this.genre1, genre2: genre2 ?? this.genre2);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'latitude': latitude,
      'longitude': longitude,
      'genre1': genre1,
      'genre2': genre2,
    };
  }

  factory Artist.fromJson(Map<String,dynamic> json) {
    return Artist(
      email: json['email'], 
      username: json['username'], 
      latitude: json['latitude'], 
      longitude: json['longitude'], 
      genre1: json['genre1'], 
      genre2: json['genre2'],
    );
  }
}