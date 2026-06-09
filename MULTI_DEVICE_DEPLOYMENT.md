# PK Timer - 一次开发，多端部署

## 概述

PK Timer 现已支持 **一次开发，多端部署**，可在以下 HarmonyOS 设备上运行：

- 📱 **手机** (Phone)
- 📟 **平板** (Tablet)
- 📺 **电视** (TV)
- ⌚ **手表** (Wearable)
- 🚗 **车机** (Car)

## 架构设计

### 1. 设备适配层

核心文件：`entry/src/main/ets/common/DeviceAdapter.ets`

提供以下功能：
- 自动检测设备类型
- 获取屏幕尺寸和密度
- 提供响应式布局配置
- 设备特定的尺寸缩放

```typescript
// 设备类型枚举
enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  TV = 'tv',
  WEARABLE = 'wearable',
  CAR = 'car'
}

// 获取当前设备类型
const deviceType = DeviceAdapter.getDeviceType()

// 获取布局配置
const layoutConfig = DeviceAdapter.getLayoutConfig()
```

### 2. 响应式布局系统

核心文件：`entry/src/main/ets/common/ResponsiveLayout.ets`

提供以下组件：
- `ResponsiveContainer` - 响应式容器组件
- `ResponsiveGrid` - 响应式网格布局
- `ResponsiveLayoutManager` - 布局管理器

### 3. 多设备资源配置

资源目录结构：
```
resources/
├── base/           # 默认资源（手机）
├── tablet/         # 平板资源
│   └── element/
│       └── float.json
├── tv/             # 电视资源
│   └── element/
│       └── float.json
└── wearable/       # 手表资源
    └── element/
        └── float.json
```

## 设备特性适配

| 设备 | 屏幕尺寸 | 字体大小 | 按钮高度 | 布局模式 | 统计详情 |
|------|----------|----------|----------|----------|----------|
| Phone | 360×640 | 48fp | 32vp | 上下堆叠 | 完整显示 |
| Tablet | 800×1200 | 72fp | 48vp | **左右并排** | 完整显示 |
| TV | 960×540 | 96fp | 56vp | **左右并排** | 完整显示 |
| Wearable | 200×200 | 32fp | 28vp | 上下堆叠 | 简化显示 |
| Car | 800×480 | 56fp | 52vp | 上下堆叠 | 简化显示 |

**布局说明：**
- **手机/手表/车机**：上下堆叠布局，P1在上，P2在下
- **平板/电视**：左右并排布局，P1在左，P2在右，充分利用大屏空间

## 构建和部署

### 1. 构建配置

项目支持多设备构建目标：

```json5
// build-profile.json5
{
  "app": {
    "products": [
      { "name": "phone", ... },
      { "name": "tablet", ... },
      { "name": "tv", ... },
      { "name": "wearable", ... },
      { "name": "car", ... }
    ]
  }
}
```

### 2. 构建命令

在 DevEco Studio 中：

1. **选择构建目标**
   - 打开 `Build` → `Select Build Target`
   - 选择目标设备类型（phone、tablet、tv、wearable、car）

2. **构建 HAP**
   ```
   Build → Make Module 'entry'
   ```

3. **运行应用**
   - 选择对应设备类型的模拟器或真机
   - 点击运行按钮

### 3. 多设备打包

生成多设备 HAP 包：

```bash
hvigorw assembleHap --mode module -p product=phone
hvigorw assembleHap --mode module -p product=tablet
hvigorw assembleHap --mode module -p product=tv
hvigorw assembleHap --mode module -p product=wearable
hvigorw assembleHap --mode module -p product=car
```

## 使用指南

### 在代码中使用设备适配

```typescript
import { DeviceAdapter, DeviceType } from '../common/DeviceAdapter'

@ComponentV2
struct MyComponent {
  build() {
    Column() {
      // 获取设备特定的布局配置
      const config = DeviceAdapter.getLayoutConfig()
      
      Text('Hello')
        .fontSize(config.timerFontSize)
        .padding(config.padding)
      
      // 根据设备类型调整
      if (DeviceAdapter.getDeviceType() === DeviceType.TABLET) {
        // 平板特有布局
      }
    }
  }
}
```

### 使用响应式值

```typescript
import { ResponsiveLayoutManager } from '../common/ResponsiveLayout'

// 根据断点返回不同值
const fontSize = ResponsiveLayoutManager.getResponsiveValue({
  sm: 14,  // 小屏
  md: 16,  // 中屏
  lg: 18,  // 大屏
  xl: 20   // 超大屏
})

// 根据设备类型返回不同值
const columns = ResponsiveLayoutManager.getDeviceSpecificValue({
  [DeviceType.PHONE]: 1,
  [DeviceType.TABLET]: 2,
  [DeviceType.TV]: 3
}, 1)  // 默认值
```

## 设备特定功能

### Phone（手机）
- 完整功能支持
- Stack 导航模式
- 底部控制栏
- 完整统计面板

### Tablet（平板）
- 大屏优化布局
- Tabs 导航模式
- 更大的字体和按钮
- 多列网格布局

### TV（电视）
- 超大字体和按钮
- 适合远距离观看
- Tabs 导航模式
- 遥控器操作优化

### Wearable（手表）
- 精简界面
- 最小化按钮尺寸
- 简化统计信息
- 圆形屏幕适配

### Car（车机）
- 驾驶安全优化
- 大按钮易于点击
- 简化统计信息
- 横屏布局

## 最佳实践

1. **使用相对尺寸**
   - 使用 `vp` 和 `fp` 单位
   - 避免硬编码像素值

2. **使用设备适配器**
   - 通过 `DeviceAdapter` 获取配置
   - 不要直接判断屏幕尺寸

3. **资源限定符**
   - 为不同设备提供专用资源
   - 使用 HarmonyOS 资源系统

4. **测试多设备**
   - 在不同设备模拟器上测试
   - 验证布局和交互

## 注意事项

1. **性能优化**
   - 手表设备注意性能限制
   - 减少不必要的动画和特效

2. **交互适配**
   - TV 设备需要考虑遥控器操作
   - Car 设备需要考虑驾驶安全

3. **功能裁剪**
   - 小屏设备可简化功能
   - 根据设备能力调整特性

## 更新日志

### v1.0.0 (2026-06-02)
- ✅ 添加多设备支持（phone、tablet、tv、wearable、car）
- ✅ 实现设备适配层
- ✅ 创建响应式布局系统
- ✅ 添加多设备资源配置
- ✅ 更新页面组件支持响应式布局
- ✅ 配置多设备构建目标