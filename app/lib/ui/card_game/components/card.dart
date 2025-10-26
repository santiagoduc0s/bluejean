import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class CardComponent extends SpriteComponent {
  CardComponent({
    required int row,
    required int col,
    super.position,
    super.size,
    super.anchor,
  }) : _row = row,
       _col = col;

  factory CardComponent.fromData(
    CardData card, {
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  }) {
    return CardComponent(
      row: card.row,
      col: card.col,
      position: position,
      size: size,
      anchor: anchor,
    );
  }

  final int _row;
  final int _col;

  static const double cardWidth = 110.64 * 4;
  static const double cardHeight = 177.17 * 4;

  static const double leftMargin = 44.47 * 4;
  static const double topMargin = 100.33 * 4;

  static final Vector2 spriteSize = Vector2(cardWidth, cardHeight);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Flame.images.load('game/cartas.png');

    final srcPos = Vector2(
      leftMargin + (_col * cardWidth),
      topMargin + (_row * cardHeight),
    );

    sprite = Sprite(
      spriteSheet,
      srcPosition: srcPos,
      srcSize: Vector2(cardWidth, cardHeight),
    );
  }
}

class CardData {
  const CardData({required this.palo, required this.valor});

  final CardSuit palo;
  final int valor;

  static const Map<String, Map<String, int>> _cardPositions = {
    '1_oros': {'row': 0, 'col': 0},
    '1_espadas': {'row': 0, 'col': 1},
    '1_bastos': {'row': 0, 'col': 2},
    '1_copas': {'row': 0, 'col': 3},
    '5_oros': {'row': 0, 'col': 4},
    '5_espadas': {'row': 0, 'col': 5},
    '5_bastos': {'row': 0, 'col': 6},
    '5_copas': {'row': 0, 'col': 7},
    '11_bastos': {'row': 0, 'col': 8},
    '11_copas': {'row': 0, 'col': 9},
    '11_espadas': {'row': 0, 'col': 10},
    '11_oros': {'row': 0, 'col': 11},
    '2_copas': {'row': 1, 'col': 0},
    '2_espadas': {'row': 1, 'col': 1},
    '2_oros': {'row': 1, 'col': 2},
    '2_bastos': {'row': 1, 'col': 3},
    '6_copas': {'row': 1, 'col': 4},
    '6_oros': {'row': 1, 'col': 5},
    '6_bastos': {'row': 1, 'col': 6},
    '6_espadas': {'row': 1, 'col': 7},
    '12_oros': {'row': 1, 'col': 8},
    '12_espadas': {'row': 1, 'col': 9},
    '12_bastos': {'row': 1, 'col': 10},
    '12_copas': {'row': 1, 'col': 11},
    '3_oros': {'row': 2, 'col': 0},
    '3_espadas': {'row': 2, 'col': 1},
    '3_bastos': {'row': 2, 'col': 2},
    '3_copas': {'row': 2, 'col': 3},
    '7_oros': {'row': 2, 'col': 4},
    '7_bastos': {'row': 2, 'col': 5},
    '7_espadas': {'row': 2, 'col': 6},
    '7_copas': {'row': 2, 'col': 7},
    '4_copas': {'row': 3, 'col': 0},
    '4_espadas': {'row': 3, 'col': 1},
    '4_bastos': {'row': 3, 'col': 2},
    '4_oros': {'row': 3, 'col': 3},
    '10_copas': {'row': 3, 'col': 4},
    '10_espadas': {'row': 3, 'col': 5},
    '10_bastos': {'row': 3, 'col': 6},
    '10_oros': {'row': 3, 'col': 7},
  };

  int get row {
    final key = '${valor}_${palo.name}';
    return _cardPositions[key]?['row'] ?? 0;
  }

  int get col {
    final key = '${valor}_${palo.name}';
    return _cardPositions[key]?['col'] ?? 0;
  }
}

enum CardSuit { oro, copa, espada, basto }
