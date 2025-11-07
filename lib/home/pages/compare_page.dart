import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CompareResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedCars;

  const CompareResultPage({super.key, required this.selectedCars});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    const bg = Color(0xffF3F5F7);
    const panel = Color(0xffEAF3FF);
    const labelChip = Color(0xffD7E7F6);

    final carA = selectedCars[0];
    final carB = selectedCars[1];

    final specs = <_SpecRowData>[
      _SpecRowData('Company',              carA['make']?.toString() ?? '', carB['make']?.toString() ?? ''),
      _SpecRowData('Fuel Type',            carA['fuelType']?.toString() ?? '', carB['fuelType']?.toString() ?? ''),
      _SpecRowData('Model',                carA['model']?.toString() ?? '', carB['model']?.toString() ?? ''),
      _SpecRowData('Year',                 carA['year']?.toString() ?? '', carB['year']?.toString() ?? ''),
      _SpecRowData('BodyType',           carA['bodyType']?.toString() ?? '', carB['bodyType']?.toString() ?? ''),
      _SpecRowData('Color',               carA['color']?.toString() ?? '', carB['color']?.toString() ?? ''),
    ];


    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Compare', style: TextStyle(color: Colors.black)),
        leading: BackButton(color: primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 84),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _CarHeaderTile(car: carA)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(child: _CarHeaderTile(car: carB, alignRight: true)),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _NamePriceCentered(
                    name: carA['title']?.toString() ?? '',
                    price: carA['price']?.toString() ?? '',
                  ),
                ),
                Expanded(
                  child: _NamePriceCentered(
                    name: carB['title']?.toString() ?? '',
                    price: carB['price']?.toString() ?? '',
                  ),
                ),

              ],
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Column(
                children: specs
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _SpecRow(
                          label: s.label,
                          left: s.left,
                          right: s.right,
                          labelBg: labelChip,
                          panelBg: panel,
                        ),
                      ),
                    )
                    .toList(),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarHeaderTile extends StatelessWidget {
  final Map<String, dynamic> car;
  final bool alignRight;
  const _CarHeaderTile({required this.car, this.alignRight = false});

  bool get _isSvg => (car['image']?.toString() ?? '').toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final carImage = car['image']?.toString() ?? '';
    Widget imageWidget;

    if (carImage.isEmpty) {
      imageWidget = Container(
        height: 80,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.directions_car, size: 40, color: Colors.grey)),
      );
    } else {
      imageWidget = _isSvg
          ? SvgPicture.asset(carImage, height: 80, fit: BoxFit.contain)
          : Image.network(carImage, height: 80, fit: BoxFit.contain);
    }

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: imageWidget,
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
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(12),
      ),
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
              child: Text(
                left,
                style: valueStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
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

class _NamePriceCentered extends StatelessWidget {
  final String name, price;
  const _NamePriceCentered({required this.name, required this.price});
  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Color(0xFF5A5A5A),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    const priceStyle = TextStyle(
      color: Color(0xFF6F6F6F),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
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
