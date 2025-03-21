import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../widgets/app_text.dart';
import '../models/post_model.dart';
import '../providers/provider.dart';
import 'widgets/image_builder.dart';

class AddPostPage extends ConsumerStatefulWidget {
  final PostModel? post;

  const AddPostPage({super.key, required this.post});

  static const String route = "/add-edit-post";

  @override
  ConsumerState<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  @override
  void initState() {
    super.initState();
    // This will be called when the update post from home page more action [Edit].
    if (widget.post != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(addPostProivder.notifier).editPost(widget.post!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(addPostProivder);
    // final post = state.post;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Create post",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          ///
          ///
          /// Select images.
          ///
          ///
          const PostImageBuilder(),

          ///
          ///
          /// Select a service
          ///
          ///
          if (widget.post?.id == null) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => ref.read(addPostProivder.notifier).selectService(context),
              child: Container(
                height: 100.px,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: KColors.grey2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Consumer(
                  builder: (_, ref, __) {
                    final service = ref.watch(addPostProivder.select((value) => value.post.service));
                    final media = service?.medias.firstOrNull;

                    if (service != null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(media?.url ?? ''),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [KColors.black10, KColors.black60],
                              ),
                            ),
                            child: AppText(
                              service.title ?? '',
                              fontSize: 16,
                              color: KColors.white,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: AppText(
                          "Select a service",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),

          ///
          ///
          /// Title and Description
          ///
          ///
          // Padding(
          //   padding: const EdgeInsets.all(16.0).copyWith(top: 0),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(12),
          //     child: AppTextField(
          //       controller: ref.read(addPostProivder.notifier).descriptionController,
          //       onChanged: (value) {
          //         final provider = ref.read(addPostProivder.notifier);
          //         provider.update((state) => state.copyWith(post: state.post.copyWith(description: value)));
          //       },
          //       validator: (value) {
          //         if (value == null || value.isEmpty) return "Required";
          //         return null;
          //       },
          //       hintText: "Type description",
          //       minLines: 8,
          //       maxLines: 100,
          //       radius: 0,
          //       borderColor: Colors.transparent,
          //       keyboardType: TextInputType.multiline,
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SafeArea(
          child: Row(
            children: [
              if (widget.post?.id != null && isENTREPRENEUR && widget.post?.createdBy == userId) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => ref.read(addPostProivder.notifier).deletePost(context, widget.post!.id!),
                    padding: const EdgeInsets.only(),
                    color: const Color.fromARGB(255, 255, 17, 0),
                    disabledColor: KColors.grey,
                    child: const AppText(
                      "Delete",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Expanded(
                child: CupertinoButton(
                  onPressed: () => ref.read(addPostProivder.notifier).submit(context, ref, PostStatus.PUBLISHED),
                  disabledColor: KColors.grey,
                  color: KColors.purple,
                  child: const AppText(
                    "Post",
                    fontSize: 16,
                    color: KColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
