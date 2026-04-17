import { TopTimer, BottomTimer, Timer, Score } from './Home'

@Entry
@ComponentV2
struct Index {
  @Local timer1: Timer = new Timer()
  @Local timer2: Timer = new Timer()
  @Local score: Score = new Score()

  build() {
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
      .backgroundColor('#F5F5F5')
      Row({ space: 12 }) {
        Column({ space: 4 }) {
          Text(`P1: ${this.score.p1Win}`)
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#1A1A1A')
          Text(`P2: ${this.score.p2Win}`)
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#1A1A1A')
          Text(`Tie: ${this.score.ties}`)
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#1A1A1A')
        }
        .alignItems(HorizontalAlign.Start)
        Button('Reset')
          .height(32)
          .fontSize(14)
          .fontWeight(500)
          .backgroundColor('#2196F3')
          .onClick(() => {
            this.timer1.reset()
            this.timer2.reset()
            this.score.reset()
          })
      }
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }
}
