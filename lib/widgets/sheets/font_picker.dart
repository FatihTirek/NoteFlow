import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../controllers/widgets/sheets/font_picker_controller.dart';
import '../../extensions/text_style_extension.dart';
import '../../theme/app_theme_state.dart';

class FontPicker extends ConsumerWidget {
  final FontPickerController controller = FontPickerController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleSmall = Theme.of(context).textTheme.titleSmall!;
    final colorScheme = Theme.of(context).colorScheme;

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SizedBox(
        height: 2 * (titleSmall.getSingleLineTextHeight(context) + 32) + 45,
        child: MasonryGridView(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: Font.values.map((font) {
            final name = ref.read(appThemeController.notifier).getFont(font);
            final active = font == ref.read(appThemeController).font;

            return Center(
              child: GestureDetector(
                onTap: () => controller.onTapFont(ref, font),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(name, style: titleSmall),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1.25,
                      color: active ? Theme.of(context).primaryColor : colorScheme.outline,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
