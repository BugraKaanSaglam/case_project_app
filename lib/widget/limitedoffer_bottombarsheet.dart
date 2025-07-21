import 'package:flutter/material.dart';

/// Shows the limited offer bottom sheet popup.
void showLimitedOfferBottomSheet(BuildContext context, {Function(int)? onPackageSelected, VoidCallback? onViewAll}) {
  showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => LimitedOfferBottomSheet(onPackageSelected: onPackageSelected, onViewAll: onViewAll));
}

class LimitedOfferBottomSheet extends StatefulWidget {
  final Function(int)? onPackageSelected;
  final VoidCallback? onViewAll;

  const LimitedOfferBottomSheet({super.key, this.onPackageSelected, this.onViewAll});

  @override
  LimitedOfferBottomSheetState createState() => LimitedOfferBottomSheetState();
}

class LimitedOfferBottomSheetState extends State<LimitedOfferBottomSheet> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sınırlı Teklif', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 8),
            Text("Jeton paketini seçerek bonus kazan\nve yeni bölümlerin kilidini açın!", style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            SizedBox(height: 24),
            Text('Alacağınız Bonuslar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_BonusItem(icon: Icons.diamond, label: 'Premium Hesap'), _BonusItem(icon: Icons.swap_horiz, label: 'Daha Fazla Eşleşme'), _BonusItem(icon: Icons.arrow_upward, label: 'Öne Çıkarma'), _BonusItem(icon: Icons.favorite, label: 'Daha Fazla Beğeni')]),
            SizedBox(height: 24),
            Text('Kilidi açmak için bir jeton paketi seçin', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            Row(children: [Expanded(child: _PackageItem(bonusText: '+10%', originalAmount: 200, finalAmount: 330, price: '₺99,99', isSelected: selectedIndex == 0, onTap: () => _onSelect(0))), SizedBox(width: 8), Expanded(child: _PackageItem(bonusText: '+70%', originalAmount: 2000, finalAmount: 3375, price: '₺799,99', isSelected: selectedIndex == 1, onTap: () => _onSelect(1))), SizedBox(width: 8), Expanded(child: _PackageItem(bonusText: '+35%', originalAmount: 1000, finalAmount: 1350, price: '₺399,99', isSelected: selectedIndex == 2, onTap: () => _onSelect(2)))]),
            SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.symmetric(vertical: 16)), onPressed: widget.onViewAll, child: Text('Tüm Jetonları Gör', style: TextStyle(fontSize: 16, color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  void _onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onPackageSelected?.call(index);
  }
}

class _BonusItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BonusItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: Icon(icon, color: Colors.pinkAccent)), SizedBox(height: 8), Text(label, style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)]);
  }
}

class _PackageItem extends StatelessWidget {
  final String bonusText;
  final int originalAmount;
  final int finalAmount;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackageItem({required this.bonusText, required this.originalAmount, required this.finalAmount, required this.price, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(gradient: isSelected ? LinearGradient(colors: [Colors.purple, Colors.blue]) : LinearGradient(colors: [Colors.red.shade700, Colors.red.shade400]), borderRadius: BorderRadius.circular(16), border: isSelected ? Border.all(color: Colors.white, width: 2) : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)), child: Text(bonusText, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), Spacer(), Text(originalAmount.toString(), style: TextStyle(color: Colors.white70, decoration: TextDecoration.lineThrough)), Text(finalAmount.toString(), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text('Jeton', style: TextStyle(color: Colors.white70)), Spacer(), Text(price, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text('Başına haftalık', style: TextStyle(color: Colors.white70, fontSize: 12))],
        ),
      ),
    );
  }
}
