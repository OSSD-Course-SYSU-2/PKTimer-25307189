import { TopTimer, BottomTimer, Timer, Score } from './Home'
import { Statistics } from './Statistics'
import { Settings } from './Settings'
import { AppConfig } from '../common/AppConfig'
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@ComponentV2
struct Index {
  @Local timer1: Timer = new Timer()
  @Local timer2: Timer = new Timer()
  @Local score: Score = new Score()
  @Local showStatistics: boolean = false
  @Local showSettings: boolean = false

  build() {
    Stack() {
      Navigation() {
        Stack({ alignContent: Alignment.Bottom }) {
          Column({ space: 0 }) {
            TopTimer({ timer: this.timer1, opponentTimer: this.timer2, score: this.score })
            Divider()
              .color('#E0E0E0')
              .strokeWidth(1)
            BottomTimer({ timer: this.timer2, opponentTimer: this.timer1, score: this.score })
          }
          .width('100%')
          .height('100%')
          .backgroundColor(AppConfig.getTheme().background)
          .padding({ top: 16 })
          Row({ space: 12 }) {
            Column({ space: 4 }) {
              Text(`${AppConfig.player1.name}: ${this.score.p1Win}`)
                .fontSize(14)
                .fontWeight(500)
                .fontColor(AppConfig.getTheme().textPrimary)
              Text(`${AppConfig.player2.name}: ${this.score.p2Win}`)
                .fontSize(14)
                .fontWeight(500)
                .fontColor(AppConfig.getTheme().textPrimary)
              Text(`Tie: ${this.score.ties}`)
                .fontSize(14)
                .fontWeight(500)
                .fontColor(AppConfig.getTheme().textPrimary)
            }
            .alignItems(HorizontalAlign.Start)
            Button('Reset')
              .height(32)
              .fontSize(14)
              .fontWeight(500)
              .backgroundColor(AppConfig.getTheme().buttonPrimary)
              .onClick(() => {
                this.timer1.reset()
                this.timer2.reset()
                this.score.reset()
              })
            Button('Statistics')
              .height(32)
              .fontSize(14)
              .fontWeight(500)
              .backgroundColor(AppConfig.getTheme().buttonSecondary)
              .onClick(() => {
                this.showStatistics = true
              })
            Button('Settings')
              .height(32)
              .fontSize(14)
              .fontWeight(500)
              .backgroundColor('#9C27B0')
              .onClick(() => {
                this.showSettings = true
              })
          }
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .width('100%')
        .height('100%')
        .bindSheet(this.showSettings, this.SettingsSheet, {
          height: 600,
          onDisappear: () => {
            this.showSettings = false
          }
        })
      }
      .title('PK Timer')
      .titleMode(NavigationTitleMode.Mini)

      if (this.showStatistics) {
        Column() {
          Column() {
            // 标题
            Text('📊 统计分析')
              .fontSize(24)
              .fontWeight(700)
              .fontColor(AppConfig.getTheme().textPrimary)
              .margin({ top: 20, bottom: 20 })

            // 胜率统计
            Column({ space: 12 }) {
              Text('🏆 胜率统计')
                .fontSize(18)
                .fontWeight(600)
                .alignSelf(ItemAlign.Start)
                .fontColor(AppConfig.getTheme().textPrimary)

              Row({ space: 16 }) {
                this.StatisticItem(`${AppConfig.player1.name} 胜率`, `${this.score.getP1WinRate().toFixed(1)}%`, AppConfig.player1.color, this.score.p1Win)
                this.StatisticItem(`${AppConfig.player2.name} 胜率`, `${this.score.getP2WinRate().toFixed(1)}%`, AppConfig.player2.color, this.score.p2Win)
                this.StatisticItem('平局率', `${this.score.getTieRate().toFixed(1)}%`, '#FFD700', this.score.ties)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(AppConfig.getTheme().cardBackground)
            .borderRadius(12)
            .margin({ bottom: 16 })

            // 个人最佳
            Column({ space: 12 }) {
              Text('📈 个人最佳')
                .fontSize(18)
                .fontWeight(600)
                .alignSelf(ItemAlign.Start)
                .fontColor(AppConfig.getTheme().textPrimary)

              Row({ space: 16 }) {
                this.StatisticItem(`${AppConfig.player1.name} 最佳`, this.formatTime(Math.min(...this.timer1.timeList, Infinity)), AppConfig.player1.color, 0)
                this.StatisticItem(`${AppConfig.player2.name} 最佳`, this.formatTime(Math.min(...this.timer2.timeList, Infinity)), AppConfig.player2.color, 0)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(AppConfig.getTheme().cardBackground)
            .borderRadius(12)
            .margin({ bottom: 16 })

            // 平均成绩
            Column({ space: 12 }) {
              Text('⏱️ 平均成绩')
                .fontSize(18)
                .fontWeight(600)
                .alignSelf(ItemAlign.Start)
                .fontColor(AppConfig.getTheme().textPrimary)

              Row({ space: 16 }) {
                this.StatisticItem(`${AppConfig.player1.name} 平均`, this.formatTime(this.timer1.timeList.length > 0 ? this.timer1.timeList.reduce((a, b) => a + b, 0) / this.timer1.timeList.length : Infinity), AppConfig.player1.color, this.timer1.timeList.length)
                this.StatisticItem(`${AppConfig.player2.name} 平均`, this.formatTime(this.timer2.timeList.length > 0 ? this.timer2.timeList.reduce((a, b) => a + b, 0) / this.timer2.timeList.length : Infinity), AppConfig.player2.color, this.timer2.timeList.length)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(AppConfig.getTheme().cardBackground)
            .borderRadius(12)
            .margin({ bottom: 16 })

            // 关闭按钮
            Button('关闭')
              .width('100%')
              .height(40)
              .backgroundColor(AppConfig.getTheme().buttonPrimary)
              .onClick(() => {
                this.showStatistics = false
              })
          }
          .width('90%')
          .padding(20)
          .backgroundColor(AppConfig.getTheme().background)
          .borderRadius(20)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.showStatistics = false
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  StatisticItem(label: string, value: string, color: string, count: number) {
    Column({ space: 8 }) {
      Text(value)
        .fontSize(24)
        .fontWeight(700)
        .fontColor(color)
      Text(label)
        .fontSize(12)
        .fontWeight(500)
        .fontColor('#757575')
      if (count > 0) {
        Text(`(${count}场)`)
          .fontSize(10)
          .fontColor('#999999')
      }
    }
  }

  @Builder
  SettingsSheet() {
    Settings()
  }

  private formatTime(time: number): string {
    if (time === Infinity || isNaN(time)) return '--:--.---'
    const minutes = Math.floor(time / 60000)
    const seconds = Math.floor((time % 60000) / 1000)
    const milliseconds = time % 1000
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds.toString().padStart(3, '0')}`
  }
}
