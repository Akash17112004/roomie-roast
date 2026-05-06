import 'dart:async';

import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskId;
  final String title;
  final String status;
  final FutureOr<void> Function() onDone;

  const TaskTile({
    super.key,
    required this.taskId,
    required this.title,
    required this.status,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final done = status == "done";
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = done ? Colors.green : colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 380;
        final horizontalMargin = isNarrow ? 8.0 : 12.0;
        final avatarRadius = isNarrow ? 18.0 : 20.0;

        return RepaintBoundary(
          child: Dismissible(
            key: ValueKey(taskId),
            direction:
                done ? DismissDirection.none : DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await onDone();
              return false;
            },
            background: Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalMargin,
                vertical: 6,
              ),
              padding: const EdgeInsets.only(
                right: 20,
              ),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalMargin,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.white,
                border: Border.all(
                  color: isDark
                      ? colorScheme.outlineVariant.withValues(alpha: 0.35)
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.28)
                        : Colors.black12,
                  ),
                ],
              ),
              child: ListTile(
                horizontalTitleGap: isNarrow ? 10 : 16,
                minLeadingWidth: avatarRadius * 2,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 12 : 18,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: accentColor,
                  child: Icon(
                    done ? Icons.check : Icons.task_alt,
                    color: done ? Colors.white : colorScheme.onPrimary,
                  ),
                ),
                title: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  done ? "Completed" : "Pending",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: done
                    ? const Icon(
                        Icons.verified,
                        color: Colors.green,
                      )
                    : IconButton(
                        onPressed: () async {
                          await onDone();
                        },
                        icon: Icon(
                          Icons.done,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
