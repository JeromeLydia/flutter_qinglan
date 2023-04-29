class MessageData {
  var voltage = 0.0; //电压
  var current = 0.0; //电流
  var temperature = 0.0; //温度
  var currentDirection = 0; //电流方向
  var energy = 0.0; //剩余能量值  (KWH)
  var actualCapacity = 0.0; //剩余容量值
  var remainingCapacityPercentage = 0; //剩余容量百分比
  var accumulatedCapacity = 0.0; //累计容量值
  var runTime = 0; //运行时间/定时时间(秒)
  var charge = false; //充电继电器开关
  var discharge = false; //放电继电器开关
  var timeSwitch = false; //定时开关
  List<int> data = []; //
  MessageData();

  void init() {
    if (data.isNotEmpty) {
      voltage = initVoltage();
      current = initCurrent();
      temperature = initTemperature();
      currentDirection = initCurrentDirection();
      energy = initEnergy();
      actualCapacity = initActualCapacity();
      accumulatedCapacity = initAccumulatedCapacity();
      remainingCapacityPercentage = initRemainingCapacityPercentage();
      runTime = initRunTime();
      charge = initCharge();
      discharge = initDischarge();
      timeSwitch = initTimeSwitch();
    }
  }

  //获取电压值
  double initVoltage() {
    if (data.length < 6) {
      return 0;
    }
    return ((data[4] << 8) | data[5]) / 100.0;
  }

  //获取电流值
  double initCurrent() {
    if (data.length < 4) {
      return 0;
    }
    return ((data[2] << 8) | data[3]) / 100.0;
  }

  //获取功率值
  double initPower() {
    if (data.length < 6) {
      return 0;
    }
    return ((data[4] << 8) | data[5]) / 100.0;
  }

  //实际能量值  (KWH)
  double initEnergy() {
    if (data.length < 10) {
      return 0;
    }
    return (data[6] << 24 | data[7] << 16 | data[8] << 8 | data[9]) / 1000;
  }

  //实际容量值 (AH)
  double initActualCapacity() {
    if (data.length < 14) {
      return 0;
    }
    return (data[10] << 24 | data[11] << 16 | data[12] << 8 | data[13]) / 1000;
  }

  //剩余容量百分比
  int initRemainingCapacityPercentage() {
    if (data.length < 23) {
      return 0;
    }
    return data[22];
  }

  //累计总容量 (AH)
  double initAccumulatedCapacity() {
    if (data.length < 29) {
      return 0;
    }
    return (data[28] << 24 | data[27] << 16 | data[26] << 8 | data[25]) / 1000;
  }

  //运行时间 (秒)
  int initRunTime() {
    if (data.length < 22) {
      return 0;
    }
    return data[18] << 24 | data[19] << 16 | data[20] << 8 | data[21];
  }

  //获取温度值
  double initTemperature() {
    if (data.length < 15) {
      return 0;
    }
    return data[14] / 1.0;
  }

  //获取电流方向 0x00:放电 0x01:充电
  int initCurrentDirection() {
    if (data.length < 16) {
      return 0;
    }
    return data[15];
  }

  //充电继电器 0x00:关 0x01:开
  bool initCharge() {
    if (data.length < 17) {
      return false;
    }
    return data[16] == 0x01;
  }

  //放电继电器 0x00:关 0x01:开
  bool initDischarge() {
    if (data.length < 18) {
      return false;
    }
    return data[17] == 0x01;
  }

  //定时功能运行状态= data23；(0;定时时间到 1:定时启动)
  bool initTimeSwitch() {
    if (data.length < 25) {
      return false;
    }
    return data[24] == 0x01;
  }
}

class DeviceData {
  double totalCapacity = 0.0; //总容量
  int mode = 0; //型号
  List<int> data;

  DeviceData({required this.data}) {
    if (data.isNotEmpty) {
      totalCapacity = initTotalCapacity();
      mode = initMode();
    }
  }

  //总容量
  double initTotalCapacity() {
    if (data.length < 4) {
      return 0;
    }
    return (data[2] << 8 | data[3]) / 10;
  }

  // 型号
  int initMode() {
    if (data.length < 6) {
      return 0;
    }
    return (data[4] << 8 | data[5]);
  }
}
