import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../../controllers/widgets/sheets/folder_picker_controller.dart';
import '../../i18n/localizations.dart';
import '../cards/folder_card.dart';

class FolderPicker extends ConsumerWidget {
  final FolderPickerController controller;
  final String? folderID;

  FolderPicker({this.folderID}) : controller = FolderPickerController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildTitle(ref), Flexible(child: buildBody(ref))],
    );
  }

  Widget buildTitle(WidgetRef ref) {
    final showButton = folderID != null || ref.watch(contextualBarController.select((state) => state.active));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.instance.w17,
            style: Theme.of(ref.context).textTheme.titleLarge,
          ),
          Row(
            children: [
              if (showButton)
                IconButton(
                  onPressed: () => controller.onTapClear(ref.context),
                  icon: Icon(Icons.highlight_remove_outlined),
                ),
              IconButton(
                onPressed: () => controller.showFolderDialog(ref.context),
                icon: Icon(Icons.create_new_folder_outlined, size: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBody(WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: controller.listenable(),
      builder: (_, __, child) {
        final folders = controller.getAllFolders(ref);

        return ListView.separated(
          shrinkWrap: true,
          itemCount: folders.length,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final folder = folders[index];

            return FolderCard(
              folder,
              slidable: false,
              higlight: folderID == folder.id,
              onTap: () => controller.onTapFolder(folder, ref.context),
            );
          },
        );
      },
    );
  }
}
