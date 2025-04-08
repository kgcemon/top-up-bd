import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class ReviewInputForm extends StatefulWidget {

  const ReviewInputForm({super.key});

  @override
  _ReviewInputFormState createState() => _ReviewInputFormState();
}

class _ReviewInputFormState extends State<ReviewInputForm> {
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(backgroundColor: Colors.grey[100],),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Leave a Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              // Rating Bar
              Row(
                children: [
                  const Text('Rating:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  _buildRatingBar(),
                ],
              ),
              const SizedBox(height: 10),
              // Review Text Field
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Write your review',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (reviewController.text.isNotEmpty) {
                    reviewController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Rating bar widget
  Widget _buildRatingBar() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            setState(() {
              rating = index + 1.0;
            });
          },
        );
      }),
    );
  }
}
