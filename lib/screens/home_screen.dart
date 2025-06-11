import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blondgames_entry.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();

  EntryType _selectedEntryType = EntryType.game; // Por defecto, añade un juego

  void _saveEntry() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena los campos requeridos.')),
      );
      return;
    }

    if (_selectedEntryType == EntryType.game && (_genreController.text.isEmpty || _platformController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Para un juego, el género y la plataforma son requeridos.')),
      );
      return;
    }

    final newEntry = BlondGamesEntry(
      title: _titleController.text,
      content: _contentController.text,
      timestamp: Timestamp.now(),
      type: _selectedEntryType,
      genre: _selectedEntryType == EntryType.game ? _genreController.text : null,
      platform: _selectedEntryType == EntryType.game ? _platformController.text : null,
    );

    _firestoreService.addEntry(newEntry);
    _titleController.clear();
    _contentController.clear();
    _genreController.clear();
    _platformController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_selectedEntryType == EntryType.game ? 'Juego' : 'Pregunta Frecuente'} guardado en BlondGames!')),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _genreController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BlondGames',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            fontFamily: 'PixelifySans', // Fuente inspirada en videojuegos
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor, // Azul medianoche
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Añade un Juego o Pregunta',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<EntryType>(
              value: _selectedEntryType,
              decoration: InputDecoration(
                labelText: 'Tipo de Entrada',
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                filled: Theme.of(context).inputDecorationTheme.filled,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: Theme.of(context).inputDecorationTheme.border,
              ),
              items: const [
                DropdownMenuItem(
                  value: EntryType.game,
                  child: Text('Videojuego', style: TextStyle(color: Colors.white70)),
                ),
                DropdownMenuItem(
                  value: EntryType.faq,
                  child: Text('Pregunta Frecuente (FAQ)', style: TextStyle(color: Colors.white70)),
                ),
              ],
              onChanged: (EntryType? newValue) {
                setState(() {
                  _selectedEntryType = newValue!;
                  // Limpiar campos específicos si se cambia el tipo
                  _genreController.clear();
                  _platformController.clear();
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: _selectedEntryType == EntryType.game ? 'Título del Juego' : 'Pregunta Frecuente',
                hintText: _selectedEntryType == EntryType.game ? 'Ej: Cyberpunk 2077' : 'Ej: ¿Cuáles son sus horarios?',
                border: Theme.of(context).inputDecorationTheme.border,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                filled: Theme.of(context).inputDecorationTheme.filled,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            if (_selectedEntryType == EntryType.game) ...[
              TextField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Género',
                  hintText: 'Ej: RPG, Acción, Aventura',
                  border: Theme.of(context).inputDecorationTheme.border,
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _platformController,
                decoration: InputDecoration(
                  labelText: 'Plataforma',
                  hintText: 'Ej: PC, PlayStation 5, Xbox Series X',
                  border: Theme.of(context).inputDecorationTheme.border,
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
            ],
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: _selectedEntryType == EntryType.game ? 'Descripción o Detalles' : 'Respuesta',
                hintText: _selectedEntryType == EntryType.game
                    ? 'Ej: Un mundo abierto futurista con decisiones impactantes...'
                    : 'Ej: Abrimos de lunes a viernes de 10 AM a 8 PM.',
                border: Theme.of(context).inputDecorationTheme.border,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                filled: Theme.of(context).inputDecorationTheme.filled,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text(
                'Guardar ${_selectedEntryType == EntryType.game ? 'Juego' : 'Pregunta'}',
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Catálogo de BlondGames',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<List<BlondGamesEntry>>(
                stream: _firestoreService.getEntries(), // Obtiene todos los tipos de entradas
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aún no hay juegos o preguntas frecuentes. ¡Añade uno!',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final entries = snapshot.data!;
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        color: Theme.of(context).cardColor, // Gris oscuro para tarjetas
                        child: ListTile(
                          title: Text(
                            entry.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.content,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              if (entry.type == EntryType.game)
                                Text(
                                  'Género: ${entry.genre ?? 'N/A'} | Plataforma: ${entry.platform ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _firestoreService.deleteEntry(entry.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${entry.type == EntryType.game ? 'Juego' : 'Pregunta'} eliminada.')),
                              );
                            },
                          ),
                          leading: Text(
                            '${entry.timestamp.toDate().day}/${entry.timestamp.toDate().month}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}