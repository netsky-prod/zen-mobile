import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/server_profile.dart';

class StatusCard extends StatelessWidget {
  final bool isConnected;
  final ServerProfile? server;
  final Duration uptime;
  final int rxBytes;
  final int txBytes;
  final String Function(int) formatBytes;

  const StatusCard({
    super.key,
    required this.isConnected,
    required this.server,
    required this.uptime,
    this.rxBytes = 0,
    this.txBytes = 0,
    required this.formatBytes,
  });

  String _formatUptime(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            'Status',
            isConnected ? 'Connected' : 'Disconnected',
            isConnected ? Colors.green : AppTheme.textMuted,
          ),
          const SizedBox(height: 8),
          _buildRow(
            'Server',
            server?.address ?? 'None',
            AppTheme.textLight,
          ),
          const SizedBox(height: 8),
          _buildRow(
            'Protocol',
            server?.protocol ?? '-',
            AppTheme.textLight,
          ),
          const SizedBox(height: 8),
          _buildRow(
            'Uptime',
            isConnected ? _formatUptime(uptime) : '0h 0m 0s',
            AppTheme.accentGold,
          ),
          if (isConnected) ...[
            const SizedBox(height: 8),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            _buildRow(
              '↓ Download',
              formatBytes(rxBytes),
              Colors.greenAccent,
            ),
            const SizedBox(height: 8),
            _buildRow(
              '↑ Upload',
              formatBytes(txBytes),
              Colors.orangeAccent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontFamily: 'SpecialElite',
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SpecialElite',
            fontSize: 12,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
