class Holiday {
  Meta? meta;
  Response? response;

  Holiday({this.meta, this.response});

  Holiday.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Meta {
  int? code;

  Meta({this.code});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Response {
  List<Holidays>? holidays;

  Response({this.holidays});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['holidays'] != null) {
      holidays = <Holidays>[];
      json['holidays'].forEach((v) {
        holidays!.add(new Holidays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.holidays != null) {
      data['holidays'] = this.holidays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Holidays {
  String? name;
  String? description;
  Country? country;
  Date? date;
  List<String>? type;
  String? primaryType;
  String? canonicalUrl;
  String? urlid;
  String? locations;
  String? states;

  Holidays(
      {this.name,
        this.description,
        this.country,
        this.date,
        this.type,
        this.primaryType,
        this.canonicalUrl,
        this.urlid,
        this.locations,
        this.states});

  Holidays.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    type = json['type'].cast<String>();
    primaryType = json['primary_type'];
    canonicalUrl = json['canonical_url'];
    urlid = json['urlid'];
    locations = json['locations'];
    states = json['states'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    data['type'] = this.type;
    data['primary_type'] = this.primaryType;
    data['canonical_url'] = this.canonicalUrl;
    data['urlid'] = this.urlid;
    data['locations'] = this.locations;
    data['states'] = this.states;
    return data;
  }
}

class Country {
  String? id;
  String? name;

  Country({this.id, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Date {
  String? iso;
  Datetime? datetime;
  Timezone? timezone;

  Date({this.iso, this.datetime, this.timezone});

  Date.fromJson(Map<String, dynamic> json) {
    iso = json['iso'];
    datetime = json['datetime'] != null
        ? new Datetime.fromJson(json['datetime'])
        : null;
    timezone = json['timezone'] != null
        ? new Timezone.fromJson(json['timezone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso'] = this.iso;
    if (this.datetime != null) {
      data['datetime'] = this.datetime!.toJson();
    }
    if (this.timezone != null) {
      data['timezone'] = this.timezone!.toJson();
    }
    return data;
  }
}

class Datetime {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;

  Datetime(
      {this.year, this.month, this.day, this.hour, this.minute, this.second});

  Datetime.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['second'] = this.second;
    return data;
  }
}

class Timezone {
  String? offset;
  String? zoneabb;
  int? zoneoffset;
  int? zonedst;
  int? zonetotaloffset;

  Timezone(
      {this.offset,
        this.zoneabb,
        this.zoneoffset,
        this.zonedst,
        this.zonetotaloffset});

  Timezone.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    zoneabb = json['zoneabb'];
    zoneoffset = json['zoneoffset'];
    zonedst = json['zonedst'];
    zonetotaloffset = json['zonetotaloffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['zoneabb'] = this.zoneabb;
    data['zoneoffset'] = this.zoneoffset;
    data['zonedst'] = this.zonedst;
    data['zonetotaloffset'] = this.zonetotaloffset;
    return data;
  }
}
// class HolidaysModel {
//   String? name;
//   String? nameLocal;
//   String? language;
//   String? description;
//   String? country;
//   String? location;
//   String? type;
//   String? date;
//   String? dateYear;
//   String? dateMonth;
//   String? dateDay;
//   String? weekDay;
//
//   HolidaysModel(
//       {this.name,
//         this.nameLocal,
//         this.language,
//         this.description,
//         this.country,
//         this.location,
//         this.type,
//         this.date,
//         this.dateYear,
//         this.dateMonth,
//         this.dateDay,
//         this.weekDay});
//
//   HolidaysModel.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     nameLocal = json['name_local'];
//     language = json['language'];
//     description = json['description'];
//     country = json['country'];
//     location = json['location'];
//     type = json['type'];
//     date = json['date'];
//     dateYear = json['date_year'];
//     dateMonth = json['date_month'];
//     dateDay = json['date_day'];
//     weekDay = json['week_day'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['name_local'] = this.nameLocal;
//     data['language'] = this.language;
//     data['description'] = this.description;
//     data['country'] = this.country;
//     data['location'] = this.location;
//     data['type'] = this.type;
//     data['date'] = this.date;
//     data['date_year'] = this.dateYear;
//     data['date_month'] = this.dateMonth;
//     data['date_day'] = this.dateDay;
//     data['week_day'] = this.weekDay;
//     return data;
//   }


