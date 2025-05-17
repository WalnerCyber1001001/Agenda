import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';

class AddTaskButtonWidget extends StatefulWidget {
  final TextEditingController taskController;
  final VoidCallback addTask;

  const AddTaskButtonWidget({
    super.key,
    required this.taskController,
    required this.addTask,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskButtonWidgetState createState() => _AddTaskButtonWidgetState();
}

class _AddTaskButtonWidgetState extends State<AddTaskButtonWidget> {
  bool isBlurActive = BlurManager.isBlurActive;

  @override
  void initState() {
    super.initState();
    BlurManager.setOnBlurChanged(_onBlurStatusChanged);
  }

  void _onBlurStatusChanged() {
    // Usar addPostFrameCallback para garantir que setState será chamado após a construção
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isBlurActive = BlurManager.isBlurActive;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: (MediaQuery.of(context).size.width - 52) / 2,
      child: SizedBox(
        width: 52,
        height: 52,
        child: !isBlurActive
            ? AddTasksButton(
                onAdd: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Adicionar Tarefa'),
                        content: TextField(
                          controller: widget.taskController,
                          decoration: const InputDecoration(
                              hintText: 'Digite a tarefa'),
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            CapitalizeEachWordFormatter(),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Adicionar'),
                            onPressed: () {
                              widget.addTask();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    BlurManager.setOnBlurChanged(() => {});
    super.dispose();
  }
}

class TaskListStack extends StatefulWidget {
  final double height;
  final ScrollController scrollController;
  final double nonInteractiveItemHeight;

  const TaskListStack({
    super.key,
    required this.height,
    required this.scrollController,
    required this.nonInteractiveItemHeight,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskListStackState createState() => _TaskListStackState();
}

class _TaskListStackState extends State<TaskListStack> {
  late TaskSaver _taskSaver;
  final TextEditingController taskInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskSaver = TaskSaver();
    _taskSaver.loadTasks().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.height >= 555) const BlurEffect(),
        Positioned.fill(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AddTaskButtonWidget(
                  taskController: taskInputController,
                  addTask: () {
                    if (taskInputController.text.isNotEmpty) {
                      setState(() {
                        _taskSaver.addTask(taskInputController.text);
                        taskInputController.clear();
                      });
                    }
                  },
                ),
                for (int index = _taskSaver.tasks.length - 1;
                    index >= 0;
                    index--)
                  TaskItem(
                    task: _taskSaver.tasks[index],
                    onDelete: () {
                      setState(() {
                        _taskSaver.removeTask(index);
                      });
                    },
                  ),
                if (widget.height >= 555)
                  NonInteractiveItem(height: widget.nonInteractiveItemHeight),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NonInteractiveItem extends StatelessWidget {
  final double height;

  const NonInteractiveItem({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(40, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
      ),
      /*child: const Center(
        child: Text(
          'Item não interativo',
          style: TextStyle(
            color: Color.fromARGB(190, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontFamily: 'CustomFont',
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color.fromARGB(130, 255, 255, 255),
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}

class CapitalizeEachWordFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    // Capitaliza cada palavra individualmente
    final capitalizedText = newValue.text
        .split(' ') // Divide o texto em palavras
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' '); // Junta novamente com espaços

    return newValue.copyWith(
      text: capitalizedText,
      selection: TextSelection.collapsed(offset: capitalizedText.length),
    );
  }
}

class TaskListContainer extends StatelessWidget {
  final double bottom;
  final double left;
  final double width;
  final double height;
  final ScrollController scrollController;
  final double nonInteractiveItemHeight;

  const TaskListContainer({
    super.key,
    required this.bottom,
    required this.left,
    required this.width,
    required this.height,
    required this.scrollController,
    required this.nonInteractiveItemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(20, 255, 99, 99),
        ),
        width: width,
        height: height,
        child: TaskListStack(
          height: height,
          scrollController: scrollController,
          nonInteractiveItemHeight: nonInteractiveItemHeight,
        ),
      ),
    );
  }
}

class TaskSaver {
  List<String> tasks = []; // Lista de strings, não widgets!

  // Carregar tarefas
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> taskList = json.decode(tasksString);
      tasks = taskList.map((task) => task as String).toList();
    }
  }

  // Salvar tarefas
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString =
        json.encode(tasks); // Codifica a lista de tarefas
    await prefs.setString('tasks', tasksString);
  }

  // Adicionar tarefa
  void addTask(String task) {
    if (task.isNotEmpty) {
      tasks.add(task);
      saveTasks(); // Salva após adicionar
    }
  }

  // Remover tarefa
  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      saveTasks(); // Salva após remover
    }
  }
}

class AddTasksButton extends StatelessWidget {
  final VoidCallback onAdd;

  const AddTasksButton({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onAdd, // Executa a função recebida
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Arredondar as pontas
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(30, 232, 217, 255),
        ),
        padding: WidgetStateProperty.all(
            EdgeInsets.zero), // Remover o padding padrão
        minimumSize: WidgetStateProperty.all(
            const Size(54, 54)), // Definir o tamanho mínimo do botão
      ),
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/clock/crossicon.png', // Caminho da imagem
          width: 54.0, // Largura da imagem ajustada ao botão
          height: 54.0, // Altura da imagem ajustada ao botão
          fit: BoxFit
              .fill, // Preenche o botão, possivelmente distorcendo a imagem
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final List<String> tasks;
  final Function(int) onDelete;
  final double width;
  final double height;
  final double bottom;
  final double left;
  final double nonInteractiveItemHeight;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onDelete,
    this.width = double.infinity,
    this.height = 300.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.nonInteractiveItemHeight = 400.0,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  double _currentHeight = 176;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    double currentScrollPosition = _scrollController.position.pixels;
    double maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (currentScrollPosition >= maxScrollExtent && _currentHeight <= 176) {
      setState(() {
        _currentHeight = 556;
        BlurManager.setBlurActive(true);
        print(BlurManager.isBlurActive);
      });
    } else if (currentScrollPosition <= 0 && _currentHeight >= 555) {
      setState(() {
        _currentHeight = 176;
        BlurManager.setBlurActive(false);
        print(BlurManager.isBlurActive);
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentHeight >= 555) {
      setState(() {
        _currentHeight = 176;
        BlurManager.setBlurActive(false);
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: TaskListContainer(
        bottom: widget.bottom,
        left: widget.left,
        width: widget.width,
        height: _currentHeight,
        scrollController: _scrollController,
        nonInteractiveItemHeight: widget.nonInteractiveItemHeight,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TaskItemText extends StatelessWidget {
  final String task;

  const TaskItemText({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        task,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(190, 255, 255, 255),
          fontWeight: FontWeight.normal,
          fontFamily: 'CustomFont',
          letterSpacing: 2.0,
          fontSize: 16,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Color.fromARGB(130, 255, 255, 255),
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String task;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: 340,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(4, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          /// Texto centralizado
          TaskItemText(task: task),

          /// Botão de exclusão posicionado à direita
          DeleteButton(onDelete: onDelete),
        ],
      ),
    );
  }
}

class BlurEffect extends StatefulWidget {
  const BlurEffect({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _BlurEffectState createState() => _BlurEffectState();
}

class _BlurEffectState extends State<BlurEffect> {
  bool isBlurActive = BlurManager.isBlurActive;

  @override
  void initState() {
    super.initState();
    // Registra o callback global para escutar mudanças no BlurManager
    BlurManager.setOnBlurChanged(_onBlurStatusChanged);
  }

  void _onBlurStatusChanged() {
    // Usar addPostFrameCallback para garantir que setState será chamado após a construção
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isBlurActive = BlurManager.isBlurActive;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define o desfoque como ativo
    BlurManager.setBlurActive(true);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: const Padding(
          padding: EdgeInsets.all(0.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    BlurManager.setOnBlurChanged(() => {}); // Limpa o callback
    super.dispose();
  }
}

class BlurManager with ChangeNotifier {
  static bool isBlurActive = false;
  static VoidCallback? onBlurChanged;

  static void setBlurActive(bool isActive) {
    isBlurActive = isActive;
    onBlurChanged?.call(); // Chama o callback global sempre que o status mudar
  }

  static bool getBlurStatus(bool bool) {
    return isBlurActive;
  }

  static void setOnBlurChanged(VoidCallback callback) {
    onBlurChanged = callback;
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 2,
      top: 2,
      bottom: 0,
      child: IconButton(
        icon: const Icon(Icons.delete_rounded,
            color: Color.fromARGB(57, 245, 225, 255)),
        onPressed: onDelete,
        iconSize: 18,
      ),
    );
  }
}
