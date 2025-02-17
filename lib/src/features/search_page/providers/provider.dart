import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services/search_api.dart';
import '../../../utils/debouncer.dart';
import 'state.dart';

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, SearchState>(
  (ref) {
    final notifier = SearchNotifier();
    ref.onDispose(() => notifier.searchController.dispose());
    return notifier;
  },
);

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void setState(SearchState value) => mounted ? state = value : null;

  TextEditingController searchController = TextEditingController();

  final searchDebouncer = Debouncer(milliseconds: 600);

  void onSearchChanged(String? query) {
    final searched = query == null ? null : state.searched;
    setState(state.copyWith(searched: searched));
    if (query != null) searchDebouncer.run(() => search(query));
  }

  void clearSearch() {
    searchController.clear();
    setState(state.copyWith(searched: null));
  }

  Future<void> search(String query) async {
    final result = await SearchApi.search(query);
    setState(state.copyWith(searched: result));
  }
}
