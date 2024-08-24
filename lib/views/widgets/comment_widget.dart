import 'package:flutter/material.dart';
import 'package:wemotions/views/widgets/commentBubble_widget.dart';
import '../../models/comment.dart';
import 'commentBubbleReply_widget.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final ValueChanged<Comment>? onReply;
  final ValueChanged<String>? onReplyDisplayName;
  final String? onreplyDisplayNameString;
  CommentWidget({required this.comment, this.onReply, this.onReplyDisplayName, this.onreplyDisplayNameString});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            CommentBubbleWidget(comment: widget.comment, onReply: widget.onReply,onReplyDisplayName: widget.onReplyDisplayName),
            if (widget.comment.replies.isNotEmpty) ...[
              Column(
                children: widget.comment.replies
                    .map((reply) => CommentBubbleReplyWidget(comment: reply,onReply: widget.onReply,onReplyDisplayName: widget.onReplyDisplayName, parentComment: widget.comment ))
                    .toList(),
              )
            ]
          ]),
        ],
      ),
    );
  }
}
