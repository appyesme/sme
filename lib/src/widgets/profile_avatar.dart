import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? image;
  final double scale;
  final double? errorIconSize;
  const ProfileAvatar({
    super.key,
    required this.image,
    required this.scale,
    this.errorIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: image ?? '',
        fit: BoxFit.cover,
        height: scale,
        width: scale,
        maxHeightDiskCache: 200,
        maxWidthDiskCache: 200,
        placeholder: (context, url) => CircleAvatar(
          backgroundColor: KColors.grey1,
          child: Icon(
            CupertinoIcons.person_solid,
            size: errorIconSize,
            color: Colors.black26,
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundColor: KColors.grey2,
          child: Icon(
            CupertinoIcons.person_solid,
            size: errorIconSize,
            color: KColors.black10,
          ),
        ),
      ),
    );
  }
}
