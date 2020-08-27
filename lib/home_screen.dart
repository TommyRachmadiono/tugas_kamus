import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  bool searchEmpty = true;
  String searchText = '';
  bool _isLoading = false;

  List dataKamus;
  List filterList;

  Future getData() async {
    setState(() {
      _isLoading = true;
    });

    final responseData =
        await http.get('http://10.0.2.2:8000/api/dictionaries');

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      setState(() {
        dataKamus = data['dictionaries'];
        _isLoading = false;
        print(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  _HomeScreenState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          searchEmpty = true;
          searchText = '';
        });
      } else {
        setState(() {
          searchEmpty = false;
          searchText = _searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Kamus Sederhana'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  //memanggil method untuk view search
                  _createSearchView(),
                  SizedBox(height: 20),
                  searchEmpty ? _createListView() : _performSearch()
                ],
              ),
      ),
    );
  }

  Widget _createSearchView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // membuat widget tampilan list awal
  Widget _createListView() {
    return Flexible(
      child: ListView.builder(
        itemCount: dataKamus.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white,
            elevation: 5,
            child: Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    "${dataKamus[index]['indonesia_word']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("${dataKamus[index]['english_word']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //membuat widget untuk hasil search
  Widget _performSearch() {
    filterList = List();
    for (var data in dataKamus) {
      var item = data;

      if (item['indonesia_word']
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        filterList.add(item);
      }
    }

    return _createFilteredListView();
  }

  //membuat listview untuk hasil search
  Widget _createFilteredListView() {
    return Flexible(
      child: ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white,
            elevation: 5,
            child: Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${filterList[index]['indonesia_word']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("${filterList[index]['english_word']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
