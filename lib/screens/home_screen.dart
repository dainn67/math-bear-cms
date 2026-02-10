import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imagen_provider.dart';
import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImageGenProvider imageGenProvider;

  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _numberOfImagesController = TextEditingController(text: '5');

  String get prompt => _promptController.text.trim();
  int get numberOfImages => int.tryParse(_numberOfImagesController.text.trim()) ?? 5;

  @override
  void initState() {
    super.initState();
    imageGenProvider = Provider.of<ImageGenProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _numberOfImagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Bear CMS - Danh sách câu hỏi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              imageGenProvider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
            },
          ),
        ],
      ),
      body: Consumer<ImageGenProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Prompt input section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _promptController,
                            decoration: InputDecoration(
                              labelText: 'Prompt',
                              hintText: 'Nhập prompt để tạo câu hỏi...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              if (_promptController.text.trim().isNotEmpty) {
                                provider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _numberOfImagesController,
                            decoration: InputDecoration(
                              labelText: 'Số lượng',
                              hintText: '5',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              prefixIcon: const Icon(Icons.numbers),
                            ),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (_promptController.text.trim().isNotEmpty) {
                                provider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  if (_promptController.text.trim().isNotEmpty) {
                                    provider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
                                  }
                                },
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Tạo'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content section
              Expanded(child: _buildContent(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ImageGenProvider provider) {
    // Loading
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh sách câu hỏi...'),
          ],
        ),
      );
    }

    // Error message
    if (provider.imageQuestions.any((question) => question.hasError)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                provider.imageQuestions.firstWhere((question) => question.hasError).error!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                provider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // Empty list
    if (provider.imageQuestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.question_answer_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có câu hỏi nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhập prompt ở trên để tạo câu hỏi',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                provider.generateImageQuestionsList(prompt, numberOfImages: numberOfImages);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tải câu hỏi mẫu'),
            ),
          ],
        ),
      );
    }

    // Display grid of questions
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.imageQuestions.length,
      itemBuilder: (context, index) => _QuestionCard(question: provider.imageQuestions[index]),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final ImageQuestion question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section with fixed height
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: question.imageGenResponse.hasImages
                  ? Image.memory(
                      base64Decode(question.imageGenResponse.firstImage!),
                      width: double.infinity,
                      fit: BoxFit.scaleDown,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          // Question text section with fixed height
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Text(
                question.question,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
