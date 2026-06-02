import { hilog } from '@kit.PerformanceAnalysisKit'
import { DistributedDataManager, AppState } from './DistributedDataManager'
import { DeviceConnectionManager, DeviceInfo } from './DeviceConnectionManager'

export enum MigrationType {
  CONTINUE = 'continue',
  MIGRATE = 'migrate',
  RECALL = 'recall'
}

export interface MigrationResult {
  success: boolean
  deviceId: string
  migrationType: MigrationType
  timestamp: number
  error?: string
}

export type MigrationCompleteCallback = (result: MigrationResult) => void

@ObservedV2
export class MigrationManager {
  private static instance: MigrationManager | null = null
  private distributedDataManager: DistributedDataManager
  private deviceConnectionManager: DeviceConnectionManager
  @Trace private isMigrating: boolean = false
  @Trace private lastMigrationTime: number = 0
  @Trace private migrationHistory: MigrationResult[] = []
  private migrationCallback: MigrationCompleteCallback | null = null
  
  private constructor() {
    this.distributedDataManager = DistributedDataManager.getInstance()
    this.deviceConnectionManager = DeviceConnectionManager.getInstance()
  }
  
  static getInstance(): MigrationManager {
    if (!MigrationManager.instance) {
      MigrationManager.instance = new MigrationManager()
    }
    return MigrationManager.instance
  }
  
  async initialize(): Promise<boolean> {
    try {
      const dataManagerInit = await this.distributedDataManager.initialize()
      const connectionManagerInit = await this.deviceConnectionManager.initialize()
      
      if (dataManagerInit && connectionManagerInit) {
        hilog.info(0x0000, 'Migration', 'Migration manager initialized')
        return true
      }
      
      return false
    } catch (error) {
      hilog.error(0x0000, 'Migration', 'Failed to initialize: %{public}s', JSON.stringify(error))
      return false
    }
  }
  
  async prepareMigration(state: AppState): Promise<boolean> {
    if (this.isMigrating) {
      return false
    }
    
    this.isMigrating = true
    return true
  }
  
  async migrateToDevice(deviceId: string, state: AppState): Promise<MigrationResult> {
    if (this.isMigrating) {
      return {
        success: false,
        deviceId: deviceId,
        migrationType: MigrationType.MIGRATE,
        timestamp: Date.now(),
        error: 'Migration is already in progress'
      }
    }
    
    this.isMigrating = true
    
    const result: MigrationResult = {
      success: true,
      deviceId: deviceId,
      migrationType: MigrationType.MIGRATE,
      timestamp: Date.now()
    }
    
    this.lastMigrationTime = result.timestamp
    this.migrationHistory.push(result)
    
    if (this.migrationCallback) {
      this.migrationCallback(result)
    }
    
    hilog.info(0x0000, 'Migration', 'Migration to device %{public}s completed', deviceId)
    this.isMigrating = false
    return result
  }
  
  async continueToRemoteDevice(deviceId: string, state: AppState): Promise<MigrationResult> {
    return await this.migrateToDevice(deviceId, state)
  }
  
  async recallFromRemoteDevice(): Promise<AppState | null> {
    const state = await this.distributedDataManager.loadAppState()
    if (state) {
      const result: MigrationResult = {
        success: true,
        deviceId: 'local',
        migrationType: MigrationType.RECALL,
        timestamp: Date.now()
      }
      
      this.lastMigrationTime = result.timestamp
      this.migrationHistory.push(result)
      
      if (this.migrationCallback) {
        this.migrationCallback(result)
      }
    }
    return state
  }
  
  getMigrationHistory(): MigrationResult[] {
    return this.migrationHistory
  }
  
  getLastMigrationTime(): number {
    return this.lastMigrationTime
  }
  
  isMigrationInProgress(): boolean {
    return this.isMigrating
  }
  
  setMigrationCompleteCallback(callback: MigrationCompleteCallback): void {
    this.migrationCallback = callback
  }
  
  async release(): Promise<void> {
    await this.deviceConnectionManager.release()
    hilog.info(0x0000, 'Migration', 'Migration manager released')
  }
}
