import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/role_switching_provider.dart';
import '../services/role_switching_service.dart';
import '../widgets/role_switch_widget.dart';
import '../utlis/constants/colors.dart';

/// Example screen demonstrating role switching functionality
class RoleSwitchingExampleScreen extends StatefulWidget {
  const RoleSwitchingExampleScreen({Key? key}) : super(key: key);

  @override
  State<RoleSwitchingExampleScreen> createState() => _RoleSwitchingExampleScreenState();
}

class _RoleSwitchingExampleScreenState extends State<RoleSwitchingExampleScreen> {
  String? _apiTestResult;
  bool _isTestingApi = false;

  @override
  void initState() {
    super.initState();
    // Initialize role information when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoleSwitchingProvider>().initializeRoleInfo();
    });
  }

  /// Test the role switching API directly
  Future<void> _testRoleSwitchingApi() async {
    setState(() {
      _isTestingApi = true;
      _apiTestResult = null;
    });

    try {
      // Get current role info
      final roleInfo = await RoleSwitchingService.getCurrentRoleInfo();
      if (roleInfo == null) {
        setState(() {
          _apiTestResult = 'Error: No authentication token found';
        });
        return;
      }

      final currentRole = roleInfo['currentRole'];
      final availableRoles = List<String>.from(roleInfo['availableRoles'] ?? []);

      // Determine target role for testing
      String? targetRole;
      if (currentRole == 'Pet Owner' && availableRoles.contains('Business')) {
        targetRole = 'Business';
      } else if (currentRole == 'Business' && availableRoles.contains('Pet Owner')) {
        targetRole = 'Pet Owner';
      }

      if (targetRole == null) {
        setState(() {
          _apiTestResult = 'No alternative role available for switching.\n'
              'Current: $currentRole\n'
              'Available: ${availableRoles.join(', ')}';
        });
        return;
      }

      // Test the API call
      final result = await RoleSwitchingService.switchRole(targetRole);
      
      setState(() {
        _apiTestResult = 'Success! Switched to $targetRole\n'
            'Previous role: $currentRole\n'
            'New token received: ${result['token'] != null ? 'Yes' : 'No'}';
      });

      // Refresh the provider to show updated state
      if (mounted) {
        context.read<RoleSwitchingProvider>().initializeRoleInfo();
      }

    } catch (e) {
      setState(() {
        _apiTestResult = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isTestingApi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Switching Example'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        actions: const [
          RoleSwitchAppBarAction(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Role Information
            _buildSectionCard(
              title: 'Current Role Information',
              child: Consumer<RoleSwitchingProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final roleInfo = provider.getRoleDisplayInfo();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Current Role', roleInfo['currentRoleDisplay']),
                      _buildInfoRow('Has Multiple Roles', provider.hasMultipleRoles ? 'Yes' : 'No'),
                      _buildInfoRow('Can Switch', provider.canSwitchRoles ? 'Yes' : 'No'),
                      if (provider.availableRoles.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Available Roles:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...provider.availableRoles.map((role) => Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Row(
                            children: [
                              Icon(provider.getRoleIcon(role), size: 16),
                              const SizedBox(width: 8),
                              Text(provider.getRoleDisplayName(role)),
                              if (role == provider.currentRole) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                              ],
                            ],
                          ),
                        )),
                      ],
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Role Switch Widget Examples
            _buildSectionCard(
              title: 'Role Switch Widgets',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Button Style:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const RoleSwitchWidget(showAsButton: true),
                  
                  const SizedBox(height: 16),
                  
                  const Text('Selector Style:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const RoleSwitchWidget(showAsButton: false),
                  
                  const SizedBox(height: 16),
                  
                  const Text('Current Role Display:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const RoleSwitchWidget(showAsButton: false, showCurrentRole: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // API Testing Section
            _buildSectionCard(
              title: 'API Testing',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test the role switching API directly:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isTestingApi ? null : _testRoleSwitchingApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                    ),
                    child: _isTestingApi
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Test Role Switch API'),
                  ),
                  if (_apiTestResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _apiTestResult!.startsWith('Error')
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _apiTestResult!.startsWith('Error')
                              ? Colors.red.withOpacity(0.3)
                              : Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _apiTestResult!,
                        style: TextStyle(
                          color: _apiTestResult!.startsWith('Error')
                              ? Colors.red[700]
                              : Colors.green[700],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Usage Instructions
            _buildSectionCard(
              title: 'Usage Instructions',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Role Validation:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• The system checks if the user has permission to switch to the target role'),
                  Text('• Only users with multiple available roles can switch'),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    '2. API Call:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Makes a POST request to /api/auth/switch-role'),
                  Text('• Includes the new role in the request body'),
                  Text('• Returns a new JWT token with updated role information'),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    '3. State Management:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Updates the stored authentication token'),
                  Text('• Updates the user type in SharedPreferences'),
                  Text('• Notifies all listeners of the role change'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
