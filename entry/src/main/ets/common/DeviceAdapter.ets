import { display } from '@kit.ArkUI'

export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  TV = 'tv',
  WEARABLE = 'wearable',
  CAR = 'car'
}

export interface DeviceConfig {
  type: DeviceType
  screenWidth: number
  screenHeight: number
  density: number
  isLandscape: boolean
}

export interface LayoutConfig {
  timerHeight: string | number
  timerFontSize: number
  buttonHeight: number
  buttonFontSize: number
  padding: number
  spacing: number
  columns: number
  showDetailedStats: boolean
  navigationMode: 'stack' | 'tabs'
}

@ObservedV2
export class DeviceAdapter {
  @Trace private static currentDevice: DeviceType = DeviceType.PHONE
  @Trace private static screenWidth: number = 360
  @Trace private static screenHeight: number = 640
  @Trace private static density: number = 1.0

  static readonly BREAKPOINT_SM: number = 320
  static readonly BREAKPOINT_MD: number = 600
  static readonly BREAKPOINT_LG: number = 840
  static readonly BREAKPOINT_XL: number = 1024

  static initialize(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync()
      DeviceAdapter.screenWidth = displayInfo.width / displayInfo.densityPixels
      DeviceAdapter.screenHeight = displayInfo.height / displayInfo.densityPixels
      DeviceAdapter.density = displayInfo.densityPixels
      DeviceAdapter.currentDevice = DeviceAdapter.detectDeviceType()
    } catch (error) {
      console.error('DeviceAdapter initialization failed:', error)
    }
  }

  private static detectDeviceType(): DeviceType {
    const width = DeviceAdapter.screenWidth
    const height = DeviceAdapter.screenHeight
    const minDimension = Math.min(width, height)
    const maxDimension = Math.max(width, height)

    if (minDimension < 200) {
      return DeviceType.WEARABLE
    }
    
    if (maxDimension >= 1200 && minDimension >= 800) {
      return DeviceType.TABLET
    }
    
    if (width >= 960 && height >= 540) {
      return DeviceType.TV
    }
    
    if (width >= 800 && height >= 480) {
      return DeviceType.CAR
    }
    
    return DeviceType.PHONE
  }

  static getDeviceType(): DeviceType {
    return DeviceAdapter.currentDevice
  }

  static getScreenWidth(): number {
    return DeviceAdapter.screenWidth
  }

  static getScreenHeight(): number {
    return DeviceAdapter.screenHeight
  }

  static getDensity(): number {
    return DeviceAdapter.density
  }

  static isLandscape(): boolean {
    return DeviceAdapter.screenWidth > DeviceAdapter.screenHeight
  }

  static getLayoutConfig(): LayoutConfig {
    const deviceType = DeviceAdapter.getDeviceType()
    const width = DeviceAdapter.getScreenWidth()
    
    switch (deviceType) {
      case DeviceType.WEARABLE:
        return {
          timerHeight: '45%',
          timerFontSize: 32,
          buttonHeight: 28,
          buttonFontSize: 10,
          padding: 8,
          spacing: 6,
          columns: 1,
          showDetailedStats: false,
          navigationMode: 'stack'
        }
        
      case DeviceType.TABLET:
        return {
          timerHeight: width > 900 ? '50%' : '45%',
          timerFontSize: 72,
          buttonHeight: 48,
          buttonFontSize: 16,
          padding: 24,
          spacing: 16,
          columns: width > 900 ? 3 : 2,
          showDetailedStats: true,
          navigationMode: 'tabs'
        }
        
      case DeviceType.TV:
        return {
          timerHeight: '50%',
          timerFontSize: 96,
          buttonHeight: 56,
          buttonFontSize: 18,
          padding: 32,
          spacing: 20,
          columns: 3,
          showDetailedStats: true,
          navigationMode: 'tabs'
        }
        
      case DeviceType.CAR:
        return {
          timerHeight: '40%',
          timerFontSize: 56,
          buttonHeight: 52,
          buttonFontSize: 16,
          padding: 20,
          spacing: 12,
          columns: 2,
          showDetailedStats: false,
          navigationMode: 'stack'
        }
        
      case DeviceType.PHONE:
      default:
        return {
          timerHeight: '50%',
          timerFontSize: 48,
          buttonHeight: 32,
          buttonFontSize: 14,
          padding: 16,
          spacing: 12,
          columns: 1,
          showDetailedStats: true,
          navigationMode: 'stack'
        }
    }
  }

  static getBreakpoint(): 'sm' | 'md' | 'lg' | 'xl' {
    const width = DeviceAdapter.getScreenWidth()
    
    if (width < DeviceAdapter.BREAKPOINT_MD) {
      return 'sm'
    } else if (width < DeviceAdapter.BREAKPOINT_LG) {
      return 'md'
    } else if (width < DeviceAdapter.BREAKPOINT_XL) {
      return 'lg'
    } else {
      return 'xl'
    }
  }

  static scaleValue(baseValue: number): number {
    const deviceType = DeviceAdapter.getDeviceType()
    let scaleFactor = 1.0
    
    switch (deviceType) {
      case DeviceType.WEARABLE:
        scaleFactor = 0.6
        break
      case DeviceType.TABLET:
        scaleFactor = 1.3
        break
      case DeviceType.TV:
        scaleFactor = 1.5
        break
      case DeviceType.CAR:
        scaleFactor = 1.2
        break
      default:
        scaleFactor = 1.0
    }
    
    return baseValue * scaleFactor
  }

  static shouldUseCompactLayout(): boolean {
    const deviceType = DeviceAdapter.getDeviceType()
    return deviceType === DeviceType.WEARABLE || deviceType === DeviceType.PHONE
  }

  static shouldShowBottomControls(): boolean {
    return true
  }

  static getMaxContentWidth(): number {
    const deviceType = DeviceAdapter.getDeviceType()
    const screenWidth = DeviceAdapter.getScreenWidth()
    
    switch (deviceType) {
      case DeviceType.TABLET:
        return screenWidth
      case DeviceType.TV:
        return screenWidth
      case DeviceType.CAR:
        return screenWidth
      default:
        return screenWidth
    }
  }
}