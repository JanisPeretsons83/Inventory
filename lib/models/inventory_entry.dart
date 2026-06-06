class InventoryEntry {
  String id;
  String area;
  String grade;
  String size;
  int packages;
  double m3PerPackage;
  double totalM3;
  int month;
  int year;

  InventoryEntry({
    required this.id,
    required this.area,
    required this.grade,
    required this.size,
    required this.packages,
    required this.m3PerPackage,
    required this.totalM3,
    required this.month,
    required this.year,
  });
}
