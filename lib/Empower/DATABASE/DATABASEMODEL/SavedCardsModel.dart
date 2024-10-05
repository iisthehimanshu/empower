
import 'package:empower/Empower/APIModel/Schedulemodel.dart';
import 'package:hive/hive.dart';

part 'SavedCardsModel.g.dart';

@HiveType(typeId: 20)

class SavedCardsModel extends HiveObject{
  @HiveField(0)
  Map<String, Data> cardData;

  SavedCardsModel({required this.cardData});
}