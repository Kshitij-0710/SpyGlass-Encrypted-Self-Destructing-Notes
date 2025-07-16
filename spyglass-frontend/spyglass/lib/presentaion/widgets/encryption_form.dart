import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EncryptionForm extends StatefulWidget {
  final TextEditingController keyController;
  final TextEditingController hintController;
  final int maxViews;
  final int expiryMinutes;
  final Function(int) onMaxViewsChanged;
  final Function(int) onExpiryChanged;
  final List<String> hintSuggestions;
  final bool isImprovingHint;
  final Function(String) onImproveHint;
  final Function(String) onHintSuggestionSelected;

  const EncryptionForm({
    Key? key,
    required this.keyController,
    required this.hintController,
    required this.maxViews,
    required this.expiryMinutes,
    required this.onMaxViewsChanged,
    required this.onExpiryChanged,
    required this.hintSuggestions,
    required this.isImprovingHint,
    required this.onImproveHint,
    required this.onHintSuggestionSelected,
  }) : super(key: key);

  @override
  State<EncryptionForm> createState() => _EncryptionFormState();
}

class _EncryptionFormState extends State<EncryptionForm> {
  bool _isKeyVisible = false;
  String _keyStrength = '';
  Color _keyStrengthColor = Colors.grey;
  final FocusNode _keyFocusNode = FocusNode();
  final FocusNode _hintFocusNode = FocusNode();

  // Predefined expiry options in minutes
  final Map<String, int> _expiryOptions = {
    '5 minutes': 5,
    '15 minutes': 15,
    '30 minutes': 30,
    '1 hour': 60,
    '2 hours': 120,
    '6 hours': 360,
    '12 hours': 720,
    '1 day': 1440,
    '3 days': 4320,
    '1 week': 10080,
  };

  @override
  void initState() {
    super.initState();
    widget.keyController.addListener(_checkKeyStrength);
    _checkKeyStrength();
  }

  @override
  void dispose() {
    widget.keyController.removeListener(_checkKeyStrength);
    _keyFocusNode.dispose();
    _hintFocusNode.dispose();
    super.dispose();
  }

  void _checkKeyStrength() {
    final key = widget.keyController.text;
    
    if (key.isEmpty) {
      setState(() {
        _keyStrength = '';
        _keyStrengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;
    
    // Length check
    if (key.length >= 8) score++;
    if (key.length >= 12) score++;
    if (key.length >= 16) score++;
    
    // Character variety checks
    if (key.contains(RegExp(r'[A-Z]'))) score++;
    if (key.contains(RegExp(r'[a-z]'))) score++;
    if (key.contains(RegExp(r'[0-9]'))) score++;
    if (key.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'))) score++;

    setState(() {
      if (score <= 2) {
        _keyStrength = 'Weak';
        _keyStrengthColor = Colors.red;
      } else if (score <= 4) {
        _keyStrength = 'Medium';
        _keyStrengthColor = Colors.orange;
      } else if (score <= 6) {
        _keyStrength = 'Strong';
        _keyStrengthColor = Colors.green;
      } else {
        _keyStrength = 'Very Strong';
        _keyStrengthColor = Colors.green[700]!;
      }
    });
  }

  void _generateSecureKey() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    final random = DateTime.now().millisecondsSinceEpoch;
    String key = '';
    
    for (int i = 0; i < 16; i++) {
      key += chars[(random + i) % chars.length];
    }
    
    widget.keyController.text = key;
    _checkKeyStrength();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Encryption Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Encryption Key Section
            _buildEncryptionKeySection(),
            const SizedBox(height: 20),

            // Key Hint Section
            _buildKeyHintSection(),
            const SizedBox(height: 20),

            // Security Settings Section
            _buildSecuritySettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptionKeySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Encryption Key',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.keyController,
          focusNode: _keyFocusNode,
          obscureText: !_isKeyVisible,
          decoration: InputDecoration(
            hintText: 'Enter a strong encryption key',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.key),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isKeyVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isKeyVisible = !_isKeyVisible),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _generateSecureKey,
                  tooltip: 'Generate secure key',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Key Strength Indicator
        if (widget.keyController.text.isNotEmpty) ...[
          Row(
            children: [
              Text(
                'Strength: ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _keyStrengthColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _keyStrengthColor, width: 1),
                ),
                child: Text(
                  _keyStrength,
                  style: TextStyle(
                    fontSize: 12,
                    color: _keyStrengthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        
        // Key Requirements
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Strong Key Requirements:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• At least 12 characters long\n• Mix of uppercase and lowercase\n• Include numbers and symbols\n• Avoid personal information',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue[700],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyHintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Key Hint',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Help others (and yourself) remember the key without revealing it',
              child: Icon(
                Icons.help_outline,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.hintController,
          focusNode: _hintFocusNode,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Optional hint to help remember the key (visible to everyone)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.lightbulb_outline),
            suffixIcon: widget.hintController.text.isNotEmpty
                ? IconButton(
                    icon: widget.isImprovingHint
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high),
                    onPressed: widget.isImprovingHint
                        ? null
                        : () => widget.onImproveHint(widget.hintController.text),
                    tooltip: 'Improve hint with AI',
                  )
                : null,
          ),
        ),
        
        // Hint Suggestions
        if (widget.hintSuggestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'AI Suggestions:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.purple[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.hintSuggestions.map((suggestion) => 
              ActionChip(
                label: Text(
                  suggestion,
                  style: const TextStyle(fontSize: 12),
                ),
                onPressed: () => widget.onHintSuggestionSelected(suggestion),
                backgroundColor: Colors.purple[50],
                side: BorderSide(color: Colors.purple[200]!),
              ),
            ).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSecuritySettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Settings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Max Views Setting
        _buildMaxViewsSetting(),
        const SizedBox(height: 20),
        
        // Expiry Setting
        _buildExpirySetting(),
      ],
    );
  }

  Widget _buildMaxViewsSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.visibility, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Maximum Views',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.maxViews} ${widget.maxViews == 1 ? 'view' : 'views'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: widget.maxViews.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                onChanged: (value) => widget.onMaxViewsChanged(value.round()),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: widget.maxViews.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  isDense: true,
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null && intValue >= 1 && intValue <= 100) {
                    widget.onMaxViewsChanged(intValue);
                  }
                },
              ),
            ),
          ],
        ),
        Text(
          'Note will be automatically deleted after ${widget.maxViews} ${widget.maxViews == 1 ? 'view' : 'views'}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildExpirySetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timer, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Auto-Delete After',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatExpiryTime(widget.expiryMinutes),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _expiryOptions.entries.map((entry) =>
            ChoiceChip(
              label: Text(
                entry.key,
                style: const TextStyle(fontSize: 12),
              ),
              selected: widget.expiryMinutes == entry.value,
              onSelected: (selected) {
                if (selected) {
                  widget.onExpiryChanged(entry.value);
                }
              },
              selectedColor: Colors.orange[200],
              backgroundColor: Colors.grey[100],
            ),
          ).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Note will be permanently deleted after ${_formatExpiryTime(widget.expiryMinutes)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatExpiryTime(int minutes) {
    if (minutes < 60) {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else {
        return '$hours${hours == 1 ? 'h' : 'h'} ${remainingMinutes}m';
      }
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return '$days ${days == 1 ? 'day' : 'days'}';
      } else {
        return '$days${days == 1 ? 'd' : 'd'} ${remainingHours}h';
      }
    }
  }
}