import 'package:flutter/material.dart';
import 'package:to_do_app/components/styles/app_theme.dart';
import 'package:to_do_app/components/ui/addTask.dart';
import 'package:to_do_app/components/ui/appBar.dart';
import 'package:to_do_app/view/home/note_editor_screen.dart';
import 'package:to_do_app/viewmodel/home/home.viewmodel.dart';
import 'package:to_do_app/viewmodel/home/note.viewmodel.dart';
import 'widget/task_list_view.dart';
import 'widget/note_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeViewModel _taskViewModel = HomeViewModel();
  final NoteViewModel _noteViewModel = NoteViewModel();
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Updates the FAB when you swipe tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeTabIndex = _tabController.index);
      }
    });

    _loadData();
  }

  Future<void> _loadData() async {
    await _taskViewModel.loadTodos();
    await _noteViewModel.loadNotes();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Workspace',
        extraActions: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: isDark ? theme.colorScheme.secondary : Colors.white,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: "Tasks"),
              Tab(text: "Notes"),
            ],
          ),
        ],
      ),
      body: Container(
        // Use your app_theme or hardcoded gradient here
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            colors: isDark
                ? [theme.scaffoldBackgroundColor, theme.colorScheme.surface]
                : [
                    theme.primaryColor,
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              TaskListView(
                viewModel: _taskViewModel,
                onRefresh: () => setState(() {}),
              ),
              NoteGridView(
                viewModel: _noteViewModel, // Pass the actual ViewModel
                onRefresh: () => setState(() {}),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? Colors.white : theme.primaryColor,
        onPressed: () {
          if (_activeTabIndex == 0) {
            _openAddTaskSheet();
          } else {
            _openNoteEditor();
          }
        },
        label: Text(
          _activeTabIndex == 0 ? "Add Task" : "New Note",
          style: TextStyle(
            color: isDark ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          _activeTabIndex == 0 ? Icons.add : Icons.edit_note,
          // color: Colors.blue,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskBottomSheet(
        onSave: (title, desc, priority) {
          setState(
            () => _taskViewModel.addTodo(
              title,
              description: desc,
              priority: priority,
            ),
          );
        },
      ),
    );
  }

  void _openNoteEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(viewModel: _noteViewModel),
      ),
    );

    // If result is true, it means a note was saved
    if (result == true) {
      setState(() {}); // Refresh the NoteGridView
    }
  }
}
