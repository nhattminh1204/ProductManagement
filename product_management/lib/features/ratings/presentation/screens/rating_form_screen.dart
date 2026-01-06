import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rating_provider.dart';
import '../../domain/entities/rating_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class RatingFormScreen extends StatefulWidget {
  final int productId;
  final String? productName;

  const RatingFormScreen({
    super.key,
    required this.productId,
    this.productName,
  });

  @override
  State<RatingFormScreen> createState() => _RatingFormScreenState();
}

class _RatingFormScreenState extends State<RatingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final ratingProvider = context.read<RatingProvider>();
      final authProvider = context.read<AuthProvider>();

      // Get user ID from AuthProvider
      final userId = authProvider.userId;

      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to rate'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final rating = Rating(
        id: 0,
        productId: widget.productId,
        userId: userId,
        rating: _rating,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        createdDate: DateTime.now(),
        productName: widget.productName,
      );

      final success = await ratingProvider.createRating(rating);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating submitted successfully'),
            backgroundColor: AppColors.secondary,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Product'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.productName != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.productName!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                'Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 48,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              Text(
                '$_rating out of 5 stars',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                  hintText: 'Share your experience...',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              Consumer<RatingProvider>(
                builder: (context, provider, _) {
                  return FilledButton(
                    onPressed: provider.isLoading ? null : _handleSubmit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Submit Rating',
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
