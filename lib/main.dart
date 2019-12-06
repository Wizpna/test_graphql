import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      title: "Test GraphQL",
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://countries.trevorblades.com/");

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
            link: httpLink,
            cache:
                OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));
    return GraphQLProvider(
      client: client,
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test GraphQL"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(document: r'''
        query GetContinent($code: String!){
          continent(code: $code){
              name  
              countries{
              name
            }
          }
        }
        ''', variables: <String, dynamic>{"code": "AF"}),
        builder: (
          QueryResult result, {
          BoolCallback refetch,
          FetchMore fetchMore,
        }) {
          if (result.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: result.data["continent"]["countries"].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title:
                    Text(result.data["continent"]["countries"][index]["name"]),
              );
            },
          );
        },
      ),
    );
  }
}
