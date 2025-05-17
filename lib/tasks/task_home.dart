import 'package:agenda/background_image/background_image_widget.dart';
import 'package:agenda/urgence_classifier/urgence_classifier.dart';
import 'package:agenda/app_bar_task_title/app_bar_task_title.dart';
import 'package:agenda/analog_clock/analog_clock_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agenda/timer_event_pop_in.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskHome extends StatefulWidget {
  final String task;
  final VoidCallback onDelete;
  final double clockHeight;
  final double deleteTaskButtonHeight;
  final double urgencyWidgetHeight;

  const TaskHome({
    super.key,
    required this.task,
    required this.onDelete,
    this.clockHeight = 320,
    this.deleteTaskButtonHeight = 50,
    this.urgencyWidgetHeight = 300,
  });

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  String? _id; // Torna o ID inicializável mais tarde.

  @override
  void initState() {
    super.initState();
    _initializeId();
  }

  /// Inicializa o ID verificando se já existe, caso contrário, cria e salva um novo.
  Future<void> _initializeId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('${widget.task}_id'); // Tenta recuperar o ID salvo
    if (storedId != null) {
      setState(() {
        _id = storedId; // Usa o ID existente
      });
    } else {
      final newId = const Uuid().v4();
      await prefs.setString('${widget.task}_id', newId); // Salva o novo ID
      setState(() {
        _id = newId; // Usa o novo ID
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_id == null) {
      // Mostra uma tela de carregamento enquanto o ID é inicializado.
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double clockSize = screenWidth * 0.96;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarTaskTitle(task: widget.task),  
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(
            // Background Image
            child: BackgroundImageWidget(
              backgroundImagePath: 'assets/clock/fundoroxo.png',
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 44.8)),

                // Analog Clock
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: SizedBox(
                    width: clockSize,
                    height: widget.clockHeight,
                    child: const AnalogClockWidget(),
                  ),
                ),

                // Urgence Classifier
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: screenWidth * 0.04,
                  ),
                  child: SizedBox(
                    width: screenWidth * 1.0,
                    child: UrgenceClassifier(
                      id: _id!, // Passa o ID único
                      title: 'Urgência',
                    ),
                  ),
                ),

                // Time Event
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: screenWidth * 0.04),
                  child: GestureDetector(
                    onTap: () => TimerEventPopin.timereventpopin(
                        context), // Abre o Pop-up
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(10, 246, 228, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Hora do Evento',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Color.fromARGB(70, 255, 255, 255),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Delete Task
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: SizedBox(
                    height: widget.deleteTaskButtonHeight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.onDelete();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
