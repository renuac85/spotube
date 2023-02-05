import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:tuple/tuple.dart';

class SearchQueries {
  final get = InfiniteQueryJob.withVariableKey<List<Page>,
      Tuple2<String, SpotifyApi>, int>(
    preQueryKey: "search-query",
    refetchOnExternalDataChange: true,
    initialParam: 0,
    enabled: false,
    getNextPageParam: (lastPage, lastParam) =>
        lastPage.isNotEmpty && (lastPage.first.items?.length ?? 0) < 10
            ? null
            : lastParam + 10,
    getPreviousPageParam: (lastPage, lastParam) => lastParam - 10,
    task: (queryKey, pageParam, variables) {
      if (variables.item1.trim().isEmpty) return [];
      final queryString = variables.item1;
      final spotify = variables.item2;
      final searchType = getVariable(queryKey);
      return spotify.search.get(
        queryString,
        types: [SearchType(searchType)],
      ).getPage(10, pageParam);
    },
  );
}