import 'package:flutter/material.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LabHomePage(),
    );
  }
}

class LabHomePage extends StatefulWidget {
  const LabHomePage({super.key});

  @override
  State<LabHomePage> createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {
  int _selectedIndex = 0;

  final List<String> _titles = const [
    'Task 1: Selection Controls', 'Task 2: Input Fields',
    'Task 3: Buttons & Actions', 'Task 4: Indicators & Feedback',
    'Task 5: Dialogs & Modals', 'Task 6: Sliders & Pickers',
    'Task 7: Scrollable Collections', 'Task 8: Grid Gallery',
    'Task 9: Navigation Controls',
  ];

  final List<Widget> _pages = const [
    SettingsTask(), LoginTask(), CounterTask(), FeedbackTask(), DialogsTask(),
    SliderDateTask(), ScrollableListTask(), GridGalleryTask(), NavigationControlsTask(),
  ];

  final List<IconData> _icons = const [
    Icons.settings, Icons.login, Icons.add_circle, Icons.hourglass_bottom,
    Icons.layers, Icons.tune, Icons.view_list, Icons.grid_view, Icons.navigation,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex]), centerTitle: true),
      drawer: Drawer(
        child: SafeArea(
          child: Column(children: [
            const DrawerHeader(child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.flutter_dash, size: 48), SizedBox(height: 8),
                Text('Flutter Lab 4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Choose a task')],
            ))),
            Expanded(child: ListView.builder(
              itemCount: _titles.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(_icons[index]), title: Text(_titles[index]),
                selected: _selectedIndex == index,
                onTap: () { setState(() => _selectedIndex = index); Navigator.pop(context); },
              ),
            )),
          ]),
        ),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
    );
  }
}

// -----------------------------------------------------------------------------
// TASK 1: Selection Controls
// Exercise 1.1: SwitchListTile + CheckboxListTile
// Exercise 1.2: Agree to Terms enables/disables the button.
// -----------------------------------------------------------------------------

class SettingsTask extends StatefulWidget {
  const SettingsTask({super.key});

  @override
  State<SettingsTask> createState() => _SettingsTaskState();
}

class _SettingsTaskState extends State<SettingsTask> {
  bool _darkMode = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Try the controls below.'),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Turn dark mode preference on/off'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Agree to Terms'),
                subtitle: const Text('You must agree before continuing'),
                secondary: const Icon(Icons.check_circle_outline),
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _agreedToTerms
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully.'),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.save),
          label: const Text('Continue / Save'),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TASK 2: Input Fields
// Exercise 2.1: Login form with password visibility toggle.
// Exercise 2.2: Email validation requires an @ symbol.
// -----------------------------------------------------------------------------

class LoginTask extends StatefulWidget {
  const LoginTask({super.key});

  @override
  State<LoginTask> createState() => _LoginTaskState();
}

class _LoginTaskState extends State<LoginTask> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login submitted for ${_emailController.text}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 80),
            const SizedBox(height: 8),
            const Text(
              'Login Form',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Please enter your email';
                }
                if (!email.contains('@')) {
                  return 'Email must contain @';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? 'Show password'
                      : 'Hide password',
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TASK 3: Buttons & Action Items
// Exercise 3.1: FloatingActionButton increments a counter.
// Exercise 3.2: OutlinedButton resets the counter to 0.
// -----------------------------------------------------------------------------

class CounterTask extends StatefulWidget {
  const CounterTask({super.key});

  @override
  State<CounterTask> createState() => _CounterTaskState();
}

class _CounterTaskState extends State<CounterTask> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app_outlined, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Counter',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset to 0'),
              ),
              const SizedBox(height: 8),
              const Text('Press the + button in the bottom-right corner.'),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TASK 4: Indicators & Feedback
// Exercise 4.1: Button shows centered CircularProgressIndicator for 3 seconds.
// Exercise 4.2: SnackBar with an Undo action after completion.
// -----------------------------------------------------------------------------

class FeedbackTask extends StatefulWidget {
  const FeedbackTask({super.key});

  @override
  State<FeedbackTask> createState() => _FeedbackTaskState();
}

class _FeedbackTaskState extends State<FeedbackTask> {
  bool _loading = false;

  Future<void> _startOperation() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Operation completed.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action undone.')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _loading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Processing for 3 seconds...'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 70),
                  const SizedBox(height: 16),
                  const Text(
                    'Async Operation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap the button to simulate a 3-second operation.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _startOperation,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Operation'),
                  ),
                ],
              ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TASK 5: Dialogs & Modals
// Exercise 5.1: AlertDialog with Cancel/Delete.
// Exercise 5.2: showModalBottomSheet with share options.
// -----------------------------------------------------------------------------

class DialogsTask extends StatefulWidget {
  const DialogsTask({super.key});

  @override
  State<DialogsTask> createState() => _DialogsTaskState();
}

class _DialogsTaskState extends State<DialogsTask> {
  String _status = 'Item is available';

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete item?'),
          content: const Text(
            'Are you sure you want to delete this item? This action '
            'cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldDelete == true) {
      setState(() {
        _status = 'Item deleted';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted.')),
      );
    }
  }

  void _showShareSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const ListTile(
                title: Text(
                  'Share',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Share by Message'),
                onTap: () {
                  Navigator.pop(context);
                  _showShareMessage('Message');
                },
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Share by Email'),
                onTap: () {
                  Navigator.pop(context);
                  _showShareMessage('Email');
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  _showShareMessage('Link copied');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showShareMessage(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$method selected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.description_outlined, size: 60),
                    const SizedBox(height: 12),
                    const Text(
                      'Example Item',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Item'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showShareSheet,
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}


// TASK 6: Slider volume control and date picker.
class SliderDateTask extends StatefulWidget {
  const SliderDateTask({super.key});
  @override
  State<SliderDateTask> createState() => _SliderDateTaskState();
}

class _SliderDateTaskState extends State<SliderDateTask> {
  double _volume = 50;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context, initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000), lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null ? 'No date selected' :
      '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}';
    return ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.volume_up, size: 64),
      const Text('Volume Control', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Text('${_volume.round()}%', textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium),
      Slider(value: _volume, min: 0, max: 100, divisions: 100,
        label: '${_volume.round()}%', onChanged: (v) => setState(() => _volume = v)),
      const Divider(height: 40),
      const Text('Date Picker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text(dateText),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: _pickDate, icon: const Icon(Icons.calendar_month), label: const Text('Choose Date')),
    ]);
  }
}

// TASK 7: ListView.builder with 20 swipe-to-dismiss items.
class ScrollableListTask extends StatefulWidget {
  const ScrollableListTask({super.key});
  @override
  State<ScrollableListTask> createState() => _ScrollableListTaskState();
}

class _ScrollableListTaskState extends State<ScrollableListTask> {
  late List<String> _items;
  @override
  void initState() { super.initState(); _items = List.generate(20, (i) => 'List item ${i + 1}'); }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('All items dismissed.'),
      TextButton(onPressed: () => setState(() => _items = List.generate(20, (i) => 'List item ${i + 1}')), child: const Text('Restore list')),
    ]));
    return ListView.builder(
      padding: const EdgeInsets.all(8), itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: ValueKey(item), direction: DismissDirection.horizontal,
          background: Container(color: Colors.red.shade100, alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20), child: const Icon(Icons.delete, color: Colors.red)),
          secondaryBackground: Container(color: Colors.red.shade100, alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.red)),
          onDismissed: (_) { setState(() => _items.remove(item)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed'))); },
          child: Card(child: ListTile(leading: CircleAvatar(child: Text('${index + 1}')), title: Text(item), subtitle: const Text('Swipe to dismiss'), trailing: const Icon(Icons.drag_handle))),
        );
      },
    );
  }
}

// TASK 8: Two-column photo gallery. Internet connection is required for photos.
class GridGalleryTask extends StatelessWidget {
  const GridGalleryTask({super.key});
  static const List<String> _images = [
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=700',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=700',
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=700',
    'https://images.unsplash.com/photo-1472396961693-142e6e269027?w=700',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=700',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=700',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=700',
    'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=700',
  ];

  @override
  Widget build(BuildContext context) => GridView.count(
    padding: const EdgeInsets.all(12), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
    children: List.generate(_images.length, (i) => InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImagePreviewPage(imageUrl: _images[i], imageNumber: i + 1))),
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Stack(fit: StackFit.expand, children: [
        Image.network(_images[i], fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, error, stack) => const ColoredBox(color: Color(0xFFE0E0E0), child: Center(child: Icon(Icons.broken_image, size: 40))),
        ),
        Align(alignment: Alignment.bottomCenter, child: Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.black54,
          child: Text('Photo ${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ])),
    )),
  );
}

class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({super.key, required this.imageUrl, required this.imageNumber});
  final String imageUrl;
  final int imageNumber;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Photo $imageNumber')),
    body: Center(child: InteractiveViewer(child: Image.network(imageUrl, fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, size: 64)))),
  );
}

// TASK 9: Demonstrates BottomNavigationBar and TabBar/TabBarView.
class NavigationControlsTask extends StatefulWidget {
  const NavigationControlsTask({super.key});
  @override
  State<NavigationControlsTask> createState() => _NavigationControlsTaskState();
}

class _NavigationControlsTaskState extends State<NavigationControlsTask> {
  int _bottomIndex = 0;
  final List<Widget> _bottomPages = const [
    Center(child: Text('Home page', style: TextStyle(fontSize: 22))),
    Center(child: Text('Search page', style: TextStyle(fontSize: 22))),
    Center(child: Text('Profile page', style: TextStyle(fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(title: const Text('Top Tabs'), bottom: const TabBar(tabs: [
        Tab(icon: Icon(Icons.home_outlined), text: 'Home'),
        Tab(icon: Icon(Icons.search), text: 'Search'),
        Tab(icon: Icon(Icons.person_outline), text: 'Profile'),
      ])),
      body: Column(children: [
        const Padding(padding: EdgeInsets.all(10), child: Text('Top tabs: TabBar + TabBarView')),
        const Expanded(child: TabBarView(children: [
          Center(child: Text('Home tab content', style: TextStyle(fontSize: 20))),
          Center(child: Text('Search tab content', style: TextStyle(fontSize: 20))),
          Center(child: Text('Profile tab content', style: TextStyle(fontSize: 20))),
        ])),
        const Divider(),
        const Padding(padding: EdgeInsets.only(top: 6), child: Text('BottomNavigationBar example')),
        Expanded(child: _bottomPages[_bottomIndex]),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex, onTap: (index) => setState(() => _bottomIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ),
  );
}
