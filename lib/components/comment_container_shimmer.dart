import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentContainerShimmer extends StatelessWidget {
  const CommentContainerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Profile picture goes here
            _wrapShimmer(
                const CircleAvatar()
            ),
            Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    _wrapShimmer(
                      Card(
                        child: Text(
                          ''.padLeft(32)
                        ),
                      )
                    ),

                    // Comment content
                    _wrapShimmer(
                        const Card(
                          child: SizedBox(
                              height: 128,
                              width: 256,
                          ),
                        )
                    )
                  ],
                )
            )
          ],
        ),
    );
  }

  Widget _wrapShimmer(Widget content) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        period: const Duration(milliseconds: 1500),
        child: content
    );
  }
}