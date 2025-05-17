import 'package:agenda/tasks/add_tasks_button_widget.dart';
import 'package:agenda/tasks/add_task_button.dart';
import 'package:agenda/tasks/task_service.dart';
import 'package:agenda/tasks/task_home.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';

class TaskListWidget extends StatefulWidget {
  final String id;
  final List<String> tasks;

  TaskListWidget({
    super.key,
    String? id, // Torna o id opcional
    List<String>? tasks, // Torna tasks opcional
  })  : id = id ?? const Uuid().v4(), // Gera um ID único se não for fornecido
        tasks =
            tasks ?? []; // Define uma lista vazia se tasks não for fornecida

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final List<String> tasks = [];
  final TextEditingController taskInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double heightSize = 186.0;
  bool hasHiddenItems = false; // Estado para verificar se há itens ocultos

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _scrollController.addListener(_handleScroll);
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await TaskService.loadTasks();
    setState(() {
      tasks.clear();
      tasks.addAll(loadedTasks);
    });
  }

  void _saveTasks() {
    TaskService.saveTasks(tasks);
  }

  Future<void> _turnListSizeBig() async {
    setState(() {
      heightSize = 580.0;
      BlurManager.setBlurActive(true);
    });
  }

  Future<void> _turnListSizeSmall() async {
    setState(() {
      heightSize = 186.0;
      BlurManager.setBlurActive(false);
    });
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      //final viewportHeight = _scrollController.position.viewportDimension;
      final currentScroll = _scrollController.position.pixels;

      bool currentlyHidden = maxScroll > 0 && currentScroll < maxScroll;

      //log('hasHiddenItems: $currentlyHidden');
      //log('maxScroll: $maxScroll, viewportHeight: $viewportHeight, currentScroll: $currentScroll');

      if (currentlyHidden != hasHiddenItems) {
        setState(() {
          hasHiddenItems = currentlyHidden;
        });
      }

      if (hasHiddenItems) {
        _turnListSizeBig();
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (heightSize > 186.0) {
      await _turnListSizeSmall();
      return Future.value(false); // Impede a navegação para trás
    }
    return Future.value(true); // Permite sair da tela
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(0, 114, 114,
              114), // Torna o fundo transparente para permitir o efeito de blur
          child: Stack(
            children: [
              // Efeito de blur
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2), // Ajuste o valor do sigma conforme necessário
                  child: Container(
                    color: const Color.fromARGB(100, 255, 255, 255)
                        .withOpacity(0.0),
                  ),
                ),
              ),
              // Conteúdo do alerta
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Adicionar Tarefa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(
                            210, 250, 244, 255), // Mudando a cor do título
                      ),
                    ),
                  ),
                  // Campo de texto
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextField(
                      controller: taskInputController,
                      style: const TextStyle(
                        color: Colors.white, // Cor do texto digitado
                        fontSize: 16, // Tamanho do texto digitado
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Digite sua tarefa',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 253, 249, 255)), // Cor do rótulo
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 254, 249, 255),
                              width: 1), // Borda ao focar
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        hintText: 'Ex: Leitura Diária',
                        hintStyle: TextStyle(
                            color: Colors.grey), // Cor do texto de dica
                      ),
                    ),
                  ),
                  // Botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red), // Cor do texto
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (taskInputController.text.isNotEmpty) {
                            setState(() {
                              tasks.add(taskInputController.text);
                              taskInputController.clear();
                              _saveTasks();
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                              255, 251, 246, 255), // Cor do texto
                          backgroundColor: const Color.fromARGB(
                              40, 250, 244, 255), // Cor do fundo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Define o nível de arredondamento
                          ),
                          elevation: 0, // Elevação do botão (sombra)
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10), // Espaçamento interno
                        ),
                        child: const Text(
                          'Adicionar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (heightSize >= 187) {
        if (newIndex > oldIndex) newIndex -= 1;
        final String task = tasks.removeAt(oldIndex);
        tasks.insert(newIndex, task);
        _saveTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(children: [
        if (tasks.isNotEmpty)
          // Adicionando o efeito de blur quando "hasHiddenItems" for verdadeiro
          if (heightSize > 187.0)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 7,
                    sigmaY: 7), // Ajuste o valor do sigma conforme necessário
                child: Container(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                ),
              ),
            ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            height: heightSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ReorderableListView.builder(
              scrollController: _scrollController,
              itemCount: tasks.length,
              onReorder: _reorderTasks,
              itemBuilder: (context, taskIndex) {
                return Card(
                  key: ValueKey(
                      '${widget.id}_$taskIndex'), // ID exclusivo por índice
                  elevation: 0,
                  color: const Color.fromARGB(8, 240, 230, 255),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskHome(
                            task: tasks[taskIndex],
                            onDelete: () {
                              setState(() {
                                tasks.removeAt(taskIndex);
                                _saveTasks();
                              });
                            },
                          ),
                        ),
                      );
                    },
                    title: Center(
                      child: Text(
                        tasks[taskIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color.fromARGB(230, 255, 241, 241),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0, // Define o desfoque do brilho
                              color: Color.fromARGB(60, 255, 255, 255), // Cor do brilho
                              offset:
                                  Offset(0, 0), // Ajusta a posição do brilho
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Botão de Adicionar Tarefas
        if (heightSize < 187.0)
          AddTaskButton(
            onPressed: _showTaskDialog,
          ),
      ]),
    );
  }

  @override
  void dispose() {
    taskInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
