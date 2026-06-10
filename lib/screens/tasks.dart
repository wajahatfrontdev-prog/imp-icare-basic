import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_text.dart';
import '../services/task_service.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final TaskService _taskService = TaskService();
  bool _isLoading = true;
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _taskService.getMyTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading tasks: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;

    if (isWeb) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB), // Soft background color
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          title: CustomText(
            text: "My Tasks",
            fontWeight: FontWeight.bold,
            letterSpacing: -0.31,
            lineHeight: 1.0,
            fontSize: 20,
            fontFamily: "Gilroy-Bold",
            color: AppColors.primaryColor,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E9F2))),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: TabBar(
                    controller: controller,
                    indicatorWeight: 4,
                    indicatorPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    indicatorColor: AppColors.primaryColor,
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: const Color(0xFF8B98B4),
                    labelStyle: const TextStyle(
                      fontFamily: "Gilroy-Bold",
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: "Gilroy-Medium",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: "Assigned"),
                      Tab(text: "Completed"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: TabBarView(
                    controller: controller,
                    children: [
                      WebTasksList(
                        tasks: _tasks
                            .where((t) => t['status'] != 'Completed')
                            .toList(),
                        isCompleted: false,
                        onRefresh: _loadTasks,
                      ),
                      WebTasksList(
                        tasks: _tasks
                            .where((t) => t['status'] == 'Completed')
                            .toList(),
                        isCompleted: true,
                        onRefresh: _loadTasks,
                      ),
                    ],
                  ),
                ),
              ),
      );
    } // end web layout

    // Original Mobile Layout
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "My Tasks",
          fontWeight: FontWeight.bold,
          letterSpacing: -0.31,
          lineHeight: 1.0,
          fontSize: 16.78,
          fontFamily: "Gilroy-Bold",
          color: AppColors.primary500,
        ),
        actions: [
          IconButton(
            onPressed: _loadTasks,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        bottom: TabBar(
          controller: controller,
          indicatorWeight: 6,
          indicatorColor: AppColors.themeBlack,
          tabs: [
            CustomText(
              text: "Assigned",
              padding: const EdgeInsets.only(bottom: 5),
              width: Utils.windowWidth(context) * 0.45,
              textAlign: TextAlign.center,
              fontFamily: "Gilroy-Bold",
              fontSize: 13,
            ),
            CustomText(
              text: "Completed",
              fontFamily: "Gilroy-Bold",
              fontSize: 13,
              padding: const EdgeInsets.only(bottom: 5),
              width: Utils.windowWidth(context) * 0.45,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: controller,
              children: [
                TasksList(
                  tasks: _tasks
                      .where((t) => t['status'] != 'Completed')
                      .toList(),
                  onRefresh: _loadTasks,
                ),
                TasksList(
                  tasks: _tasks
                      .where((t) => t['status'] == 'Completed')
                      .toList(),
                  onRefresh: _loadTasks,
                ),
              ],
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ORIGINAL MOBILE COMPONENTS (Unchanged)
// ═══════════════════════════════════════════════════════════════════════════

class TasksList extends StatelessWidget {
  final List<dynamic> tasks;
  final VoidCallback onRefresh;
  const TasksList({super.key, required this.tasks, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(14)),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        return TaskCard(task: tasks[i], onRefresh: onRefresh);
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final dynamic task;
  final VoidCallback onRefresh;
  const TaskCard({super.key, required this.task, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final dateStr = task['dueDate'] ?? '';
    DateTime? dateObj = DateTime.tryParse(dateStr);
    final formattedDate = dateObj != null
        ? DateFormat('dd/MM/yyyy').format(dateObj)
        : '—';

    return Container(
      margin: EdgeInsets.only(top: ScallingConfig.verticalScale(10)),
      padding: EdgeInsets.symmetric(
        vertical: ScallingConfig.verticalScale(10),
        horizontal: ScallingConfig.scale(15),
      ),
      width: Utils.windowWidth(context) * 0.9,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey100,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: formattedDate,
                color: AppColors.tertiaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: "Gilroy-Regular",
              ),
              if (task['status'] != 'Completed')
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    await TaskService().updateTaskStatus(
                      task['_id'],
                      'Completed',
                    );
                    onRefresh();
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
            ],
          ),
          SizedBox(height: ScallingConfig.scale(8)),
          Text(
            task['title'] ?? 'No Title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          CustomText(
            text: task['description'] ?? "No Description",
            color: AppColors.primary500,
            fontSize: 12,
            maxLines: 8,
            fontWeight: FontWeight.w400,
            fontFamily: "Gilroy-Regular",
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NEW WEB COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════

class WebTasksList extends StatelessWidget {
  final List<dynamic> tasks;
  final bool isCompleted;
  final VoidCallback onRefresh;
  const WebTasksList({
    super.key,
    required this.tasks,
    required this.isCompleted,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ScallingConfig.scale(20),
        vertical: ScallingConfig.verticalScale(20),
      ),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        return WebTaskItem(
          task: tasks[i],
          isCompleted: isCompleted,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

class WebTaskItem extends StatelessWidget {
  final dynamic task;
  final bool isCompleted;
  final VoidCallback onRefresh;

  const WebTaskItem({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final title = task['title'] ?? 'Task';
    final description = task['description'] ?? 'No description';
    final dateStr = task['dueDate'] ?? '';
    DateTime? dateObj = DateTime.tryParse(dateStr);
    final formattedDate = dateObj != null
        ? DateFormat('dd MMM, yyyy').format(dateObj)
        : '—';
    final priority = task['priority'] ?? 'Medium';
    final status = task['status'] ?? 'Assigned';
    final assignedBy = task['assignedBy']?['name'] ?? 'Admin';

    final statusColor = status == 'Completed'
        ? const Color(0xFF10B981)
        : status == 'In Progress'
        ? const Color(0xFF3B82F6)
        : const Color(0xFFF59E0B);
    final statusBg = status == 'Completed'
        ? const Color(0xFFECFDF5)
        : status == 'In Progress'
        ? const Color(0xFFEFF6FF)
        : const Color(0xFFFEF3C7);
    final statusIcon = status == 'Completed'
        ? Icons.check_circle_rounded
        : status == 'In Progress'
        ? Icons.timelapse_rounded
        : Icons.pending_actions_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F4F9), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header (Status + Actions) ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (!isCompleted)
                          TextButton.icon(
                            onPressed: () async {
                              await TaskService().updateTaskStatus(
                                task['_id'],
                                'Completed',
                              );
                              onRefresh();
                            },
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 16,
                            ),
                            label: const Text(
                              'Complete',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey.shade400,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Title ──
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Gilroy-Bold",
                  ),
                ),

                const SizedBox(height: 8),

                // ── Description ──
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy-Regular",
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // ── Footer (Avatar + Priority) ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(
                            'assets/images/user1.png',
                          ), // Fallback
                          backgroundColor: Color(0xFFE2E8F0),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Assigned by $assignedBy",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (!isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: priority == 'High'
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: priority == 'High'
                                ? const Color(0xFFFECACA)
                                : const Color(0xFFDBEAFE),
                          ),
                        ),
                        child: Text(
                          "$priority Priority",
                          style: TextStyle(
                            color: priority == 'High'
                                ? Colors.red
                                : const Color(0xFF2563EB),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
