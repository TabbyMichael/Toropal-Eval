import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);
final counterProvider = StateProvider<int>((ref) => 0);
