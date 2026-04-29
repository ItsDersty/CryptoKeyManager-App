import 'package:cryptkey_manager_app/screens/main/welcome_screen.dart';
import 'package:cryptkey_manager_app/widgets/try_again.dart';
import 'package:flutter/material.dart';

import 'package:cryptkey_manager_app/services/api_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future? userData;

  void updateUserData() {
    setState(() {
      userData = null;
    });
    final api = context.read<ApiService>();

    Future.microtask(() {
      setState(() {
        userData = api.getData();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateUserData();
  }

  int currentPageIndex = 0;
  int selectedSegment = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,

            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setSheetState) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SegmentedButton<int>(
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.comfortable,
                          ),
                          segments: const <ButtonSegment<int>>[
                            ButtonSegment(
                              value: 0,
                              label: Text('Password'),
                              icon: Icon(Icons.password_rounded),
                            ),
                            ButtonSegment(
                              value: 1,
                              label: Text('Note'),
                              icon: Icon(Icons.note_rounded),
                            ),
                          ],
                          selected: {selectedSegment},
                          onSelectionChanged: (Set<int> newSelection) {
                            setSheetState(() {
                              selectedSegment = newSelection.first;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),

                            labelText: "Password",
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {},
                            label: Text("Save"),
                            icon: const Icon(Icons.done_rounded),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity(
                                horizontal: 4,
                                vertical: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
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
                  ? TryAgain(
                      label: "",
                      onRetry: () async {
                        updateUserData();
                      },
                    )
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
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.open_in_new_rounded,
                                      ),
                                      label: const Text('View'),
                                      onPressed: () {
                                        /* ... */
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton.outlined(
                                      icon: const Icon(
                                        Icons.delete_forever_rounded,
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.errorContainer,
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
