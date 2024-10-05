import 'package:hive/hive.dart';

import '../../../Empower/LOGIN SIGNUP/LOGIN SIGNUP APIS/MODELS/SignInAPIModel.dart';



part 'SignINAPIModel.g.dart';

@HiveType(typeId: 7)
class SignINAPIModel extends HiveObject{
  @HiveField(0)
  SignInApiModel signInApiModel;

  SignINAPIModel({required this.signInApiModel});

}