class ConferenceAllAPIModel {
  bool? status;
  List<Data>? data;

  ConferenceAllAPIModel({this.status, this.data});

  ConferenceAllAPIModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? conferenceName;
  String? startDate;
  String? endDate;
  String? venueName;
  String? address;
  String? location;
  String? filename;
  String? mobile;
  String? email;
  String? website;
  List<String>? sponsors;
  List<CarouselImages>? carouselImages;
  String? information;
  String? about;
  int? iV;
  String? buildingId;
  List<String>? categories;
  String? primaryLogo;
  String? secondaryLogo;
  String? ternaryLogo;

  Data(
      {this.sId,
        this.conferenceName,
        this.startDate,
        this.endDate,
        this.venueName,
        this.address,
        this.location,
        this.filename,
        this.mobile,
        this.email,
        this.website,
        this.sponsors,
        this.carouselImages,
        this.information,
        this.about,
        this.iV,
        this.buildingId,
        this.categories,
        this.primaryLogo,
        this.secondaryLogo,
        this.ternaryLogo});

  Data.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    conferenceName = json['conferenceName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    venueName = json['venueName'];
    address = json['address'];
    location = json['location'];
    filename = json['filename'];
    mobile = json['mobile'];
    email = json['email'];
    website = json['website'];
    if (json['sponsors'] != null) {
      sponsors = <String>[];
      json['sponsors'].forEach((v) {
        sponsors!.add(v);
      });
    }
    if (json['carouselImages'] != null) {
      carouselImages = <CarouselImages>[];
      json['carouselImages'].forEach((v) {
        carouselImages!.add(new CarouselImages.fromJson(v));
      });
    }
    information = json['information'];
    about = json['about'];
    iV = json['__v'];
    buildingId = json['buildingId'];
    if (json['categories'] != null) {
      categories = <String>[];
      json['categories'].forEach((v) {
        categories!.add(v);
      });
    }
    primaryLogo = json['primaryLogo'];
    secondaryLogo = json['secondaryLogo'];
    ternaryLogo = json['ternaryLogo'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['_id'] = this.sId;
    data['conferenceName'] = this.conferenceName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['venueName'] = this.venueName;
    data['address'] = this.address;
    data['location'] = this.location;
    data['filename'] = this.filename;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['website'] = this.website;
    if (this.sponsors != null) {
      data['sponsors'] = this.sponsors!.map((v) => v).toList();
    }
    if (this.carouselImages != null) {
      data['carouselImages'] =
          this.carouselImages!.map((v) => v.toJson()).toList();
    }
    data['information'] = this.information;
    data['about'] = this.about;
    data['__v'] = this.iV;
    data['buildingId'] = this.buildingId;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v).toList();
    }
    data['primaryLogo'] = this.primaryLogo;
    data['secondaryLogo'] = this.secondaryLogo;
    data['ternaryLogo'] = this.ternaryLogo;
    return data;
  }
}

class CarouselImages {
  String? filename;
  String? description;
  String? redirectUrl;

  CarouselImages({this.filename, this.description, this.redirectUrl});

  CarouselImages.fromJson(Map<dynamic, dynamic> json) {
    filename = json['filename'];
    description = json['description'];
    redirectUrl = json['redirectUrl'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['filename'] = this.filename;
    data['description'] = this.description;
    data['redirectUrl'] = this.redirectUrl;
    return data;
  }
}