import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services/users_apis.dart';
import 'state.dart';

final favouritesProvider = StateNotifierProvider.autoDispose<FavouritesNotifier, FavouritesState>((ref) {
  final notifier = FavouritesNotifier()..getFavouriteUsers();
  return notifier;
});

class FavouritesNotifier extends StateNotifier<FavouritesState> {
  FavouritesNotifier() : super(const FavouritesState());

  void setState(FavouritesState value) => state = value;

  void update(FavouritesState Function(FavouritesState state) value) {
    final updated = value(state);
    setState(updated);
  }

  void getFavouriteUsers() async {
    final users = await UsersApi.getFavouriteUsers();
    final updated = state.copyWith(users: users);
    setState(updated);
  }
}
