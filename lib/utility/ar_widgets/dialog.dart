import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> arDialog({required String title, required String subject, bool? isWarning = false, required VoidCallback onConfirm, Widget? optionalWidget, VoidCallback? onCancel, required BuildContext context}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return  _ArDialogBody(
            title: title,
            subject: subject,
            isWarning: isWarning,
            onConfirm: onConfirm,
            optionalWidget: optionalWidget,
            onCancel: onCancel,
          );
        },
      ));
}

class _ArDialogBody extends StatefulWidget {
   const _ArDialogBody({
    required this.title,
    required this.subject,
    this.isWarning = false,
    required this.onConfirm,
    this.optionalWidget,
    this.onCancel,
  });

  final String title;
  final String subject;
  final bool? isWarning;
  final Function onConfirm;
  final Widget? optionalWidget;
  final Function? onCancel;

  @override
  State<_ArDialogBody> createState() {
    return _ArDialogBodyState();
  }
}

class _ArDialogBodyState extends State<_ArDialogBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(vertical: size.height / 7, horizontal: size.width / 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                IconButton(onPressed: () async {
                    try {
                      await widget.onCancel!();
                    } catch (_) {
                    } finally {
                      context.read<ArButtonCubit>().setUnLoad();
                    }
                },
                    icon: const Icon(Icons.close))
              ],),
            ),
            Text(
              "${widget.title}\n",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(widget.subject),
            Expanded(child: Center(child: widget.optionalWidget ?? Container())),
            Center(
              child: BlocBuilder<ArButtonCubit,bool>(
                builder: (BuildContext context, state) {
                  return ArButton(
                    title: "Okay",
                    isLoading: state,
                    isSelected: true,
                    action: () async {
                      context.read<ArButtonCubit>().setLoad();
                      try {
                        await widget.onConfirm();
                      } catch (_) {}
                      finally{
                        context.read<ArButtonCubit>().setUnLoad();
                      }
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
