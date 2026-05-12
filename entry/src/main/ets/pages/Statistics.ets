import { Score } from './Home'

interface DataPoint {
  x: number
  y: number
  color: string
}

@Preview
@ComponentV2
export struct Statistics {
  @Param score: Score = new Score()
  @Param p1TimeList: number[] = []
  @Param p2TimeList: number[] = []
  private chartSize: number = 300

  build() {
    Column({ space: 16 }) {
      Text('📊 统计分析')
        .fontSize(24)
        .fontWeight(700)
        .alignSelf(ItemAlign.Start)

      Column({ space: 12 }) {
        Text('🏆 胜率统计')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
        Row({ space: 16 }) {
          StatisticItem({ label: 'P1 胜率', value: `${this.score.getP1WinRate().toFixed(1)}%`, color: '#FF6B6B', count: this.score.p1Win })
          StatisticItem({ label: 'P2 胜率', value: `${this.score.getP2WinRate().toFixed(1)}%`, color: '#4ECDC4', count: this.score.p2Win })
          StatisticItem({ label: '平局率', value: `${this.score.getTieRate().toFixed(1)}%`, color: '#FFD700', count: this.score.ties })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
      .borderRadius(12)

      Column({ space: 12 }) {
        Text('📈 个人最佳')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
        Row({ space: 16 }) {
          StatisticItem({ label: 'P1 最佳', value: this.formatTime(Math.min(...this.p1TimeList, Infinity)), color: '#FF6B6B', count: 0 })
          StatisticItem({ label: 'P2 最佳', value: this.formatTime(Math.min(...this.p2TimeList, Infinity)), color: '#4ECDC4', count: 0 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
      .borderRadius(12)

      Column({ space: 12 }) {
        Text('📊 成绩趋势')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
        Row({ space: 8 }) {
          Column({ space: 4 }) {
            Row({ space: 4 }) {
              Text('●')
                .fontSize(12)
                .fontColor('#FF6B6B')
              Text('P1')
                .fontSize(12)
                .fontColor('#757575')
            }
            .alignItems(VerticalAlign.Center)
          }
          Column({ space: 4 }) {
            Row({ space: 4 }) {
              Text('●')
                .fontSize(12)
                .fontColor('#4ECDC4')
              Text('P2')
                .fontSize(12)
                .fontColor('#757575')
            }
            .alignItems(VerticalAlign.Center)
          }
        }
        .justifyContent(FlexAlign.Start)
        CustomLineChart({ dataPoints: this.getDataPoints(), chartSize: this.chartSize })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
      .borderRadius(12)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }

  formatTime(time: number): string {
    if (time === Infinity) return '--:--.---'
    const minutes = Math.floor(time / 60000)
    const seconds = Math.floor((time % 60000) / 1000)
    const milliseconds = time % 1000
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds.toString().padStart(3, '0')}`
  }

  getDataPoints(): DataPoint[] {
    const dataPoints: DataPoint[] = []
    const maxLen = Math.max(this.p1TimeList.length, this.p2TimeList.length)
    for (let i = 0; i < maxLen; i++) {
      if (i < this.p1TimeList.length) {
        dataPoints.push({ x: i, y: this.p1TimeList[i], color: '#FF6B6B' })
      }
      if (i < this.p2TimeList.length) {
        dataPoints.push({ x: i, y: this.p2TimeList[i], color: '#4ECDC4' })
      }
    }
    return dataPoints
  }
}

@ComponentV2
struct StatisticItem {
  @Param label: string = ''
  @Param value: string = ''
  @Param color: string = '#1A1A1A'
  @Param count: number = 0

  build() {
    Column({ space: 8 }) {
      Text(this.value)
        .fontSize(24)
        .fontWeight(700)
        .fontColor(this.color)
      Text(this.label)
        .fontSize(12)
        .fontWeight(500)
        .fontColor('#757575')
    }
  }
}

@ComponentV2
struct CustomLineChart {
  @Param dataPoints: DataPoint[] = []
  @Param chartSize: number = 300
  private chartPadding: number = 32

  build() {
    Stack() {
      Canvas(this.context)
        .width('100%')
        .aspectRatio(2)
        .onReady(() => {
          this.drawChart()
        })
    }
    .alignContent(Alignment.TopStart)
  }

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D()

  private drawChart() {
    this.context.clearRect(0, 0, this.chartSize, this.chartSize)
    this.drawAxes()
    this.drawGridLines()
    this.drawDataLines()
    this.drawDataPoints()
  }

  private drawAxes() {
    this.context.strokeStyle = '#E0E0E0'
    this.context.lineWidth = 1
    this.context.beginPath()
    this.context.moveTo(this.chartPadding, this.chartPadding)
    this.context.lineTo(this.chartPadding, this.chartSize - this.chartPadding)
    this.context.lineTo(this.chartSize - this.chartPadding, this.chartSize - this.chartPadding)
    this.context.stroke()
  }

  private drawGridLines() {
    const gridCount = 5
    this.context.strokeStyle = '#F0F0F0'
    this.context.lineWidth = 0.5
    for (let i = 1; i <= gridCount; i++) {
      const y = this.chartPadding + (this.chartSize - 2 * this.chartPadding) * i / gridCount
      this.context.beginPath()
      this.context.moveTo(this.chartPadding, y)
      this.context.lineTo(this.chartSize - this.chartPadding, y)
      this.context.stroke()
    }
  }

  private drawDataLines() {
    const groupedData = this.groupDataByColor()
    groupedData.forEach((points, color) => {
      this.context.strokeStyle = color
      this.context.lineWidth = 2
      this.context.beginPath()
      points.forEach((point, index) => {
        const x = this.chartPadding + (this.chartSize - 2 * this.chartPadding) * point.x / (Math.max(...points.map(p => p.x)) || 1)
        const maxY = Math.max(...points.map(p => p.y))
        const y = this.chartSize - this.chartPadding - (this.chartSize - 2 * this.chartPadding) * point.y / (maxY || 1)
        if (index === 0) {
          this.context.moveTo(x, y)
        } else {
          this.context.lineTo(x, y)
        }
      })
      this.context.stroke()
    })
  }

  private drawDataPoints() {
    const groupedData = this.groupDataByColor()
    groupedData.forEach((points, color) => {
      points.forEach(point => {
        const x = this.chartPadding + (this.chartSize - 2 * this.chartPadding) * point.x / (Math.max(...points.map(p => p.x)) || 1)
        const maxY = Math.max(...points.map(p => p.y))
        const y = this.chartSize - this.chartPadding - (this.chartSize - 2 * this.chartPadding) * point.y / (maxY || 1)
        this.context.fillStyle = color
        this.context.beginPath()
        this.context.arc(x, y, 3, 0, 2 * Math.PI)
        this.context.fill()
      })
    })
  }

  private groupDataByColor(): Map<string, DataPoint[]> {
    const map = new Map<string, DataPoint[]>()
    this.dataPoints.forEach(point => {
      if (!map.has(point.color)) {
        map.set(point.color, [])
      }
      map.get(point.color)!.push(point)
    })
    return map
  }
}
