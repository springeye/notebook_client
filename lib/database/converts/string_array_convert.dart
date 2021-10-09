import 'package:floor/floor.dart';

class StringArrayConvert extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return databaseValue.split(",").toList();
  }

  @override
  String encode(List<String> value) {
    return value.join(",");
  }
}
