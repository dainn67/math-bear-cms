import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imagen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Bear CMS - Image Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input and send button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập prompt để tạo ảnh...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ImageGenProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                      onPressed: provider.isLoading ? null : () => provider.generateImage(_promptController.text),
                      child: const Text('Send'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Display image or status
            Expanded(
              child: Consumer<ImageGenProvider>(
                builder: (context, provider, child) {
                  // Loading
                  if (provider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Đang tạo ảnh...'),
                        ],
                      ),
                    );
                  }

                  // Error
                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              provider.clearImage();
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  // No image response yet
                  if (provider.imageGenResponse == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nhập prompt và nhấn Send để tạo ảnh',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Display image
                  return Column(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(provider.imageGenResponse!.images[0]),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              provider.clearImage();
                              _promptController.clear();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tạo ảnh mới'),
                          ),
                        ],
                      )),
                      const SizedBox(height: 24),
                      Text('Response text: ${provider.imageGenResponse?.text ?? 'Empty'}'),
                      Text('Image count: ${provider.imageGenResponse?.imageCount.toString() ?? '0'}'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
