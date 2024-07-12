import 'package:minio/models.dart';
import 'package:test/test.dart';

void main() {
  final date = DateTime.utc(2017, 8, 11, 19, 34, 18);
  final dateString = 'Fri, 11 Aug 2017 19:34:18 GMT';

  test('CopyConditions.setModified() works', () {
    final cc = CopyConditions();
    cc.setModified(date);
    expect(cc.modified, equals(dateString));
  });

  test('CopyConditions.setUnmodified() works', () {
    final cc = CopyConditions();
    cc.setUnmodified(date);
    expect(cc.unmodified, dateString);
  });
}
