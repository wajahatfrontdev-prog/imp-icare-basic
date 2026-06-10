class LabTest {
  final String id;
  final String name;
  final double price;
  bool isSelected;

  LabTest({
    required this.id,
    required this.name,
    required this.price,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}
