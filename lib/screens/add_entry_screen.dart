import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_entry.dart';
import '../data/grade_data.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final areaCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final pkgCtrl = TextEditingController();

  String grade = '1a';
  double m3PerPackage = 0.01026;

  double get total =>
      (int.tryParse(pkgCtrl.text) ?? 0) * m3PerPackage;

  void save() {
    final packages = int.tryParse(pkgCtrl.text) ?? 0;

    Navigator.pop(
      context,
      InventoryEntry(
        id: const Uuid().v4(),
        area: areaCtrl.text,
        grade: grade,
        size: sizeCtrl.text,
        packages: packages,
        m3PerPackage: m3PerPackage,
        totalM3: packages * m3PerPackage,
        month: DateTime.now().month,
        year: DateTime.now().year,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: areaCtrl, decoration: const InputDecoration(labelText: 'Apgabals')),
            TextField(controller: sizeCtrl, decoration: const InputDecoration(labelText: 'Izmērs')),
            TextField(controller: pkgCtrl, decoration: const InputDecoration(labelText: 'Pakas'), onChanged: (_) => setState(() {})),
            DropdownButton<String>(
              value: grade,
              isExpanded: true,
              items: GradeData.grades.map((g) {
                return DropdownMenuItem(
                  value: g['code'],
                  child: Text('\${g['code']} — \${g['desc']}'),
                );
              }).toList(),
              onChanged: (v) => setState(() => grade = v!),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade100,
              child: Text('📐 m³ kopā: \${total.toStringAsFixed(3)}'),
            ),
            const Spacer(),
            ElevatedButton(onPressed: save, child: const Text('Saglabāt'))
          ],
        ),
      ),
    );
  }
}
