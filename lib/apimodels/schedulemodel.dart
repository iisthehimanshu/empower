import 'package:intl/intl.dart';

class scheduleModel {
  List<Data>? data;
  bool? status;

  scheduleModel({this.data, this.status});

  scheduleModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? sId;
  String? eventName;
  String? eventDate;
  String? startTime;
  String? endTime;
  String? eventType;
  String? bookingType;
  List<String>? genre;
  String? categories;
  String? conferenceId;
  String? venueName;
  int? slots;
  String? eventDetails;
  String? moderator;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Coordinators>? coordinators;
  String? filename;
  List<SubEvents>? subEvents;
  String? venueId;

  Data(
      {this.sId,
        this.eventName,
        this.eventDate,
        this.startTime,
        this.endTime,
        this.eventType,
        this.bookingType,
        this.genre,
        this.categories,
        this.conferenceId,
        this.venueName,
        this.slots,
        this.eventDetails,
        this.moderator,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.coordinators,
        this.filename,
        this.subEvents,
        this.venueId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventName = json['eventName'];
    eventDate = json['eventDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    eventType = json['eventType'];
    bookingType = json['bookingType'];
    genre = json['genre'].cast<String>();
    categories = json['categories'];
    conferenceId = json['conferenceId'];
    venueName = json['venueName'];
    slots = json['slots'];
    eventDetails = json['eventDetails'];
    moderator = json['moderator'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['coordinators'] != null) {
      coordinators = <Coordinators>[];
      json['coordinators'].forEach((v) {
        coordinators!.add(new Coordinators.fromJson(v));
      });
    }
    filename = json['filename'];
    if (json['subEvents'] != null) {
      subEvents = <SubEvents>[];
      json['subEvents'].forEach((v) {
        subEvents!.add(new SubEvents.fromJson(v));
      });
    }
    venueId = json['venueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['eventName'] = this.eventName;
    data['eventDate'] = this.eventDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['eventType'] = this.eventType;
    data['bookingType'] = this.bookingType;
    data['genre'] = this.genre;
    data['categories'] = this.categories;
    data['conferenceId'] = this.conferenceId;
    data['venueName'] = this.venueName;
    data['slots'] = this.slots;
    data['eventDetails'] = this.eventDetails;
    data['moderator'] = this.moderator;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.coordinators != null) {
      data['coordinators'] = this.coordinators!.map((v) => v.toJson()).toList();
    }
    data['filename'] = this.filename;
    if (this.subEvents != null) {
      data['subEvents'] = this.subEvents!.map((v) => v.toJson()).toList();
    }
    data['venueId'] = this.venueId;
    return data;
  }

  bool isEventHappeningNow() {
    // Get today's date in 'yyyy-MM-dd' format
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if event date is today
    if (eventDate == today) {
      // Get current time
      DateTime now = DateTime.now();
      String currentTime = DateFormat.Hm().format(now); // Format to HH:mm

      // Check if current time is between startTime and endTime
      if (startTime != null && endTime != null) {
        DateTime start = DateFormat.Hm().parse(startTime!);
        DateTime end = DateFormat.Hm().parse(endTime!);
        // Set the date for start and end times to today's date
        start = DateTime(now.year, now.month, now.day, start.hour, start.minute);
        end = DateTime(now.year, now.month, now.day, end.hour, end.minute);
        return now.isAfter(start) && now.isBefore(end);
      }
    }
    return false;
  }

}

class Coordinators {
  String? name;
  String? mobile;
  String? sId;
  String? designation;

  Coordinators({this.name, this.mobile, this.sId, this.designation});

  Coordinators.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    sId = json['_id'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['_id'] = this.sId;
    data['designation'] = this.designation;
    return data;
  }
}

class SubEvents {
  String? name;
  String? date;
  String? startTime;
  String? endTime;
  String? sId;

  SubEvents({this.name, this.date, this.startTime, this.endTime, this.sId});

  SubEvents.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['_id'] = this.sId;
    return data;
  }
}
