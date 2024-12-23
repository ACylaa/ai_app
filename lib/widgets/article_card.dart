import 'package:ai_app/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';
import '../theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);
  Map<String, String> parseSummary(String? summary) {
    if (summary == null) {
      return {
        'summaryText': 'No summary available.',
        'importanceLevel': 'Not specified',
      };
    }

    final summaryParts = summary.split('Importance Level');
    if (summaryParts.length > 1) {
      final firstPart = summaryParts[0]
          .replaceAll("Here's a concise summary and importance level:\nSummary\n", '')
          .trim();
      final secondPart = summaryParts[1].split('\n')[0].trim();

      return {
        'summaryText': firstPart.isEmpty ? 'No summary available.' : firstPart,
        'importanceLevel': secondPart.isEmpty ? 'Not specified' : secondPart,
      };
    } else {
      return {
        'summaryText': summary.trim(),
        'importanceLevel': 'Not specified',
      };
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsed = parseSummary(article.summary);
    final summaryText = parsed['summaryText']!;
    final importanceLevel = parsed['importanceLevel']!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.primaryColor),
        ),
        child: Column(
          // Important fix: let the Column shrink-wrap its children
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image or placeholder
            AspectRatio(
              aspectRatio: 16 / 9,
              child: (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                  ? Image.network(
                      article.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                article.title ?? 'No Title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Summary text (no Expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                summaryText,
                style: const TextStyle(fontSize: 14),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Importance level
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Importance Level: $importanceLevel',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // "Read Full Article"
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: InkWell(
                onTap: () {
                  if (article.url != null && article.url!.isNotEmpty) {
                    _launchUrl(article.url!);
                  }
                },
                child: Text(
                  'Read Full Article',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: const Center(
        child: Text('No Image Available'),
      ),
    );
  }
}
