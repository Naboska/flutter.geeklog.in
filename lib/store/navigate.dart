import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navigate {
  int index = 0;

  Navigate({this.index});
}

final navigateState = StateProvider((ref) => Navigate(index: 0));