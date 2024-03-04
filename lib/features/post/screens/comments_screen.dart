import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/post/widgets/comment_card.dart';
import 'package:pets_social/features/post/widgets/post_card.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/models/profile.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void postComment(ModelPost post) {
    ref.read(postControllerProvider.notifier).postComment(
          _commentController.text.trim(),
          post,
        );
    setState(() {
      _commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final getComments = ref.watch(getCommentsProvider(widget.postId));
    final post = ref.watch(getPostByIdProvider(widget.postId));

    return post.when(
        error: (error, stacktrace) => Text('error: $error'),
        loading: () => Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            ),
        data: (post) {
          PostCard(post: post);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text(LocaleKeys.comments.tr()),
              centerTitle: false,
            ),
            body: getComments.when(
              error: (error, stacktrace) => Text('error: $error'),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                ),
              ),
              data: (getComments) {
                return ListView.builder(
                  itemCount: getComments.length,
                  itemBuilder: (context, index) => CommentCard(
                    comment: getComments[index],
                  ),
                );
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: (profile != null && profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/images/default_pic') as ImageProvider<Object>,
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8.0),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.commentAs.tr(namedArgs: {"profile": profile!.username}),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        postComment(post);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Text(
                          LocaleKeys.post.tr(),
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
