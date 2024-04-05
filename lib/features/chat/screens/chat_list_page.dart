import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/features/chat/controller/chat_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/router.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  bool isShowUsers = false;
  final TextEditingController searchController = TextEditingController();
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ModelProfile? profile = ref.read(userProvider);
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', whereIn: profile!.following).get();

      if (usersSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
          ModelProfile profile = ModelProfile.fromSnap(doc);

          profiles.add(profile);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: LocaleKeys.search.tr(),
            labelStyle: TextStyle(color: theme.colorScheme.secondary),
            suffixIcon: isShowUsers
                ? TextButton(
                    onPressed: () {
                      setState(
                        () {
                          searchController.clear();
                          isShowUsers = false;
                        },
                      );
                    },
                    child: Text(LocaleKeys.cancel.tr()))
                : const Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(
              () {
                isShowUsers = true;
                profilesFiltered = profiles.where((element) => element.username.toLowerCase().contains(value.toLowerCase())).toList();
              },
            );
          },
        ),
      ),
      body: isShowUsers
          ? ListView.builder(
              itemCount: profilesFiltered.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.goNamed(AppRouter.chatPage.name, pathParameters: {
                      'receiverUserEmail': profilesFiltered[index].email,
                      'receiverProfileUid': profilesFiltered[index].profileUid,
                      'receiverUsername': profilesFiltered[index].username,
                      'receiverUserUid': profilesFiltered[index].uid,
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilesFiltered[index].photoUrl!),
                    ),
                    title: Text(profilesFiltered[index].username),
                  ),
                );
              },
            )
          : _buildUserList(),
    );
  }

  //PROFILES LIST
  Widget _buildUserList() {
    final ThemeData theme = Theme.of(context);
    final chatsList = ref.watch(getChatsListProvider);

    return chatsList.when(
      loading: () => LinearProgressIndicator(
        color: theme.colorScheme.secondary,
      ),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (chats) {
        if (chats.isEmpty) {
          return Center(
            child: Text(LocaleKeys.startChatting.tr()),
          );
        }
        return ListView(
          children: chats.map<Widget>((chats) => _buildUserListItem(chats)).toList(),
        );
      },
    );
  }

  //PROFILES LIST ITEMS
  Widget _buildUserListItem(
    DocumentSnapshot document,
  ) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final lastMessages = ref.watch(getLastMessageProvider(profile!.profileUid, data['profileUid']));

    return lastMessages.when(
      error: (error, stacktrace) => Text('Error: $error'),
      loading: () => LinearProgressIndicator(
        color: theme.colorScheme.secondary,
      ),
      data: (lastMessages) {
        bool hasUnreadMessages = lastMessages.any((lastMessage) => !lastMessage['read']);
        String message = lastMessages.isNotEmpty ? lastMessages[0]['message'] : '';
        String croppedMessage = cropMessage(message, 25);

        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
          ),
          title: hasUnreadMessages
              ? Text(
                  data['username'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Text(data['username']),
          subtitle: Text(
            croppedMessage,
            //style: hasUnreadMessages ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          trailing: hasUnreadMessages
              ? Icon(
                  Icons.fiber_manual_record,
                  size: 20,
                  color: theme.colorScheme.secondary,
                )
              : null,
          onTap: () {
            context.goNamed(AppRouter.chatPage.name, pathParameters: {
              'receiverUserEmail': data['email'],
              'receiverProfileUid': data['profileUid'],
              'receiverUsername': data['username'],
              'receiverUserUid': data['uid'],
            });
          },
        );
      },
    );
  }
}
