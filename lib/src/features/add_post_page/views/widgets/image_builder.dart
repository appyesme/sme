import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/kcolors.dart';
import '../../../../services/file_service/file_service.dart';
import '../../../../widgets/svg_icon.dart';
import '../../models/post_model.dart';
import '../../providers/provider.dart';

class PostImageBuilder extends ConsumerWidget {
  const PostImageBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> valueNotifier = ValueNotifier(0);

    return GestureDetector(
      onTap: ref.read(addPostProivder.notifier).pickImages,
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer(
          builder: (_, ref, __) {
            final images = ref.watch(addPostProivder.select((value) => value.images));
            final postMedias = ref.watch(addPostProivder.select((value) => value.post.medias));

            final medias = [...images ?? <FileX>[], ...postMedias];

            if (medias.isEmpty) {
              return addNewImageWidget();
            } else {
              final notExceeded = medias.length < MAX_POST_MEDIA_COUNT;
              final count = medias.length + (notExceeded ? 1 : 0);

              return Stack(
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: count,
                      onPageChanged: (value) => valueNotifier.value = value,
                      itemBuilder: (context, index) {
                        if (notExceeded && medias.length == index) return addNewImageWidget();

                        final media = medias[index];
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: KColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: KColors.black10),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    if (media is FileX) {
                                      return Image.file(
                                        File(media.path),
                                        fit: BoxFit.cover,
                                      );
                                    } else if (media is PostMedia) {
                                      return CachedNetworkImage(
                                        imageUrl: media.url ?? '',
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {
                                  final provider = ref.read(addPostProivder.notifier);
                                  provider.deleteMedia(context, index, media: media is PostMedia ? media : null);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: KColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: KColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: valueNotifier,
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              count,
                              (dotindex) {
                                bool isSelected = dotindex == valueNotifier.value;

                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Container addNewImageWidget() {
    return Container(
      decoration: BoxDecoration(
        color: KColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: KColors.black10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            SvgIcons.uploadimage,
            color: KColors.grey,
            size: 54.px,
          ),
        ],
      ),
    );
  }
}
