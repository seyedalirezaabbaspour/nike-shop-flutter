

import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/ui/widgets/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;
  BannerSlider({
    super.key, required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
            physics: defaultScrollPhysics,
            controller: _controller,
            itemCount: banners.length,
            itemBuilder: (context, index) => _Slide(banner: banners[index]),
              ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Center(
              child: SmoothPageIndicator(controller: _controller, count: banners.length,
              axisDirection: Axis.horizontal,
              effect: WormEffect(
                spacing: 4,
                radius: 4,
                dotWidth: 18,
                dotHeight: 3,
                paintStyle: PaintingStyle.fill,
                strokeWidth: 1.5,
                dotColor: Colors.grey.shade400,
                activeDotColor: Theme.of(context).colorScheme.onSurface
              ),  
                      ),
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final BannerEntity banner;
  const _Slide({
    super.key,
    required this.banner,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageUrl: banner.imageUrl,
        borderRadius: 12,
        ),
    );
  }
}