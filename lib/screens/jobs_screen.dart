import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_clone/services/global_variables.dart';
import 'package:freelancer_clone/widgets/job_widget.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? _jobCategoryFilter;

  @override
  void initState() {
    getMyData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      name = userDoc.get('name');
      userImage = userDoc.get('userImage');
      location = userDoc.get('location');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            _jobCategoryFilter ?? 'All',
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ))
          ],
          leading: IconButton(
              onPressed: () {
                _showTaskCategoriesDialog(size: MediaQuery.of(context).size);
              },
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.black,
              )),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory', isEqualTo: _jobCategoryFilter)
              .where(
                'recruitment',
                isEqualTo: true,
              )
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      return JobWidget(
                          jobTitle: snapshot.data?.docs[index]['jobTitle'],
                          jobDescription: snapshot.data?.docs[index]
                              ['jobDescription'],
                          jobId: snapshot.data?.docs[index]['jobId'],
                          uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                          userImage: snapshot.data?.docs[index]['userImage'],
                          name: snapshot.data?.docs[index]['name'],
                          recruitment: snapshot.data?.docs[index]
                              ['recruitment'],
                          email: snapshot.data?.docs[index]['email'],
                          location: snapshot.data?.docs[index]['location']);
                    }));
              } else {
                return const Center(
                  child: Text('There is no jobs available'),
                );
              }
            }
            return const Center(
              child: Text('something went wrong'),
            );
          },
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
                  setState(() {
                    _jobCategoryFilter = null;
                  });
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
