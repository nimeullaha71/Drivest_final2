import 'package:drivest_office/home/pages/compare_page.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';

class CompareSelectionPage extends StatefulWidget {
  const CompareSelectionPage({super.key, this.onBackToHome});
  final VoidCallback? onBackToHome;

  @override
  State<CompareSelectionPage> createState() => _CompareSelectionPageState();
}

class _CompareSelectionPageState extends State<CompareSelectionPage> {
  static const primary = Color(0xff015093);
  static const bg = Color(0xffF3F5F7);
  static const borderColor = Color(0xFFCCDCE9);

  final TextEditingController _search = TextEditingController();

  final List<String> models = const [
    'BMW Z4', 'Audi RS Q8',
    'BMW Z4', 'Audi RS Q8',
    'Audi RS Q8', 'BMW Z4',
  ];

  final Set<int> _selected = {};
  final List<int> _order = [];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggle(int i) {
    setState(() {
      if (_selected.contains(i)) {
        _selected.remove(i);
        _order.remove(i);
      } else {
        _selected.add(i);
        _order.add(i);
        if (_order.length > 2) {
          final oldest = _order.removeAt(0);
          _selected.remove(oldest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sheetHeight = 72;
    final double bottomPad =
        sheetHeight + MediaQuery.of(context).padding.bottom + 8;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Car Selection',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w400, fontSize: 20),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              if (widget.onBackToHome != null) {
                widget.onBackToHome!();
              } else {
                Navigator.maybePop(context);
              }
            },

            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: IconButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainBottomNavScreen()), (route)=>false);
              }, icon: Icon(Icons.arrow_back_ios,size: 18,color: primary ,)),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        decoration: const InputDecoration(
                          hintText: 'search',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: bg,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Choose your car',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: models.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.9,
                ),
                itemBuilder: (context, i) => _SelectablePill(
                  text: models[i],
                  selected: _selected.contains(i),
                  onTap: () => _toggle(i),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomSheet: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selected.length == 2
                ? () {
              final lastTwo = _order.toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompareResultPage(),
                ),
              );
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withOpacity(.35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 8,
              shadowColor: primary.withOpacity(.35),
            ),
            child: const Text(
              'Compare car',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

    );
  }
}

class _SelectablePill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectablePill({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    final sideColor = selected ? Colors.transparent : const Color(0xff1E63B6);

    return Material(
      color: selected ? primary : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: sideColor, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
