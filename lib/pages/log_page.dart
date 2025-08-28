import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/log_provider.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logProvider = Provider.of<LogProvider>(context);
    final todayLog = logProvider.todayLog;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: todayLog.isEmpty
            ? const Center(
                child: Text(
                  'No food added today.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1A237E), // Navy blue
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: todayLog.length,
                itemBuilder: (context, i) {
                  final entry = todayLog[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Color(0xFF1A237E).withOpacity(0.2),
                      ),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF1A237E).withOpacity(0.1),
                        child: const Icon(
                          Icons.fastfood,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      title: Text(
                        entry.food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      subtitle: Text(
                        '${entry.food.calories} kcal x ${entry.quantity}',
                        style: TextStyle(
                          color: Color(0xFF1A237E).withOpacity(0.7),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${entry.food.calories * entry.quantity} kcal',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () =>
                                _showRemoveDialog(context, entry, logProvider),
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Color(0xFF1A237E),
                            ),
                            iconSize: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, entry, LogProvider logProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xFF1A237E).withOpacity(0.3)),
        ),
        title: const Text(
          'Remove Food',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${entry.food.name}" from your log?',
          style: TextStyle(color: Color(0xFF1A237E).withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF1A237E)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1A237E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              logProvider.removeLog(entry);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${entry.food.name} removed from log'),
                  backgroundColor: Color(0xFF1A237E),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
