import 'package:cloud_firestore/cloud_firestore.dart';

class TypeTest {
  final int oneScore;
  final int twoScore;
  final int threeScore;
  final int fourScore;
  final int fiveScore;
  final int sixScore;
  final int sevenScore;
  final int eightScore;
  final int nineScore;
  final String id;
  int winningType;
  List<int> questionsAnswered = [];
  Map<String, int> score;
  final List<Map<String, dynamic>> questions = [
    {
      "id": 1,
      "uniqueId": 1001,
      "question": "I've been romantic and imaginitive.",
      "type": "four",
      "selected": false
    },
    {
      "id": 1,
      "uniqueId": 1002,
      "question": "I've been pragmatic and down to earth.",
      "type": "six",
      "selected": false
    },
    {
      "id": 2,
      "uniqueId": 10003,
      "question": "I've tended to take on confrontations.",
      "type": "eight",
      "selected": false
    },
    {
      "id": 2,
      "uniqueId": 1004,
      "question": "I've tended to avoid confrontations.",
      "type": "eight",
      "selected": false
    },
    {
      "id": 3,
      "uniqueId": 1005,
      "question": "I've typically been direct, formal, and idealistic.",
      "type": "one",
      "selected": false
    },
    {
      "id": 3,
      "uniqueId": 1006,
      "question": "I've typically been diplomatic, charming, and ambitious",
      "type": "three",
      "selected": false
    },
    {
      "id": 4,
      "uniqueId": 1007,
      "question": "I've tended to be focused and intense",
      "type": "five",
      "selected": false
    },
    {
      "id": 4,
      "uniqueId": 1008,
      "question": "I've tended to be spontaneous and fun-loving",
      "type": "seven",
      "selected": false
    },
    {
      "id": 5,
      "uniqueId": 1009,
      "question":
          "I've been a hospitable person and enjoyed welcoming new friends into my life",
      "type": "two",
      "selected": false
    },
    {
      "id": 5,
      "uniqueId": 1010,
      "question":
          "I've been a private person and have not mixed much with others",
      "type": "four",
      "selected": false
    },
    {
      "id": 6,
      "uniqueId": 1011,
      "question": "Generally it's been difficult to get a rise out of me",
      "type": "nine",
      "selected": false
    },
    {
      "id": 6,
      "uniqueId": 1012,
      "question": "Generally it's been easy to get a rise out of me",
      "type": "six",
      "selected": false
    },
    {
      "id": 7,
      "uniqueId": 1013,
      "question": "I've been more of a 'street-mart' survivor",
      "type": "eight",
      "selected": false
    },
    {
      "id": 7,
      "uniqueId": 1014,
      "question": "I've been more of a high minded idealist",
      "type": "one",
      "selected": false
    },
    {
      "id": 8,
      "uniqueId": 1015,
      "question": "I've needed to show affection to people",
      "type": "two",
      "selected": false
    },
    {
      "id": 8,
      "uniqueId": 1016,
      "question": "I've preferred to maintain a certain distance with people",
      "type": "five",
      "selected": false
    },
    {
      "id": 9,
      "uniqueId": 1017,
      "question":
          "When presented with a new experience, I've usually asked myself if it would be useful to me.",
      "type": "three",
      "selected": false
    },
    {
      "id": 9,
      "uniqueId": 1018,
      "question":
          "When presented with a new experience, I've usually asked myself if it would be enjoyable",
      "type": "seven",
      "selected": false
    },
    {
      "id": 10,
      "uniqueId": 1019,
      "question": "I have tended to focus too much on myself",
      "type": "four",
      "selected": false
    },
    {
      "id": 10,
      "uniqueId": 1020,
      "question": "I have tended to focus too much on others",
      "type": "nine",
      "selected": false
    },
    {
      "id": 11,
      "uniqueId": 1021,
      "question": "Others have depended on my insight and knowledge",
      "type": "five",
      "selected": false
    },
    {
      "id": 11,
      "uniqueId": 1022,
      "question": "Others have depended on my strength and decisiveness",
      "type": "eight",
      "selected": false
    },
    {
      "id": 12,
      "uniqueId": 1023,
      "question": "I have come across as being too unsure of myself",
      "type": "six",
      "selected": false
    },
    {
      "id": 12,
      "uniqueId": 1024,
      "question": "I have come across as being too sure of myself",
      "type": "one",
      "selected": false
    },
    {
      "id": 13,
      "uniqueId": 1025,
      "question": "I have been more relationship-oriented than goal-oriented",
      "type": "eight",
      "selected": false
    },
    {
      "id": 13,
      "uniqueId": 1026,
      "question": "I have been more goal-oriented than relationship-oriented",
      "type": "three",
      "selected": false
    },
    {
      "id": 14,
      "uniqueId": 1027,
      "question": "I have not been able to speak up for myself very well",
      "type": "four",
      "selected": false
    },
    {
      "id": 14,
      "uniqueId": 1028,
      "question":
          "I have been outspoken- I've said what others wished they had the nerve to say",
      "type": "seven",
      "selected": false
    },
    {
      "id": 15,
      "uniqueId": 1029,
      "question":
          "It's been difficult for me to stop considering alternatives and do something definite",
      "type": "five",
      "selected": false
    },
    {
      "id": 15,
      "uniqueId": 1030,
      "question":
          "It's been difficult for me to take it easy and be more flexible",
      "type": "one",
      "selected": false
    },
    {
      "id": 16,
      "uniqueId": 1031,
      "question": "I have tended to be hesitant and procrastinating",
      "type": "six",
      "selected": false
    },
    {
      "id": 16,
      "uniqueId": 1032,
      "question": "I have tended to be bold and domineering",
      "type": "eight",
      "selected": false
    },
    {
      "id": 17,
      "uniqueId": 1033,
      "question":
          "My reluctance to get too involved has gotten me into trouble with people",
      "type": "nine",
      "selected": false
    },
    {
      "id": 17,
      "uniqueId": 1034,
      "question":
          "My eagerness to have people depend on me has gotten me into trouble with them",
      "type": "two",
      "selected": false
    },
    {
      "id": 18,
      "uniqueId": 1035,
      "question":
          "Usually, I have been able to put my feelings aside to get the job done",
      "type": "three",
      "selected": false
    },
    {
      "id": 18,
      "uniqueId": 1036,
      "question":
          "Usually, I have needed to work through my feelings before I could act.",
      "type": "four",
      "selected": false
    },
    {
      "id": 19,
      "uniqueId": 1037,
      "question": "Generally, I have been methodical and cautious. ",
      "type": "six",
      "selected": false
    },
    {
      "id": 19,
      "uniqueId": 1038,
      "question": "Generally, I have been adventurous and taken risks",
      "type": "seven",
      "selected": false
    },
    {
      "id": 20,
      "uniqueId": 1039,
      "question":
          "I have tended to be a supportive, giving person who enjoys the company of others.",
      "type": "two",
      "selected": false
    },
    {
      "id": 20,
      "uniqueId": 1040,
      "question":
          "I have tended to be a serious, reserved person who likes discussing issues.",
      "type": "one",
      "selected": false
    },
    {
      "id": 21,
      "uniqueId": 1041,
      "question": "I've often felt the need to be a 'pillar of strength.'",
      "type": "eight",
      "selected": false
    },
    {
      "id": 21,
      "uniqueId": 1042,
      "question": "I've often felt the need to perform perfectly",
      "type": "three",
      "selected": false
    },
    {
      "id": 22,
      "uniqueId": 1043,
      "question":
          "I've typically been interested in asking tough questions and maintaining my independence",
      "type": "five",
      "selected": false
    },
    {
      "id": 22,
      "uniqueId": 1044,
      "question":
          "I've typically been interested in maintaining my stability and peace of mind.",
      "type": "nine",
      "selected": false
    },
    {
      "id": 23,
      "uniqueId": 1045,
      "question":
          "I've typically been interested in maintaining my stability and peace of mind.",
      "type": "six",
      "selected": false
    },
    {
      "id": 23,
      "uniqueId": 1046,
      "question":
          "I've typically been interested in maintaining my stability and peace of mind.",
      "type": "two",
      "selected": false
    },
    {
      "id": 24,
      "uniqueId": 1047,
      "question":
          "I've often worried that I'm missing out on something better.",
      "type": "seven",
      "selected": false
    },
    {
      "id": 24,
      "uniqueId": 1048,
      "question":
          "I've often worried that if I let down my guard, someone will take advantage of me.",
      "type": "eight",
      "selected": false
    },
    {
      "id": 25,
      "uniqueId": 1049,
      "question": "My habit of being 'stand-offish' has annoyed people.",
      "type": "four",
      "selected": false
    },
    {
      "id": 25,
      "uniqueId": 1050,
      "question": "My habit of telling people what to do has annoyed people.",
      "type": "one",
      "selected": false
    },
    {
      "id": 26,
      "uniqueId": 1051,
      "question":
          "Usually, when troubles have gotten to me, I have been able to 'tune them out.'",
      "type": "nine",
      "selected": false
    },
    {
      "id": 26,
      "uniqueId": 1052,
      "question":
          "Usually, when troubles have gotten to me, I have treated myself to something I've enjoyed",
      "type": "seven",
      "selected": false
    },
    {
      "id": 27,
      "uniqueId": 1053,
      "question":
          "I have depended upon my friends and they have known that they can depend on me.",
      "type": "six",
      "selected": false
    },
    {
      "id": 27,
      "uniqueId": 1054,
      "question":
          "I have not depended on people. I have done things on my own.",
      "type": "three",
      "selected": false
    },
    {
      "id": 28,
      "uniqueId": 1055,
      "question": "I have tended to be detached and preoccupied.",
      "type": "five",
      "selected": false
    },
    {
      "id": 28,
      "uniqueId": 1056,
      "question": "I have tended to be moody and self-absorbed.",
      "type": "four",
      "selected": false
    },
    {
      "id": 29,
      "uniqueId": 1057,
      "question": "I have liked to challenge people and 'shake them up.'",
      "type": "eight",
      "selected": false
    },
    {
      "id": 29,
      "uniqueId": 1058,
      "question": "I have liked to comfort people and calm them down.",
      "type": "two",
      "selected": false
    },
    {
      "id": 30,
      "uniqueId": 1059,
      "question": "I have generally been an outgoing, sociable person. ",
      "type": "seven",
      "selected": false
    },
    {
      "id": 30,
      "uniqueId": 1060,
      "question": "I have generally been an earnest, self-disciplined person.",
      "type": "one",
      "selected": false
    },
    {
      "id": 31,
      "uniqueId": 1061,
      "question": "I've usually been shy about showing my abilities.",
      "type": "nine",
      "selected": false
    },
    {
      "id": 31,
      "uniqueId": 1062,
      "question": "I've usually liked to let people know what I can do well.",
      "type": "three",
      "selected": false
    },
    {
      "id": 32,
      "uniqueId": 1063,
      "question":
          "Pursuing my personal interests has been more important to me than having comfort and security.",
      "type": "five",
      "selected": false
    },
    {
      "id": 32,
      "uniqueId": 1064,
      "question":
          "Having comfort and security has been more important to me than pursuing my personal interests",
      "type": "six",
      "selected": false
    },
    {
      "id": 33,
      "uniqueId": 1065,
      "question":
          "When I've had conflict with others, I've tended to withdraw.",
      "type": "four",
      "selected": false
    },
    {
      "id": 33,
      "uniqueId": 1066,
      "question":
          "When I've had conflict with others, I've rarely backed down.",
      "type": "eight",
      "selected": false
    },
    {
      "id": 34,
      "uniqueId": 1067,
      "question": "I have given in too easily and let others push me around. ",
      "type": "nine",
      "selected": false
    },
    {
      "id": 34,
      "uniqueId": 1068,
      "question": "I have been too uncompromising and demanding with others.",
      "type": "one",
      "selected": false
    },
    {
      "id": 35,
      "uniqueId": 1069,
      "question":
          "I've been appreciated for my unsinkable spirit and great sense of humour.",
      "type": "seven",
      "selected": false
    },
    {
      "id": 35,
      "uniqueId": 1070,
      "question":
          "I've been appreciated for my quiet strength and exceptional generosity.",
      "type": "two",
      "selected": false
    },
    {
      "id": 36,
      "uniqueId": 1071,
      "question":
          "Much of my success has been due to my talent for making a favourable impression.",
      "type": "three",
      "selected": false
    },
    {
      "id": 36,
      "uniqueId": 1072,
      "question":
          "Much of my success has been achieved despite my lack of interest in developing 'Interpersonal skills.'",
      "type": "five",
      "selected": false
    }
  ];
  TypeTest(
      {this.oneScore = 0,
      this.id,
      this.twoScore = 0,
      this.threeScore = 0,
      this.fourScore = 0,
      this.fiveScore = 0,
      this.sixScore = 0,
      this.sevenScore = 0,
      this.eightScore = 0,
      this.nineScore = 0,
      this.winningType,
      this.questionsAnswered}) {
    this.score = {
      "one": oneScore,
      "two": twoScore,
      "three": threeScore,
      "four": fourScore,
      "five": fiveScore,
      "six": sixScore,
      "seven": sevenScore,
      "eight": eightScore,
      "nine": nineScore
    };
  }
  void scoreQuestion({int uniqueId, String type}) {
    this.questions.forEach((ele) {
      if (uniqueId == ele["uniqueId"]) {
        ele["selected"] = true;
      }
    });
    this.score[type]++;
  }

  List<Map<String, dynamic>> displayQuestions() {
    final filteredList = questions
        .where((question) => !questionsAnswered.contains(question["id"]))
        .toList();
    filteredList.shuffle();
    final poppedItem = filteredList.removeAt(0);
    final complement =
        filteredList.where((el) => el["id"] == poppedItem["id"]).toList();
    complement.add(poppedItem);
    return complement;
  }

  void addQuestionToAnswered(int id) {
    questionsAnswered.add(id);
  }

  void selectAnswer({String question}) {
    questions.forEach((ele) {
      if (ele["question"] == question) ele["selected"] = true;
    });
  }

  void removeSelect({String question}) {
    questions.forEach((ele) {
      questions.forEach((ele) {
        if (ele["question"] == question) ele["selected"] = false;
      });
    });
  }

  factory TypeTest.fromDocument(DocumentSnapshot doc) {
    return TypeTest(
        id: doc["id"],
        oneScore: doc["oneScore"],
        twoScore: doc["twoScore"],
        threeScore: doc["threeScore"],
        fourScore: doc["fourScore"],
        fiveScore: doc["fiveScore"],
        sixScore: doc["sixScore"],
        sevenScore: doc["sevenScore"],
        eightScore: doc["eightScore"],
        nineScore: doc["nineScore"],
        winningType: doc["winningType"],
        questionsAnswered: doc["questionsAnswered"]);
  }
}
