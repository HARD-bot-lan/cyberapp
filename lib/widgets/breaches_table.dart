import 'package:flutter/material.dart';
import '../models/breach.dart';
import '../utils/formatters.dart';

class BreachesTable extends StatelessWidget {
  final List<Breach> breaches;

  const BreachesTable({
    super.key,
    required this.breaches,
  });

  @override
  Widget build(BuildContext context) {
    if (breaches.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No breach data available'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Target')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Description')),
        ],
        rows: breaches.map((breach) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  breach.target,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DataCell(Text(Formatters.formatDate(breach.date))),
              DataCell(Text(breach.description)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
