import 'package:flutter/material.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'name': 'Free',
      'price': 0,
      'period': '',
      'color': Color(0xFF4A90E2),
      'isCurrent': true,
      'features': [],
    },
    {
      'name': 'Silver',
      'price': 25,
      'period': 'Month',
      'color': Color(0xFFFF9F43),
      'isCurrent': false,
      'features': [
        'Integrated Calendar to CRM',
        'Unlimited Appointments',
        'Text Service and Reminders',
      ],
    },
    {
      'name': 'Gold',
      'price': 35,
      'period': 'Month',
      'color': Color(0xFF74B9FF),
      'isCurrent': false,
      'features': [
        'Advanced Reporting',
        'Create Customer Profile',
        'Featured on Top of Searches',
      ],
    },
    {
      'name': 'Premium',
      'price': 45,
      'period': 'Month',
      'color': Color(0xFF00CEC9),
      'isCurrent': false,
      'features': [
        'Fully Integrated CRM Platform',
        'Send Customer Information',
        'Access Marketing Metrics',
        'Custom Market Trend Information',
        'Ecommerce Sales',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Subscription',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Plan Section
            _buildCurrentPlan(),
            SizedBox(height: AppSizes.lg),

            // Upgrade Section
            Text(
              'Upgrade',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppSizes.md),

            // Subscription Plans
            Expanded(
              child: ListView.builder(
                itemCount: subscriptionPlans.length - 1, // Exclude Free plan
                itemBuilder: (context, index) {
                  final plan = subscriptionPlans[index + 1]; // Skip Free plan
                  return _buildSubscriptionCard(plan);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlan() {
    final currentPlan = subscriptionPlans.firstWhere((plan) => plan['isCurrent']);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
        gradient: LinearGradient(
          colors: [currentPlan['color'], currentPlan['color'].withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                currentPlan['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Add paw print decoration
          Positioned(
            right: 20,
            top: 20,
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.pets,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> plan) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
        color: plan['color'],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                ),
                child: Text(
                  plan['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${plan['price']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' /${plan['period']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          Text(
            'Features:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          ...plan['features'].map<Widget>((feature) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6, right: AppSizes.xs),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        feature,
                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white,
                         height: 1.2,
                      ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }
}