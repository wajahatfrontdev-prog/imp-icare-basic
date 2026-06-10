import 'package:flutter/material.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/services/instructor_service.dart';

class InstructorAssignedLearners extends StatefulWidget {
  const InstructorAssignedLearners({super.key});

  @override
  State<InstructorAssignedLearners> createState() =>
      _InstructorAssignedLearnersState();
}

class _InstructorAssignedLearnersState
    extends State<InstructorAssignedLearners> {
  final InstructorService _instructorService = InstructorService();
  bool _isLoading = true;
  List<dynamic> _learners = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLearners();
  }

  Future<void> _loadLearners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final learners = await _instructorService.getAssignedLearners();
      setState(() {
        _learners = learners;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: const CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Assigned Learners',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadLearners,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _learners.isEmpty
          ? const Center(child: Text('No learners enrolled yet'))
          : RefreshIndicator(
              onRefresh: _loadLearners,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _learners.length,
                itemBuilder: (context, index) {
                  return _buildLearnerCard(_learners[index]);
                },
              ),
            ),
    );
  }

  Widget _buildLearnerCard(Map<String, dynamic> learner) {
    final user = learner['user'];
    final course = learner['course'];
    final progress = learner['progress'] ?? 0;
    final name = user?['name'] ?? 'Unknown';
    final role = user?['role'] ?? 'Student';
    final courseName = course?['title'] ?? 'Course';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      role == 'Doctor'
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF10B981),
                      role == 'Doctor'
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF34D399),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: role == 'Doctor'
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF64748B),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  course,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              Text(
                '$progress%',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress / 100.0,
            backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}
