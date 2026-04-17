@ObservedV2
export class Timer {
  @Trace time: number = 0
  @Trace startTime: number = 0
  @Trace isRunning: boolean = false
  @Trace lastTime: number = 0
  @Trace mo3: number = 0
  @Trace ao5: number = 0
  timeList: number[] = []
  intervalId: number = -1

  start() {
    this.startTime = Date.now()
    this.isRunning = true
    this.intervalId = setInterval(() => {
      this.time = Date.now() - this.startTime
    }, 10)
  }

  stop() {
    clearInterval(this.intervalId)
    this.isRunning = false
    this.lastTime = this.time
    this.timeList.push(this.lastTime)
    this.updateStatistics()
  }

  clearLastTime() {
    this.lastTime = 0
  }

  reset() {
    this.time = 0
    this.startTime = 0
    this.isRunning = false
    this.lastTime = 0
    this.timeList = []
    this.mo3 = 0
    this.ao5 = 0
    clearInterval(this.intervalId)
  }

  updateStatistics() {
    if (this.timeList.length >= 3) {
      this.mo3 = this.calculateAverage(this.timeList.slice(-3))
    }
    if (this.timeList.length >= 5) {
      this.ao5 = this.calculateAverage(this.timeList.slice(-5))
    }
  }

  calculateAverage(times: number[]): number {
    const sortedTimes = [...times].sort((a, b) => a - b)
    const trimmedTimes = sortedTimes.slice(1, sortedTimes.length - 1)
    return trimmedTimes.reduce((sum, time) => sum + time, 0) / trimmedTimes.length
  }
}

@ObservedV2
export class Score {
  @Trace p1Win: number = 0
  @Trace p2Win: number = 0
  @Trace ties: number = 0
  @Trace lastWinner: 'p1' | 'p2' | 'tie' | null = null

  updateWinner(winner: 'p1' | 'p2' | 'tie') {
    if (winner === 'p1') {
      this.p1Win++
    } else if (winner === 'p2') {
      this.p2Win++
    } else {
      this.ties++
    }
    this.lastWinner = winner
  }

  reset() {
    this.p1Win = 0
    this.p2Win = 0
    this.ties = 0
    this.lastWinner = null
  }
}

interface TimerParams {
  timer: Timer
  opponentTimer: Timer
  score: Score
}

@Builder
export function TopTimer($: TimerParams) {
  Stack() {
    Column() {
      Text('P1')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000')
      Text(formatTime($.timer.time))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000')
      Column({ space: 4 }) {
        Row({ space: 16 }) {
          Text('MO3:')
            .fontSize(16)
            .fontColor('#000')
            .alignSelf(ItemAlign.Center)
          Column() {
            Text(formatTime($.timer.mo3))
              .fontSize(16)
              .fontColor('#000')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        Row({ space: 16 }) {
          Text('AO5:')
            .fontSize(16)
            .fontColor('#000')
            .alignSelf(ItemAlign.Center)
          Column() {
            Text(formatTime($.timer.ao5))
              .fontSize(16)
              .fontColor('#000')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(8)
    if ($.score.lastWinner === 'p1') {
      Column({ space: 8 }) {
        Text('🎉')
          .fontSize(48)
        Text('WINNER!')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFD700')
      }
      .justifyContent(FlexAlign.Center)
    }
  }
  .width('100%')
  .height('50%')
  .backgroundColor(Color.Transparent)
  .onClick(() => {
    if (!$.opponentTimer.isRunning && !$.timer.isRunning) {
      $.timer.start()
    } else if ($.timer.isRunning) {
      $.timer.stop()
      if (!$.opponentTimer.isRunning && $.opponentTimer.lastTime > 0) {
        $.score.updateWinner(compareTimes($.timer.lastTime, $.opponentTimer.lastTime))
        $.timer.clearLastTime()
        $.opponentTimer.clearLastTime()
      }
    }
  })
}

function compareTimes(time1: number, time2: number): 'p1' | 'p2' | 'tie' {
  if (time1 < time2) return 'p1'
  if (time1 > time2) return 'p2'
  return 'tie'
}

function formatTime(time: number): string {
  const minutes = Math.floor(time / 60000)
  const seconds = Math.floor((time % 60000) / 1000)
  const milliseconds = time % 1000
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds.toString().padStart(3, '0')}`
}

@Builder
export function BottomTimer($: TimerParams) {
  Stack() {
    Column() {
      Text('P2')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000')
      Text(formatTime($.timer.time))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000')
      Column({ space: 4 }) {
        Row({ space: 16 }) {
          Text('MO3:')
            .fontSize(16)
            .fontColor('#000')
            .alignSelf(ItemAlign.Center)
          Column() {
            Text(formatTime($.timer.mo3))
              .fontSize(16)
              .fontColor('#000')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        Row({ space: 16 }) {
          Text('AO5:')
            .fontSize(16)
            .fontColor('#000')
            .alignSelf(ItemAlign.Center)
          Column() {
            Text(formatTime($.timer.ao5))
              .fontSize(16)
              .fontColor('#000')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(8)
    if ($.score.lastWinner === 'p2') {
      Column({ space: 8 }) {
        Text('🎉')
          .fontSize(48)
        Text('WINNER!')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFD700')
      }
      .justifyContent(FlexAlign.Center)
    }
  }
  .width('100%')
  .height('50%')
  .backgroundColor(Color.Transparent)
  .onClick(() => {
    if (!$.opponentTimer.isRunning && !$.timer.isRunning) {
      $.timer.start()
    } else if ($.timer.isRunning) {
      $.timer.stop()
      if (!$.opponentTimer.isRunning && $.opponentTimer.lastTime > 0) {
        $.score.updateWinner(compareTimes($.timer.lastTime, $.opponentTimer.lastTime))
        $.timer.clearLastTime()
        $.opponentTimer.clearLastTime()
      }
    }
  })
}
