import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onDone;

  const TaskTile({
    super.key,
    required this.title,
    required this.status,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final bool done =
        status == "done";

    return Dismissible(
      key: Key(title),
      direction:
          done
              ? DismissDirection.none
              : DismissDirection
                  .endToStart,
      onDismissed: (_) {
        onDone();
      },
      background: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        padding:
            const EdgeInsets.only(
          right: 20,
        ),
        alignment:
            Alignment.centerRight,
        decoration:
            BoxDecoration(
          color: Colors.green,
          borderRadius:
              BorderRadius.circular(
                  18),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration:
            BoxDecoration(
          color: Colors.white
              .withOpacity(
                  0.92),
          borderRadius:
              BorderRadius.circular(
                  18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 1,
              offset:
                  Offset(0, 5),
              color:
                  Colors.black12,
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor:
                done
                    ? Colors.green
                    : const Color(
                        0xff7b61ff),
            child: Icon(
              done
                  ? Icons.check
                  : Icons.task_alt,
              color:
                  Colors.white,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              decoration:
                  done
                      ? TextDecoration
                          .lineThrough
                      : null,
            ),
          ),
          subtitle: Text(
            done
                ? "Completed ✅"
                : "Pending 😴",
          ),
          trailing:
              done
                  ? const Icon(
                      Icons
                          .verified,
                      color:
                          Colors.green,
                    )
                  : IconButton(
                      onPressed:
                          onDone,
                      icon:
                          const Icon(
                        Icons.done,
                      ),
                    ),
        ),
      )
          .animate()
          .fadeIn(
            duration: 500.ms,
          )
          .slideY(
            begin: 0.25,
            end: 0,
            duration: 500.ms,
          )
          .scale(
            begin: const Offset(
              .95,
              .95,
            ),
            end: const Offset(
              1,
              1,
            ),
          ),
    );
  }
}