import 'package:flutter_riverpod/flutter_riverpod.dart';

final obcode = StateNotifierProvider<TakeCode, String>((ref) => TakeCode(''));

class TakeCode extends StateNotifier<String> {
  TakeCode(this.oobcode) : super('');
  final String oobcode;

  updatecode(String code) {
    state = code;
  }
}
