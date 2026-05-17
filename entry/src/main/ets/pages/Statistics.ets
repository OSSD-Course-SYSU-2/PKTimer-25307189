import { Score } from './Home'
import { AppConfig } from '../common/AppConfig'

@Preview
@ComponentV2
export struct Statistics {
  @Param @Require score: Score
  @Param @Require p1TimeList: number[]
  @Param @Require p2TimeList: number[]

  build() {
    Column() {
      Text('📊 统计分析')
        .fontSize(24)
        .fontWeight(700)
        .fontColor('#000000')
        .margin({ top: 20, bottom: 20 })

      Text(`玩家1胜场: ${this.score.p1Win}`)
        .fontSize(16)
        .fontColor('#000000')
        .margin({ bottom: 10 })

      Text(`玩家2胜场: ${this.score.p2Win}`)
        .fontSize(16)
        .fontColor('#000000')
        .margin({ bottom: 10 })

      Text(`平局: ${this.score.ties}`)
        .fontSize(16)
        .fontColor('#000000')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
  }
}
