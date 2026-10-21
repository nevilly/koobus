// Validators — kanuni za kuangalia data ya mtumiaji kabla ya kutuma.
// Hizi ni "business rules" ndogo: zinatumika na login na screens zote
// zinazohitaji kuangalia format ya data.

class Validators {
  // Simu ya Tanzania: inaanza na +255 au 0, ikifuatiwa na 6 au 7 (mtandao
  // wa simu), jumla ya tarakimu 9 baada ya prefix.
  // Mfano halisi: +255712345678 au 0712345678
  static final RegExp _phonePattern = RegExp(r'^(?:\+255|0)[67]\d{8}$');

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tafadhali weka namba ya simu';
    }
    // Ondoa nafasi za mbele/nyuma kabla ya kuangalia
    final normalized = value.trim();
    if (!_phonePattern.hasMatch(normalized)) {
      return 'Namba si sahihi. Mfano: 0712345678';
    }
    return null; // null = hakuna hitilafu (imepita)
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tafadhali weka nenosiri';
    }
    if (value.length < 6) {
      return 'Nenosiri liwe na herufi 6 au zaidi';
    }
    return null;
  }
}
