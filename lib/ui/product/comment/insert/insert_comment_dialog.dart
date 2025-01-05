import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/comment_repository.dart';
import 'package:nike/ui/product/comment/insert/bloc/insert_comment_bloc.dart';

class InsertCommentDialog extends StatefulWidget {
  final int productId;
  final ScaffoldMessengerState? scaffoldMessenger;

  const InsertCommentDialog({super.key, required this.productId, this.scaffoldMessenger});

  @override
  State<InsertCommentDialog> createState() => _InsertCommentDialogState();
}

class _InsertCommentDialogState extends State<InsertCommentDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InsertCommentBloc>(
      create: (context) {
        final bloc = InsertCommentBloc(commentRepository, widget.productId);
        subscription = bloc.stream.listen((state) {
          if (state is InsertCommentSuccess) {
            widget.scaffoldMessenger?.showSnackBar(
                SnackBar(content: Text(state.message)));
            Navigator.of(context, rootNavigator: true).pop();
          } 
          else if (state is InsertCommentError) {
            Navigator.of(context, rootNavigator: true).pop();
            widget.scaffoldMessenger?.showSnackBar(
                SnackBar(content: Text(state.exception.message)));
                
          }
        });
        return bloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 300,
          padding: EdgeInsets.all(24),
          child: BlocBuilder<InsertCommentBloc, InsertCommentState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    "ثبت نظر",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      label: Text('عنوان'),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      label: Text('متن نظر خود را اینجا وارد کنید'),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<InsertCommentBloc>().add(
                        InsertCommentFormSubmit(
                          _titleController.text,
                          _contentController.text,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(state is InsertCommentLoading)
                          CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary,),

                        Text('ذخیره'),
                      ],
                    ),
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size.fromHeight(56)),
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
