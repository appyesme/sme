import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../add_post_page/models/post_model.dart';
import '../../../add_post_page/views/add_post_page.dart';
import '../../../home_page/views/widgets/post_card.dart';
import '../../../services_list_page/models/service_model.dart';

Future<ServiceModel?> viewPostSheet(BuildContext context, PostModel post) {
  return showDialog<ServiceModel?>(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: PostCard(
          post: post,
          onEditTap: () {
            context.pop(); // Close the post view modal sheet.
            context.pushNamed(
              AddPostPage.route,
              extra: post,
            );
          },
        ),
      ),
    ),
  );
}
