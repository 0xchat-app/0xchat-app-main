import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';

class ChatUserChoosePage extends StatefulWidget {
  const ChatUserChoosePage({Key? key}) : super(key: key);

  @override
  State<ChatUserChoosePage> createState() => _ChatUserChoosePageState();
}

class _ChatUserChoosePageState extends State<ChatUserChoosePage> {
  List<SelectableUser> _selectableUsers = [];

  @override
  void initState() {
    super.initState();
    // Initialize the SelectableUser list
    final friends = Contacts.sharedInstance.allContacts;
    _selectableUsers = friends.values.map((user) => SelectableUser(user: user)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        useLargeTitle : false,
        centerTitle: true,
        title: 'Choose friend',
        backgroundColor: ThemeColor.color200,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              // Process the selected users
              final selectedUsers = _selectableUsers.where((su) => su.isSelected).map((su) => su.user).toList();
              // ...
              Navigator.of(context).pop(selectedUsers);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _selectableUsers.length,
        itemBuilder: (context, index) {
          final selectableUser = _selectableUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(selectableUser.user.picture ?? ''),
            ),
            title: Text(selectableUser.user.name ?? ''),
            trailing: Checkbox(
              value: selectableUser.isSelected,
              onChanged: (value) {
                setState(() {
                  selectableUser.isSelected = value!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}



class SelectableUser {
  final UserDB user;
  bool isSelected;

  SelectableUser({required this.user, this.isSelected = false});
}
