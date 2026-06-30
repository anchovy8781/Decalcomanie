import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoUrl,
    required this.radius,
    this.onTap,
    this.showEditBadge = false,
  });

  final String? photoUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditBadge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: photoUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photoUrl!,
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person_rounded,
                        size: radius,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person_rounded,
                    size: radius,
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
          if (showEditBadge)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: radius * 0.35,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
