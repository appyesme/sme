import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../add_post_page/models/post_model.dart';
import '../../../profile_page/views/profile_page.dart';
import '../../../service_details_page/views/service_details_page.dart';
import '../../providers/provider.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  final VoidCallback onEditTap;
  const PostCard({
    super.key,
    required this.post,
    required this.onEditTap,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void onAuthorTap(PostModel post) {
    DialogHelper.unfocus(context);
    context.pushNamed(
      ProfilePage.route,
      extra: post.createdBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final index = ref.read(homeProvider.select((value) => value.posts?.indexWhere((e) => e.id == widget.post.id)));
    if (index == null || index == -1) return const SizedBox();

    final post = ref.watch(homeProvider.select((value) => value.posts?.elementAt(index)));
    if (post == null) return const SizedBox();

    final medias = post.medias;
    ValueNotifier<int> valueNotifier = ValueNotifier(0);

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              key: PageStorageKey(post.id ?? ''),
              onPageChanged: (value) => valueNotifier.value = value,
              physics: const ClampingScrollPhysics(),
              children: [
                ...medias.map(
                  (e) => AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: e.url ?? '',
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (context, url) => CachedNetworkImage(
                        imageUrl: e.url ?? '', // Load lower-quality thumbnail first
                        memCacheWidth: 300,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          post.medias.length,
                          (dotindex) {
                            bool isSelected = dotindex == valueNotifier.value;

                            return Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    KColors.black40,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onAuthorTap(post),
                    child: ProfileAvatar(
                      image: post.author?.photoUrl,
                      scale: 24,
                      errorIconSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => onAuthorTap(post),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: AppText(
                              post.author?.name ?? '',
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                              color: KColors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (!isENTREPRENEUR) ...[
                    AppButton(
                      onTap: () {
                        context.pushNamed(
                          ServiceDetailsPage.route,
                          extra: ServiceDetailsParam(
                            serviceID: post.serviceId,
                            showActions: false,
                          ),
                        );
                      },
                      width: 30.px,
                      height: 30.px,
                      elevation: 0,
                      radius: 30,
                      fontSize: 12,
                      textColor: KColors.white,
                      backgroundColor: KColors.black50,
                      text: "View",
                    ),
                  ],
                  if (isLoggedIn && isENTREPRENEUR && post.createdBy == userId) ...[
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => widget.onEditTap.call(),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: KColors.grey2,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: KColors.bgColor,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
