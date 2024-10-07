import 'package:empower/Empower/DATABASE/DATABASEMODEL/ScheduleApiModel.dart';
import 'package:hive/hive.dart';

class ScheduleApiModelBox{
  static Box<ScheduleApiModel> getData() => Hive.box<ScheduleApiModel>('ScheduleApiModelFile');
}