import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

class AddOnsChecklist extends StatefulWidget {
  const AddOnsChecklist({super.key});

  @override
  State<AddOnsChecklist> createState() => _AddOnsChecklistState();
}

class _AddOnsChecklistState extends State<AddOnsChecklist> {
  final List<Map<String, dynamic>> addOns = [
    {'title': 'lorem ipsum (\$4+)', 'selected': false},
    {'title': 'lorem ipsum (\$4+)', 'selected': false},
    {'title': 'lorem ipsum (\$4+)', 'selected': false},
    {'title': 'lorem ipsum (\$4+)', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Add Ons',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSizeMd,
            color: AppColors.primary,
          ),
        ),
        ...addOns.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Row(
            children: [
              Expanded(
                child: Text(
                  item['title'],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(width: 1,   color: AppColors.primary),
                value: item['selected'],
                onChanged: (value) {
                  setState(() {
                    addOns[index]['selected'] = value!;
                  });
                },
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
