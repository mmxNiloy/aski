import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostContainerShimmer extends StatelessWidget {
  const PostContainerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            drawCardHeaderShimmer(),
            const SizedBox(
              height: 8.0,
            ),

            // Title of a Card
            drawCardContentShimmer(),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget drawCardHeaderShimmer() {
    // Show User Profile Pic
    // Show User name
    // Show when the post has been posted
    // Menu bar for reporting the post

    return Row(
      children: [
        // Profile Pic Circle Area
        // Grab profile pic from gmail, fb or other platforms
        // Grab from database as well if exists
        // Otherwise placeholder image
        wrapShimmer(
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              // Profile pic
              child: Icon(
                Icons.circle_rounded,
                size: 40,
              ),
          )
        ),

        // User Name and post timestamp
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              wrapShimmer(
                  Card(
                    child: Text(
                      'x' * 32,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                    ),
                ),
                  )
              ),

              wrapShimmer(
                  const Card(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Posted on dd-mm-yyyy hh:mm am/pm',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),

                        SizedBox(width: 8,),

                        Icon(Icons.public, size: 10),
                      ],
                ),
                  )
              ),
              // timestamp

            ],
          ),
        ),
      ],
    );
  }

  Widget drawCardContentShimmer() {
    // Body and meat of the card
    // Will show the main contents of the post

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Title
        wrapShimmer(
          Card(
            child: Text(
                "x" * 64,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
        ),

        const SizedBox(
          height: 8.0,
        ),

        // Post Content
        // TODO: Constraint the box to facilitate a few lines as preview
        wrapShimmer(
          Container(
            height: 128,
            color: Colors.cyan
          )
        )
      ],
    );
  }

  Widget wrapShimmer(Widget content) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        period: const Duration(milliseconds: 1500),
        child: content
    );
  }
}