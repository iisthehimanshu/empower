import 'package:intl/intl.dart';

import 'CardData.dart';

class ScheduleModel {
  List<CardData>? data;
  bool? status;
  List<Speakers>? speakers;
  List<CommiteeMembers>? commiteeMembers;  // Change to List<CommiteeMembers>?

  ScheduleModel({this.data, this.status, this.speakers, this.commiteeMembers});

  ScheduleModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <CardData>[];
      json['data'].forEach((v) {
        data!.add(CardData.fromJson(v));
      });
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
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

  Speakers(
      {this.sId,
        this.name,
        this.conferenceId,
        this.designation,
        this.dissabilities,
        this.type,
        this.filename,
        this.roles,
        this.iV});

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

  CommiteeMembers(
      {this.name,
        this.conferenceId,
        this.designation,
        this.dissabilities,
        this.type,
        this.filename,
        this.roles,
        this.sId});

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
    return data;
  }
}