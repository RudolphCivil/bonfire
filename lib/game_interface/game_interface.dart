import 'package:bonfire/bonfire.dart';

/// The way you cand raw things like life bars, stamina and settings. In another words, anything that you may add to the interface to the game.
class GameInterface extends GameComponent {
  @override
  PositionType get positionType => PositionType.viewport;

  @override
  int get priority {
    return LayerPriority.getInterfacePriority(gameRef.highestPriority);
  }

  /// Used to add components in your interface like a Button.
  @override
  Future<void>? add(Component component) {
    if (component is InterfaceComponent) {
      removeById(component.id);
    }
    return super.add(component);
  }

  /// Used to remove component of the interface by id
  void removeById(int id) {
    if (children.isEmpty) return;

    children.removeWhere((element) {
      return element is InterfaceComponent && element.id == id;
    });
  }

  @override
  bool hasGesture() => true;
}
