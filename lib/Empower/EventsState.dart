import 'API/ScheduleAPI.dart';
import 'APIModel/Schedulemodel.dart';

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

}