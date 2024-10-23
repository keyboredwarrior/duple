import 'package:cloud_firestore/cloud_firestore.dart';
import 'artist_model.dart';

class ArtistDatastate {
  final List<ArtistModel> artistModels;
  final bool loading;
  final bool noMoreData;
  final DocumentSnapshot? lastDoc;

  ArtistDatastate({
    required this.artistModels,
    required this.lastDoc,
    required this.loading,
    required this.noMoreData,
  });

  ArtistDatastate copyWith({
    List<ArtistModel>? artistModels,
    bool? loading,
    bool? noMoreData,
    DocumentSnapshot? lastDoc,
  }) {
    return ArtistDatastate(
      artistModels: artistModels ?? this.artistModels, 
      lastDoc: lastDoc ?? this.lastDoc, 
      loading: loading ?? this.loading, 
      noMoreData: noMoreData ?? this.noMoreData
    );
  }
}