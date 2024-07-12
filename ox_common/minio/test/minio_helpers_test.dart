import 'package:minio/src/minio_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('helpers', () {
    test('should validate for s3 endpoint', () {
      expect(isValidEndpoint('s3.amazonaws.com'), isTrue);
    });
    test('should validate for s3 china', () {
      expect(isValidEndpoint('s3.cn-north-1.amazonaws.com.cn'), isTrue);
    });
    test('should validate for us-west-2', () {
      expect(isValidEndpoint('s3-us-west-2.amazonaws.com'), isTrue);
    });
    test('should fail for invalid endpoint characters', () {
      expect(isValidEndpoint('111.#2.11'), isFalse);
    });
    test('should validate for valid ip', () {
      expect(isValidIPv4('1.1.1.1'), isTrue);
    });
    test('should fail for invalid ip', () {
      expect(isValidIPv4('1.1.1'), isFalse);
    });
    test('should make date short', () {
      final date = DateTime.parse('2012-12-03T17:25:36.331Z');
      expect(makeDateShort(date), '20121203');
    });
    test('should make date long', () {
      final date = DateTime.parse('2017-08-11T17:26:34.935Z');
      expect(makeDateLong(date), '20170811T172634Z');
    });
  });
  ;
}
