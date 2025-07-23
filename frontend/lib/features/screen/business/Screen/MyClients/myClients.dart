import 'package:flutter/material.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/common/widgets/appbar/appbar.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryButton(
              title: 'Add New Client',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${clients.length} Users Found",
                    style: TextStyle(color: Colors.grey)),
                Row(
                  children: const [
                    Icon(Icons.sort, size: 18),
                    SizedBox(width: 4),
                    Text("Sort", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                separatorBuilder: (context, index) =>
                    Divider(thickness: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(client['image']!),
                    ),
                    title: Text(client['name'] ?? ''),
                    subtitle: Text(client['pet'] ?? ''),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: const Text("Delete"),
                          )
                        else ...[
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () {
                              // Handle edit
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
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
