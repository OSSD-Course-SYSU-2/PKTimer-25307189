import { DeviceAdapter, DeviceType } from './DeviceAdapter'

export interface ResponsiveValueConfig {
  sm: number
  md: number
  lg: number
  xl: number
}

@ObservedV2
export class ResponsiveLayoutManager {
  @Trace private static isInitialized: boolean = false

  static initialize(): void {
    if (!ResponsiveLayoutManager.isInitialized) {
      DeviceAdapter.initialize()
      ResponsiveLayoutManager.isInitialized = true
    }
  }

  static getResponsiveValue(config: ResponsiveValueConfig): number {
    const breakpoint = DeviceAdapter.getBreakpoint()
    if (breakpoint === 'sm') {
      return config.sm
    } else if (breakpoint === 'md') {
      return config.md
    } else if (breakpoint === 'lg') {
      return config.lg
    } else {
      return config.xl
    }
  }

  static getDeviceSpecificValue(
    phoneValue: number,
    tabletValue: number,
    tvValue: number,
    wearableValue: number,
    carValue: number
  ): number {
    const deviceType = DeviceAdapter.getDeviceType()
    switch (deviceType) {
      case DeviceType.PHONE:
        return phoneValue
      case DeviceType.TABLET:
        return tabletValue
      case DeviceType.TV:
        return tvValue
      case DeviceType.WEARABLE:
        return wearableValue
      case DeviceType.CAR:
        return carValue
      default:
        return phoneValue
    }
  }
}
