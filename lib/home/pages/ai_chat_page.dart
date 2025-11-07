import 'package:flutter/material.dart';
import '../../main_bottom_nav_screen.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const primary = Color(0xff015093);
  static const pageBg  = Color(0xffF3F5F7);
  final TextEditingController _input = TextEditingController();

  final _messages = <_Msg>[
    _Msg('Hello, Good Morning', true),
    _Msg("I'm looking for a car under \$20,000, good for family use", true),
    _Msg('Good Morning', false),
    _Msg('Got it! Based on your budget and family needs, here are some great options', false),
    _Msg('We can meet tomorrow', true),
    _Msg('That will be great!', false),
    _Msg("I'm doing well, thanks for asking! Glad to hear you're fine too.", false),
    _Msg('Not much, just looking to chat and maybe learn something new.', true),
    _Msg('Okay see you tomorrow', true),
    _Msg('Okay, thanks for your time', false),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sheetH = 80.0;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('AI Suggestion', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xffCCDCE9),
                shape: BoxShape.circle,
              ),
              child: IconButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainBottomNavScreen()), (route)=>false);
              }, icon: Icon(Icons.arrow_back_ios,size: 18,color: primary ,)),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, sheetH),
        itemCount: _messages.length,
        itemBuilder: (context, i) => _Bubble(msg: _messages[i]),
      ),

      bottomSheet: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0x14000000))),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xffCCDCE9)),
                  ),
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  if (_input.text.trim().isEmpty) return;
                  setState(() {
                    _messages.add(_Msg(_input.text.trim(), true));
                  });
                  _input.clear();
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffCCDCE9)),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: const Icon(Icons.send_rounded, color: primary, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool isMe;
  const _Msg(this.text, this.isMe);
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    const inBg    = Color(0xffE9EDF2);

    final align = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.isMe ? primary : inBg;
    final textColor = msg.isMe ? Colors.white : const Color(0xFF333333);
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: msg.isMe ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: msg.isMe ? const Radius.circular(4) : const Radius.circular(16),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .72),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
            child: Text(
              msg.text,
              style: TextStyle(color: textColor, fontSize: 13.5, height: 1.35),
            ),
          ),
        ),
      ],
    );
  }
}
