final String tableNote = 'wordsTable';

class NoteFeild {
  static final List<String> values = [word, meanings, date, fav];

  static final String word = 'word';
  static final String meanings = 'meanings';
  static final String fav = 'fav';
  static final String date = 'date';
}

class Word {
  final String word;
  final String meaning;
  // late String description;
  String weight = '';
  final DateTime date;
  bool fav = false;
  Word(this.word, this.meaning, this.date, this.fav) {
    weight = setWeight(word);
  }

  // void setDescription(String d) {
  //   description = d;
  // }

  static Word fromJson(Map<String, dynamic> json) => Word(
      json[NoteFeild.word] as String,
      json[NoteFeild.meanings] as String,
      DateTime.parse(json[NoteFeild.date] as String),
      json[NoteFeild.fav] == 1 ? true : false);

  Map<String, dynamic> toJson() => {
        NoteFeild.word: word,
        NoteFeild.meanings: meaning,
        NoteFeild.date: date.toString(),
        NoteFeild.fav: fav ? 1 : 0,
      };
  String setWeight(String word) {
    String weight = '';
    for (int i = 0; i < word.length; i++) {
      if (word[i] == 'a') {
        weight = weight + '1 ';
      }
      if (word[i] == 'b') {
        weight = weight + '2 ';
      }
      if (word[i] == 'c') {
        weight = weight + '3 ';
      }
      if (word[i] == 'd') {
        weight = weight + '4 ';
      }
      if (word[i] == 'e') {
        weight = weight + '5 ';
      }
      if (word[i] == 'f') {
        weight = weight + '6 ';
      }
      if (word[i] == 'g') {
        weight = weight + '7 ';
      }
      if (word[i] == 'h') {
        weight = weight + '8 ';
      }
      if (word[i] == 'i') {
        weight = weight + '9 ';
      }
      if (word[i] == 'j') {
        weight = weight + '10 ';
      }
      if (word[i] == 'k') {
        weight = weight + '11 ';
      }
      if (word[i] == 'l') {
        weight = weight + '12 ';
      }
      if (word[i] == 'm') {
        weight = weight + '13 ';
      }
      if (word[i] == 'n') {
        weight = weight + '14 ';
      }
      if (word[i] == 'o') {
        weight = weight + '15 ';
      }
      if (word[i] == 'p') {
        weight = weight + '16 ';
      }
      if (word[i] == 'q') {
        weight = weight + '17 ';
      }
      if (word[i] == 'r') {
        weight = weight + '18 ';
      }
      if (word[i] == 's') {
        weight = weight + '19 ';
      }
      if (word[i] == 't') {
        weight = weight + '20 ';
      }
      if (word[i] == 'u') {
        weight = weight + '21 ';
      }
      if (word[i] == 'v') {
        weight = weight + '22 ';
      }
      if (word[i] == 'w') {
        weight = weight + '23 ';
      }
      if (word[i] == 'x') {
        weight = weight + '24 ';
      }
      if (word[i] == 'y') {
        weight = weight + '25 ';
      }
      if (word[i] == 'z') {
        weight = weight + '26 ';
      }
    }
    return weight;
  }
}
