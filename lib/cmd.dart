const List<int> READ = [0xFB, 0x01]; // 读取设备参数指令
const int READ_DEVICE = 0x02; // 读取设备电池容量和型号
const int CHARGE = 0x03; // 充电开
const int DISCHARGE = 0x04; // 放电开
const List<int> CLEAR_CURRENT = [
  0xFE,
  0x00,
  0xD1,
  0x00,
  0x00,
  0x00,
  0x01
]; // 电流清零
const int CLEAR_DATE = 0x06; // 数据清零
const int SET_SURPLUS = 0x07; // 余量设定
const int SET_CAPACITY = 0x08; // 容量设定
const int TIME_CONTROL = 0x09; // 定时控制
// 设置页命令
const int SET_OVP = 0x11; // 充电过压值
const int SET_LVP = 0x12; // 放电欠压值
const int SET_OCP = 0x13; // 充电过流值
const int SET_NCP = 0x14; // 放电过流值
const int SET_STV = 0x15; // 充电启动值
const int SET_OTP = 0x16; // 过温度保护值
const int SET_LTP = 0x17; // 低温恢复值
const int SET_DEL = 0x18; // 继电器延时
const int SET_TTL = 0x19; // 上电默认输出
const int SET_PTM = 0x1A; // 温控模式
const int SET_LAG = 0x1B; // 语言
const int SET_STE = 0x1C; // 定时时间值
const int SET_ETM = 0x1D; // 定时模式
const int SET_OKI = 0x1E; // 充电电流系数微调
const int SET_NKI = 0x1F; // 放电电流系数微调
const int SAVE = 0x21; // 保存设置
const int SET_DWM = 0x22; // 继电器工作模式
const int SET_ADC = 0x23; // 通讯地址码
const int SET_PAI = 0x24; // 电流归0值设置
const int SAVE_HOME = 0x25; // 首页保存设置
const int SET_RELAY = 0x26; // 首页保存设置
