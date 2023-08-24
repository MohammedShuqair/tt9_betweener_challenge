import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/features/profile/links/model/link.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_text_form_field.dart';
import 'package:tt9_betweener_challenge/views/widgets/sub_appbar.dart';

class LinkScreen extends StatefulWidget {
  static String addId = "/addLinkScreen";
  const LinkScreen.add({Key? key, this.link}) : super(key: key);
  const LinkScreen.edit({Key? key, required this.link}) : super(key: key);
  final Link? link;

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  late bool isEdit;
  late bool portrait;

  @override
  void initState() {
    isEdit = widget.link != null;
    titleController = TextEditingController();
    linkController = TextEditingController();
    usernameController = TextEditingController();
    setControllers();
    super.initState();
  }

  void setControllers() {
    if (isEdit) {
      titleController.text = widget.link!.title!;
      linkController.text = widget.link!.link!;
      usernameController.text = widget.link!.username!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppBar(
        hint: isEdit ? "Edit" : "Add Link",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Form(
          key: key,
          child: OrientationBuilder(builder: (context, orientation) {
            portrait = orientation == Orientation.portrait;
            Widget txt1 = CustomTextFormField(
              controller: titleController,
              hint: 'Snapchat',
              label: 'Title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the title';
                }
                return null;
              },
            );
            Widget txt2 = CustomTextFormField(
              controller: linkController,
              onChanged: (v) {
                usernameController.text = getUsernameFromInstagramLink(v) ?? '';
              },
              hint: 'http:\\\\www.example.com',
              label: 'Link',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the link';
                }
                return null;
              },
            );
            Widget txt3 = CustomTextFormField(
              controller: usernameController,
              hint: '@osama',
              label: 'username',
            );
            Widget button = InkWell(
              onTap: () async {
                if (key.currentState?.validate() ?? false) {
                  if (isEdit) {
                    ApiHelper()
                        .editLink(
                            context,
                            widget.link!.copyWith(
                              title: titleController.text,
                              username: usernameController.text,
                              link: linkController.text,
                            ))
                        .then((success) {
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    });
                  } else {
                    await ApiHelper().addLink(
                        titleController.text, linkController.text,
                        username: usernameController.text, context: context);
                  }
                }
              },
              child: Container(
                // height: portrait ? null : double.infinity,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 58),
                decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(14)),
                child: Text(isEdit ? "SAVE" : "ADD"),
              ),
            );
            if (portrait) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 58,
                    ),
                    txt1,
                    const SizedBox(
                      height: 18,
                    ),
                    txt2,
                    const SizedBox(
                      height: 18,
                    ),
                    txt3,
                    const SizedBox(
                      height: 38,
                    ),
                    button,
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [txt1, txt2, txt3],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    button
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  String? getUsernameFromInstagramLink(String link) {
    List<String> parts = link.split('/');

    for (String part in parts) {
      if (part.contains('?')) {
        return '@${part.split('?')[0]}';
      }
    }

    return null;
  }
}
