import { DeviceConnectionManager, DeviceInfo, DeviceState } from './DeviceConnectionManager'
import { MigrationManager, MigrationType } from './MigrationManager'
import { AppConfig } from './AppConfig'
import { hilog } from '@kit.PerformanceAnalysisKit'

@ComponentV2
export struct FlowControl {
  @Local showDeviceList: boolean = false
  @Local devices: DeviceInfo[] = []
  @Local isDiscovering: boolean = false
  @Local migrationStatus: string = ''
  
  private deviceConnectionManager: DeviceConnectionManager = DeviceConnectionManager.getInstance()
  private migrationManager: MigrationManager = MigrationManager.getInstance()
  
  aboutToAppear(): void {
    this.deviceConnectionManager.setDeviceDiscoveryCallback((devices: DeviceInfo[]) => {
      this.devices = devices
    })
    
    this.migrationManager.setMigrationCompleteCallback((result) => {
      if (result.success) {
        if (result.migrationType === MigrationType.MIGRATE) {
          this.migrationStatus = '流转成功'
        } else if (result.migrationType === MigrationType.RECALL) {
          this.migrationStatus = '拉回成功'
        }
      } else {
        this.migrationStatus = '流转失败: ' + (result.error ?? '未知错误')
      }
    })
  }
  
  build() {
    Column() {
      Row({ space: 8 }) {
        Button({ type: ButtonType.Circle }) {
          Text('📱')
            .fontSize(20)
        }
        .width(36)
        .height(36)
        .backgroundColor(AppConfig.getTheme().cardBackground)
        .onClick(() => {
          this.toggleDeviceDiscovery()
        })
        
        if (this.isDiscovering) {
          LoadingProgress()
            .width(20)
            .height(20)
            .color(AppConfig.getTheme().textPrimary)
        }
        
        if (this.migrationStatus) {
          Text(this.migrationStatus)
            .fontSize(12)
            .fontColor('#4CAF50')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      
      if (this.showDeviceList && this.devices.length > 0) {
        this.DeviceListPanel()
      }
      
      if (this.showDeviceList && this.devices.length === 0 && this.isDiscovering) {
        Row() {
          LoadingProgress()
            .width(16)
            .height(16)
            .color(AppConfig.getTheme().textSecondary)
          Text('正在发现设备...')
            .fontSize(12)
            .fontColor(AppConfig.getTheme().textSecondary)
        }
        .width('100%')
        .margin({ top: 8 })
      }
    }
    .width('100%')
  }
  
  @Builder
  DeviceListPanel() {
    Column({ space: 8 }) {
      Text('可流转设备')
        .fontSize(14)
        .fontWeight(600)
        .fontColor(AppConfig.getTheme().textPrimary)
        .width('100%')
      
      ForEach(this.devices, (device: DeviceInfo) => {
        this.DeviceItem(device)
      }, (device: DeviceInfo) => device.deviceId)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppConfig.getTheme().cardBackground)
    .borderRadius(8)
    .margin({ top: 8 })
  }
  
  @Builder
  DeviceItem(device: DeviceInfo) {
    Row({ space: 12 }) {
      Text(this.getDeviceIcon(device.deviceType))
        .fontSize(24)
      
      Column({ space: 4 }) {
        Text(device.deviceName)
          .fontSize(14)
          .fontWeight(500)
          .fontColor(AppConfig.getTheme().textPrimary)
        
        Text(this.getDeviceTypeText(device.deviceType))
          .fontSize(12)
          .fontColor(AppConfig.getTheme().textSecondary)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      if (device.deviceState === DeviceState.ONLINE) {
        Button('流转')
          .height(28)
          .fontSize(12)
          .backgroundColor('#2196F3')
          .onClick(() => {
            this.migrateToDevice(device)
          })
      } else {
        Text('离线')
          .fontSize(12)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .padding(8)
    .backgroundColor(AppConfig.getTheme().background)
    .borderRadius(6)
  }
  
  private async toggleDeviceDiscovery(): Promise<void> {
    if (this.isDiscovering) {
      await this.deviceConnectionManager.stopDeviceDiscovery()
      this.isDiscovering = false
      this.showDeviceList = false
    } else {
      const success = await this.deviceConnectionManager.startDeviceDiscovery()
      if (success) {
        this.isDiscovering = true
        this.showDeviceList = true
        this.migrationStatus = ''
      }
    }
  }
  
  private async migrateToDevice(device: DeviceInfo): Promise<void> {
    this.migrationStatus = '正在流转...'
    
    hilog.info(0x0000, 'FlowControl', 'Starting migration to device: %{public}s', device.deviceName)
    
    this.showDeviceList = false
    await this.deviceConnectionManager.stopDeviceDiscovery()
    this.isDiscovering = false
  }
  
  private getDeviceIcon(deviceType: string): string {
    if (deviceType === '00' || deviceType === 'phone') {
      return '📱'
    } else if (deviceType === '01' || deviceType === 'tablet') {
      return '📟'
    } else if (deviceType === '02' || deviceType === 'tv') {
      return '📺'
    } else if (deviceType === '03' || deviceType === 'wearable') {
      return '⌚'
    } else if (deviceType === '04' || deviceType === 'car') {
      return '🚗'
    } else {
      return '📱'
    }
  }
  
  private getDeviceTypeText(deviceType: string): string {
    if (deviceType === '00' || deviceType === 'phone') {
      return '手机'
    } else if (deviceType === '01' || deviceType === 'tablet') {
      return '平板'
    } else if (deviceType === '02' || deviceType === 'tv') {
      return '电视'
    } else if (deviceType === '03' || deviceType === 'wearable') {
      return '手表'
    } else if (deviceType === '04' || deviceType === 'car') {
      return '车机'
    } else {
      return '未知设备'
    }
  }
}
