import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedModel = '默认模型';

  final List<String> _availableModels = const [
    '默认模型',
    '英语学习助手',
    '编程导师',
    '数学解题',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _createNewConversation() {
    setState(() {
      _messages.clear();
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _messages.add(
        Message(
          id: '${DateTime.now().millisecondsSinceEpoch}-ai',
          text: '这里是AI回复的示例内容，用于展示界面效果。',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _inputController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showModelSelector() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '选择AI模型',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ..._availableModels.map(
                (model) => ListTile(
                  title: Text(model),
                  trailing: model == _selectedModel
                      ? const Icon(Icons.check, color: Colors.indigo)
                      : null,
                  onTap: () {
                    setState(() => _selectedModel = model);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 学习助手'),
        centerTitle: true,
      ),
      drawer: _ConversationList(onNewConversation: _createNewConversation),
      endDrawer: const _SettingsDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _EmptyConversation(onCreate: _createNewConversation)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(
                        message: message,
                        onShowActions: message.isUser
                            ? null
                            : () => _showMessageActions(message),
                      );
                    },
                  ),
          ),
          _InputArea(
            controller: _inputController,
            selectedModel: _selectedModel,
            onModelTap: _showModelSelector,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showMessageActions(Message _) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(title: Text('操作1')),
              ListTile(title: Text('操作2')),
              ListTile(title: Text('操作3')),
            ],
          ),
        );
      },
    );
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.onNewConversation});

  final VoidCallback onNewConversation;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '对话列表',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('对话 ${index + 1}'),
                    subtitle: const Text('上次更新：昨天'),
                    onTap: () => Navigator.of(context).pop(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNewConversation();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('新建对话'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDrawer extends StatelessWidget {
  const _SettingsDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '设置',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('账户管理'),
            ),
            const ListTile(
              leading: Icon(Icons.edit_note_outlined),
              title: Text('填写资料'),
            ),
            const ListTile(
              leading: Icon(Icons.workspace_premium_outlined),
              title: Text('订阅套餐'),
            ),
            const ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('设置语言'),
            ),
            const ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('主题设置'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.selectedModel,
    required this.onModelTap,
    required this.onSend,
  });

  final TextEditingController controller;
  final String selectedModel;
  final VoidCallback onModelTap;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onModelTap,
                icon: const Icon(Icons.memory_outlined),
                label: Text(selectedModel),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: '请输入要发送的内容…',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: onSend,
                  child: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              '还没有对话',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '点击下方按钮开始你的第一次学习对话。',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_comment_rounded),
              label: const Text('新建对话'),
            ),
          ],
        ),
      ),
    );
  }
}
