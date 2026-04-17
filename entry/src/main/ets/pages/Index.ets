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
          .color('#000')
          .strokeWidth(2)
        BottomTimer({ timer: this.timer2, opponentTimer: this.timer1, score: this.score })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
      Row({ space: 8 }) {
        Column({ space: 4 }) {
          Text(`P1: ${this.score.p1Win}`)
            .fontSize(16)
            .fontColor('#000')
          Text(`P2: ${this.score.p2Win}`)
            .fontSize(16)
            .fontColor('#000')
          Text(`Tie: ${this.score.ties}`)
            .fontSize(16)
            .fontColor('#000')
        }
        .alignItems(HorizontalAlign.Start)
        Button('Reset')
          .onClick(() => {
            this.timer1.reset()
            this.timer2.reset()
            this.score.reset()
          })
      }
      .padding(8)
    }
    .width('100%')
    .height('100%')
  }
}
