import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/role_switching_service.dart';
import '../services/user_session_service.dart';
import '../features/screen/Navigation.dart';
import '../features/screen/business/BusinessProfileScreen.dart';
import '../utlis/constants/colors.dart';

/// Simple test widget for role switching functionality
class SimpleRoleSwitchTest extends StatefulWidget {
  const SimpleRoleSwitchTest({Key? key}) : super(key: key);

  @override
  State<SimpleRoleSwitchTest> createState() => _SimpleRoleSwitchTestState();
}

class _SimpleRoleSwitchTestState extends State<SimpleRoleSwitchTest> {
  String? _currentUserType;
  bool _isLoading = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserType();
  }

  Future<void> _loadCurrentUserType() async {
    final userType = await UserSessionService.getCurrentUserType();
    setState(() {
      _currentUserType = userType ?? 'Unknown';
    });
  }

  Future<void> _testDirectRoleSwitch() async {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    try {
      // Determine target role
      final targetRole = _currentUserType == 'Business' ? 'Pet Owner' : 'Business';
      
      // Test the API call directly
      final result = await RoleSwitchingService.switchRole(targetRole);
      
      setState(() {
        _testResult = 'SUCCESS: Switched to $targetRole\nMessage: ${result['message']}';
      });

      // Update current user type
      await _loadCurrentUserType();

      // Navigate to appropriate screen
      Widget targetScreen = targetRole == 'Pet Owner' 
          ? const CurvedNavScreen() 
          : BusinessProfileScreen();
      
      Get.offAll(() => targetScreen);

    } catch (e) {
      setState(() {
        _testResult = 'ERROR: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testLegacySwitch() async {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    try {
      await UserSessionService.switchAccountTypeLegacy(context);
      setState(() {
        _testResult = 'SUCCESS: Legacy switch completed';
      });
    } catch (e) {
      setState(() {
        _testResult = 'ERROR: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testImprovedSwitch() async {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    try {
      await UserSessionService.switchAccountType(context);
      setState(() {
        _testResult = 'SUCCESS: Improved switch completed';
      });
    } catch (e) {
      setState(() {
        _testResult = 'ERROR: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Role Switch Test',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            // Current user type
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    _currentUserType == 'Business' ? Icons.business : Icons.pets,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current: ${_currentUserType ?? 'Loading...'}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test buttons
            if (!_isLoading) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testDirectRoleSwitch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Direct API'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testLegacySwitch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Legacy'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _testImprovedSwitch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Improved Switch'),
                ),
              ),
            ] else ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Testing...'),
                  ],
                ),
              ),
            ],
            
            // Test result
            if (_testResult != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testResult!.startsWith('SUCCESS')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testResult!.startsWith('SUCCESS')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(
                  _testResult!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: _testResult!.startsWith('SUCCESS')
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Instructions
            Text(
              'Instructions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '• Direct API: Tests the role switching API directly\n'
              '• Legacy: Uses the old local switching method\n'
              '• Improved: Uses the new smart switching logic',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple floating action button for quick role switching
class QuickRoleSwitchFAB extends StatelessWidget {
  const QuickRoleSwitchFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Show a simple dialog with switch options
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quick Role Switch'),
            content: const Text('Choose a switching method:'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  UserSessionService.switchAccountType(context);
                },
                child: const Text('Smart Switch'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  UserSessionService.switchAccountTypeLegacy(context);
                },
                child: const Text('Legacy Switch'),
              ),
            ],
          ),
        );
      },
      backgroundColor: AppColors.primaryColor,
      child: const Icon(Icons.swap_horiz, color: Colors.white),
    );
  }
}
