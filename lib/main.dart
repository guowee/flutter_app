import 'package:flutter/material.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Test Demo',
      theme: new ThemeData(primarySwatch: Colors.blueGrey),
      home: new BookList(
        books: generateBook(),
      ),
    );
  }

  Iterable<Book> generateBook() {
    final listBookName = [
      "区块链",
      "大数据",
      "人工智能",
      "深度学习",
      "卷积神经",
      "物联网",
      "无人驾驶",
      "支付加密",
      "自我意识",
      "宇宙深处"
    ];
    final listAuthorName = [
      "丁丁张",
      "[美] H.P.洛夫克拉夫特 ",
      " [美] 克里斯·克劳利",
      "[英] 珍妮特·温特森 ",
      "[马来西亚] 黄锦树",
      "[挪] 尤·奈斯博 ",
      "李硕",
      "[日] MONCEAU FLEURS ",
      "黄鹭",
      "贝尔纳黛特·墨菲"
    ];

    final listBookUrl = [
      "https://img3.doubanio.com/lpic/s29625884.jpg",
      "https://img3.doubanio.com/lpic/s29700193.jpg",
      "https://img3.doubanio.com/lpic/s29712680.jpg",
      "https://img3.doubanio.com/lpic/s29679753.jpg",
      "https://img3.doubanio.com/mpic/s29682706.jpg",
      "https://img1.doubanio.com/mpic/s29667478.jpg",
      "https://img1.doubanio.com/mpic/s29669647.jpg",
      "https://img3.doubanio.com/mpic/s29648610.jpg",
      "https://img3.doubanio.com/mpic/s29683281.jpg",
      "https://img1.doubanio.com/mpic/s29664089.jpg",
    ];

    var books = <Book>[];
    for (var i = 0; i < 10; i++) {
      Book book = new Book();
      book.author = listAuthorName[i];
      book.name = listBookName[i];
      book.price = 12 + i;
      book.bookUrl = listBookUrl[i];
      books.add(book);
    }
    return books;
  }
}

typedef void BookFavoriteCallback(Book book, bool isFav);

class Book {
  String name;
  String author;
  int price;
  String bookUrl;
}

class BookList extends StatefulWidget {
  BookList({Key key, this.books}) : super(key: key);

  final List<Book> books;

  @override
  State<StatefulWidget> createState() {
    return new _BookListState();
  }
}

class _BookListState extends State<BookList> {
  Set<Book> choiceBookList = new Set<Book>();

  void _handleBookFavorite(Book book, bool isFav) {
    setState(() {
      if (isFav) {
        choiceBookList.add(book);
      } else {
        choiceBookList.remove(book);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '书架',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: navigate2Favorite,
          )
        ],
        centerTitle: true,
      ),
      body: _buildListView(true),
    );
  }

  Widget _buildListView(bool isAll) {
    if (isAll) {
      return new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.books.map((Book book) {
          return new BookListItem(
            book: book,
            isFav: choiceBookList.contains(book),
            callback: _handleBookFavorite,
          );
        }).toList(),
      );
    } else {
      return new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: choiceBookList.map((Book book) {
          return new BookListItem(
            book: book,
            isFav: choiceBookList.contains(book),
            callback: _handleBookFavorite,
          );
        }).toList(),
      );
    }
  }

  navigate2Favorite() {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("收藏"),
          ),
          body: _buildListView(false),
        );
      },
    ));
  }
}

class BookListItem extends StatelessWidget {
  BookListItem({Book book, this.isFav, this.callback})
      : book = book,
        super(key: new ObjectKey(book));

  final Book book;
  final bool isFav;
  final BookFavoriteCallback callback;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new Row(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            width: 100.0,
            height: 100.0,
            child: new Image.network(
              book.bookUrl,
              width: 75.0,
              height: 100.0,
              fit: BoxFit.fill,
            ),
          ),
          new Expanded(
            child: new Container(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
              child: new Column(
                verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    book.name,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  new Text(
                    book.author,
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  new Text(
                    book.price.toString(),
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            height: 100.0,
            alignment: Alignment.center,
            child: new GestureDetector(
              onTap: () {
                callback(book, !isFav);
              },
              child: new Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
