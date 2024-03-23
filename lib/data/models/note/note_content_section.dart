class NoteContentSection {
  SectionType sectionType;
  dynamic content;

  NoteContentSection({
    required this.sectionType,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'sectionType': sectionType.description,
      'content': content,
    };
  }

  factory NoteContentSection.fromMap(Map<String, dynamic> map) {
    return NoteContentSection(
      sectionType: sectionTypeFromString(map['sectionType']),
      content: map['content'] as dynamic,
    );
  }
}

enum SectionType { text, image }

extension SectionExtension on SectionType {
  String get description {
    switch (this) {
      case SectionType.text:
        return 'text';
      case SectionType.image:
        return 'image';
      default:
        return '';
    }
  }
}

SectionType sectionTypeFromString(String section) {
  switch (section) {
    case 'text':
      return SectionType.text;
    case 'image':
      return SectionType.image;
    default:
      return SectionType.text;
  }
}
