import { AppConfig, PlayerConfig } from '../common/AppConfig'

@Preview
@ComponentV2
export struct Settings {
  @Local isDarkMode: boolean = AppConfig.isDarkMode
  @Local player1Name: string = AppConfig.player1.name
  @Local player2Name: string = AppConfig.player2.name
  @Local player1Color: string = AppConfig.player1.color
  @Local player2Color: string = AppConfig.player2.color
  
  private colorOptions: string[] = [
    '#FF6B6B', '#4ECDC4', '#FFD700', '#9C27B0', '#00BCD4',
    '#FF5722', '#795548', '#607D8B', '#E91E63', '#009688'
  ]

  build() {
    Column({ space: 16 }) {
      Text('⚙️ 设置')
        .fontSize(24)
        .fontWeight(700)
        .alignSelf(ItemAlign.Start)
        .fontColor(AppConfig.getTheme().textPrimary)

      // 主题设置
      Column({ space: 12 }) {
        Text('🎨 主题设置')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
          .fontColor(AppConfig.getTheme().textPrimary)
        
        Row({ space: 12 }) {
          Text('深色模式')
            .fontSize(16)
            .fontColor(AppConfig.getTheme().textPrimary)
          
          Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
            .onChange((isOn: boolean) => {
              this.isDarkMode = isOn
              AppConfig.toggleTheme()
            })
            .selectedColor('#4ECDC4')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(AppConfig.getTheme().cardBackground)
      .borderRadius(12)

      // P1 设置
      Column({ space: 12 }) {
        Text('👤 玩家 1 设置')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
          .fontColor(AppConfig.getTheme().textPrimary)
        
        Row({ space: 12 }) {
          Text('名称')
            .fontSize(16)
            .fontColor(AppConfig.getTheme().textPrimary)
          
          TextInput({ text: this.player1Name })
            .width(120)
            .height(40)
            .backgroundColor(AppConfig.getTheme().background)
            .fontColor(AppConfig.getTheme().textPrimary)
            .onChange((value: string) => {
              this.player1Name = value
              AppConfig.setPlayer1Name(value)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        
        Column({ space: 8 }) {
          Text('颜色')
            .fontSize(16)
            .fontColor(AppConfig.getTheme().textPrimary)
            .alignSelf(ItemAlign.Start)
          
          Row({ space: 8 }) {
            ForEach(this.colorOptions, (color: string) => {
              ColorOption({
                color: color,
                isSelected: this.player1Color === color,
                onSelect: () => {
                  this.player1Color = color
                  AppConfig.setPlayer1Color(color)
                }
              })
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(AppConfig.getTheme().cardBackground)
      .borderRadius(12)

      // P2 设置
      Column({ space: 12 }) {
        Text('👤 玩家 2 设置')
          .fontSize(18)
          .fontWeight(600)
          .alignSelf(ItemAlign.Start)
          .fontColor(AppConfig.getTheme().textPrimary)
        
        Row({ space: 12 }) {
          Text('名称')
            .fontSize(16)
            .fontColor(AppConfig.getTheme().textPrimary)
          
          TextInput({ text: this.player2Name })
            .width(120)
            .height(40)
            .backgroundColor(AppConfig.getTheme().background)
            .fontColor(AppConfig.getTheme().textPrimary)
            .onChange((value: string) => {
              this.player2Name = value
              AppConfig.setPlayer2Name(value)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        
        Column({ space: 8 }) {
          Text('颜色')
            .fontSize(16)
            .fontColor(AppConfig.getTheme().textPrimary)
            .alignSelf(ItemAlign.Start)
          
          Row({ space: 8 }) {
            ForEach(this.colorOptions, (color: string) => {
              ColorOption({
                color: color,
                isSelected: this.player2Color === color,
                onSelect: () => {
                  this.player2Color = color
                  AppConfig.setPlayer2Color(color)
                }
              })
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(AppConfig.getTheme().cardBackground)
      .borderRadius(12)

      // 重置按钮
      Button('重置为默认设置')
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontWeight(600)
        .backgroundColor('#FF5722')
        .fontColor('#FFFFFF')
        .onClick(() => {
          this.resetToDefault()
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppConfig.getTheme().background)
  }

  resetToDefault() {
    this.player1Name = 'P1'
    this.player2Name = 'P2'
    this.player1Color = '#FF6B6B'
    this.player2Color = '#4ECDC4'
    this.isDarkMode = false
    
    AppConfig.setPlayer1Name('P1')
    AppConfig.setPlayer2Name('P2')
    AppConfig.setPlayer1Color('#FF6B6B')
    AppConfig.setPlayer2Color('#4ECDC4')
    AppConfig.isDarkMode = false
  }
}

@ComponentV2
struct ColorOption {
  @Param color: string = '#FF6B6B'
  @Param isSelected: boolean = false
  @Param onSelect: () => void = () => {}

  build() {
    Column() {
      if (this.isSelected) {
        Text('✓')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .fontWeight(700)
      }
    }
    .width(32)
    .height(32)
    .borderRadius(16)
    .backgroundColor(this.color)
    .justifyContent(FlexAlign.Center)
    .border(this.isSelected ? { width: 3, color: '#FFFFFF' } : { width: 0, color: 'transparent' })
    .onClick(() => {
      this.onSelect()
    })
  }
}
