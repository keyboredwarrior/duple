import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'artist_model.dart';
import 'artist_datastate.dart';

final dataProviders =
    AutoDisposeStateNotifierProvider<DataStateNotifier, ArtistDatastate>(
  (ref) {
    final notifier = DataStateNotifier(
      ref: ref,
      fireStore: FirebaseFirestore.instance,
    );

// This part is particularly useful when you want to temporarily retain the state of a provider to prevent it from being automatically disposed of when there are no active listeners.
// You can ignore this if you don't need to persist data temporarily on widget dispose.
    ref.onCancel(() {
      final link = ref.keepAlive();
      final timer = Timer(const Duration(seconds: 15), () {
        link.close();
      });
      ref.onDispose(timer.cancel);
    });
    return notifier;
  },
);

class DataStateNotifier extends StateNotifier<ArtistDatastate> {
  final FirebaseFirestore fireStore;
  final AutoDisposeStateNotifierProviderRef<DataStateNotifier, ArtistDatastate> ref;
  final List<List<ArtistModel>> allPagedResults = [];
  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> _subscriptions = [];
  int pageLimit = 10;

  DataStateNotifier({
    required this.ref,
    required this.fireStore,
  }) : super(ArtistDatastate(
          artistModels: [],
          loading: false,
          noMoreData: false,
          lastDoc: null,
        )) {
// Initial data load.
    loadMore();

// You can also set a listener here to for any changes and call the restart() function with new values to switch collection.
// listener() {
//      restart();
// });
  }

  Future<void> loadMore() async {
    if (state.loading || state.noMoreData) return;

    await Future.delayed(Duration.zero);
    state = state.copyWith(loading: true);

    await fetchArtists();
  }

  Future<void> fetchArtists() async {
    try {
      String collection = 'Artists'; // Here country and langauge can be dynamic and can change depending on other providers.

      Query<Map<String, dynamic>> query = fireStore
          .collection(collection)
          .limit(pageLimit)
          .orderBy('username', descending: true);

      if (state.lastDoc != null) {
        query = query.startAfterDocument(state.lastDoc!);
      }

      // current page index
      var currentRequestIndex = allPagedResults.length;

      var snapshots = query.snapshots();

      final subscription = snapshots.listen(
        (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
          processData(
              querySnapshot: querySnapshot,
              currentRequestIndex: currentRequestIndex);
        },
      );
      _subscriptions.add(subscription);
    } catch (e) {
      log('error from data_service: $e');
    }
  }

void processData({
    required QuerySnapshot<Map<String, dynamic>> querySnapshot,
    required int currentRequestIndex,
  }) {
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot? lastDocument;
      final List<ArtistModel> artists = querySnapshot.docs.map((doc) {
        final artist = doc.data();
        return ArtistModel.fromJson(artist);
      }).toList();

      // Check if the page exists or not
      var pageExists = currentRequestIndex < allPagedResults.length;

      // If the page exists update the articles for that page
      if (pageExists) {
        allPagedResults[currentRequestIndex] = artists;
      }
      // If the page doesn't exist add the page data
      else {
        allPagedResults.add(artists);
      }

      // Concatenate the full list to be shown
      var allVideos = allPagedResults.fold<List<ArtistModel>>(
          [], (initialValue, pageItems) => initialValue..addAll(pageItems));

      if (currentRequestIndex == allPagedResults.length - 1) {
        lastDocument = querySnapshot.docs.last;
      }

      state = state.copyWith(
          artistModels: allVideos,
          lastDoc: lastDocument,
          noMoreData: artists.length != pageLimit,
          loading: false);
    } else {
      state = state.copyWith(noMoreData: false, loading: false);
    }
  }

// Always call this function to clear previous subscriptions before subscribing to a new collection.
  Future<void> clearPreviousSubscription() async {
    allPagedResults.clear();

    List<Future<void>> cancelFutures = [];

    for (var subscription in _subscriptions) {
      cancelFutures.add(subscription.cancel());
    }

    // Wait for all cancel futures to complete
    await Future.wait(cancelFutures);

    _subscriptions.clear();
  }

  Future<void> clearData() async {
    allPagedResults.clear();
    state = state.copyWith(
      loading: false,
      artistModels: [],
      lastDoc: null,
      noMoreData: false,
    );
    await clearPreviousSubscription();
  }

  void restart() async {
    await clearData();
    loadMore();
  }

  @override
  void dispose() async {
    await clearPreviousSubscription();
    super.dispose();
  }
}