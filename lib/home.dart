import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recipe {
  final String name;
  final String description;
  final String thumbnailUrl;

  Recipe({
    required this.name,
    required this.description,
    required this.thumbnailUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food API Call - Albert Muhammad Irgi - C14200169'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
              controller: myController,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: recipes.isNotEmpty
                  ? ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(recipe.description),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Image.network(
                                  recipe.thumbnailUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No recipes found',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchFoods,
        child: const Icon(Icons.search),
      ),
    );
  }

  void fetchFoods() async {
    String q = myController.text;
    String url =
        "https://tasty.p.rapidapi.com/recipes/list?from=0&size=20&q=$q";
    Map<String, String> headers = <String, String>{
      "X-RapidAPI-Key": "5ee36fb016mshd529944a053eb81p1e552cjsn8f74df0ca413",
      "X-RapidAPI-Host": "tasty.p.rapidapi.com",
    };
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final body = response.body;
    final json = jsonDecode(body);

    final List<dynamic> results = json['results'];
    List<Recipe> fetchedRecipes = results.map((recipeJson) {
      return Recipe.fromJson(recipeJson);
    }).toList();

    setState(() {
      recipes = fetchedRecipes;
    });
  }
}
