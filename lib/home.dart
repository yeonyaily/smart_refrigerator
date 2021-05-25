import 'package:flutter/material.dart';
// import 'model/fridgeItem.dart';

class HomePage extends StatefulWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       child: Text("Hello!!!"),
  //     ),
  //   );
  // }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  List<Card> _buildGridCards(BuildContext context) {
    // List<FridgeItem> products = ProductsRepository.loadProducts(Category.all);

    // if(products == null || products.isEmpty) return const <Card>[];

    final ThemeData theme = Theme.of(context);
    final List<int> foolElement = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];
    // final NumberFormat formatter = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());

    return foolElement.map((element){
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            // TODO: Center items on the card (103)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: Image.asset(
                  "assets/diamond.png",
                  // TODO: Adjust the box size (102)
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    // TODO: Align labels to the bottom and center (103)
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // TODO: Change innermost Column (103)
                    children: <Widget>[
                      // TODO: Handle overflowing labels (103)
                      Text( "20-month-old chocolate",
                        style: TextStyle(fontSize: 15.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      SizedBox(height: 8.0),
                      Text( "~ 2021. 12. 31",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Icon(Icons.circle, size: 10.0, color: Colors.green[800]),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    
    return Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        // TODO: Add buttons and title (102)
        title: Text('***의 냉장고'),
        automaticallyImplyLeading: false,

        // TODO: Add trailing buttons (102)
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            child: Column(
              children: [
                Icon(Icons.add, semanticLabel: 'add', size: 18),
                Text("넣기"),
              ],
            ),
            onPressed: () { print('Add-item button'); },
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            child: Column(
              children: [
                Icon(Icons.remove, semanticLabel: 'remove', size: 18),
                Text("빼기"),
              ],
            ),
            onPressed: () { print('Remove-item button'); },
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            child: Column(
              children: [
                Icon(Icons.shopping_basket, semanticLabel: 'basket', size: 18),
                Text("장바구니"),
              ],
            ),
            onPressed: () { print('Basket button'); },
          ),
          // IconButton(
          //   icon: Icon(Icons.add, semanticLabel: 'add',),
          //   onPressed: () { print('Add-item button'); },
          // ),
          // IconButton(
          //   icon: Icon(Icons.remove, semanticLabel: 'remove',),
          //   onPressed: () { print('Remove-item button'); },
          // ),
          // IconButton(
          //   icon: Icon(Icons.shopping_basket, semanticLabel: 'basket',),
          //   onPressed: () { print('Basket button'); },
          // ),
        ],
      ),

      // TODO: Add a grid view (102)
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 3.0,

          // TODO: Build a grid of cards (102)
          children: _buildGridCards(context),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '모두의 냉장고',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: '내 요리 피드',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '내 냉장고',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 프로필',
          ),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        // selectedItemColor: Colors.amber[800],
        fixedColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
