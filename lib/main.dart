import 'package:flutter/material.dart';
import 'package:sec_app/app.dart';
import 'package:sec_app/services/hive_service.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.instance.initializeDatabase();
  runApp(const MyApp());
}

class MyNoteApp extends StatefulWidget {
  const MyNoteApp({super.key});

  @override
  State<MyNoteApp> createState() => _MyNoteApptState();
}

class _MyNoteApptState extends State<MyNoteApp> {
  late List<Note> notes;
  late HiveService _services;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _services = HiveService.instance;
    notes = _services.getAll();
  }

  // Note note =Note(content: "The content", title: "My Title");
  @override
  Widget build(BuildContext context) {
    List<Note> favNotes = [];

    for (Note note in notes) {
      if (note.isFav) favNotes.add(note);
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My notes"),
          bottom: TabBar(
            tabs: [
              Tab(text: "All notes"),
              Tab(text: "Favourites"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 43, 72, 104),
                        shadowColor: const Color.fromARGB(255, 93, 148, 185),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(notes[index].title),
                                  IconButton(
                                    onPressed: () async {
                                      notes[index].isFav = !notes[index].isFav;
                                      await _services.updateNote(
                                        notes[index].title,
                                        Note(
                                          content: notes[index].content,
                                          title: notes[index].title,
                                          isFav: notes[index].isFav,
                                        ),
                                      );
                                      setState(() {
                                        notes = _services.getAll();
                                      });
                                    },
                                    icon: Icon(
                                      notes[index].isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              Text(notes[index].content),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                43,
                                72,
                                104,
                              ),
                            ),
                            onPressed: () {
                              titleController.text = notes[index].title;
                              contentController.text = notes[index].content;
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Edit note"),
                                        ),

                                        SizedBox(
                                          child: TextField(
                                            controller: titleController,
                                            decoration: InputDecoration(
                                              labelText: "Title",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 15),

                                        SizedBox(
                                          child: TextField(
                                            controller: contentController,
                                            decoration: InputDecoration(
                                              labelText: "Content",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 15),

                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  43,
                                                  72,
                                                  104,
                                                ),
                                          ),
                                          onPressed: () async {
                                            await _services.updateNote(
                                              notes[index].title,
                                              Note(
                                                content: contentController.text,
                                                title: titleController.text,
                                              ),
                                            );

                                            setState(() {
                                              notes = _services.getAll();
                                            });

                                            Navigator.pop(context);
                                          },
                                          child: Text("Update"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ); //showmodal
                            },

                            child: Text("Edit note"),
                          ),
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 43, 72, 104),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await _services.deleteNote(notes[index].title);
                                setState(() {
                                  notes = _services.getAll();
                                });
                              },
                              icon: Icon(Icons.delete_forever),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            ListView.builder(
              itemCount: favNotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 43, 72, 104),
                        shadowColor: const Color.fromARGB(255, 93, 148, 185),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(favNotes[index].title),
                                  Icon(Icons.favorite),
                                ],
                              ),
                              Text(favNotes[index].content),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(255, 245, 246, 248),
          unselectedItemColor: const Color.fromARGB(255, 132, 132, 132),
          backgroundColor: const Color.fromARGB(255, 45, 47, 48),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 43, 72, 104),
          onPressed: () {
            titleController.clear();
            contentController.clear();
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Add new note"),
                      ),

                      SizedBox(
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      SizedBox(
                        // width: 300,
                        child: TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            labelText: "Content",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            43,
                            72,
                            104,
                          ),
                        ),
                        onPressed: () async {
                          Note newNote = Note(
                            content: contentController.text,
                            title: titleController.text,
                          );

                          await _services.addNote(newNote);

                          setState(() {
                            notes = _services.getAll();
                          });

                          Navigator.pop(context);
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                );
              },
            ); //modalsheet
          },
          icon: Icon(Icons.add),
          label: Text("Add new note"),
        ),
      ),
    );
  }
}
