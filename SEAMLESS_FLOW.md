# PK Timer - 自由流转功能

## 概述

PK Timer 支持 HarmonyOS **自由流转**功能，实现应用在不同设备间的无缝迁移和协同。用户可以在多个设备间自由切换，享受连续一致的使用体验。

## 核心能力

### 1. 设备发现
- 自动发现同一网络下的 HarmonyOS 设备
- 实时显示设备在线/离线状态
- 支持多种设备类型识别（手机、平板、TV、手表、车机）

### 2. 状态迁移
- 完整的应用状态保存和恢复
- 计时器状态实时同步
- 比分和统计数据无缝迁移
- 个性化配置自动同步

### 3. 流转控制
- 一键流转到目标设备
- 流转状态实时反馈
- 支持拉回操作
- 流转历史记录

## 技术架构

### 1. 分布式数据管理

**文件：** `entry/src/main/ets/common/DistributedDataManager.ets`

**功能：**
- 基于 HarmonyOS 分布式键值存储（KV Store）
- 自动跨设备数据同步
- 数据变更监听
- 支持加密和安全级别配置

**核心接口：**
```typescript
// 初始化分布式数据管理
await distributedDataManager.initialize()

// 保存应用状态
await distributedDataManager.saveAppState(state)

// 加载应用状态
const state = await distributedDataManager.loadAppState()

// 注册数据变更监听
distributedDataManager.registerDataChangeListener(callback)
```

### 2. 设备连接管理

**文件：** `entry/src/main/ets/common/DeviceConnectionManager.ets`

**功能：**
- 设备发现和扫描
- 设备状态管理
- 设备连接维护
- 设备信息获取

**核心接口：**
```typescript
// 初始化设备连接管理
await deviceConnectionManager.initialize()

// 开始设备发现
await deviceConnectionManager.startDeviceDiscovery()

// 停止设备发现
await deviceConnectionManager.stopDeviceDiscovery()

// 获取发现的设备列表
const devices = deviceConnectionManager.getDiscoveredDevices()
```

### 3. 迁移管理

**文件：** `entry/src/main/ets/common/MigrationManager.ets`

**功能：**
- 应用状态迁移
- 流转操作管理
- 迁移历史记录
- 回调和通知

**核心接口：**
```typescript
// 初始化迁移管理
await migrationManager.initialize()

// 迁移到目标设备
await migrationManager.migrateToDevice(deviceId, state)

// 继续到远程设备
await migrationManager.continueToRemoteDevice(deviceId, state)

// 从远程设备拉回
const state = await migrationManager.recallFromRemoteDevice()
```

### 4. 流转控制 UI

**文件：** `entry/src/main/ets/common/FlowControl.ets`

**功能：**
- 设备列表展示
- 流转操作按钮
- 流转状态提示
- 设备图标显示

## 使用指南

### 1. 启用流转功能

应用启动时会自动初始化流转功能，无需手动配置。

### 2. 发现设备

1. 点击底部控制栏的**设备图标** 📱
2. 系统开始扫描附近的 HarmonyOS 设备
3. 发现的设备会显示在设备列表中

### 3. 流转到其他设备

1. 在设备列表中选择目标设备
2. 点击**"流转"**按钮
3. 等待流转完成提示
4. 应用将自动在目标设备上打开并恢复状态

### 4. 拉回操作

如需将应用从其他设备拉回当前设备：
1. 点击设备图标
2. 选择原设备
3. 点击流转按钮完成拉回

## 流转状态说明

| 状态 | 说明 |
|------|------|
| 正在发现设备... | 设备扫描进行中 |
| 流转成功 | 应用已成功迁移到目标设备 |
| 拉回成功 | 应用已从远程设备拉回 |
| 流转失败 | 迁移过程中出现错误 |
| 离线 | 目标设备不在线 |

## 应用状态同步

### 同步内容

流转时会自动同步以下数据：

**计时器状态：**
- 当前计时时间
- 运行状态（运行中/已停止）
- 历史成绩列表
- MO3、AO5 统计数据
- 个人最佳、最差成绩
- 平均成绩、标准差

**比分数据：**
- P1 胜场数
- P2 胜场数
- 平局次数
- 最后获胜者
- 比赛历史记录

**应用配置：**
- 选手名称
- 选手颜色
- 深色/浅色模式

### 数据一致性

- 使用分布式键值存储保证数据一致性
- 自动冲突解决
- 实时同步更新

## 权限配置

应用已配置以下分布式权限：

```json5
"requestPermissions": [
  {
    "name": "ohos.permission.DISTRIBUTED_DATASYNC"
  },
  {
    "name": "ohos.permission.GET_DISTRIBUTED_DEVICE_INFO"
  },
  {
    "name": "ohos.permission.ACCESS_SERVICE_DM"
  }
]
```

**权限说明：**
- `DISTRIBUTED_DATASYNC` - 分布式数据同步权限
- `GET_DISTRIBUTED_DEVICE_INFO` - 获取分布式设备信息权限
- `ACCESS_SERVICE_DM` - 访问设备管理服务权限

## Ability 生命周期

### 分布式相关回调

```typescript
// Ability 创建时初始化迁移管理
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
  MigrationManager.getInstance().initialize()
}

// 继续到远程设备
onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
  return AbilityConstant.OnContinueResult.AGREE
}

// 保存状态
onSaveState(reason: AbilityConstant.StateType, wantParam: Record<string, Object>): AbilityConstant.AbilityResult {
  return AbilityConstant.AbilityResult.SUCCESS
}

// 恢复状态
onRestoreState(want: Want, stateData: AbilityConstant.StateData, restoreParam: AbilityConstant.RestoreParam): void {
  // 恢复应用状态
}

// Ability 销毁时释放资源
onDestroy(): void {
  MigrationManager.getInstance().release()
}
```

## 使用场景

### 场景1：手机到平板

1. 在手机上进行计时比赛
2. 发现平板设备并流转
3. 在平板上继续查看统计数据（大屏优势）

### 场景2：平板到电视

1. 在平板上完成多场比赛
2. 流转到电视设备
3. 在大屏电视上展示比赛结果

### 场景3：手机到手表

1. 手机上进行计时设置
2. 流转到手表
3. 在手表上快速查看计时结果

### 场景4：车机使用

1. 在手机上配置好应用
2. 上车后流转到车机
3. 在车机上使用大按钮操作（驾驶安全）

## 技术细节

### 1. 数据存储

使用 HarmonyOS 分布式键值存储（SingleKVStore）：
- 存储ID：`PktimerDistributedStore`
- 存储类型：单版本（SINGLE_VERSION）
- 安全级别：S1
- 自动同步：启用

### 2. 设备发现

使用 HarmonyOS 设备管理服务：
- 发现模式：主动发现（DISCOVER_MODE_ACTIVE）
- 传输介质：自动（AUTO）
- 发现频率：中频（MID）
- 能力：ddmpCapability

### 3. 状态序列化

应用状态使用 JSON 序列化：
```typescript
interface AppState {
  timer1: TimerState
  timer2: TimerState
  score: ScoreState
  appConfig: AppConfigState
  timestamp: number
}
```

## 注意事项

### 1. 网络要求
- 所有设备需在同一局域网
- 建议使用 Wi-Fi 连接
- 确保网络稳定

### 2. 设备要求
- 所有设备需登录同一华为账号
- 设备需支持 HarmonyOS 分布式能力
- 设备需开启分布式开关

### 3. 性能考虑
- 大量数据同步可能耗时
- 建议在数据稳定时进行流转
- 避免在计时过程中流转

### 4. 错误处理
- 流转失败时会显示错误信息
- 可重试流转操作
- 检查网络和设备状态

## 最佳实践

1. **流转时机**
   - 在比赛间隙进行流转
   - 避免在计时运行中流转
   - 数据稳定后流转效果最佳

2. **设备选择**
   - 根据场景选择合适设备
   - 大屏设备适合展示统计
   - 小屏设备适合快速操作

3. **数据管理**
   - 定期清理历史数据
   - 重要比赛后及时流转备份
   - 合理使用重置功能

## 更新日志

### v1.0.0 (2026-06-02)
- ✅ 实现分布式数据管理
- ✅ 实现设备发现和连接
- ✅ 实现应用状态迁移
- ✅ 创建流转控制 UI
- ✅ 配置分布式权限
- ✅ 集成到主页面

## 相关文档

- [多端部署文档](./MULTI_DEVICE_DEPLOYMENT.md)
- [项目说明文档](./README.md)