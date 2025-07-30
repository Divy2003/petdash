import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/common/widgets/appbar/appbar.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import 'AddNewClients.dart';
import 'EditClients.dart';

class MyClients extends StatefulWidget {
  const MyClients({super.key});

  @override
  State<MyClients> createState() => _MyClientsState();
}

class _MyClientsState extends State<MyClients> {
  List<Map<String, String>> clients = List.generate(
    8,
        (index) => {
      "name": "Customer: Floyd Miles",
      "pet": "Pet: Baxter",
      "image": "https://via.placeholder.com/150"
    },
  );

  int? deletingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Clients'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryButton(
              title: 'Add New Client',
              onPressed: () {
                Get.to(() => const AddNewClients());
              },
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${clients.length} Users Found",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.sort, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text("Sort", style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 22.r,
                      backgroundImage: NetworkImage(client['image']!),
                    ),
                    title: Text(
                      client['name'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: Text(
                      client['pet'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (deletingIndex == index)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                clients.removeAt(index);
                                deletingIndex = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                            ),
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          )
                        else ...[
                          IconButton(
                            icon: Icon(Icons.edit, size: 18.sp),
                            onPressed: () {
                              Get.to(() => const EditClientDetails());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 18.sp),
                            onPressed: () {
                              setState(() {
                                deletingIndex = index;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
