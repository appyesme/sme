import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import '../core/shared/shared.dart';
import 'app_text.dart';

class CachedImageViewer extends StatelessWidget {
  final String path;
  const CachedImageViewer({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                appLogo,
                fit: BoxFit.fill,
                height: 40,
                width: 40,
                opacity: const AlwaysStoppedAnimation(0.1),
              ),
            ),
          ],
        );
      },
      placeholder: (context, url) {
        return const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: KColors.bgColor,
              ),
            ),
            AppText("Loading...", color: KColors.grey),
          ],
        );
      },
    );
  }
}
