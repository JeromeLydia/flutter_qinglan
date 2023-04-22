class MessageData {
  var voltage = 0.0; //电压
  var current = 0.0; //电流
  var temperature = 0.0; //温度
  var currentDirection = 0; //电流方向
  var energy = 0.0; //实际能量值  (KWH)
  var actualCapacity = 0.0; //实际容量值
  var remainingCapacityPercentage = 0; //剩余容量百分比
  var runTime = 0; //运行时间 (秒)
  var charge = false; //充电继电器开关
  var discharge = false; //放电继电器开关
  List<int> data = [];
  MessageData();

  void init() {
    if (data.isNotEmpty) {
      voltage = initVoltage();
      current = initCurrent();
      temperature = initTemperature();
      currentDirection = initCurrentDirection();
      energy = initEnergy();
      actualCapacity = initActualCapacity();
      remainingCapacityPercentage = initRemainingCapacityPercentage();
      runTime = initRunTime();
      charge = initCharge();
      discharge = initDischarge();
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

  //运行时间 (秒)
  int initRunTime() {
    if (data.length < 22) {
      return 0;
    }
    return data[18] << 24 | data[19] << 16 | data[20] << 8 | data[21];
  }

  //剩余容量百分比
  int initRemainingCapacityPercentage() {
    if (data.length < 23) {
      return 0;
    }
    return data[22];
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
}

class DeviceData {
  List<int> data;

  DeviceData({required this.data}) {
    if (data.isNotEmpty) {}
  }
}
