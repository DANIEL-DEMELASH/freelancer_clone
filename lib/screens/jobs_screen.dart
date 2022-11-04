import 'package:flutter/material.dart';
import 'package:freelancer_clone/services/global_variables.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? _jobCategoryFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                _showTaskCategoriesDialog(size: MediaQuery.of(context).size);
              },
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.black,
              )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [],
          ),
        ));
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (context) {
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
                shrinkWrap: true,
                itemCount: jobCategories.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        jobCategories[index],
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _jobCategoryFilter = jobCategories[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                })),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'close',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  _jobCategoryFilter = null;
                  Navigator.pop(context);
                },
                child: const Text('cancel filter',
                    style: TextStyle(color: Colors.white))),
          ],
        );
      },
    );
  }
}
