export interface PlayerConfig {
  name: string
  color: string
}

export interface ThemeColors {
  background: string
  cardBackground: string
  textPrimary: string
  textSecondary: string
  divider: string
  buttonPrimary: string
  buttonSecondary: string
}

@ObservedV2
export class AppConfig {
  @Trace static player1: PlayerConfig = {
    name: 'P1',
    color: '#FF6B6B'
  }
  
  @Trace static player2: PlayerConfig = {
    name: 'P2',
    color: '#4ECDC4'
  }
  
  @Trace static isDarkMode: boolean = false
  
  static getLightTheme(): ThemeColors {
    return {
      background: '#F5F5F5',
      cardBackground: '#FFFFFF',
      textPrimary: '#1A1A1A',
      textSecondary: '#757575',
      divider: '#E0E0E0',
      buttonPrimary: '#2196F3',
      buttonSecondary: '#4CAF50'
    }
  }
  
  static getDarkTheme(): ThemeColors {
    return {
      background: '#1A1A1A',
      cardBackground: '#2D2D2D',
      textPrimary: '#FFFFFF',
      textSecondary: '#B0B0B0',
      divider: '#404040',
      buttonPrimary: '#1976D2',
      buttonSecondary: '#388E3C'
    }
  }
  
  static getTheme(): ThemeColors {
    return AppConfig.isDarkMode ? AppConfig.getDarkTheme() : AppConfig.getLightTheme()
  }
  
  static toggleTheme() {
    AppConfig.isDarkMode = !AppConfig.isDarkMode
  }
  
  static setPlayer1Name(name: string) {
    AppConfig.player1.name = name
  }
  
  static setPlayer2Name(name: string) {
    AppConfig.player2.name = name
  }
  
  static setPlayer1Color(color: string) {
    AppConfig.player1.color = color
  }
  
  static setPlayer2Color(color: string) {
    AppConfig.player2.color = color
  }
}
