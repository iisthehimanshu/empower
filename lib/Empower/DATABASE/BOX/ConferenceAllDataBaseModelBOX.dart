
import 'package:hive/hive.dart';

import '../DATABASEMODEL/ConferenceAllDataBaseModel.dart';

class ConferenceAllDataBaseModelBOX{
  static Box<ConferenceAllDataBaseModel> getData() => Hive.box<ConferenceAllDataBaseModel>('ConferenceAllDataBaseModelBOX');
}