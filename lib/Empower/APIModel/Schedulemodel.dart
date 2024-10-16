import 'package:intl/intl.dart';

import 'CardData.dart';

class ScheduleModel {
  List<CardData>? data;
  bool? status;
  List<Speakers>? speakers;
  List<CommiteeMembers>? commiteeMembers;  // Change to List<CommiteeMembers>?
  List<ThemesAndSessions>? themesAndSessions;
  List<String>? organizationTeam;
  List<Exhibitors>? exhibitors;
  Map<String,List<CardData>>? groupedDataByVenue;


  ScheduleModel({this.data, this.status, this.speakers, this.commiteeMembers,this.themesAndSessions,this.organizationTeam,
    this.exhibitors, this.groupedDataByVenue});

  ScheduleModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <CardData>[];
      json['data'].forEach((v) {
        data!.add(CardData.fromJson(v));
      });
      groupedDataByVenue = groupByVenueId(data!);
    }
    status = json['status'];
    if (json['speakers'] != null) {
      speakers = <Speakers>[];
      json['speakers'].forEach((v) {
        speakers!.add(Speakers.fromJson(v));
      });
    }
    // Update the parsing for commiteeMembers to handle a list
    if (json['commiteeMembers'] != null) {
      commiteeMembers = <CommiteeMembers>[];
      json['commiteeMembers'].forEach((v) {
        commiteeMembers!.add(CommiteeMembers.fromJson(v));
      });
    }
    if (json['themesAndSessions'] != null) {
      themesAndSessions = <ThemesAndSessions>[];
      json['themesAndSessions'].forEach((v) {
        themesAndSessions!.add(new ThemesAndSessions.fromJson(v));
      });
    }
    organizationTeam = json['organizationTeam'].cast<String>();
    if (json['exhibitors'] != null) {
      exhibitors = <Exhibitors>[];
      json['exhibitors'].forEach((v) {
        exhibitors!.add(new Exhibitors.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.speakers != null) {
      data['speakers'] = this.speakers!.map((v) => v.toJson()).toList();
    }
    if (this.commiteeMembers != null) {
      data['commiteeMembers'] = this.commiteeMembers!.map((v) => v.toJson()).toList();
    }
    if (this.themesAndSessions != null) {
      data['themesAndSessions'] =
          this.themesAndSessions!.map((v) => v.toJson()).toList();
    }
    data['organizationTeam'] = this.organizationTeam;
    if (this.exhibitors != null) {
      data['exhibitors'] = this.exhibitors!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, List<CardData>> groupByVenueId(List<CardData> cardDataList) {
    Map<String, List<CardData>> venueMap = {};

    for (var cardData in cardDataList) {
      // Check if the venueId exists in the map
      if (cardData.venueId != null) {
        if (venueMap.containsKey(cardData.venueId)) {
          // If venueId already exists, add the card to the list
          venueMap[cardData.venueId]!.add(cardData);
        } else {
          // If venueId doesn't exist, create a new list with this card
          venueMap[cardData.venueId!] = [cardData];
        }
      }
    }

    return venueMap;
  }


}

class Speakers {
  String? sId;
  String? name;
  String? conferenceId;
  String? designation;
  List<Null>? dissabilities;
  String? type;
  String? filename;
  List<String>? roles;
  int? iV;
  String? about;


  Speakers(
      {this.sId,
        this.name,
        this.conferenceId,
        this.designation,
        this.dissabilities,
        this.type,
        this.filename,
        this.roles,
        this.iV,this.about});

  Speakers.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    conferenceId = json['conferenceId'];
    designation = json['designation'];
    if (json['dissabilities'] != null) {
      dissabilities = [];
      json['dissabilities'].forEach((v) {
        dissabilities!.add(v);
      });
    }
    type = json['type'];
    filename = json['filename'];
    roles = json['roles'].cast<String>();
    iV = json['__v'];
    about = json['about'];

  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['conferenceId'] = this.conferenceId;
    data['designation'] = this.designation;
    if (this.dissabilities != null) {
      data['dissabilities'] =
          this.dissabilities!.map((v) => v).toList();
    }
    data['type'] = this.type;
    data['filename'] = this.filename;
    data['roles'] = this.roles;
    data['__v'] = this.iV;
    data['about'] = this.about;

    return data;
  }
}

class ThemesAndSessions {
  String? sId;
  String? themeName;
  List<String>? eventIds;
  String? conferenceId;
  List<String>? dates;
  List<String>? times;
  int? order;
  int? iV;

  ThemesAndSessions({this.sId,
        this.themeName,
        this.eventIds,
        this.conferenceId,
        this.dates,
    this.times,
        this.order,
        this.iV});

  ThemesAndSessions.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    themeName = json['themeName'];
    eventIds = json['eventIds'].cast<String>();
    conferenceId = json['conferenceId'];
    if (json['dates'] != null) {
      dates = <String>[];
      json['dates'].forEach((v) {
        dates!.add(v);
      });
    }

    if (json['times'] != null) {
      times = <String>[];
      json['times'].forEach((v) {
        times!.add(v);
      });
    }

    order = json['order'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['themeName'] = this.themeName;
    data['eventIds'] = this.eventIds;
    data['conferenceId'] = this.conferenceId;
    if (this.dates != null) {
      data['dates'] = this.dates!.map((v) => v).toList();
    }
    if (this.times != null) {
      data['times'] = this.times!.map((v) => v).toList();
    }
    data['order'] = this.order;
    data['__v'] = this.iV;
    return data;
  }
}

class CommiteeMembers {
  String? name;
  String? conferenceId;
  String? designation;
  List<String>? dissabilities;
  String? type;
  String? filename;
  List<String>? roles;
  String? sId;
  String? about;

  CommiteeMembers(
      {this.name,
        this.conferenceId,
        this.designation,
        this.dissabilities,
        this.type,
        this.filename,
        this.roles,
        this.sId,this.about});

  CommiteeMembers.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    conferenceId = json['conferenceId'];
    designation = json['designation'];
    if (json['dissabilities'] != null) {
      dissabilities = <String>[];
      json['dissabilities'].forEach((v) {
        dissabilities!.add(v);
      });
    }
    type = json['type'];
    filename = json['filename'];
    roles = json['roles'].cast<String>();
    sId = json['_id'];
    about = json['about'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['name'] = this.name;
    data['conferenceId'] = this.conferenceId;
    data['designation'] = this.designation;
    if (this.dissabilities != null) {
      data['dissabilities'] =
          this.dissabilities!.map((v) => v).toList();
    }
    data['type'] = this.type;
    data['filename'] = this.filename;
    data['roles'] = this.roles;
    data['_id'] = this.sId;
    data['about'] = this.about;
    return data;
  }
}

class Exhibitors {
  String? sId;
  String? companyName;
  String? contactPersionName;
  String? about;
  String? emailAndPhone;
  String? website;
  String? linkedIn;
  String? boothNo;
  String? venueId;
  String? filename;
  int? iV;

  Exhibitors(
      {this.sId,
        this.companyName,
        this.contactPersionName,
        this.about,
        this.emailAndPhone,
        this.website,
        this.linkedIn,
        this.boothNo,
        this.venueId,
        this.filename,
        this.iV});

  Exhibitors.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    companyName = json['companyName'];
    contactPersionName = json['contactPersionName'];
    about = json['about'];
    emailAndPhone = json['emailAndPhone'];
    website = json['website'];
    linkedIn = json['linkedIn'];
    boothNo = json['boothNo'];
    venueId = json['venueId'];
    filename = json['filename'];
    iV = json['__v'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['_id'] = this.sId;
    data['companyName'] = this.companyName;
    data['contactPersionName'] = this.contactPersionName;
    data['about'] = this.about;
    data['emailAndPhone'] = this.emailAndPhone;
    data['website'] = this.website;
    data['linkedIn'] = this.linkedIn;
    data['boothNo'] = this.boothNo;
    data['venueId'] = this.venueId;
    data['filename'] = this.filename;
    data['__v'] = this.iV;
    return data;
  }
}