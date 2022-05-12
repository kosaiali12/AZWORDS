import 'package:azwords/Function/word.dart';
import 'package:flutter/cupertino.dart';

class WordData extends ChangeNotifier {
  List<Word> words = [];
  List<Word> temp = [];
  List<Word> selectedwords = [];
  bool adding = true;
  bool selecting = false;
  bool explinationBoxShowed = false;
  bool explinationContentShowed = false;
  bool explinationDone = false;
  bool testing = false;
  int displayselected = 1;
  int selected = 1;
  int barButtonSelected = 1;

  void setTesting(bool value) {
    testing = value;
    notifyListeners();
  }

  void setselecting(bool b) {
    selecting = b;
    notifyListeners();
  }

  void setFav(Word index) {
    words[isFav2(index)].fav = !words[isFav2(index)].fav;
    // if (selected == 4) sorFavourite();
    notifyListeners();
  }

  void setdisplaySelected(int index) {
    displayselected = index;
    notifyListeners();
  }

  void setSelected(int index) {
    selected = index;
    notifyListeners();
  }

  void setBarButton(int index) {
    barButtonSelected = index;
    notifyListeners();
  }

  void addWord(String w, String m, DateTime d) {
    // Word word = Word(w, m, d);
    // words.add(word);
    notifyListeners();
  }

  void setAdd(bool add) {
    adding = add;
    notifyListeners();
  }

  void setShowed(bool e) {
    explinationBoxShowed = e;

    notifyListeners();
  }

  void setContentShowed(bool e) {
    explinationContentShowed = e;
    notifyListeners();
  }

  void setExDone() {
    explinationDone = true;
  }

  void addSelected(Word index) {
    if (!hasSelected(index)) {
      selectedwords.add(index);
    }
    notifyListeners();
  }

  bool hasSelected(Word index) {
    for (int i = 0; i < selectedwords.length; i++) {
      if (index.word == selectedwords[i].word) {
        return true;
      }
    }
    return false;
  }

  void delete() {
    for (int i = 0; i < selectedwords.length; i++) {
      print(selectedwords[i].word);
      int j = 0;
      while (j < words.length) {
        if (selectedwords[i].word == words[j].word) {
          words.removeAt(j);
          break;
        } else {
          j++;
        }
      }
      j = 0;
      while (j < temp.length) {
        if (selectedwords[i].word == temp[j].word) {
          temp.removeAt(j);
          break;
        } else {
          j++;
        }
      }
    }

    selectedwords.removeRange(0, selectedwords.length);

    // if (selected == 2) {
    //   sortAtoZ();
    // } else if (selected == 3) {
    //   sortZtoA();
    // }
    setselecting(false);
    notifyListeners();
  }

  void removeSelectedAll() {
    selectedwords.removeRange(0, selectedwords.length);
    selecting = false;
    notifyListeners();
  }

  void removeselected(Word index) {
    for (int i = 0; i < selectedwords.length; i++) {
      if (index.word == selectedwords[i].word) {
        selectedwords.removeAt(i);
      }
    }

    notifyListeners();
  }

  bool isFav(Word index) {
    if (selected == 1) {
      for (int i = 0; i < words.length; i++) {
        if (index.word == words[i].word && words[i].fav) {
          return true;
        }
      }
    } else {
      for (int i = 0; i < temp.length; i++) {
        if (index.word == temp[i].word && temp[i].fav) return true;
      }
    }
    return false;
  }

  int isFav2(Word index) {
    for (int i = 0; i < words.length; i++) {
      if (index.word == words[i].word) {
        return i;
      }
    }
    return -1;
  }

  List<Word> sortAtoZ(List<Word> words) {
    temp = [];
    for (int i = 0; i < words.length; i++) {
      bool exist = false;
      for (int j = 0; j < temp.length; j++) {
        if (temp[j].word == words[i].word) {
          exist = true;
        }
      }
      if (!exist) {
        temp.add(words[i]);
      }
    }

    for (int i = 0; i < temp.length; i++) {
      for (int j = i + 1; j < temp.length; j++) {
        int k = 0;
        int m = 0;
        while (k < temp[i].weight.length - 1 && m < temp[j].weight.length - 1) {
          int n1, n2;
          if (temp[i].weight[k + 1] == ' ') {
            n1 = int.parse(temp[i].weight[k]);
            k += 2;
          } else {
            n1 = int.parse(temp[i].weight.substring(k, k + 2));
            k += 3;
          }
          if (temp[j].weight[m + 1] == ' ') {
            n2 = int.parse(temp[j].weight[m]);
            m += 2;
          } else {
            n2 = int.parse(temp[j].weight.substring(m, m + 2));
            m += 3;
          }
          // print('result : n1= $n1 : n2= $n2');
          if (n1 < n2) {
            break;
          } else if (n1 == n2) {
            continue;
          }
          if (n1 > n2) {
            var p = temp[i];
            temp[i] = temp[j];
            temp[j] = p;
            break;
          }
        }
      }
    }
    return temp;
  }

  List<Word> sortZtoA(List<Word> words) {
    temp = [];
    for (int i = 0; i < words.length; i++) {
      bool exist = false;
      for (int j = 0; j < temp.length; j++) {
        if (temp[j].word == words[i].word) {
          exist = true;
        }
      }
      if (!exist) {
        temp.add(words[i]);
      }
    }

    for (int i = 0; i < temp.length; i++) {
      for (int j = i + 1; j < temp.length; j++) {
        int k = 0;
        int m = 0;
        while (k < temp[i].weight.length - 1 && m < temp[j].weight.length - 1) {
          int n1, n2;
          if (temp[i].weight[k + 1] == ' ') {
            n1 = int.parse(temp[i].weight[k]);
            k += 2;
          } else {
            n1 = int.parse(temp[i].weight.substring(k, k + 2));
            k += 3;
          }
          if (temp[j].weight[m + 1] == ' ') {
            n2 = int.parse(temp[j].weight[m]);
            m += 2;
          } else {
            n2 = int.parse(temp[j].weight.substring(m, m + 2));
            m += 3;
          }
          // print('result : n1= $n1 : n2= $n2');
          if (n1 > n2) {
            break;
          } else if (n1 == n2) {
            continue;
          }
          if (n1 < n2) {
            var p = temp[i];
            temp[i] = temp[j];
            temp[j] = p;
            break;
          }
        }
      }
    }
    return temp;
  }

  List<Word> sorFavourite(List<Word> words) {
    temp = [];
    for (int i = 0; i < words.length; i++) {
      if (words[i].fav == true) temp.add(words[i]);
    }
    return temp;
  }

  List<Word> search(String word) {
    List<Word> foundedwords = [];
    // sortAtoZ();
    if (word != '') {
      for (int i = 0; i < temp.length; i++) {
        String word1 = '';
        for (int j = 0; j < temp[i].word.length; j++) {
          word1 = word1 + temp[i].word[j];
          if (temp[i].word.contains(word)) {
            bool isExisted = false;
            for (int k = 0; k < foundedwords.length; k++) {
              if (foundedwords[k].word == temp[i].word) {
                isExisted = true;
                break;
              }
            }
            if (!isExisted) foundedwords.add(temp[i]);
          }
        }
      }
    }
    print(foundedwords);
    return foundedwords;
  }
}
