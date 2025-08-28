import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _heightFtController;
  late TextEditingController _heightInController;
  String _heightUnit = 'cm';
  String _gender = 'Male';
  double _weight = 70;
  final List<String> _goals = [
    'Maintain',
    'Weight Loss',
    'Weight Gain',
    'Muscle Build',
  ];
  String _goal = 'Maintain';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user.name);
    _heightController = TextEditingController(text: user.height.toString());
    _weightController = TextEditingController(text: user.weight.toString());
    _heightFtController = TextEditingController();
    _heightInController = TextEditingController();
    _goal = user.fitnessGoal;
    _gender = user.gender;
    _weight = user.weight;

    // Convert cm to ft/in if needed
    double totalInches = user.height / 2.54;
    int ft = totalInches ~/ 12;
    int inch = (totalInches % 12).round();
    _heightFtController.text = ft.toString();
    _heightInController.text = inch.toString();

    // Initialize animations
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
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    super.dispose();
  }

  void _saveProfile(UserProvider userProvider) {
    double heightCm;
    if (_heightUnit == 'cm') {
      heightCm = double.tryParse(_heightController.text) ?? 0;
    } else {
      int ft = int.tryParse(_heightFtController.text) ?? 0;
      int inch = int.tryParse(_heightInController.text) ?? 0;
      heightCm = (ft * 12 + inch) * 2.54;
    }
    userProvider.updateUser(
      name: _nameController.text,
      height: heightCm,
      weight: _weight,
      fitnessGoal: _goal,
      gender: _gender,
      recalculateCalories: true,
    );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile updated!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1A237E), // Navy blue
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // White background
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A237E), // Navy blue background
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Profile & Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isEditing ? Icons.close : Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                setState(() => _isEditing = !_isEditing),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: !_isEditing
                            ? _buildViewMode(user)
                            : _buildEditMode(userProvider),
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

  Widget _buildViewMode(user) {
    return ListView(
      children: [
        _buildProfileCard('Name', user.name, Icons.person),
        _buildProfileCard(
          'Height',
          '${user.height.toStringAsFixed(1)} cm',
          Icons.height,
        ),
        _buildProfileCard(
          'Weight',
          '${user.weight.toStringAsFixed(1)} kg',
          Icons.monitor_weight,
        ),
        _buildProfileCard('Fitness Goal', user.fitnessGoal, Icons.flag),
        _buildProfileCard(
          'Daily Calorie Goal',
          '${user.calorieGoal} kcal',
          Icons.local_fire_department,
        ),
        _buildProfileCard('Gender', user.gender, Icons.wc),
      ],
    );
  }

  Widget _buildProfileCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A237E),
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A237E).withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildEditMode(UserProvider userProvider) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildEditField('Name', _nameController, Icons.person),
          const SizedBox(height: 16),
          _buildHeightInput(),
          const SizedBox(height: 16),
          _buildWeightSlider(),
          const SizedBox(height: 16),
          _buildGenderSelector(),
          const SizedBox(height: 16),
          _buildGoalSelector(),
          const SizedBox(height: 32),
          Container(
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
              icon: const Icon(Icons.save, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () => _saveProfile(userProvider),
              label: const Text(
                'Save Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF1A237E)),
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
          ),
        ),
        style: const TextStyle(color: Color(0xFF1A237E)),
        validator: (val) => val!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildHeightInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Height',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'cm', label: Text('cm')),
                    ButtonSegment(value: 'ft', label: Text('ft/in')),
                  ],
                  selected: {_heightUnit},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _heightUnit = newSelection.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      Set<MaterialState> states,
                    ) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFF1A237E);
                      }
                      return Colors.white;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((
                      Set<MaterialState> states,
                    ) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return const Color(0xFF1A237E);
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_heightUnit == 'cm')
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                labelStyle: TextStyle(color: Color(0xFF1A237E)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
              ),
              style: const TextStyle(color: Color(0xFF1A237E)),
              keyboardType: TextInputType.number,
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightFtController,
                    decoration: const InputDecoration(
                      labelText: 'Feet',
                      labelStyle: TextStyle(color: Color(0xFF1A237E)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1A237E),
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1A237E)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _heightInController,
                    decoration: const InputDecoration(
                      labelText: 'Inches',
                      labelStyle: TextStyle(color: Color(0xFF1A237E)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1A237E),
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1A237E)),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildWeightSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight: ${_weight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A237E),
            ),
          ),
          Slider(
            value: _weight,
            min: 30,
            max: 200,
            divisions: 170,
            activeColor: const Color(0xFF1A237E),
            inactiveColor: const Color(0xFF1A237E).withOpacity(0.3),
            onChanged: (val) => setState(() => _weight = val),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Male', label: Text('Male')),
              ButtonSegment(value: 'Female', label: Text('Female')),
            ],
            selected: {_gender},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _gender = newSelection.first);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFF1A237E);
                }
                return Colors.white;
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFF1A237E);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fitness Goal',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _goal,
            items: _goals
                .map(
                  (goal) => DropdownMenuItem(
                    value: goal,
                    child: Text(
                      goal,
                      style: const TextStyle(color: Color(0xFF1A237E)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _goal = val!),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
              ),
            ),
            style: const TextStyle(color: Color(0xFF1A237E)),
            iconEnabledColor: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }
}
