class Percurso {
  final List<List<double>> coordinates;

  Percurso({required this.coordinates});

  factory Percurso.fromJson(Map<String, dynamic> json) {
    List<List<double>> coords = [];
    if (json['features'] != null && json['features'] is List) {
      for (var feature in json['features']) {
        if (feature['geometry'] != null && feature['geometry']['coordinates'] != null) {
          for (var coord in feature['geometry']['coordinates']) {
            coords.add(List<double>.from(coord));
          }
        }
      }
    }
    return Percurso(coordinates: coords);
  }
}
