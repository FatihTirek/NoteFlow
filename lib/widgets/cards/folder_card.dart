import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../animations/animatable_card.dart';
import '../../animations/slidable_card.dart';
import '../../controllers/widgets/cards/folder_card_controller.dart';
import '../../models/folder.dart';
import '../../utils.dart';
import '../../main.dart';

class FolderCard extends ConsumerStatefulWidget {
  final Folder folder;
  final bool higlight;
  final bool slidable;
  final VoidCallback? onTap;

  FolderCard(
    this.folder, {
    this.onTap,
    this.slidable = true,
    this.higlight = false,
  }) : super(key: ValueKey(folder.id));

  @override
  _FolderCardState createState() => _FolderCardState();
}

class _FolderCardState extends ConsumerState<FolderCard>
    with SingleTickerProviderStateMixin, Utils {
  late FolderCardController controller;

  @override
  void initState() {
    super.initState();
    controller = FolderCardController(
      ref,
      animationController: widget.slidable
          ? AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            )
          : null,
    );
  }

  @override
  void dispose() {
    if (widget.slidable) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.slidable) {
      return AnimatableCard(
        id: widget.folder.id,
        exitAnimController: controller.animationController!,
        child: GestureDetector(
          onTap: widget.onTap ?? () => controller.onTapCard(widget.folder),
          child: SlidableCard(
            child: buildFolderCard(),
            actions: [
              SlidableCardAction(
                backgroundColor: colorScheme.surface,
                onTap: () => controller.onTapEdit(widget.folder),
                icon: Icon(Icons.edit_outlined, color: primaryColor),
                borderSide: BorderSide(
                  color: colorScheme.outline,
                  width: 1.25,
                ),
              ),
              SlidableCardAction(
                backgroundColor: colorScheme.surface,
                onTap: () => controller.onTapDelete(widget.folder),
                icon: Icon(Icons.delete_outline_rounded, color: primaryColor),
                borderSide: BorderSide(
                  color: colorScheme.outline,
                  width: 1.25,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap ?? () => controller.onTapCard(widget.folder),
      child: buildFolderCard(),
    );
  }

  Widget buildFolderCard() {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: widget.higlight
            ? BorderSide(color: primaryColor, width: 1.25)
            : BorderSide(color: colorScheme.outline, width: 1.25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          children: [
            preImage,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.folder.name,
                maxLines: 1,
                softWrap: false,
                style: textTheme.bodyLarge,
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              widget.folder.numberOfNotes.toString(),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
