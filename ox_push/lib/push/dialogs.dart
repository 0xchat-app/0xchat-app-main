import 'package:flutter/material.dart';

noDistributorDialog({required Null Function() onDismissed}) {
  return (BuildContext context) {
    return AlertDialog(
      title: const Text('Push Notifications'),
      content: const SingleChildScrollView(
          child: SelectableText(
              "You need to install a distributor for push notifications to work.\nYou can find more information at: https://unifiedpush.org/users/intro/")),
      actions: [
        TextButton(
          child: const Text('Dismiss'),
          onPressed: () {
            onDismissed();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  };
}

pickDistributorDialog(distributors) {
  return (BuildContext context) {
    return SimpleDialog(
        title: const Text('Select push distributor'),
        children: distributors
            .map<Widget>(
              (d) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, d);
                },
                child: Text(d),
              ),
            )
            .toList());
  };
}
