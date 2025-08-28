import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../providers/log_provider.dart';
import '../models/food_model.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  String search = '';
  String selectedRegion = 'All';
  final TextEditingController _manualName = TextEditingController();
  final TextEditingController _manualCalories = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> regions = [
    'All',
    'Global',
    'North India',
    'South India',
    'East India',
    'West India',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _manualName.dispose();
    _manualCalories.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final logProvider = Provider.of<LogProvider>(context);
    List foods = search.isEmpty
        ? foodProvider.filterByRegion(selectedRegion)
        : foodProvider
              .filterByRegion(selectedRegion)
              .where(
                (food) =>
                    food.name.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // White background
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    child: Text(
                      '🍎 Food Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E), // Navy blue
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF1A237E).withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A237E).withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'e.g. Dosa',
                              hintStyle: TextStyle(
                                color: const Color(0xFF1A237E).withOpacity(0.6),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF1A237E),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFF1A237E,
                              ).withOpacity(0.05),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1A237E),
                                  width: 2,
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Color(0xFF1A237E)),
                            onChanged: (val) => setState(() => search = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: selectedRegion,
                            items: regions
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(
                                      r,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedRegion = val ?? 'All'),
                            underline: Container(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            dropdownColor: const Color(0xFF1A237E),
                            iconEnabledColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foods.length,
                    itemBuilder: (context, i) {
                      final food = foods[i];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (i * 50)),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: const Color(0xFF1A237E).withOpacity(0.2),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                food.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              subtitle: Text(
                                '${food.calories} kcal • ${food.region}',
                                style: TextStyle(
                                  color: const Color(
                                    0xFF1A237E,
                                  ).withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A237E),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _showAddFoodDialog(
                                    context,
                                    food,
                                    logProvider,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A237E).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          _showManualAddDialog(context, logProvider),
                      label: const Text(
                        'Add Custom Food',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddFoodDialog(
    BuildContext context,
    FoodModel food,
    LogProvider logProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.3)),
        ),
        title: Text(
          'Add ${food.name}',
          style: const TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: _quantityController,
          decoration: InputDecoration(
            labelText: 'Quantity',
            labelStyle: const TextStyle(color: Color(0xFF1A237E)),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF1A237E).withOpacity(0.3),
              ),
            ),
          ),
          style: const TextStyle(color: Color(0xFF1A237E)),
          keyboardType: TextInputType.number,
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
              backgroundColor: const Color(0xFF1A237E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final qty = double.tryParse(_quantityController.text) ?? 1;
              logProvider.addLog(food, qty.round());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Food added!'),
                  backgroundColor: const Color(0xFF1A237E),
                ),
              );
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showManualAddDialog(BuildContext context, LogProvider logProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.3)),
        ),
        title: const Text(
          'Add Custom Food',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _manualName,
              decoration: InputDecoration(
                labelText: 'Food Name',
                labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF1A237E).withOpacity(0.3),
                  ),
                ),
              ),
              style: const TextStyle(color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _manualCalories,
              decoration: InputDecoration(
                labelText: 'Calories per 100g',
                labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF1A237E).withOpacity(0.3),
                  ),
                ),
              ),
              style: const TextStyle(color: Color(0xFF1A237E)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity (g)',
                labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF1A237E).withOpacity(0.3),
                  ),
                ),
              ),
              style: const TextStyle(color: Color(0xFF1A237E)),
              keyboardType: TextInputType.number,
            ),
          ],
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
              backgroundColor: const Color(0xFF1A237E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_manualName.text.isNotEmpty &&
                  _manualCalories.text.isNotEmpty) {
                final calories = int.tryParse(_manualCalories.text) ?? 0;
                final qty = double.tryParse(_quantityController.text) ?? 100;
                final food = FoodModel(
                  name: _manualName.text,
                  calories: calories,
                  region: 'Custom',
                );
                logProvider.addLog(food, (qty / 100).round());
                Navigator.pop(context);
                _manualName.clear();
                _manualCalories.clear();
                _quantityController.text = '1';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custom food added!'),
                    backgroundColor: Color(0xFF1A237E),
                  ),
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
