import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, dynamic>> _matchingResults = [];
  List<Map<String, dynamic>> _filteredResults = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMatchingResults();
  }

  Future<void> _fetchMatchingResults() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('matching_results').get();
    List<Map<String, dynamic>> results = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      _matchingResults = results;
      _filteredResults = results;
      _isLoading = false;
    });
  }

  void _filterResults(String query) {
    setState(() {
      _searchQuery = query;
      _filteredResults = _matchingResults.where((result) {
        return result['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _downloadResults() async {
    // Implement the logic to download the matching results
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Results'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterResults,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredResults.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> result = _filteredResults[index];
                      return ListTile(
                        title: Text(result['name']),
                        subtitle: Text(result['email']),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _downloadResults,
                    child: Text('Download Results'),
                  ),
                ),
              ],
            ),
    );
  }
}
