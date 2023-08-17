import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


Future<dynamic> arDialog({
  required String title,
  required String subject,
  required VoidCallback onConfirm,
  Widget? optionalWidget,
  BuildContext? context,
  VoidCallback? onCancel
}) {
  return showDialog(
      barrierDismissible: false,
      context: context?? Constants.kScaffoldKey.currentState!.context,
      builder: (_) => StatefulBuilder(
        builder: (_, __) {
          return  _ArDialogBody(
            title: title,
            subject: subject,
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
    required this.onConfirm,
    this.optionalWidget,
    this.onCancel,
  });

  final String title;
  final String subject;
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
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.h),
            padding:  EdgeInsets.symmetric(vertical: 4.h,horizontal: 3.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      IconButton(onPressed: () async {
                          try {
                            if(widget.onCancel!=null) {
                              await widget.onCancel!();
                            }
                          } catch(e,stackTrace) {
                            ArLogger.log(data: e,stackTrace: stackTrace);
                          } finally {
                            context.read<ArButtonCubit>().setUnLoad();
                            Navigator.pop(context);
                          }
                      },
                          icon: const Icon(Icons.close))
                    ],),
                  ),
                  Text(
                    "${widget.title}\n",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Flexible(
                      flex: 2,
                      child: Text(widget.subject)),
                  Flexible(
                    flex: context.watch<ArButtonCubit>().state||widget.optionalWidget!=null? 5:0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Center(child:
                      context.watch<ArButtonCubit>().state? const TerminalScreen():
                      widget.optionalWidget??const SizedBox(height: 10,)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Center(
                      child: BlocBuilder<ArButtonCubit,bool>(
                        builder: (BuildContext context, state) {
                          return ArButton(
                            title: "Okay",
                            isLoading: state,
                            isSelected: true,
                            action: () async {
                              try {
                                 await widget.onConfirm();
                              } catch(e,stackTrace) {
                                ArLogger.log(data: e,stackTrace: stackTrace);
                              }
                            },
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
