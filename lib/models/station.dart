class Station {
  late String name;
  late String source;
  late String logo;
  late String location;

  Station(
      {required this.name,
      required this.source,
      required this.logo,
      required this.location});

  Map<String, dynamic> toMap() {
    var map = {
      "name": name,
      "source": source,
      "logo": logo,
      "location": location,
    };
    return map;
  }

  Station.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    source = json['source'];
    logo = json['logo'];
    location = json['location'];
  }
}
