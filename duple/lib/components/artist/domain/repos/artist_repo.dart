import 'package:duple/components/artist/domain/artist.dart';

abstract class ArtistRepo {
  Future<List<Artist>> fetchAllArtists();
  Future<void> createArtist(Artist artist);
  Future<void> deleteArtist(String artistId);
  Future<List<Artist>> fetchArtistsByArtistId(String artistId);
}