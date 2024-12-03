import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.get(Uri.parse('http://localhost:3000/api/matching_results'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(json.decode(response.body));
      setState(() {
        _matchingResults = results;
        _filteredResults = results;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load matching results');
    }
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
    final response = await http.get(Uri.parse('http://localhost:3000/api/matching_results'));
    if (response.statusCode == 200) {
      // Implement the logic to download the matching results
    } else {
      throw Exception('Failed to download matching results');
    }
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
