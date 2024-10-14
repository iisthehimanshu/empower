import 'package:hive/hive.dart';
part 'ConferenceAllDataBaseModel.g.dart';

@HiveType(typeId: 19)
class ConferenceAllDataBaseModel extends HiveObject{
  @HiveField(0)
  Map<String, dynamic> responseBody;

  ConferenceAllDataBaseModel({required this.responseBody});
}