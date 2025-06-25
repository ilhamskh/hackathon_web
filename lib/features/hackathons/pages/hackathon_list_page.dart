import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/hackathon_cubit.dart';
import '../../../shared/models/hackathon_model.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/responsive_utils.dart';

class HackathonListPage extends StatefulWidget {
  const HackathonListPage({super.key});

  @override
  State<HackathonListPage> createState() => _HackathonListPageState();
}

class _HackathonListPageState extends State<HackathonListPage> {
  @override
  void initState() {
    super.initState();
    context.read<HackathonCubit>().loadHackathons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackathons'),
        actions: [
          IconButton(
            onPressed: () {
              NavigationService().navigateTo('hackathon-create');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Create New Hackathon',
          ),
        ],
      ),
      body: BlocConsumer<HackathonCubit, HackathonState>(
        listener: (context, state) {
          if (state is HackathonError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HackathonLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HackathonListLoaded) {
            if (state.hackathons.isEmpty) {
              return _buildEmptyState();
            }
            return _buildHackathonList(state.hackathons);
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationService().navigateTo('hackathon-create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Hackathon'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hackathons found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first hackathon to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              NavigationService().navigateTo('hackathon-create');
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Hackathon'),
          ),
        ],
      ),
    );
  }

  Widget _buildHackathonList(List<HackathonModel> hackathons) {
    return ResponsiveUtils.isMobile(context)
        ? _buildMobileList(hackathons)
        : _buildDesktopGrid(hackathons);
  }

  Widget _buildMobileList(List<HackathonModel> hackathons) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HackathonCubit>().loadHackathons();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hackathons.length,
        itemBuilder: (context, index) {
          final hackathon = hackathons[index];
          return _buildHackathonCard(hackathon, isMobile: true);
        },
      ),
    );
  }

  Widget _buildDesktopGrid(List<HackathonModel> hackathons) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HackathonCubit>().loadHackathons();
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.isTablet(context) ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: hackathons.length,
          itemBuilder: (context, index) {
            final hackathon = hackathons[index];
            return _buildHackathonCard(hackathon, isMobile: false);
          },
        ),
      ),
    );
  }

  Widget _buildHackathonCard(
    HackathonModel hackathon, {
    required bool isMobile,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          NavigationService().navigateTo(
            'hackathon-detail',
            arguments: {'id': hackathon.id ?? ''},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hackathon.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(hackathon.status ?? 'draft'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                hackathon.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: isMobile ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.event,
                '${_formatDate(hackathon.startDate)} - ${_formatDate(hackathon.endDate)}',
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                Icons.people,
                'Team: ${hackathon.minTeamSize}-${hackathon.maxTeamSize} members',
              ),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.location_on, hackathon.type),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Open landing page
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Preview'),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, hackathon),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('Duplicate'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'draft':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case 'ended':
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuAction(String action, HackathonModel hackathon) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit
        break;
      case 'duplicate':
        // TODO: Duplicate hackathon
        break;
      case 'delete':
        _showDeleteDialog(hackathon);
        break;
    }
  }

  void _showDeleteDialog(HackathonModel hackathon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hackathon'),
        content: Text('Are you sure you want to delete "${hackathon.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<HackathonCubit>().deleteHackathon(hackathon.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
