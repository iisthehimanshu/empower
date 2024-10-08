
import 'package:intl/intl.dart';

class CardData {
  String? sId;
  String? eventName;
  String? eventDate;
  String? startTime;
  String? endTime;
  String? moderator;
  String? bookingType;
  List<String>? genre;
  String? categories;
  String? conferenceId;
  String? venueName;
  String? venueId;
  String? slots;
  String? eventDetails;
  String? eventType;
  List<String>? coordinators;
  List<Null>? subEvents;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? filename;
  String? speakerId;
  String? speakerName;

  CardData(
      {this.sId,
        this.eventName,
        this.eventDate,
        this.startTime,
        this.endTime,
        this.moderator,
        this.bookingType,
        this.genre,
        this.categories,
        this.conferenceId,
        this.venueName,
        this.venueId,
        this.slots,
        this.eventDetails,
        this.eventType,
        this.coordinators,
        this.subEvents,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.filename,
        this.speakerId,
        this.speakerName});

  CardData.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    eventName = json['eventName'];
    eventDate = json['eventDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    moderator = json['moderator'];
    bookingType = json['bookingType'];
    genre = json['genre'].cast<String>();
    categories = json['categories'];
    conferenceId = json['conferenceId'];
    venueName = json['venueName'];
    venueId = json['venueId'];
    slots = json['slots'];
    eventDetails = json['eventDetails'];
    eventType = json['eventType'];
    if (json['coordinators'] != null) {
      coordinators = [];
      json['coordinators'].forEach((v) {
        coordinators!.add((v));
      });
    }
    if (json['subEvents'] != null) {
      subEvents = [];
      json['subEvents'].forEach((v) {
        subEvents!.add((v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    filename = json['filename'];
    speakerId = json['speakerId'];
    speakerName = json['speakerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['eventName'] = this.eventName;
    data['eventDate'] = this.eventDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['moderator'] = this.moderator;
    data['bookingType'] = this.bookingType;
    data['genre'] = this.genre;
    data['categories'] = this.categories;
    data['conferenceId'] = this.conferenceId;
    data['venueName'] = this.venueName;
    data['venueId'] = this.venueId;
    data['slots'] = this.slots;
    data['eventDetails'] = this.eventDetails;
    data['eventType'] = this.eventType;
    if (this.coordinators != null) {
      data['coordinators'] = this.coordinators!.map((v) => v).toList();
    }
    if (this.subEvents != null) {
      data['subEvents'] = this.subEvents!.map((v) => v).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['filename'] = this.filename;
    data['speakerId'] = this.speakerId;
    data['speakerName'] = this.speakerName;
    return data;
  }



  bool isCurrentDateTimeBetween(String startTime, String endTime, String date) {
    // Define the time and date format
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Parse the date to get the DateTime object
    DateTime parsedDate = dateFormat.parse(date);

    // Create start and end DateTime objects by combining date with start and end times
    DateTime parsedStartDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      timeFormat.parse(startTime).hour,
      timeFormat.parse(startTime).minute,
    );

    DateTime parsedEndDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      timeFormat.parse(endTime).hour,
      timeFormat.parse(endTime).minute,
    );

    // Get the current date-time
    final now = DateTime.now();

    // Check if current date-time is between start and end date-time
    return now.isAfter(parsedStartDateTime) && now.isBefore(parsedEndDateTime);
  }

  bool isEventHappeningNow() {
    print("isEventHappeningNow");
    // Get today's date in 'yyyy-MM-dd' format
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if event date is today
    if (eventDate == today) {
      print("yesToday");
      // Get current time
      DateTime now = DateTime.now();
      String currentTime = DateFormat.Hm().format(now); // Format to HH:mm

      // Check if current time is between startTime and endTime
      if (startTime != null && endTime != null) {
        DateTime start = DateFormat.Hm().parse(startTime!);
        // DateTime end = DateFormat.Hm().parse(endTime!);
        // Set the date for start and end times to today's date
        // start = DateTime(now.year, now.month, now.day, start.hour, start.minute);
        // end = DateTime(now.year, now.month, now.day, end.hour, end.minute);
        print("$currentTime ${start}" );
        // return DateTime.parse(startTime!) < DateTime.parse(startTime!)? true : ;
        return false;
      }else{
        print("not today");
      }
    }
    return false;
  }
}
