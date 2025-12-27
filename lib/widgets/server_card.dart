import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/server_profile.dart';

class ServerCard extends StatelessWidget {
  final ServerProfile server;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const ServerCard({
    super.key,
    required this.server,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [AppTheme.redPrimary, AppTheme.redDark]
                : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? AppTheme.accentGold 
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Opacity(
          opacity: isDisabled && !isSelected ? 0.5 : 1.0,
          child: Row(
            children: [
              // Server info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.name,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        letterSpacing: 1,
                        color: isSelected ? Colors.white : AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${server.address}:${server.port} // ${server.protocol}',
                      style: TextStyle(
                        fontFamily: 'SpecialElite',
                        fontSize: 11,
                        color: isSelected 
                            ? Colors.white.withOpacity(0.8)
                            : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Delete button
              if (!isSelected || !isDisabled)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: isSelected 
                        ? Colors.white.withOpacity(0.7)
                        : AppTheme.textMuted,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
