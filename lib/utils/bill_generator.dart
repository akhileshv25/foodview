import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> generateBill(Map<String, dynamic> order) async {
  final pdf = pw.Document();
  final font = pw.Font.helvetica();

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with Business Name & Logo Placeholder
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("My Restaurant", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: font)),
                    pw.Text("123, Food Street, City, Country", style: pw.TextStyle(fontSize: 12, font: font)),
                    pw.Text("Phone: +91 9876543210", style: pw.TextStyle(fontSize: 12, font: font)),
                  ],
                ),
                pw.Container(
                  width: 50,
                  height: 50,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Center(child: pw.Text("LOGO", style: pw.TextStyle(fontSize: 10))),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Order Details Section
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Order ID: ${order['orderId']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font)),
                  pw.Text("Date: ${DateTime.fromMillisecondsSinceEpoch(int.parse(order['orderId']))}", style: pw.TextStyle(font: font)),
                  pw.Text("Status: ${order['status'].toUpperCase()}", style: pw.TextStyle(font: font)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Items Table
            pw.Text("Items", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: font)),
            pw.SizedBox(height: 5),
            pw.Table.fromTextArray(
              headers: ["Item", "Qty", "Unit Price", "Total"],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              cellAlignment: pw.Alignment.centerLeft,
              cellHeight: 30,
              data: List<List<dynamic>>.from(order['items'].map((item) => [
                item['name'],
                item['quantity'].toString(),
                "Rs.${item['pricePerUnit'].toStringAsFixed(2)}",
                "Rs.${(item['quantity'] * item['pricePerUnit']).toStringAsFixed(2)}"
              ])),
              border: pw.TableBorder.all(width: 0.5),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(thickness: 0.8),
            
            // Total Section
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1.5),
                borderRadius: pw.BorderRadius.circular(5),
                color: pw.GridPaper.lineColor

              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TOTAL AMOUNT", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: font)),
                  pw.Text(
                    "Rs.${order['items'].fold(0, (sum, item) => sum + (item['quantity'] * item['pricePerUnit']))}",
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: font),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Thank You Note
            pw.Center(
              child: pw.Text("Thank you for your order!", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, font: font)),
            ),
          ],
        );
      },
    ),
  );

  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/bill_${order['orderId']}.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  } catch (e) {
    print("Error opening PDF: $e");
  }
}
