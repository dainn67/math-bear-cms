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
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _numberOfImagesController = TextEditingController(text: '5');

  String get _prompt => _promptController.text.trim();
  int get _numberOfImages => int.tryParse(_numberOfImagesController.text.trim()) ?? 5;

  @override
  void dispose() {
    _promptController.dispose();
    _numberOfImagesController.dispose();
    super.dispose();
  }

  void _handleGenerate(ImageGenProvider provider) {
    if (_prompt.isNotEmpty) {
      provider.generateImageQuestionsList(_prompt, numberOfImages: _numberOfImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Consumer<ImageGenProvider>(
        builder: (context, provider, _) => Column(
          children: [
            _buildInputSection(provider),
            Expanded(child: _buildContent(provider)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Math Bear CMS',
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  Widget _buildInputSection(ImageGenProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tạo câu hỏi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _buildPromptField(provider),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: _buildNumberField(provider),
              ),
              const SizedBox(width: 16),
              _buildGenerateButton(provider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptField(ImageGenProvider provider) {
    return TextField(
      controller: _promptController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: 'Nhập nội dung câu hỏi...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4299E1), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onSubmitted: (_) => _handleGenerate(provider),
    );
  }

  Widget _buildNumberField(ImageGenProvider provider) {
    return TextField(
      controller: _numberOfImagesController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: '5',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4299E1), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onSubmitted: (_) => _handleGenerate(provider),
    );
  }

  Widget _buildGenerateButton(ImageGenProvider provider) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: provider.isLoading ? null : () => _handleGenerate(provider),
        icon: Icon(
          provider.isLoading ? Icons.hourglass_empty : Icons.auto_awesome,
          size: 20,
        ),
        label: Text(provider.isLoading ? 'Đang tạo...' : 'Tạo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4299E1),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBackgroundColor: const Color(0xFFCBD5E0),
        ),
      ),
    );
  }

  Widget _buildContent(ImageGenProvider provider) {
    if (provider.isLoading) {
      return _buildLoadingState();
    }

    if (provider.imageQuestions.any((q) => q.hasError)) {
      return _buildErrorState(provider);
    }

    if (provider.imageQuestions.isEmpty) {
      return _buildEmptyState();
    }

    return _buildQuestionsList(provider);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF4299E1),
            strokeWidth: 3,
          ),
          SizedBox(height: 24),
          Text(
            'Đang tạo câu hỏi...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ImageGenProvider provider) {
    final error = provider.imageQuestions.firstWhere((q) => q.hasError).error!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFFC8181),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              error,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4A5568),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _handleGenerate(provider),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4299E1),
                side: const BorderSide(color: Color(0xFF4299E1)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.layers_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chưa có câu hỏi nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập prompt và nhấn "Tạo" để bắt đầu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList(ImageGenProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        childAspectRatio: 0.75,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: provider.imageQuestions.length,
      itemBuilder: (context, index) => _QuestionCard(
        question: provider.imageQuestions[index],
        index: index,
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final ImageQuestion question;
  final int index;

  const _QuestionCard({
    required this.question,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildQuestionSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: question.imageGenResponse.hasImages
              ? Image.memory(
                  base64Decode(question.imageGenResponse.firstImage!),
                  width: double.infinity,
                  fit: BoxFit.contain,
                )
              : const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Color(0xFFCBD5E0),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Câu ${index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C5282),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                question.question,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF2D3748),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
