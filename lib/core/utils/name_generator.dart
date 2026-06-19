import 'dart:math';

class NameGenerator {
  NameGenerator._();

  static final List<String> _titles = [
    'Dr.',
    'Prof.',
    'Assoc. Prof.',
    'Senior Researcher',
    'Fellow',
  ];

  static final List<String> _firstNames = [
    'Clara',
    'Eric',
    'Sophia',
    'Alan',
    'Grace',
    'Isaac',
    'Ada',
    'Charles',
    'Marie',
    'Albert',
    'Nikola',
    'Linus',
    'Tim',
    'Stephen',
    'Margaret',
  ];

  static final List<String> _lastNames = [
    'Quantum',
    'Neural',
    'Vector',
    'Tensor',
    'Entropy',
    'Helix',
    'Matrix',
    'Kernel',
    'Cipher',
    'Graph',
    'Fourier',
    'Shannon',
    'Turing',
    'Curie',
    'Einstein',
  ];

  static String generateRandomName() {
    final random = Random();
    final title = _titles[random.nextInt(_titles.length)];
    final firstName = _firstNames[random.nextInt(_firstNames.length)];
    final lastName = _lastNames[random.nextInt(_lastNames.length)];
    return '$title $firstName $lastName';
  }
}
