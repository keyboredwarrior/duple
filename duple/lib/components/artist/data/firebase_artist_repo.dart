import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/components/artist/domain/artist.dart';
import 'package:duple/components/artist/domain/repos/artist_repo.dart';

class FirebaseArtistRepo implements ArtistRepo {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference artistsCollection = FirebaseFirestore.instance.collection('Artists');


  @override 
  Future<void> createArtist(Artist artist) async {
    try{
      await artistsCollection.doc(artist.email).set(artist.toJson());
    } catch (e) {
      throw Exception("ERROR CREATING ARTIST");
    }
  }

  @override
  Future<void> deleteArtist(String artistId) async {
    await artistsCollection.doc(artistId).delete();
  }

  @override
  Future<List<Artist>> fetchAllArtists() async {
    try{

      final artistsSnapshot = await artistsCollection.orderBy('username', descending: true).get();

      final List<Artist> allArtists = artistsSnapshot.docs.map((doc) => Artist.fromJson(doc.data() as Map<String,dynamic>)).toList();


      return allArtists;
    } catch (e) {throw Exception("ERROR FETCHING ARTISTS");}
  }

  @override
  Future<List<Artist>> fetchArtistsByArtistId(String artistId) {
    // TODO: implement fetchArtistsByArtistId
    throw UnimplementedError();
  }
}