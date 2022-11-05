import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key, required this.jobId});
  final String jobId;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobId', isEqualTo: widget.jobId)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?.docs[0]['jobTitle'],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.network(
                            snapshot.data?.docs[0]['userImage'],
                            width: 80,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              '${snapshot.data?.docs[0]['applicants']} applicants'),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.person_add)
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(),
                      const Text(
                        'Job Description',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.data?.docs[0]['jobDescription']),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(),
                      Center(
                        child: MaterialButton(
                          onPressed: () {},
                          color: Colors.orange,
                          child: const Text(
                            'Easy Apply Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Uploaded on'),
                          Text(
                            // '${snapshot.data?.docs[0]['createdAt']}',
                            '',
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Deadline date'),
                          Text('${snapshot.data?.docs[0]['jobDeadlineDate']}')
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('There is no jobs available'),
                );
              }
            }
            return const Center(
              child: Text('something went wrong'),
            );
          }),
        ));
  }
}
