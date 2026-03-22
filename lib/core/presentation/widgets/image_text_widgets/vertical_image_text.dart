import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = AppColors.text1,
    this.backgroundColor = AppColors.white,
    this.onTap, this.isNetworkImage = false,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.text1,
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: isNetworkImage
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            SizedBox(
                width: 55,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}