import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../data/models/note/note.dart';

class PdfHandler {
  static PdfHandler instance = PdfHandler._();

  PdfHandler._();

  Future<File> generate({
    required Note note,
  }) async {
    final ByteData data =
        await rootBundle.load('assets/images/note_pdf_background.jpg');
    final Uint8List bytes = data.buffer.asUint8List();

    var pdfDocument = Document();
    pdfDocument.addPage(MultiPage(
        pageTheme: PageTheme(
          margin: EdgeInsets.zero,
          buildBackground: (context) => Image(
            MemoryImage(bytes),
            fit: BoxFit.cover,
          ),
        ),
        build: (Context context) => [
              _buildPageTitle(note.title),
              _buildContent(note),
            ]));

    return PdfApi.instance
        .savePdfDocument(filename: note.title, pdfDocument: pdfDocument);
  }

  Widget _buildPageTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 55, bottom: 40, right: 55),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: PdfColors.white,
        ),
      ),
    );
  }

  Widget _buildContent(Note note) {
    return Padding(
        padding: const EdgeInsets.only(left: 55, bottom: 120, right: 55),
        child: Column(
            children: note.content
                .map((section) => Text(section.content,
                    style: const TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                    )))
                .toList()));
  }
}

class PdfApi {
  static PdfApi instance = PdfApi._();

  PdfApi._();

  Future<File> savePdfDocument({
    required String filename,
    required Document pdfDocument,
  }) async {
    final Uint8List documentBytes = await pdfDocument.save();

    Directory? dir = await getDownloadsDirectory();

    File pdfFile = File('${dir!.path}/$filename.pdf');

    pdfFile.writeAsBytes(documentBytes);

    return pdfFile;
  }
}
