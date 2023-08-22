import 'package:flutter/material.dart';
import 'package:merlin_foyer_app/utility/colors.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  ///The Constructor of SuperBottomNavigationBar.
  ///items is required.
  CustomBottomNavigationBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.height = 70.0,
    this.backgroundColor = const Color(0xFF191919),
    this.padding = EdgeInsets.zero,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 400),
    this.elevation = 8,
    this.onSelected,
  })  : assert(items.isNotEmpty),
        assert(items.length <= 10),
        assert(currentIndex < items.length),
        assert(currentIndex >= 0),
        assert(height >= 25),
        // assert(backgroundColor != null),
        // assert(curve != null),
        // assert(duration != null),
        assert(elevation >= 0.0);
  // assert(padding != null);

  /* Variables */

  ///[items] List of SuperBottomNavigationBarItem to show them in your BottomNavigationBar.
  final List<CustomBottomNavigationBarItem> items;

  ///[currentIndex] The tab to display.
  final int currentIndex;

  ///[height] Height of the BottomNavigationBar.
  final double height;

  ///[backgroundColor] backgroundColor of BottomNavigationBar.
  final Color backgroundColor;

  ///[curve] The transition curve.
  final Curve curve;

  ///[duration] The transition duration.
  final Duration duration;

  ///[padding] The padding surrounding the entire widget.
  ///
  /// You can use to adding floating effect.
  final EdgeInsets padding;

  ///[elevation] The elevation of the widget.
  final double elevation;

  ///[onSelected] Callback method , Return the index of the tab that was tapping.
  ValueChanged<int>? onSelected = (int index) {};

  @override

  /// Creating state fo SuperBottomNavigationBar.
  State<StatefulWidget> createState() => _CustomBottomNavigationBarState();
}

/* SuperBottomNavigationBar Widget Class */

/// This class is represent BottomNavigationBar Widget.
class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  /// This class is represent BottomNavigationBar Widget.
  int selected = 0;

  @override

  /// using the widget.
  CustomBottomNavigationBar get widget => super.widget;

  @override

  /// When initialize the widget.
  void initState() {
    /// Super initialize.
    super.initState();

    selected = widget.currentIndex;
  }

  @override

  /// Building the widget.
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Material(
        color: widget.backgroundColor,
        elevation: widget.elevation,
        child: InkWell(
          child: Container(
            color: MerlinColors.darkBlueColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                widget.items.length,
                (index) => Expanded(
                  child: SuperNavItem(
                    item: widget.items[index],
                    selected: selected == index,
                    height: widget.height,
                    curve: widget.curve,
                    duration: widget.duration,
                    changeIndex: () {
                      ///Change the state.
                      setState(() {});
                      selected = index;
                      widget.onSelected!(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* SuperNavItem Widget Class */

/// A tab to display in SuperBottomNavigationBar.
class SuperNavItem extends StatelessWidget {
  ///The Constructor of SuperNavItem.
  ///All variables is required.
  const SuperNavItem(
      {super.key,
      required this.item,
      required this.selected,
      required this.height,
      required this.curve,
      required this.duration,
      required this.changeIndex});

  ///[item] SuperNavItem object which contains all of data to display.
  final CustomBottomNavigationBarItem item;

  ///[selected] To check how to show the tab when it is selected.
  final bool selected;

  ///[height] Height of the tab.
  final double height;

  ///[duration] The transition duration.
  final Duration duration;

  ///[curve] The transition curve.
  final Curve curve;

  ///[changeIndex] The callback method the change the state.
  final GestureTapCallback changeIndex;

  @override

  /// Building the widget
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: changeIndex,
        highlightColor: item.highlightColor.withOpacity(0.6),
        splashColor: item.splashColor.withOpacity(0.4),
        hoverColor: item.hoverColor.withOpacity(0.6),
        child: Ink(
          child: AnimatedContainer(
            height: height,
            duration: duration,
            curve: curve,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: selected
                  ? Border(bottom: BorderSide(color: item.borderBottomColor, width: item.borderBottomWidth))
                  : const Border(bottom: BorderSide(color: Colors.transparent, width: 0)),
              gradient: /*selected
                  ? LinearGradient(
                      colors: [
                        item.backgroundShadowColor.withOpacity(0.5),
                        Colors.transparent,

                        // Color(0xFF6c5ce7).withOpacity(0.5),
                        // Color(0xFF897dec).withOpacity(0.01)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )
                  :*/
                  const LinearGradient(
                colors: [Colors.transparent, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Container(
              // color: selected ? item.selectedIconColor : item.unSelectedIconColor.withOpacity(0.5),
              // height: selected ? item.size : item.size - 5,
              // width: selected ? item.size : item.size - 5,
              child: selected ? item.selectedIcon : item.unSelectedIcon,
            ),
          ),
        ),
      ),
    );
  }
}

/* Model Class */

/// A tab to display in SuperBottomNavigationBar.
class CustomBottomNavigationBarItem {
  ///The Constructor of SuperBottomNavigationBarItem.
  const CustomBottomNavigationBarItem(
      {this.unSelectedIcon,
      this.selectedIcon,
      this.size = 30,
      this.selectedIconColor = Colors.transparent,
      this.unSelectedIconColor = Colors.transparent,
      this.highlightColor = Colors.transparent, //Colors.grey.withOpacity(0.6)
      this.splashColor = const Color(0xFF4F54DC),
      this.hoverColor = Colors.transparent, //Colors.grey.withOpacity(0.6)
      this.borderBottomColor = const Color(0xFF4F54DC),
      this.borderBottomWidth = 3,
      this.backgroundShadowColor = Colors.transparent})
      :
        // assert(unSelectedIcon != null),
        // assert(selectedIcon != null),
        assert(size >= 7),
        // assert(selectedIconColor != null),
        // assert(unSelectedIconColor != null),
        // assert(highlightColor != null),
        // assert(splashColor != null),
        // assert(hoverColor != null),
        // assert(borderBottomColor != null),
        // assert(backgroundShadowColor != null),
        assert(borderBottomWidth >= 1);

  /* Variables */

  ///[unSelectedIcon] The icon of the tab when tab is not selected.
  final Widget? unSelectedIcon;

  ///[selectedIcon] The icon of the tab when tab is selected.
  final Widget? selectedIcon;

  ///[size] The size of the tab.
  final double size;

  ///[selectedIconColor] The primary color to use for this tab.
  final Color selectedIconColor;

  ///[unSelectedIconColor] The color to display when this tab is not selected.
  final Color unSelectedIconColor;

  ///[highlightColor] The highlight color of the ink response when pressed.
  ///You can use it to add ripple effect.
  final Color highlightColor;

  ///[splashColor] The splash color of the ink response.
  ///You can use it to add ripple effect.
  final Color splashColor;

  ///[hoverColor] The color of the ink response when a pointer is hovering over it.
  ///You can use it to add ripple effect.
  final Color hoverColor;

  ///[borderBottomColor] The color of borderBottom.
  final Color borderBottomColor;

  ///[borderBottomWidth] The width of borderBottom.
  final double borderBottomWidth;

  ///[backgroundShadowColor] The shadow color behind the icon.
  final Color backgroundShadowColor;
}
