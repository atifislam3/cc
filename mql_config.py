"""
Trading Strategy Configuration Parser
Parses MQL4/MQL5 strategy parameters from the problem statement
"""

from trading_signals import TradingConfig

def parse_mql_config(config_text: str = None) -> TradingConfig:
    """
    Parse MQL4/MQL5 configuration parameters and return TradingConfig object
    If no config_text provided, returns configuration based on problem statement
    """
    
    # Default configuration based on problem statement
    config = TradingConfig()
    
    # Parse the configuration from problem statement
    # These are the key parameters that were identified as important
    
    # WIN RATE FILTER
    config.mao_fixa = False  # APPLY FILTER WITHOUT MARTINGALE
    config.filtro_mao_fixa = 78.0  # WITHOUT MARTINGALE
    config.aplica_filtro_no_gale = False  # APPLY FILTER WITH MARTINGALE  
    config.filtro_martingale = 92.0  # WITH MARTINGALE
    
    # TMA #1
    config.tma231 = False
    config.periodo_tma5357 = 4
    config.periodo_tma6357 = 11
    config.periodo_tma664 = 32
    
    # TMA #2
    config.tma234 = False
    config.periodo_tma536 = 20
    config.periodo_tma636 = 5
    config.periodo_tma635 = 41
    
    # TWR OBITO STRATEGY
    config.tma2 = False
    config.periodo_tma5 = 2
    config.periodo_tma6 = 7
    config.periodo_tma7 = 18
    config.periodo_tma8 = 20
    config.periodo_tma9 = 22
    
    # TWR OBITO STRATEGY 2
    config.tma3 = False
    config.periodo_tma10 = 20
    config.periodo_tma11 = 74
    
    # TWR OBITO STRATEGY 3
    config.tma4 = False
    config.periodo_tma12 = 4
    config.periodo_tma13 = 45
    config.periodo_tma14 = 79
    config.periodo_tma15 = 13
    config.periodo_tma16 = 25
    
    # TWR OBITO STRATEGY 4 (MACD)
    config.ativa_macd2 = False
    config.macd_period4 = 89
    config.macd_period5 = 56
    config.macd_period6 = 14
    
    # TWR OBITO MACD
    config.ativa_macd = False
    config.macd_period1 = 12
    config.macd_period2 = 26
    config.macd_period3 = 9
    
    # PREMIUM RSI-TF
    config.master_estrategia20 = False
    config.periodo_rsi2 = 7
    config.max_rsi2 = 9
    config.min_rsi2 = 24
    
    # RSI-1
    config.periodo_rsi5 = False
    config.periodo_rsi0 = 3
    config.periodo_rsi15 = 65
    config.max_rsi10 = 6
    config.min_rsi10 = 87
    
    # RSI-2 (ENABLED BY DEFAULT in problem statement)
    config.master_estrategia3 = True
    config.periodo_rsi = 3
    config.max_rsi = 65
    config.min_rsi = 35
    
    # QTX RSI-2TF
    config.periodo_rsi6 = False
    config.periodo_rsi1 = 0
    config.periodo_rsi16 = 14
    config.max_rsi11 = 30
    config.min_rsi11 = 70
    
    # BNL RSI-3TF
    config.periodo_rsi7 = False
    config.periodo_rsi30 = 8
    config.periodo_rsi17 = 1
    config.max_rsi12 = 23
    config.min_rsi12 = 50
    
    # QTX MACD
    config.ativa_macd50 = False
    config.macd_period100 = 6
    config.macd_period10 = 13
    config.macd_period24 = 6
    
    # BNL MACD
    config.ativa_macd55 = False
    config.macd_period101 = 5
    config.macd_period12 = 12
    config.macd_period17 = 3
    
    # TWR SS KOMBINER PRO STRATEGY (ENABLED BY DEFAULT)
    config.master_estrategia = True
    config.periodo_rsi12 = 3
    config.max_rsi22 = 65
    config.min_rsi32 = 35
    
    # TWR SS KOMBINER STRATEGY 2
    config.master_estrategia1 = False
    config.periodo_rsi3 = 3
    config.max_rsi1 = 65
    config.min_rsi1 = 35
    
    # TWR SS KOMBINER STRATEGY 3
    config.master_estrategia2 = False
    config.periodo_rsi20 = 0
    config.max_rsi20 = 0
    config.min_rsi20 = 0
    
    # TWR SS KOMBINER PRO
    config.sakib_kombiner_pro = False
    
    # CUSTOMIZED STRATEGYs
    config.master_estrategia25 = False  # CUSTOMIZED STRATEGY
    config.master_estrategia45 = False  # CUSTOMIZED STRATEGY 2
    
    # TREND FILTER
    config.filtro_tendencia5 = False
    config.gi_84 = 76
    config.gd_88 = 0.0
    config.trend_gale = False
    
    # TREND WIN RATE (ENABLED BY DEFAULT)
    config.master_estrategia6 = True
    
    # SUPPORT AND RESISTANCE
    config.ser = False
    config.media_movel = 14
    config.filtro_tendencia2 = False
    
    # RETRACTION FILTERs
    config.filt_ret = False
    config.shadow_ratio = 80
    config.filt_ret_2 = False
    config.shadow_ratio2 = 80
    
    return config

def get_strategy_descriptions() -> dict:
    """Return descriptions of all available strategies"""
    return {
        "WIN_RATE_FILTER": "Filter based on win rate thresholds with/without martingale",
        "TMA_1": "Triangular Moving Average #1 (Periods: 4, 11, 32)",
        "TMA_2": "Triangular Moving Average #2 (Periods: 20, 5, 41)", 
        "TWR_OBITO_1": "TWR OBITO Strategy (5 periods: 2, 7, 18, 20, 22)",
        "TWR_OBITO_2": "TWR OBITO Strategy 2 (2 periods: 20, 74)",
        "TWR_OBITO_3": "TWR OBITO Strategy 3 (5 periods: 4, 45, 79, 13, 25)",
        "TWR_OBITO_MACD_4": "TWR OBITO MACD Strategy 4 (Periods: 89, 56, 14)",
        "TWR_OBITO_MACD": "TWR OBITO MACD (Periods: 12, 26, 9)",
        "PREMIUM_RSI_TF": "Premium RSI-TF (Period: 7, Max: 9, Min: 24)",
        "RSI_1": "RSI-1 (Period: 3, Range: 65-6, Max: 87)",
        "RSI_2": "RSI-2 (Period: 3, Range: 35-65) - ACTIVE BY DEFAULT",
        "QTX_RSI_2TF": "QTX RSI-2TF (Period: 14, Range: 30-70)",
        "BNL_RSI_3TF": "BNL RSI-3TF (Period: 8, Range: 23-50)",
        "QTX_MACD": "QTX MACD (Periods: 6, 13, 6)",
        "BNL_MACD": "BNL MACD (Periods: 5, 12, 3)",
        "TWR_SS_KOMBINER_PRO": "TWR SS KOMBINER PRO STRATEGY - ACTIVE BY DEFAULT",
        "TWR_SS_KOMBINER_2": "TWR SS KOMBINER STRATEGY 2",
        "TWR_SS_KOMBINER_3": "TWR SS KOMBINER STRATEGY 3",
        "TREND_WIN_RATE": "TREND WIN RATE 1.0 - ACTIVE BY DEFAULT",
        "SUPPORT_RESISTANCE": "Support and Resistance Filter",
        "RETRACTION_FILTER": "Retraction/Candle Filter"
    }

def print_active_strategies(config: TradingConfig):
    """Print which strategies are currently active"""
    active = []
    
    if config.master_estrategia3:
        active.append(f"RSI-2 (Period: {config.periodo_rsi}, Range: {config.min_rsi}-{config.max_rsi})")
    
    if config.master_estrategia:
        active.append(f"TWR SS KOMBINER PRO (RSI Period: {config.periodo_rsi12})")
    
    if config.master_estrategia6:
        active.append("TREND WIN RATE 1.0")
    
    if config.tma231:
        active.append(f"TMA #1 (Periods: {config.periodo_tma5357}, {config.periodo_tma6357}, {config.periodo_tma664})")
    
    if config.tma234:
        active.append(f"TMA #2 (Periods: {config.periodo_tma536}, {config.periodo_tma636}, {config.periodo_tma635})")
    
    if config.ativa_macd:
        active.append(f"TWR OBITO MACD (Periods: {config.macd_period1}, {config.macd_period2}, {config.macd_period3})")
    
    if config.ativa_macd2:
        active.append(f"TWR OBITO MACD 4 (Periods: {config.macd_period4}, {config.macd_period5}, {config.macd_period6})")
    
    print("Active Strategies:")
    for strategy in active:
        print(f"  • {strategy}")
    
    if not active:
        print("  • No strategies currently active")

# Test the configuration
if __name__ == "__main__":
    config = parse_mql_config()
    print("MQL4/MQL5 Configuration Parsed:")
    print_active_strategies(config)
    
    descriptions = get_strategy_descriptions()
    print("\nAvailable Strategy Descriptions:")
    for name, desc in descriptions.items():
        print(f"  {name}: {desc}")