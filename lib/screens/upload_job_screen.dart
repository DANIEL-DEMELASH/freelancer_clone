import 'package:flutter/material.dart';
import 'package:freelancer_clone/services/flutter_fire.dart';
import 'package:freelancer_clone/services/global_variables.dart';
import 'package:intl/intl.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({super.key});

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  final _jobCategoryText = TextEditingController(text: '');
  final _jobTitileText = TextEditingController(text: '');
  final _jobDescription = TextEditingController(text: '');
  final _jobDeadlineText = TextEditingController(text: '');
  final _uploadJobKey = GlobalKey<FormState>();

  final _jobTitleFocusNode = FocusNode();
  final _jobDescriptionFocusNode = FocusNode();
  final _jobDeadlineFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _jobCategoryText.dispose();
    _jobTitileText.dispose();
    _jobDescription.dispose();
    _jobDeadlineText.dispose();

    _jobTitleFocusNode.dispose();
    _jobDescriptionFocusNode.dispose();
    _jobDeadlineFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _uploadJobKey,
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'Fill all forms',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Signatra',
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Job Category',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                onTap: () {
                  _showTaskCategoriesDialog();
                },
                readOnly: true,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_jobTitleFocusNode),
                controller: _jobCategoryText,
                decoration: InputDecoration(
                    hintText: 'Select job category',
                    filled: true,
                    fillColor: Colors.grey.shade100),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please choose job category';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Job Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _jobTitileText,
                focusNode: _jobTitleFocusNode,
                onEditingComplete: () => FocusScope.of(context)
                    .requestFocus(_jobDescriptionFocusNode),
                decoration: InputDecoration(
                    filled: true, fillColor: Colors.grey.shade100),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter job title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Job Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                maxLines: 5,
                minLines: 4,
                controller: _jobDescription,
                focusNode: _jobDescriptionFocusNode,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_jobDeadlineFocusNode),
                decoration: InputDecoration(
                    filled: true, fillColor: Colors.grey.shade100),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter job description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Job Deadline',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _jobDeadlineText,
                focusNode: _jobDeadlineFocusNode,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: 'choose deadline date',
                    filled: true,
                    fillColor: Colors.grey.shade100),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please choose job deadline date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 0)),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _jobDeadlineText.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              MaterialButton(
                onPressed: () async {
                  if (_uploadJobKey.currentState!.validate()) {
                    await uploadTask(
                        jobCategory: _jobCategoryText.text,
                        jobTitle: _jobTitileText.text.trim(),
                        jobDescription: _jobDescription.text.trim(),
                        jobDeadlineDate: _jobDeadlineText.text,
                        context: context);
                    _jobCategoryText.clear();
                    _jobTitileText.clear();
                    _jobDescription.clear();
                    _jobDeadlineText.clear();
                  }
                },
                color: Colors.orange,
                minWidth: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Post Job',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog() {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                  itemCount: jobCategories.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _jobCategoryText.text = jobCategories[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          jobCategories[index],
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  })),
            ),
          );
        }));
  }
}
