import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_entry.dart';
import 'add_entry_screen.dart';
import '../services/excel_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InventoryEntry> entries = [];

  int get totalPackages => entries.fold(0, (s, e) => s + e.packages);
  double get totalM3 => entries.fold(0, (s, e) => s + e.totalM3);

  void addEntry(InventoryEntry e) {
    setState(() => entries.add(e));
  }

  void deleteEntry(String id) {
    setState(() => entries.removeWhere((e) => e.id == id));
  }

  void copyEntry(InventoryEntry e) {
    setState(() {
      entries.add(InventoryEntry(
        id: const Uuid().v4(),
        area: e.area,
        grade: e.grade,
        size: e.size,
        packages: e.packages,
        m3PerPackage: e.m3PerPackage,
        totalM3: e.totalM3,
        month: e.month,
        year: e.year,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Tool')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (c, i) {
                final e = entries[i];
                return Card(
                  child: ListTile(
                    title: Text('${e.area} | ${e.grade} | ${e.packages} pk'),
                    subtitle: Text('${e.totalM3.toStringAsFixed(3)} m³'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => copyEntry(e), icon: const Icon(Icons.copy)),
                        IconButton(onPressed: () => deleteEntry(e.id), icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Text('📦 Pakas kopā: \$totalPackages'),
                Text('📐 m³ kopā: \${totalM3.toStringAsFixed(3)}'),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEntryScreen()),
                    );
                    if (result != null) addEntry(result);
                  },
                  child: const Text('➕ Add'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ExcelService.export(entries),
                  child: const Text('📤 Excel'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
