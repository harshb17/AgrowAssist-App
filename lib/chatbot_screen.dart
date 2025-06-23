import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/chatbot_provider.dart';
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  Map<String, dynamic> _offlineData = {};

  @override
  void initState() {
    super.initState();
    _loadOfflineData();

    // Add initial greeting message
    _messages.add({
      'text':
          'Hello! I\'m your AgrowAssist chatbot. How can I help you with farming today? Try asking me about crop diseases, market prices, farming innovations, or type "help" to see all topics.',
      'isUser': false,
    });
  }

  Future<void> _loadOfflineData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/farming_qa.json',
      );
      setState(() {
        _offlineData = json.decode(response);
      });
    } catch (e) {
      print('Error loading offline data: $e');
      setState(() {
        _offlineData = {
          "questions": {
            "about_app":
                "AgrowAssist is an AI-powered app designed to help Indian farmers with crop recommendations, disease detection, and farming advice.",
            "soil_types":
                "Common soil types in India include alluvial soil, black soil, red soil, laterite soil, and desert soil.",
            "crop_rotation":
                "Crop rotation is the practice of growing different crops in the same area in sequential seasons to improve soil health and reduce pests and diseases.",
            "help":
                "I can provide information on farming practices, crop diseases, market prices, and more. Type 'help' to see all available topics.",
          },
        };
      });
    }
  }

  void _toggleOnlineMode(BuildContext context) {
    final chatbotProvider = Provider.of<ChatbotProvider>(
      context,
      listen: false,
    );
    chatbotProvider.toggleOnlineMode();

    // Add system message when mode changes
    setState(() {
      _messages.add({
        'text':
            chatbotProvider.isOnlineMode
                ? 'Switched to online mode. Using Gemini AI with pre-configured API key.'
                : 'Switched to offline mode. Using local knowledge base.',
        'isUser': false,
        'isSystem': true,
      });
    });

    _scrollToBottom();
  }

  void _sendMessage(BuildContext context) async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    final chatbotProvider = Provider.of<ChatbotProvider>(
      context,
      listen: false,
    );

    setState(() {
      _messages.add({'text': userMessage, 'isUser': true});
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get response using the improved provider
      String response = await chatbotProvider.getGeminiResponse(userMessage);

      if (mounted) {
        setState(() {
          _messages.add({'text': response, 'isUser': false});
          _isLoading = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'text':
                'Sorry, there was an error processing your request. Please try again later.',
            'isUser': false,
            'isError': true,
          });
          _isLoading = false;
        });

        _scrollToBottom();
      }
    }
  }

  String _getOfflineResponse(String query) {
    final lowerQuery = query.toLowerCase();

    // Simple keyword matching for offline mode
    if (_offlineData.containsKey("questions")) {
      final questions = _offlineData["questions"] as Map<String, dynamic>;

      // First, try exact matches
      if (questions.containsKey(lowerQuery.trim())) {
        return questions[lowerQuery.trim()];
      }

      // Then try to find keywords in the query
      for (var key in questions.keys) {
        // Check if key is in the query as a standalone word
        if (lowerQuery.contains(key)) {
          return questions[key];
        }
      }

      // If still not found, try to match parts of words
      for (var key in questions.keys) {
        List<String> keyWords = key.split('_');
        for (var word in keyWords) {
          if (lowerQuery.contains(word) && word.length > 3) {
            // Only match meaningful words
            return questions[key];
          }
        }
      }
    }

    return "I don't have information about that in my offline database. Please try asking something about Indian farming practices or this app.";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatbotProvider = Provider.of<ChatbotProvider>(context);
    final isOnlineMode = chatbotProvider.isOnlineMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Farming Assistant')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            child: Row(
              children: [
                Icon(
                  isOnlineMode
                      ? Icons.cloud_outlined
                      : Icons.cloud_off_outlined,
                  color:
                      isOnlineMode
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mode:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  isOnlineMode
                      ? 'Online (Gemini AI)'
                      : 'Offline (Local Database)',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isOnlineMode,
                  onChanged: (_) => _toggleOnlineMode(context),
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'] as bool;
                final isSystem = message['isSystem'] as bool? ?? false;
                final isError = message['isError'] as bool? ?? false;

                if (isSystem) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isUser
                              ? colorScheme.primary
                              : (isError
                                  ? Colors.red.shade100
                                  : colorScheme.surfaceVariant),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color:
                            isUser
                                ? colorScheme.onPrimary
                                : (isError
                                    ? Colors.red.shade900
                                    : colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Suggestion chips
          if (_messages.length < 3 && !_isLoading)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSuggestionChip('App features'),
                  _buildSuggestionChip('Farming news'),
                  _buildSuggestionChip('Market prices'),
                  _buildSuggestionChip('Organic farming'),
                  _buildSuggestionChip('Crop diseases'),
                  _buildSuggestionChip('Farming hacks'),
                ],
              ),
            ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isOnlineMode
                        ? 'Getting response from Gemini...'
                        : 'Searching local knowledge base...',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.1)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask about farming, crops, or this app...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabled: !_isLoading,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted:
                        !_isLoading ? (_) => _sendMessage(context) : null,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor:
                      _isLoading ? Colors.grey : colorScheme.primary,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: colorScheme.onPrimary,
                    onPressed: _isLoading ? null : () => _sendMessage(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(label),
        onPressed: () {
          setState(() {
            _messageController.text = label;
          });
          _sendMessage(context);
        },
      ),
    );
  }
}
