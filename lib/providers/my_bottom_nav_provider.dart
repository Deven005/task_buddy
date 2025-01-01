import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_bottom_nav_provider.g.dart';

@riverpod
class MyBottomNavNotifier extends _$MyBottomNavNotifier {
  @override
  int build() {
    return 0;
  }

  changeCurrentIndex(int updatedIndex) {
    state = updatedIndex;
  }
}
