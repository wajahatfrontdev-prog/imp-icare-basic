void main() {
  dynamic lab = {
    'location': {
      'type': 'Point',
      'coordinates': [0, 0],
    },
  };
  dynamic result = lab['address'] is String
      ? lab['address']
      : (lab['location'] is String
            ? lab['location']
            : 'Location not available');
  print('Result: $result');
  print('Is String: ${result is String}');

  String explicit = lab['address'] is String
      ? lab['address']
      : (lab['location'] is String
            ? lab['location']
            : 'Location not available');
  print(explicit);
}
