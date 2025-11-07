import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

/// Bottom sheet for NIP-07 permission requests
class NostrPermissionBottomSheet extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const NostrPermissionBottomSheet({
    Key? key,
    required this.title,
    required this.content,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  State<NostrPermissionBottomSheet> createState() => _NostrPermissionBottomSheetState();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    bool? result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (BuildContext context) => NostrPermissionBottomSheet(
        title: title,
        content: content,
      ),
    );
    return result ?? false;
  }
}

class _NostrPermissionBottomSheetState extends State<NostrPermissionBottomSheet> {
  late Map<String, bool> _permissionStates;

  @override
  void initState() {
    super.initState();
    // Parse permission items and initialize states
    List<String> permissionItems = _parsePermissionItems(widget.content);
    _permissionStates = {
      for (var item in permissionItems) item: true, // Default to checked
    };
  }

  // Parse permission items from content string (format: "☑️ Item 1\n☑️ Item 2")
  List<String> _parsePermissionItems(String content) {
    List<String> items = [];
    List<String> lines = content.split('\n');
    for (String line in lines) {
      // Remove checkbox emoji and trim
      String cleaned = line.replaceAll(RegExp(r'☑️\s*'), '').trim();
      if (cleaned.isNotEmpty) {
        items.add(cleaned);
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // Parse permission items from content
    List<String> permissionItems = _parsePermissionItems(widget.content);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.px),
          topRight: Radius.circular(12.px),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Container(
            padding: EdgeInsets.only(top: 20.px, bottom: 16.px, left: 16.px, right: 16.px),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Permission items
          if (permissionItems.isNotEmpty)
            ...permissionItems.map((item) => _buildPermissionItem(
              item,
              _permissionStates[item] ?? true,
              (value) => setState(() => _permissionStates[item] = value),
            ))
          else
            // Fallback to default permissions
            Column(
              children: [
                _buildPermissionItem(
                  'Request to read your public key',
                  _permissionStates['Request to read your public key'] ?? true,
                  (value) => setState(() => _permissionStates['Request to read your public key'] = value),
                ),
                _buildPermissionItem(
                  'Sign events using your private key',
                  _permissionStates['Sign events using your private key'] ?? true,
                  (value) => setState(() => _permissionStates['Sign events using your private key'] = value),
                ),
              ],
            ),
          SizedBox(height: 20.px),
          // Buttons
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5.px,
                  color: ThemeColor.color160,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 20.px),
            child: Row(
              children: [
                Expanded(
                  child: _buildButton(
                    context,
                    Localized.text('ox_common.cancel'),
                    ThemeColor.color0,
                    () {
                      Navigator.pop(context, false);
                      widget.onCancel?.call();
                    },
                  ),
                ),
                Container(
                  width: 0.5.px,
                  height: 56.px,
                  color: ThemeColor.color160,
                ),
                Expanded(
                  child: _buildButton(
                    context,
                    Localized.text('ox_common.confirm'),
                    null, // Use theme color
                    () {
                      Navigator.pop(context, true);
                      widget.onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String text, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(!value),
            child: CommonImage(
              iconName: value ? 'icon_item_selected.png' : 'icon_item_unselected.png',
              size: 20.px,
              package: 'ox_wallet',
              useTheme: true,
            ),
          ),
          SizedBox(width: 12.px),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color? textColor,
    VoidCallback onTap,
  ) {
    final isThemeButton = textColor == null;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 56.px,
        alignment: Alignment.center,
        child: isThemeButton
            ? ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.px,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

