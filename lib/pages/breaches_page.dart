import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/breach.dart';
import '../utils/formatters.dart';

class BreachesPage extends StatefulWidget {
  const BreachesPage({super.key});

  @override
  State<BreachesPage> createState() => _BreachesPageState();
}

class _BreachesPageState extends State<BreachesPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Breach> _breaches = [];
  List<Breach> _filteredBreaches = [];
  bool _isLoading = true;
  String? _selectedTarget;
  bool? _selectedUsefulness;

  @override
  void initState() {
    super.initState();
    _loadBreaches();
  }

  Future<void> _loadBreaches() async {
    setState(() => _isLoading = true);
    try {
      final breaches = await _firebaseService.fetchBreaches();
      setState(() {
        _breaches = breaches;
        _filteredBreaches = breaches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading breaches: $e')),
        );
      }
    }
  }

  void _filterBreaches() {
    setState(() {
      _filteredBreaches = _breaches.where((breach) {
        final targetMatch =
            _selectedTarget == null || breach.target == _selectedTarget;
        final usefulnessMatch =
            _selectedUsefulness == null || breach.usefulness == _selectedUsefulness;
        return targetMatch && usefulnessMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final targets = _breaches.map((e) => e.target).toSet().toList();
    final usefulnessLevels = _breaches.map((e) => e.usefulness).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Breaches'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Target filter
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedTarget,
                    hint: const Text('Filter by Target'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Targets'),
                      ),
                      ...targets.map((target) => DropdownMenuItem(
                            value: target,
                            child: Text(target),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedTarget = value;
                        _filterBreaches();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Usefulness filter
                Expanded(
                  child: DropdownButton<bool>(
                    value: _selectedUsefulness,
                    hint: const Text('Filter by Usefulness'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Usefulness Levels'),
                      ),
                      ...usefulnessLevels.map((usefulness) => DropdownMenuItem(
                            value: usefulness,
                            child: Text(usefulness ? 'Useful' : 'Not Useful'),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedUsefulness = value;
                        _filterBreaches();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadBreaches,
                    child: _filteredBreaches.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('No breach data available'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredBreaches.length,
                            itemBuilder: (context, index) {
                              final breach = _filteredBreaches[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(breach.target),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(breach.description),
                                      const SizedBox(height: 4),
                                      Text(
                                        Formatters.formatDate(breach.date),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
