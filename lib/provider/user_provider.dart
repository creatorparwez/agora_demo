import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notifications/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// // To get userData by Id
// final userDataProvider = StreamProvider.family<UserModel, String>((
//   ref,
//   userId,
// ) {
//   final repo = ref.watch(userRepositoryProvider);
//   return repo.getUserDataById(userId);
// });
