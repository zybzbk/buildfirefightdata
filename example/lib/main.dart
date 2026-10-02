import 'dart:ffi';

import 'package:xml/xml.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  try {
    runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

TextEditingValue onlyInputDouble(TextEditingValue old, TextEditingValue newS) {
  double? temp = double.tryParse(newS.text.trim());
  if (temp == null && !(old.text.length == 1 && newS.text.length == 0)) {
    return old;
  } else {
    return newS;
  }
} //只能输入浮点数算法实现

TextEditingValue onlyInputInt(TextEditingValue old, TextEditingValue newS) {
  int? temp = int.tryParse(newS.text.trim());
  if (temp == null && !(old.text.length == 1 && newS.text.length == 0)) {
    return old;
  } else {
    return newS;
  }
} //只能输入整数算法实现

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '数据编辑器',
      home: const MyHomePage(),
      theme: ThemeData(fontFamily: GoogleFonts.notoSansSc().fontFamily),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AmmoType {
  he('HE'),
  heat('HEAT'),
  heatfs('HEATFS'),
  atgm('ATGM'),
  ap('AP'),
  apc('APC'),
  apcbc('APCBC'),
  apcr('APCR'),
  apcnr('APCNR'),
  apds('APDS'),
  apfsds('APFSDS'),
  canister('Canister'),
  smoke('Smoke');

  final String name;
  AmmoType(this.name);
}

enum Guided {
  no('没有'),
  manual('手动'),
  faf('自动'),
  topAttack('攻顶'),
  overTheTop('越顶');

  final String name;
  Guided(this.name);
}

enum HeatERA {
  no('没有'),
  ealry('早期'),
  late('晚期'),
  coldWarEarly('冷战早期'),
  coldWar('冷战中期'),
  coldWarLate('冷战晚期'),
  modern('现代');

  final String name;
  HeatERA(this.name);
}

class Ammo {
  AmmoType ammoType;
  double? speed;
  double? mass;
  double? heMass;
  String? name;
  String? tracerImage;
  Guided? guided;
  double? atferThistime;
  String? explodeSound;
  HeatERA? heatERA;
  bool hasSmokeTrail;

  Ammo(
    this.ammoType,
    this.speed,
    this.mass,
    this.heMass,
    this.name,
    this.tracerImage,
    this.guided,
    this.atferThistime,
    this.explodeSound,
    this.heatERA,
    this.hasSmokeTrail,
  );
}

class AmmoData {
  late Ammo ammo;
  bool isSelected = false;
  AmmoData(Ammo a) {
    ammo = a;
  }
}

class AmmoEdit extends StatefulWidget {
  bool isEdit;
  List<AmmoData> ammoData;
  AmmoEdit({super.key, required this.ammoData, required this.isEdit});
  @override
  State<StatefulWidget> createState() => _AmmoEdit();
}

class _AmmoEdit extends State<AmmoEdit> {
  TextEditingController inputSpeed = TextEditingController(text: "100");
  TextEditingController inputAmmoMass = TextEditingController(text: "1");
  TextEditingController inputHEMass = TextEditingController(text: "0");
  TextEditingController inputName = TextEditingController();
  TextEditingController inputTracerImage = TextEditingController(
    text: "Default",
  );
  TextEditingController inputatferThistime = TextEditingController(text: "0");
  TextEditingController inputExplodeSound = TextEditingController(
    text: "Default",
  );

  String selectedAmmo = AmmoType.ap.name; //初始化选择的Ammo类型
  List<String> ammoType = [
    //Ammo类型列表
    AmmoType.he.name,
    AmmoType.heat.name,
    AmmoType.heatfs.name,
    AmmoType.atgm.name,
    AmmoType.ap.name,
    AmmoType.apc.name,
    AmmoType.apcbc.name,
    AmmoType.apcnr.name,
    AmmoType.apcr.name,
    AmmoType.apds.name,
    AmmoType.apfsds.name,
    AmmoType.canister.name,
    AmmoType.smoke.name,
  ];
  String selectedGuided = Guided.no.name;
  List<String> guided = [
    Guided.no.name,
    Guided.manual.name,
    Guided.faf.name,
    Guided.topAttack.name,
    Guided.overTheTop.name,
  ];
  String selectedHeatERA = HeatERA.no.name;
  List<String> heatERA = [
    HeatERA.no.name,
    HeatERA.ealry.name,
    HeatERA.late.name,
    HeatERA.coldWarEarly.name,
    HeatERA.coldWar.name,
    HeatERA.coldWarLate.name,
    HeatERA.modern.name,
  ];
  bool hasSmokeTrail = false;

  AmmoType caseStringreturnAmmoType(String S) {
    AmmoType ammoType = switch (S) {
      'HE' => AmmoType.he,
      'HEAT' => AmmoType.heat,
      'HEATFS' => AmmoType.heatfs,
      'ATGM' => AmmoType.atgm,
      'AP' => AmmoType.ap,
      'APC' => AmmoType.apc,
      'APCBC' => AmmoType.apcbc,
      'APCNR' => AmmoType.apcnr,
      'APCR' => AmmoType.apcr,
      'APDS' => AmmoType.apds,
      'APFSDS' => AmmoType.apfsds,
      'Canister' => AmmoType.canister,
      'Smoke' => AmmoType.smoke,
      String() => throw '类型不匹配',
    };
    return ammoType;
  }

  HeatERA caseStringreturnHearERA(String S) {
    HeatERA heatERA = switch (S) {
      '没有' => HeatERA.no,
      '早期' => HeatERA.ealry,
      '晚期' => HeatERA.late,
      '冷战早期' => HeatERA.coldWarEarly,
      '冷战中期' => HeatERA.coldWar,
      '冷战晚期' => HeatERA.coldWarLate,
      '现代' => HeatERA.modern,
      String() => throw '类型不匹配',
    };
    return heatERA;
  }

  Guided caseStringreturnGuided(String S) {
    Guided guided = switch (S) {
      '没有' => Guided.no,
      '手动' => Guided.manual,
      '自动' => Guided.faf,
      '攻顶' => Guided.topAttack,
      '越顶' => Guided.overTheTop,
      String() => throw '类型不匹配',
    };
    return guided;
  }

  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    if (widget.isEdit == true) {
      //循环读索引
      for (int i = 0; i < widget.ammoData.length; i++) {
        if (widget.ammoData[i].isSelected == true) {
          selectedIndex = i;
          break;
        }
      }
      //接下来初始化界面字符
      inputSpeed.text = '${widget.ammoData[selectedIndex].ammo.speed}';
      inputAmmoMass.text = '${widget.ammoData[selectedIndex].ammo.mass}';
      inputHEMass.text = '${widget.ammoData[selectedIndex].ammo.heMass}';
      inputName.text = '${widget.ammoData[selectedIndex].ammo.name}';
      inputTracerImage.text =
          '${widget.ammoData[selectedIndex].ammo.tracerImage}';
      inputatferThistime.text =
          '${widget.ammoData[selectedIndex].ammo.atferThistime}';
      inputExplodeSound.text =
          '${widget.ammoData[selectedIndex].ammo.explodeSound}';
      selectedAmmo = widget.ammoData[selectedIndex].ammo.ammoType.name;
      selectedGuided = widget.ammoData[selectedIndex].ammo.guided!.name;
      selectedHeatERA = widget.ammoData[selectedIndex].ammo.heatERA!.name;
    }
  }

  @override
  void dispose() {
    inputSpeed.dispose();
    inputAmmoMass.dispose();
    inputHEMass.dispose();
    inputName.dispose();
    inputTracerImage.dispose();
    inputatferThistime.dispose();
    inputExplodeSound.dispose();
    super.dispose();
  }

  @override //添加Ammo窗口
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("添加弹药"),
      content: Column(
        children: [
          Row(
            children: [
              Text("弹种"),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedAmmo,
                  items: ammoType.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAmmo = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("速度"),
              Expanded(
                child: TextField(
                  controller: inputSpeed,
                  inputFormatters: [
                    TextInputFormatter.withFunction(onlyInputDouble),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("弹药质量"),
              Expanded(
                child: TextField(
                  controller: inputAmmoMass,
                  inputFormatters: [
                    TextInputFormatter.withFunction(onlyInputDouble),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("HE质量"),
              Expanded(
                child: TextField(
                  controller: inputHEMass,
                  inputFormatters: [
                    TextInputFormatter.withFunction(onlyInputDouble),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("名称"),
              Expanded(child: TextField(controller: inputName)),
            ],
          ),
          Row(
            children: [
              Text("弹道图像"),
              Expanded(child: TextField(controller: inputTracerImage)),
            ],
          ),
          Row(
            children: [
              Text("制导"),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedGuided,
                  items: guided.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGuided = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("几秒后爆炸"),
              Expanded(
                child: TextField(
                  controller: inputatferThistime,
                  inputFormatters: [
                    TextInputFormatter.withFunction(onlyInputDouble),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("爆炸音效"),
              Expanded(child: TextField(controller: inputExplodeSound)),
            ],
          ),
          Row(
            children: [
              Text("时代"),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedHeatERA,
                  items: heatERA.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGuided = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("烟雾拖尾"),
              Checkbox(
                value: hasSmokeTrail,
                onChanged: (n) {
                  setState(() {
                    hasSmokeTrail = n!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Ammo ammo = Ammo(
              caseStringreturnAmmoType(selectedAmmo),
              double.tryParse(inputSpeed.text),
              double.tryParse(inputAmmoMass.text),
              double.tryParse(inputHEMass.text),
              inputName.text,
              inputTracerImage.text,
              caseStringreturnGuided(selectedGuided),
              double.tryParse(inputatferThistime.text),
              inputExplodeSound.text,
              caseStringreturnHearERA(selectedHeatERA),
              hasSmokeTrail,
            );
            AmmoData ammoData = AmmoData(ammo);
            Navigator.of(context).pop(ammoData);
          },
          child: Text("确定"),
        ),
      ],
    );
  }
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController; //Tab控件

  bool isHasMuzzleFlash = false; //初始化

  String selectFlavour = "WEAPON_RIFLE"; //选中的弹种的初始化
  List<String> flavour = [
    //弹种列表
    "WEAPON_RIFLE",
    "WEAPON_PISTOL",
    "WEAPON_CARBINE",
    "WEAPON_SHOTGUN",
    "WEAPON_AT_RIFLE",
    "WEAPON_SMG",
    "WEAPON_LMG",
    "WEAPON_HMG",
    "WEAPON_RPG",
    "WEAPON_RECOILLESS_RIFLE",
    "WEAPON_FLAMETHROWER_PORTABLE",
    "WEAPON_FLAMETHROWER_TANK",
    "WEAPON_GRENADE",
    "WEAPON_GRENADE_LAUNCHER",
    "WEAPON_MORTAR",
    "WEAPON_BOMB",
    "WEAPON_CANNON",
    "WEAPON_MLRS",
  ];

  String selectFireMode = "手动"; //选中模式初始化
  List<String> fireMode = ["手动", "半自动", "全自动"]; //射击模式列表

  bool fireOnce = false; //是否射击一次初始化

  List<AmmoData> ammoList = []; //弹药数据列表初始化

  String selectedCountry = '';

  Map<String, bool> countries = {
    '美国': false,
    '加拿大': false,
    '英国': false,
    '俄罗斯': false,
    '乌克兰': false,
    '德国': false,
    '波兰': false,
    '芬兰': false,
    '法国': false,
    '匈牙利': false,
    '格鲁吉亚': false,
    '意大利': false,
    '罗马尼亚': false,
    '奥地利': false,
    '比利时': false,
    '荷兰': false,
    '以色列': false,
    '约旦': false,
    '科威特': false,
    '伊拉克': false,
    '埃及': false,
    '伊朗': false,
    '叙利亚': false,
    '印度': false,
    '巴基斯坦': false,
    '亚美尼亚': false,
    '阿塞拜疆': false,
    '土耳其': false,
    '日本': false,
    '韩国': false,
    '南越': false,
    '中国': false,
    '朝鲜': false,
    '北越': false,
    '澳大利亚': false,
  };

  Future<void> addAmmo() async {
    AmmoData result = await showDialog(
      context: context,
      builder: (_) => AmmoEdit(ammoData: ammoList, isEdit: false),
    );
    if (result == null) return;
    setState(() {
      ammoList.add(result);
    });
  }

  Future<void> editAmmo() async {
    AmmoData result = await showDialog(
      context: context,
      builder: (_) => AmmoEdit(ammoData: ammoList, isEdit: true),
    );
    if (result == null) return;
    int selectedIndex = 0;
    for (var i = 0; i < ammoList.length; i++) {
      if (ammoList[i].isSelected == true) {
        selectedIndex = i;
        break;
      }
    }
    setState(() {
      ammoList[selectedIndex] = result;
    });
  }

  Future<void> removeAmmo() async {
    int selectedIndex = 0;
    for (var i = 0; i < ammoList.length; i++) {
      if (ammoList[i].isSelected == true) {
        selectedIndex = i;
        break;
      }
    }
    if (ammoList.isEmpty) return;
    setState(() {
      ammoList.removeAt(selectedIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  } //初始化部分Flutter控件

  @override //界面
  //叠叠乐这一块
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        title: Text("数据编辑器"),
        bottom: TabBar(controller: tabController, tabs: [Text("武器")]),
      ),
      body: DefaultTabController(
        length: 1,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("名字: "),
                    Expanded(child: TextField()),
                  ],
                ),
                Row(
                  children: [
                    Text("种类: "),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectFlavour,
                        items: flavour.map<DropdownMenuItem<String>>((
                          String item,
                        ) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectFlavour = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("口径: "),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("枪管长: "),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          TextInputFormatter.withFunction(onlyInputDouble),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("枪管数: "),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          TextInputFormatter.withFunction(onlyInputInt),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("射速: "),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          TextInputFormatter.withFunction(onlyInputDouble),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("射击音效: "),
                    Expanded(child: TextField()),
                  ],
                ),
                Row(
                  children: [
                    Text("被摧毁图片: "),
                    Expanded(child: TextField()),
                  ],
                ),
                Row(
                  children: [
                    Text("枪口火焰: "),
                    Checkbox(
                      value: isHasMuzzleFlash,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          isHasMuzzleFlash = newvalue!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("射击方式: "),
                    DropdownButton(
                      value: selectFireMode,
                      items: fireMode.map<DropdownMenuItem<String>>((
                        String item,
                      ) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectFireMode = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("弹夹子弹数: "),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          TextInputFormatter.withFunction(onlyInputInt),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("装弹音效: "),
                    Expanded(child: TextField()),
                  ],
                ),
                Row(
                  children: [
                    Text("漏夹弹出声: "),
                    Expanded(child: TextField()),
                  ],
                ),
                Row(
                  children: [
                    Text("发射一次: "),
                    Checkbox(
                      value: fireOnce,
                      onChanged: (bool? newvalue) {
                        setState(() {
                          fireOnce = newvalue!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        addAmmo();
                      },
                      child: Icon(Icons.add),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        removeAmmo();
                      },
                      child: Icon(Icons.remove),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: Text("类型")),
                          DataColumn(label: Text("速度")),
                          DataColumn(label: Text("质量")),
                          DataColumn(label: Text("HE")),
                        ],
                        rows: ammoList.map((ammo) {
                          return DataRow(
                            selected: ammo.isSelected,
                            onSelectChanged: (_) {
                              setState(() {
                                for (var element in ammoList) {
                                  element.isSelected = false;
                                }
                                ammo.isSelected = true;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                for (var e in ammoList) {
                                  e.isSelected = false;
                                }
                                ammo.isSelected = true;
                              });
                              editAmmo();
                            },
                            cells: [
                              DataCell(Text("${ammo.ammo.ammoType.name}")),
                              DataCell(Text("${ammo.ammo.speed}")),
                              DataCell(Text("${ammo.ammo.mass}")),
                              DataCell(Text("${ammo.ammo.heMass}")),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: countries.entries.map((i) {
                          return Row(
                            children: [
                              Checkbox(
                                value: countries[i.key],
                                onChanged: (newValue) {
                                  countries[i.key] = newValue ?? false;
                                },
                              ),
                              Text(i.key),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
