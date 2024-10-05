
import 'package:empower/Empower/DATABASE/DATABASEMODEL/SavedCardsModel.dart';
import 'package:hive/hive.dart';

class SavedCardBox{
  static Box<SavedCardsModel> getData() => Hive.box<SavedCardsModel>('SavedCardsModelFile');
}