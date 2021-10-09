part of utils;

extension StringCrypto on String {
  String toMD5(){
    return md5.convert(utf8.encode(this)).toString();
  }
}
extension NoteCrypto on Note {
  String toMD5(){
    String txt="${this.title}#${this.content}";
    return md5.convert(utf8.encode(txt)).toString();
  }
}

extension ListIntCrypto on List<int> {
  String toMD5(){
    return md5.convert(this).toString();
  }
}