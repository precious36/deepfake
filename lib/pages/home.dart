import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'login.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> messages = [];
  List<String> recents = [];
  TextEditingController messageController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  void clearMessages() {
    setState(() {
      recents.addAll(messages);
      messages.clear();
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.off(() => SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Center(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Unmask',
                  style: TextStyle(
                    color: Color.fromARGB(255, 231, 217, 86),
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: 'AI',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
            onPressed: clearMessages,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
         DrawerHeader(
  decoration: const BoxDecoration(
    color: Colors.white,
  ),
  child: Row(
    children: [
      const CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('assets/images/profile.jpg'),
      ),
      SizedBox(width: 16),
      Expanded(  // Wrap the Column in an Expanded widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.displayName ?? 'Guest'),
            Text(user?.email ?? 'guest@example.com'),
          ],
        ),
      ),
    ],
  ),
),
  ListTile(
                    title: const Text('Recents'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Recents'),
                            content: Text(recents.join('\n')),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_upload,
                              size: 100,
                              color: Color.fromARGB(255, 26, 179, 218),
                            ),
                            const Text('Upload your file here'),
                            const SizedBox(height: 13),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 235, 215, 35),
                                ),
                                child: const Text('Upload'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 5,
                  child: ListTile(
                    title: Text(messages[index - 1]),
                    leading: const Icon(Icons.message),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 43, 182, 140),
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: 5.5708,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          messages.add(messageController.text);
                          messageController.clear();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
