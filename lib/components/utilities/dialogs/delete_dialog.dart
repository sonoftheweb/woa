import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  String? title,
  String? description,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: title ?? 'Delete',
    content: description ?? 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
