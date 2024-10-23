import 'package:duple/components/data_card.dart';
import 'package:duple/database/datastate_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../database/artist_model.dart';
import '../database/artist_datastate.dart';

class InfiniteRealtimePagination extends ConsumerWidget {
  const InfiniteRealtimePagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(dataProviders);

    return dataListBuilder(
      loadMore: ref.read(dataProviders.notifier).loadMore,
      dataState: dataState,
      loader: const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: const Center(
        child: Icon(Icons.error_outline),
      ),
      builder: (ctx, index, dataModel) {
        return DataCard(
          dataModel: dataModel,
        );
      },
    );
  }
}

typedef DataBuilder = Widget Function(
    BuildContext context, int index, ArtistModel dataModel);

Widget dataListBuilder({
  required ArtistDatastate dataState,
  required DataBuilder builder,
  required Future<void> Function() loadMore,
  required Widget loader,
  required Widget errorWidget,
}) {
  if (dataState.noMoreData && dataState.artistModels.isEmpty) {
    return errorWidget;
  }

  final dataModels = dataState.artistModels;

  return CustomScrollView(
    slivers: [
      SliverList.builder(
        itemBuilder: (ctx, index) {
          final dataModel = dataModels[index];
          return builder(ctx, index, dataModel);
        },
        itemCount: dataModels.length,
      ),
      if (dataState.loading || (!dataState.noMoreData && dataModels.isNotEmpty))
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: VisibilityDetector(
              key: const Key('_loader'),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction > 0) {
                  loadMore();
                }
              },
              child: loader,
            ),
          ),
        ),
    ],
  );
}