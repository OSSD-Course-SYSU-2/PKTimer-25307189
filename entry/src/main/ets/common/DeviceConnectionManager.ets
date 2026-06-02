import { hilog } from '@kit.PerformanceAnalysisKit'

export interface DeviceInfo {
  deviceId: string
  deviceName: string
  deviceType: string
  deviceState: DeviceState
  networkId: string
}

export enum DeviceState {
  UNKNOWN = 'unknown',
  ONLINE = 'online',
  OFFLINE = 'offline'
}

export type DeviceDiscoveryCallback = (devices: DeviceInfo[]) => void
export type DeviceStateChangeCallback = (device: DeviceInfo) => void

@ObservedV2
export class DeviceConnectionManager {
  private static instance: DeviceConnectionManager | null = null
  @Trace private discoveredDevices: DeviceInfo[] = []
  @Trace private isDiscovering: boolean = false
  private discoveryCallback: DeviceDiscoveryCallback | null = null
  private stateChangeCallback: DeviceStateChangeCallback | null = null
  
  private constructor() {}
  
  static getInstance(): DeviceConnectionManager {
    if (!DeviceConnectionManager.instance) {
      DeviceConnectionManager.instance = new DeviceConnectionManager()
    }
    return DeviceConnectionManager.instance
  }
  
  async initialize(): Promise<boolean> {
    try {
      hilog.info(0x0000, 'DeviceConnection', 'Device connection manager initialized')
      return true
    } catch (error) {
      hilog.error(0x0000, 'DeviceConnection', 'Failed to initialize: %{public}s', JSON.stringify(error))
      return false
    }
  }
  
  async startDeviceDiscovery(): Promise<boolean> {
    if (this.isDiscovering) {
      return false
    }
    
    try {
      this.isDiscovering = true
      hilog.info(0x0000, 'DeviceConnection', 'Device discovery started')
      return true
    } catch (error) {
      hilog.error(0x0000, 'DeviceConnection', 'Failed to start discovery: %{public}s', JSON.stringify(error))
      return false
    }
  }
  
  async stopDeviceDiscovery(): Promise<boolean> {
    if (!this.isDiscovering) {
      return false
    }
    
    try {
      this.isDiscovering = false
      hilog.info(0x0000, 'DeviceConnection', 'Device discovery stopped')
      return true
    } catch (error) {
      hilog.error(0x0000, 'DeviceConnection', 'Failed to stop discovery: %{public}s', JSON.stringify(error))
      return false
    }
  }
  
  getDiscoveredDevices(): DeviceInfo[] {
    return this.discoveredDevices
  }
  
  isDiscoveryActive(): boolean {
    return this.isDiscovering
  }
  
  setDeviceDiscoveryCallback(callback: DeviceDiscoveryCallback): void {
    this.discoveryCallback = callback
  }
  
  setDeviceStateChangeCallback(callback: DeviceStateChangeCallback): void {
    this.stateChangeCallback = callback
  }
  
  async release(): Promise<void> {
    this.isDiscovering = false
    hilog.info(0x0000, 'DeviceConnection', 'Device connection manager released')
  }
}
