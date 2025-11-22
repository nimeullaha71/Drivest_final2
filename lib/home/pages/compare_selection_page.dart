import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/network/car_provider.dart';
import '../../main_bottom_nav_screen.dart';
import 'compare_page.dart';

class CompareSelectionPage extends StatefulWidget {
  const CompareSelectionPage({super.key});

  @override
  State<CompareSelectionPage> createState() => _CompareSelectionPageState();
}

class _CompareSelectionPageState extends State<CompareSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selected = {};
  final List<int> _order = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarProvider>(context, listen: false).fetchCars();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  void _onSearchChanged(String value) {
    Provider.of<CarProvider>(context, listen: false).fetchCars(search: value);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    const bg = Color(0xffF3F5F7);
    const borderColor = Color(0xFFCCDCE9);
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Car Selection', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
                  (route) => false,
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: SavedPage.primary),
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search car...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: borderColor)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),
            if (carProvider.isLoading)
              const Center(
                  child: CircularProgressIndicator(color: primary),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: carProvider.cars.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 6,
                  ),
                  itemBuilder: (context, i) {
                    final car = carProvider.cars[i];
                    return _SelectablePill(
                      title: car['title'] ?? '',
                      model: car['make'] ?? '',
                      selected: _selected.contains(i),
                      onTap: () => _toggle(i),
                    );
                  },
                ),
              ),
            SizedBox(height: 88,)
          ],
        ),
      ),
      bottomSheet: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selected.length == 2
                ? () {
              final selectedCars = _order.map((i) => carProvider.cars[i]).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompareResultPage(
                    selectedCars: selectedCars,
                  ),
                ),
              ).then((_) {
                // Reset selections when coming back
                setState(() {
                  _selected.clear();
                  _order.clear();
                });
              });
            }
                : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withOpacity(.35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
            ),
            child: const Text(
              'Compare Cars',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectablePill extends StatelessWidget {
  final String title;
  final String model;
  final bool selected;
  final VoidCallback onTap;

  const _SelectablePill({
    required this.title,
    required this.model,
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // vertically center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   title,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: selected ? Colors.white : Colors.black87,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 14,
              //   ),
              // ),
              const SizedBox(height: 4),
              Text(
                model,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white70 : Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

