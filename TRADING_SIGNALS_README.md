# 1-Minute Trading Signal Generator

## Overview
This system extracts 1-minute trading signals from MQL4/MQL5 strategy parameters, implementing the trading strategies defined in the problem statement.

## Features
- **RSI-based Signals**: Multiple RSI strategies with different periods and thresholds
- **MACD Signals**: Various MACD configurations for trend analysis  
- **TMA Signals**: Triangular Moving Average strategies
- **Trend Analysis**: Linear regression-based trend detection
- **Combination Strategies**: Multi-indicator signal generation
- **JSON Output**: Detailed signal analysis saved to file

## Strategy Configuration
The system implements all strategies from the MQL4/MQL5 parameter set:

### Active by Default:
1. **RSI-2**: Period=3, Range=35-65 (from `master_estrategia3 = true`)
2. **TWR SS KOMBINER PRO**: Combination strategy (from `master_estrategia = true`) 
3. **TREND WIN RATE 1.0**: Trend analysis (from `master_estrategia6 = true`)

### Available Strategies:
- **WIN RATE FILTER**: Filter based on win rate thresholds (78% without martingale, 92% with martingale)
- **TMA #1**: Triangular Moving Average with periods 4, 11, 32
- **TMA #2**: Triangular Moving Average with periods 20, 5, 41
- **TWR OBITO Strategies**: Multiple configurations with various periods
- **MACD Strategies**: Different MACD setups for various timeframes
- **RSI Variations**: Premium RSI-TF, QTX RSI-2TF, BNL RSI-3TF
- **Support & Resistance**: S&R based filtering
- **Retraction Filters**: Candlestick pattern analysis

## Usage

### Via Main Application:
```bash
python3 cc.py
# Select option 5 for 1-Minute Trading Signal Generator
```

### Standalone Testing:
```bash
python3 trading_signals.py
```

### Configuration Testing:
```bash
python3 mql_config.py
```

## Input Format
Price data should be provided as comma-separated values:
```
100.0,100.2,100.1,100.3,100.5,100.4,100.6,100.8,100.7,100.9
```

If no input is provided, sample data is used for demonstration.

## Output Format
The system generates three types of signals:
- **CALL**: Buy/bullish signal
- **PUT**: Sell/bearish signal  
- **HOLD**: No clear direction

Each signal includes:
- Confidence level (0-100%)
- Reasoning for the signal
- Individual strategy contributions
- Active strategy configurations

## Signal Generation Process
1. **Data Validation**: Ensures minimum data points for analysis
2. **Indicator Calculation**: Computes RSI, MACD, TMA values
3. **Strategy Evaluation**: Each active strategy generates individual signals
4. **Signal Combination**: Majority voting with confidence weighting
5. **Output Generation**: Formatted display and JSON file creation

## Technical Indicators

### RSI (Relative Strength Index)
- Measures momentum and overbought/oversold conditions
- Configurable periods and thresholds
- Multiple RSI strategies with different parameters

### MACD (Moving Average Convergence Divergence)
- Trend following momentum indicator
- Fast/slow period configurations
- Signal line crossover analysis

### TMA (Triangular Moving Average)
- Double-smoothed moving average
- Reduces noise compared to simple moving averages
- Multiple period configurations

### Trend Analysis
- Linear regression slope calculation
- Percentage-based trend strength
- Configurable sensitivity thresholds

## File Structure
```
cc.py                 # Main application with menu system
trading_signals.py    # Core signal generation engine
mql_config.py        # MQL4/MQL5 parameter configuration
corex/               # Supporting modules
  ├── __init__.py
  ├── bin.py         # BIN generation functionality
  └── val.js         # Credit card validation
```

## Configuration Parameters
Based on the MQL4/MQL5 parameter set from the problem statement:

```mql4
// Key parameters implemented:
input simnao MasterEstrategia3 = true;     // RSI-2 (Active)
input int PeriodoRSI = 03;                 // RSI Period
input int MaxRSI = 65;                     // RSI Upper Threshold
input int MinRSI = 35;                     // RSI Lower Threshold

input simnao MasterEstrategia = true;      // TWR SS KOMBINER PRO (Active)
input simnao MasterEstrategia6 = true;     // TREND WIN RATE 1.0 (Active)

// Plus 50+ additional configurable parameters...
```

## Examples

### Strong Bullish Signal:
```json
{
  "signal": "CALL",
  "confidence": 85.0,
  "reason": "Majority CALL signals (2/3)",
  "strategies_used": ["RSI-2", "TREND WIN RATE 1.0"]
}
```

### Conflicting Signals:
```json
{
  "signal": "HOLD", 
  "confidence": 0.0,
  "reason": "Conflicting signals",
  "strategies_used": ["RSI-2", "TWR SS KOMBINER PRO", "TREND WIN RATE 1.0"]
}
```

## Integration with Fox CC Tools
The 1-minute trading signal generator is seamlessly integrated into the existing Fox CC credit card tools as option #5, maintaining the original functionality while adding advanced trading capabilities.

## Requirements
- Python 3.x
- Standard libraries: json, math, dataclasses, enum, typing
- Fox CC dependencies: requests, beautifulsoup4, pyfiglet, colorama

## License
Part of the Fox CC Tools suite by VENOMPRIME Security Team.