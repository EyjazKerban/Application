import 'package:flutter/material.dart';
import 'dart:math';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final String fullName;
  final String time;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSentByMe,
    this.fullName = '',
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.75;
    final textSize = _calculateTextSize(message, maxWidth, context);
    final bubbleWidth = min(textSize.width + 50, maxWidth);

    // Extract the initials from fullName
    String initials = fullName.isNotEmpty
        ? fullName.trim().split(' ').map((e) => e[0]).take(2).join()
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end, // Align items at the bottom
        children: [
          if (!isSentByMe) // Only for received messages
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 18, // Make the avatar smaller
              child: Text(
                initials,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14), // Adjust font size as needed
              ),
            ),
          if (!isSentByMe)
            SizedBox(
                width:
                    8.0), // Spacing between the avatar and the message bubble

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            width: bubbleWidth,
            decoration: BoxDecoration(
              color:
                  isSentByMe ? Color.fromARGB(255, 21, 74, 133) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft:
                    isSentByMe ? Radius.circular(16) : Radius.circular(0),
                bottomRight:
                    isSentByMe ? Radius.circular(0) : Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 18,
                      color: isSentByMe ? Colors.white : Colors.black87),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: TextStyle(
                        fontSize: 12,
                        color: isSentByMe ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Size _calculateTextSize(String text, double maxWidth, BuildContext context) {
    final textStyle = TextStyle(fontSize: 18);
    final textSpan = TextSpan(text: text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth - 50);
    return Size(textPainter.width, textPainter.height);
  }
}
