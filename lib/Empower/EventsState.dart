import 'API/ScheduleAPI.dart';
import 'APIModel/Schedulemodel.dart';
import 'DATABASE/BOX/ScheduleApiModelBOX.dart';

class Eventsstate{
  static ScheduleModel? schedule;

  static Future<ScheduleModel?> fetchSchedule() async {
    if(schedule == null){
      schedule = await ScheduleAPI.fetchschedule();
      return schedule;
    }else{
      return schedule;
    }
  }

  static checkForUpdate()async{
    var s = await fetchSchedule();
    if(s != null){
      if(DateTime.parse(s.timeFetchedat!).difference(DateTime.now()).inMinutes.abs() >= 15){
        schedule = await ScheduleAPI.fetchschedule(fetchFromInternet: true);
        schedule = null;
      }
    }
  }

}