import 'package:cryptkey_manager_app/screens/main/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'package:cryptkey_manager_app/services/api_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future userData;
  @override
  void initState() {
    super.initState();
    final api = context.read<ApiService>();
    userData = api.getData();
  }

  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.password_rounded),
            label: 'Passwords',
          ),
          NavigationDestination(icon: Icon(Icons.note_rounded), label: 'Notes'),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('CryptKey Manager'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                  ),
                  onPressed: () async {
                    await api.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('sign out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          return IndexedStack(
            index: currentPageIndex,
            children: [
              data.isEmpty
                  ? const Center(child: Text("No data yet!"))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const ListTile(
                                  leading: Icon(Icons.album),
                                  title: Text('Title'),
                                  subtitle: Text(
                                    'some description i dont know',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('View'),
                                      onPressed: () {
                                        /* ... */
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('View'),
                                      onPressed: () {
                                        /* ... */
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              Text("Hello world!"),
              Text("Hello world2!"),
            ],
          );
        },
      ),
    );
  }
}
