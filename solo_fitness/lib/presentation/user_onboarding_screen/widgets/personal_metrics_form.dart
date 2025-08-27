import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalMetricsForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const PersonalMetricsForm({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<PersonalMetricsForm> createState() => _PersonalMetricsFormState();
}

class _PersonalMetricsFormState extends State<PersonalMetricsForm> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _weightController.text = widget.initialData['weight']?.toString() ?? '';
    _heightController.text = widget.initialData['height']?.toString() ?? '';
    _ageController.text = widget.initialData['age']?.toString() ?? '';
    _selectedGender = widget.initialData['gender'] ?? 'Male';
  }

  void _updateData() {
    final data = {
      'weight': double.tryParse(_weightController.text),
      'height': double.tryParse(_heightController.text),
      'age': int.tryParse(_ageController.text),
      'gender': _selectedGender,
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Metrics',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Help us customize your fitness journey',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 3.h),

          // Weight Input
          _buildMetricField(
            label: 'Weight (kg)',
            controller: _weightController,
            icon: 'monitor_weight',
            suffix: 'kg',
            inputType: TextInputType.numberWithOptions(decimal: true),
          ),

          SizedBox(height: 2.h),

          // Height Input
          _buildMetricField(
            label: 'Height (cm)',
            controller: _heightController,
            icon: 'height',
            suffix: 'cm',
            inputType: TextInputType.number,
          ),

          SizedBox(height: 2.h),

          // Age Input
          _buildMetricField(
            label: 'Age',
            controller: _ageController,
            icon: 'cake',
            suffix: 'years',
            inputType: TextInputType.number,
          ),

          SizedBox(height: 2.h),

          // Gender Selection
          _buildGenderSelection(),
        ],
      ),
    );
  }

  Widget _buildMetricField({
    required String label,
    required TextEditingController controller,
    required String icon,
    required String suffix,
    required TextInputType inputType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
            onChanged: (value) => _updateData(),
            inputFormatters: inputType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.primaryBlue,
                  size: 5.w,
                ),
              ),
              suffixText: suffix,
              suffixStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
            color: AppTheme.backgroundMid,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              dropdownColor: AppTheme.backgroundMid,
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.primaryBlue,
                size: 6.w,
              ),
              items: _genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                  _updateData();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
