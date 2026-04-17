# PK Timer

一个基于HarmonyOS开发的PK计时器应用，支持双人竞技计时功能。

## 项目简介

PK Timer是一个专为竞技场景设计的计时器应用，将屏幕分为上下两个区域，分别用于两位选手（P1和P2）的计时。应用会自动比较两位选手的用时，用时较少者将被标记为胜者，并实时显示比赛统计数据。

## 功能特性

- **双人竞技计时**：屏幕上下分区，分别控制P1和P2的计时器
- **实时统计**：
  - MO3（Mean of 3）：最近3次成绩的平均值（去掉最好和最差成绩）
  - AO5（Average of 5）：最近5次成绩的平均值（去掉最好和最差成绩）
- **胜负判定**：自动比较两位选手的用时，判定胜者
- **比分统计**：实时记录P1胜场、P2胜场和平局次数
- **胜利展示**：获胜者区域会显示庆祝动画（🎉 WINNER!）
- **一键重置**：支持重置所有计时器和比分数据

## 技术栈

- **开发语言**：ArkTS
- **开发框架**：ArkUI
- **运行平台**：HarmonyOS
- **最小SDK版本**：6.0.2(22)
- **目标SDK版本**：6.0.2(22)

## 项目结构

```
PKTimer/
├── AppScope/                    # 应用全局配置
│   ├── app.json5               # 应用配置文件
│   └── resources/              # 应用全局资源文件
├── entry/                      # 主模块
│   ├── src/
│   │   └── main/
│   │       ├── ets/
│   │       │   ├── entryability/
│   │       │   │   └── EntryAbility.ets          # 应用入口
│   │       │   ├── entrybackupability/
│   │       │   │   └── EntryBackupAbility.ets    # 应用备份扩展能力
│   │       │   └── pages/
│   │       │       ├── Index.ets                 # 主页面
│   │       │       └── Home.ets                  # 计时器组件和逻辑
│   │       ├── resources/                         # 模块资源文件
│   │       │   └── base/
│   │       │       ├── element/                  # 字符串、颜色等资源
│   │       │       ├── media/                    # 媒体资源
│   │       │       └── profile/                  # 配置文件
│   │       └── module.json5                       # 模块配置文件
│   ├── build-profile.json5    # 模块构建配置
│   ├── hvigorfile.ts          # 模块编译配置
│   └── oh-package.json5       # 模块依赖配置
├── build-profile.json5         # 应用构建配置
├── hvigorfile.ts              # 应用编译配置
├── hvigor/                    # 编译配置文件
├── code-linter.json5          # 代码规范配置
└── oh-package.json5           # 依赖配置
```

## 核心文件说明

### 1. EntryAbility.ets
应用的入口文件，负责加载主页面 `pages/Index`。

### 2. Index.ets
主页面组件，包含：
- 两个计时器实例（P1和P2）
- 分数统计实例
- UI布局：上下分区的计时器显示和底部的比分统计与重置按钮

### 3. Home.ets
核心业务逻辑文件，包含：

#### Timer 类
计时器核心类，提供以下功能：
- `start()`: 开始计时
- `stop()`: 停止计时并记录成绩
- `reset()`: 重置计时器
- `updateStatistics()`: 更新MO3和AO5统计数据
- `calculateAverage()`: 计算平均值（去掉最大值和最小值）

#### Score 类
比分统计类，记录：
- P1胜场数
- P2胜场数
- 平局次数
- 最后获胜者

#### TopTimer 和 BottomTimer 组件
- P1和P2的计时器UI组件
- 点击交互：点击区域开始/停止计时
- 显示当前时间、MO3、AO5
- 获胜时显示庆祝动画

## 使用说明

### 计时操作
1. **开始计时**：点击P1或P2区域开始该选手的计时
2. **停止计时**：再次点击正在计时的区域停止计时
3. **胜负判定**：当两位选手都完成计时时，系统自动比较用时并判定胜者

### 比分统计
- 底部显示当前比分：P1胜场、P2胜场、平局次数
- 获胜者区域会显示 🎉 WINNER! 动画

### 重置功能
- 点击底部的"Reset"按钮可重置所有计时器、统计数据和比分

## 构建与运行

### 环境要求
- DevEco Studio 5.0.0 Release
- HarmonyOS SDK API 12及以上

### 构建步骤
1. 使用DevEco Studio打开项目
2. 等待依赖自动下载完成
3. 连接HarmonyOS设备或启动模拟器
4. 点击Run按钮运行应用

## 依赖项

```json5
{
  "devDependencies": {
    "@ohos/hypium": "1.0.25",
    "@ohos/hamock": "1.0.0"
  }
}
```

## 测试

项目包含以下测试文件：
- `entry/src/test/LocalUnit.test.ets` - 本地单元测试
- `entry/src/ohosTest/ets/test/Ability.test.ets` - UI测试
