import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_document/open_document.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {

  final PdfInvoiceService service = PdfInvoiceService();
   MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                final data = await service.createHelloWorld();
                service.savePdfFile('invoice', data);
              },
              child: const Text("Create Invoice"),
            ),
        ),
      ),
    );
  }


}

  

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        },
      ),
    );

    return pdf.save();
  }

   Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
     await OpenDocument.openDocument(filePath: filePath);
  }
}