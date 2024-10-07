
import 'package:hive/hive.dart';
part 'ScheduleApiModel.g.dart';

@HiveType(typeId: 18)
class ScheduleApiModel extends HiveObject{
  @HiveField(0)
  Map<String, dynamic> responseBody;

  ScheduleApiModel({required this.responseBody});
}