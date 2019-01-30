import 'package:flutter_test/flutter_test.dart';
import '../lib/pages/tag_edit.dart';


void main() {
  test('Empty return error', () {
    String result = AmountFieldValidator.validate('');
    expect(result, 'Price is required and it should be a number');
  });

  test('Number returns null', () {
    String result = AmountFieldValidator.validate('3');
    expect(result, null);
  });

  test('Character returns error', () {
    String result = AmountFieldValidator.validate('A');
    expect(result, 'Price is required and it should be a number');
  });
}