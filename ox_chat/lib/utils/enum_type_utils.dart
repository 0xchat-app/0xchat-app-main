class EnumTypeUtils{

  static bool checkShiftOperation(String value, int index){
    bool result = false;
    if(value.isNotEmpty){
      int settingInt = int.parse(value);
      settingInt = (settingInt >> index) & 1;
      return settingInt == 1;
    }
    return result;
  }
}