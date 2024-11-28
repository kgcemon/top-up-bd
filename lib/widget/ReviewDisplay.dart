import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:top_up_bd/screens/add_review.dart';

import '../utils/AppColors.dart';

class ReviewDisplay extends StatelessWidget {
  final List<Map<String, dynamic>>
      reviews; // Each review contains 'text' and 'rating'

  const ReviewDisplay({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Customers Review",
          style: AppTextStyles.bodyTextMedium,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['name'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          review['time'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review['rating'] ? Icons.star : Icons.star_border,
                          color: AppColors.primaryColor,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    // Review text
                    Text(
                      review['text'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () => Get.to(() => const ReviewInputForm()),
            child: const Text(
              "Add A Review",
              style: TextStyle(color: AppColors.primaryColor),
            ))
      ],
    );
  }
}
