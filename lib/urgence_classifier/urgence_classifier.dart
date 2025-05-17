import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UrgenceClassifier extends StatefulWidget {
  final String title;
  final String id; // Identificador único para salvar a opção no dispositivo

  const UrgenceClassifier({
    required this.title,
    required this.id,
    super.key,
  });

  @override
  State<UrgenceClassifier> createState() => _UrgenceClassifierState();
}

class _UrgenceClassifierState extends State<UrgenceClassifier>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _loadSelectedOption(); // Carregar a opção salva
  }

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedOption = prefs.getString('selected_option_${widget.id}') ?? 'Opção 1';
    setState(() {});
  }

  Future<void> _saveSelectedOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_option_${widget.id}', option);
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
    _saveSelectedOption(option); // Salvar a opção escolhida
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSelectedOptionImage() {
    String imagePath;

    switch (_selectedOption) {
      case 'Opção 1':
        imagePath = 'assets/urgence/noclassifier.png';
        break;
      case 'Opção 2':
        imagePath = 'assets/urgence/highurgence.png';
        break;
      case 'Opção 3':
        imagePath = 'assets/urgence/mediumurgence.png';
        break;
      case 'Opção 4':
        imagePath = 'assets/urgence/withouturgence.png';
        break;
      default:
        imagePath = 'assets/urgence/noclassifier.png';
    }

    return Image.asset(
      imagePath,
      width: 28,
      height: 28,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _toggleExpand,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(10, 246, 228, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
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
                    Positioned(
                      right: 0,
                      child: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      child: _buildSelectedOptionImage(),
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(4, 247, 227, 253),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildOption(
                      title: 'Sem Classificação',
                      value: 'Opção 1',
                      imagePath: 'assets/urgence/noclassifier.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    _buildOption(
                      title: 'Urgente',
                      value: 'Opção 2',
                      imagePath: 'assets/urgence/highurgence.png',
                      color: Colors.red,
                    ),
                    _buildOption(
                      title: 'Urgência Média',
                      value: 'Opção 3',
                      imagePath: 'assets/urgence/mediumurgence.png',
                      color: const Color.fromARGB(255, 243, 207, 0),
                    ),
                    _buildOption(
                      title: 'Não Urgente',
                      value: 'Opção 4',
                      imagePath: 'assets/urgence/withouturgence.png',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption({
    required String title,
    required String value,
    required String imagePath,
    required Color color,
  }) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 28,
        height: 28,
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(190, 255, 255, 255),
          fontWeight: FontWeight.normal,
          fontFamily: 'CustomFont',
          letterSpacing: 2.0,
          fontSize: 16,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: Radio<String>(
          value: value,
          groupValue: _selectedOption,
          onChanged: (value) => _selectOption(value!),
          activeColor: color,
        ),
      ),
    );
  }
}
