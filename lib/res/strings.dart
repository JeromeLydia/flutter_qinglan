import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          '首页': '首页',
          '曲线图': '曲线图',
          '设置': '设置',
          '请打开蓝牙': '请打开蓝牙',
          '未连接': '未连接',
          '型号': '型号',
          '已连接': '已连接',
          '电压': '电压',
          '电流': '电流',
          '功率': '功率',
          '温度': '温度',
          '剩余能量': '剩余能量',
          '剩余容量': '剩余容量',
          '充满需用时:': '充满需用时:',
          '电流清零': '电流清零',
          '数据清零': '数据清零',
          '余量设定': '余量设定',
          '请输入电池余量': '请输入电池余量',
          '请先连接蓝牙': '请先连接蓝牙',
          '提示': '提示',
          '数值范围': '数值范围',
          '单位': '单位',
          '容量预设': '容量预设',
          '请输入电池容量': '请输入电池容量',
          '累计容量': '累计容量',
          '运行时间': '运行时间',
          '充电': '充电',
          '放电': '放电',
          '定时': '定时',
          '启动记录': '启动记录',
          '导出数据': '导出数据',
          '查看历史数据': '查看历史数据',
          '电压/温度/电流 实时曲线图': '电压/温度/电流 实时曲线图',
          '保存设置': '保存设置',
          "充电过压值": "充电过压值",
          "放电欠压值": "放电欠压值",
          "充电过流值": "充电过流值",
          "放电过流值": "放电过流值",
          "放电启动值": "放电启动值",
          "过温度保护值": "过温度保护值",
          "低温恢复值": "低温恢复值",
          "继电器延时": "继电器延时",
          "继电器工作模式": "继电器工作模式",
          "上电默认输出": "上电默认输出",
          "温度控制": "温度控制",
          "语言": "语言",
          "定时时间值": "定时时间值",
          "定时模式": "定时模式",
          "充电电流系数微调": "充电电流系数微调",
          "放电电流系数微调": "放电电流系数微调",
          "通讯地址码": "通讯地址码",
          "电流归零值": "电流归零值",
          "请输入充电过压值": "请输入充电过压值",
          "请输入放电欠压值": "请输入放电欠压值",
          "请输入充电过流值": "请输入充电过流值",
          "请输入放电过流值": "请输入放电过流值",
          "请输入放电启动值": "请输入放电启动值",
          "请输入过温度保护值": "请输入过温度保护值",
          "请输入低温恢复值": "请输入低温恢复值",
          "请输入继电器延时": "请输入继电器延时",
          "请选择继电器工作模式": "请选择继电器工作模式",
          "请输入上电默认输出": "请输入上电默认输出",
          "请选择温度模式": "请选择温度模式",
          "请选择语言": "请选择语言",
          "请输入定时时间值": "请输入定时时间值",
          "请选择定时模式": "请选择定时模式",
          "请输入充电电流系数微调": "请输入充电电流系数微调",
          "请输入放电电流系数微调": "请输入放电电流系数微调",
          "请输入通讯地址码": "请输入通讯地址码",
          "请输入电流归零值": "请输入电流归零值",
          "选择语言": "选择语言",
          "确定": "确定",
          "取消": "取消",
          "确定电流清零吗？": "确定电流清零吗？",
          "确定数据清零吗？": "确定数据清零吗？",
        },
        'en_US': {
          '首页': 'Home',
          '曲线图': 'Chart',
          '设置': 'Setting',
          '请打开蓝牙': 'Please turn on Bluetooth',
          '未连接': 'Not connected',
          '型号': 'Model',
          '已连接': 'Connected',
          '电压': 'Voltage',
          '电流': 'Current',
          '功率': 'Power',
          '温度': 'Temperature',
          '剩余能量': 'Remaining energy',
          '剩余容量': 'Remaining capacity',
          '充满需用时:': 'Full time:',
          '电流清零': 'Current clear',
          '数据清零': 'Data clear',
          '余量设定': 'Residual quantity setting',
          '请输入电池余量': 'Please enter the battery residual quantity',
          '请先连接蓝牙': 'Please connect Bluetooth first',
          '提示': 'Prompt',
          '数值范围': 'Value range',
          '单位': 'Unit',
          '容量预设': 'Capacity preset',
          '请输入电池容量': 'Please enter the battery capacity',
          '累计容量': 'Cumulative capacity',
          '运行时间': 'Running time',
          '充电': 'Charge',
          '放电': 'Discharge',
          '定时': 'Timing',
          '启动记录': 'Start record',
          '导出数据': 'Export data',
          '查看历史数据': 'View historical data',
          '电压/温度/电流 实时曲线图': 'Voltage/temperature/current real-time curve',
          '保存设置': 'Save settings',
          "充电过压值": "Overvoltage value during charging",
          "放电欠压值": "Undervoltage value during discharge",
          "充电过流值": "Overcurrent value during charging",
          "放电过流值": "Overcurrent value during discharge",
          "放电启动值": "Discharge start value",
          "过温度保护值": "Overtemperature protection value",
          "低温恢复值": "Low temperature recovery value",
          "继电器延时": "Relay delay",
          "继电器工作模式": "Relay working mode",
          "上电默认输出": "Default output on power up",
          "温度控制": "Temperature control",
          "语言": "Language",
          "定时时间值": "Timing value",
          "定时模式": "Timing mode",
          "充电电流系数微调": "Charging current coefficient fine-tuning",
          "放电电流系数微调": "Discharging current coefficient fine-tuning",
          "通讯地址码": "Communication address code",
          "电流归零值": "Current zero value",
          "请输入充电过压值": "Please enter the overvoltage value for charging",
          "请输入放电欠压值": "Please enter the undervoltage value for discharging",
          "请输入充电过流值": "Please enter the overcurrent value for charging",
          "请输入放电过流值": "Please enter the overcurrent value for discharging",
          "请输入放电启动值": "Please enter the starting value for discharging",
          "请输入过温度保护值": "Please enter the over-temperature protection value",
          "请输入低温恢复值": "Please enter the low temperature recovery value",
          "请输入继电器延时": "Please enter the relay delay time",
          "请选择继电器工作模式": "Please select the working mode of the relay",
          "请输入上电默认输出": "Please enter the default output after power-on",
          "请选择温度模式": "Please select the temperature mode",
          "请选择语言": "Please select a language",
          "请输入定时时间值": "Please enter the timing value",
          "请选择定时模式": "Please select the timing mode",
          "请输入充电电流系数微调":
              "Please enter the charging current coefficient fine-tuning",
          "请输入放电电流系数微调":
              "Please enter the discharging current coefficient fine-tuning",
          "请输入通讯地址码": "Please enter the communication address code",
          "请输入电流归零值": "Please enter the current zero value",
          "选择语言": "Select language",
          "确定": "Confirm",
          "取消": "Cancel"
        }
      };
}
