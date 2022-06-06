// ignore_for_file: dead_code, unused_import

import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:StreamBuilderTest(),
    );
  }
}

// 颜色和主题
// 颜色
class NavBar extends StatelessWidget {
  final String title;
  final Color color; //背景颜色

  NavBar({
    Key? key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 52,
        minWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          //阴影
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          //根据背景色亮度来确定Title颜色
          color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}

class NavBarTest extends StatelessWidget{

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("颜色"),
      ),
      body: Column(
        children: <Widget>[
          // 背景色为蓝色，则title自动为白色
          NavBar(color: Colors.blue, title: "标题",),
          // 背景色为白色，则title自动为黑色
          NavBar(color: Colors.white, title: "标题",)
        ],
      )
    );
  }
}

// 路由换肤

class ThemeTestRoute extends StatefulWidget {
  @override
  _ThemeTestRouteState createState() => _ThemeTestRouteState();
}

class _ThemeTestRouteState extends State<ThemeTestRoute> {
  var _themeColor = Colors.teal; //当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
          primarySwatch: _themeColor, //用于导航栏、FloatingActionButton的背景色等
          iconTheme: IconThemeData(color: _themeColor) //用于Icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行Icon使用主题中的iconTheme
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text("  颜色跟随主题")
                ]
            ),
            //为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(
                    color: Colors.black
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Icon(Icons.airport_shuttle),
                    Text("  颜色固定黑色")
                  ]
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () =>  //切换主题
                setState(() =>
                _themeColor =
                _themeColor == Colors.teal ? Colors.blue : Colors.teal
                ),
            child: Icon(Icons.palette)
        ),
      ),
    );
  }
}


//异步UI更新

//创建一个计时器的示例：每隔1秒，计数加1。这里，使用Stream来实现每隔一秒生成一个数字。
Stream<int> counter(){
  return Stream.periodic(Duration(seconds: 1), (i){
    return i;
  });
}

class StreamBuilderTest extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<int>(
      stream: counter(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        if(snapshot.hasError)
          return Text("Error: ${snapshot.error}");
        switch(snapshot.connectionState){
          case ConnectionState.none:
            return Text("没有Stream");
          case ConnectionState.waiting:
            return Text("等待数据...");
          case ConnectionState.active:
            // TODO: Handle this case.
            return Text("active:${snapshot.data}");
          case ConnectionState.done:
            // TODO: Handle this case.
            return Text("Stream已关闭");
        }
      },
    );
  }
}


// 实现一个路由，当该路由打开时我们从网上获取数据，获取数据时弹一个加载框；获取结束时，如果成功则显示获取到的数据，如果失败则显示错误。
// 不真正去网络请求数据，而是模拟一下这个过程，隔3秒后返回一个字符串
Future<String> mockNetworkData() async{
  return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据！");
}

class FutureBuilderTest extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Center(
      child: FutureBuilder<String>(
        future: mockNetworkData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // 请求已结束
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            }else{
              // 请求成功，显示数据
              return Text("Contents: ${snapshot.data}");
            }
          }else{
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}