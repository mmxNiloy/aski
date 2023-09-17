// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
// import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database

// class MessageTab extends StatefulWidget {
//   @override
//   _MessageTabState createState() => _MessageTabState();
// }

// class _MessageTabState extends State<MessageTab> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance
//       .reference(); // Reference to your Firebase Realtime Database

//   User? _user; // Firebase user object
//   List<Community> _communities = []; // List of community objects
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _getUser(); // Initialize Firebase user
//     _fetchCommunities(); // Fetch communities from Firebase
//   }

//   Future<void> _getUser() async {
//     User? user = _auth.currentUser;
//     setState(() {
//       _user = user;
//     });
//   }

//   Future<void> _fetchCommunities() async {
//     // Fetch communities from Firebase and update _communities list
//     // Use _database.child('communities').onValue to listen for updates
//     // and populate _communities list
//   }

//   Future<void> _joinCommunity(Community community) async {
//     // Implement the logic to allow the user to join a community
//     // Update Firebase database to reflect the user's membership in the community
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           // Search bar for finding communities
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search for a community',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: () {
//                   // Implement community search logic
//                   // Update the UI with search results
//                 },
//               ),
//             ),
//           ),
//           // List of communities
//           Expanded(
//             child: ListView.builder(
//               itemCount: _communities.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Community community = _communities[index];
//                 return ListTile(
//                   title: Text(community.name),
//                   subtitle: Text(community.description),
//                   trailing: ElevatedButton(
//                     onPressed: () {
//                       // Implement logic to join the community
//                       _joinCommunity(community);
//                     },
//                     child: Text('Join'),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Community {
//   final String id;
//   final String name;
//   final String description;

//   Community({
//     required this.id,
//     required this.name,
//     required this.description,
//   });
// }

//! My own code.
// Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: ListView.builder(
//           itemCount: 5,
//           itemBuilder: (context, index) {
//             return const Text("Science Group");
//           }),
//     );
import 'package:flutter/material.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Search bar for finding communities
          TextField(
            controller: null,
            decoration: InputDecoration(
              hintText: 'Search for a community',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Implement community search logic
                  // Update the UI with search results
                },
              ),
            ),
          ),
          // List of communities
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: const Text("Name of the community"),
                  subtitle: const Text("Description of the community"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Implement logic to join the community
                      // _joinCommunity(community);
                    },
                    child: const Text('Join'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
