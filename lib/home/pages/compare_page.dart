import 'package:drivest_office/home/pages/profile/profile_page.dart';
import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../main_bottom_nav_screen.dart';
import '../widgets/custome_bottom_nav_bar.dart';
import 'ai_chat_page.dart';

class CompareResultPage extends StatelessWidget {
  const CompareResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary   = Color(0xff015093);
    const bg        = Color(0xffF3F5F7);
    const panel     = Color(0xffEAF3FF);
    const labelChip = Color(0xffD7E7F6);

    final carA = _Car(name: 'BMW Z4',     price: '\$ 10,000', image: 'assets/images/bmwz4.svg');
    final carB = _Car(name: 'Audi RS Q8', price: '\$ 12,000', image: 'assets/images/audi.svg');

    final specs = <_SpecRowData>[
      _SpecRowData('Engine',               '2998 cc, 6\nCylinders Inline',    '3996 cc, 8\nCylinders In V Sh.'),
      _SpecRowData('Fuel Type',            'Petrol',                         'Petrol'),
      _SpecRowData('Max Power (bhp@rpm)',  '375 bhp\n@ 5000 rpm',            '591 bhp\n@ 6000 rpm'),
      _SpecRowData('Driving Range',        '587.08 km',                      '680 km'),
      _SpecRowData('Drivetrain',           'RWD',                            'AWD'),
      _SpecRowData('Profit',               '\$900',                           '\$1000'),
    ];

    const double sheetHeight = 84;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Compare', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: primary),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, sheetHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _CarHeaderTile(car: carA)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('VS', style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                Expanded(child: _CarHeaderTile(car: carB, alignRight: true)),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: _NamePriceCentered(name: carA.name, price: carA.price)),
                const SizedBox(width: 16),
                Expanded(child: _NamePriceCentered(name: carB.name, price: carB.price)),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Column(
                children: specs.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _SpecRow(
                    label: s.label,
                    left: s.left,
                    right: s.right,
                    labelBg: labelChip,
                    panelBg: panel,
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),

      bottomSheet: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 8,
              shadowColor: primary.withOpacity(.35),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPage()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => AiChatPage()));
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));

        },
      ),
    );
  }
}

class _Car {
  final String name, price, image;
  const _Car({required this.name, required this.price, required this.image});
}

class _CarHeaderTile extends StatelessWidget {
  final _Car car;
  final bool alignRight;
  const _CarHeaderTile({required this.car, this.alignRight = false});

  bool get _isSvg => car.image.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final image = _isSvg
        ? SvgPicture.asset(car.image, height: 80, fit: BoxFit.contain)
        : Image.asset(car.image, height: 80, fit: BoxFit.contain);

    return Align(alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft, child: image);
  }
}

class _NamePriceCentered extends StatelessWidget {
  final String name, price;
  const _NamePriceCentered({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    const nameStyle  = TextStyle(color: Color(0xFF5A5A5A), fontSize: 14, fontWeight: FontWeight.w600);
    const priceStyle = TextStyle(color: Color(0xFF6F6F6F), fontSize: 12, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(name, style: nameStyle, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text('Price: $price', style: priceStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class _SpecRowData {
  final String label, left, right;
  const _SpecRowData(this.label, this.left, this.right);
}

class _SpecRow extends StatelessWidget {
  final String label, left, right;
  final Color labelBg, panelBg;

  const _SpecRow({
    required this.label,
    required this.left,
    required this.right,
    required this.labelBg,
    required this.panelBg,
  });

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 64;
    const double labelWidth = 122;

    const labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1F1F1F),
    );
    const valueStyle = TextStyle(
      fontSize: 12.5,
      color: Colors.black87,
      height: 1.25,
    );

    return Container(
      height: rowHeight,
      decoration: BoxDecoration(color: panelBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: labelWidth,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: labelBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: labelStyle, textAlign: TextAlign.center),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(left, style: valueStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                right,
                style: valueStyle,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
