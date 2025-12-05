# Fox CC
[-] Black Fox CC Tools 
# Features
> [&] Fast & easy 

> [&] Generate a valid card

> [&] Generate multi valid card

> [&] Credit Card Valid Checker 

> [&] Generate Multi Bin Numbers

> [&] Without limit & Free


# Installation-Linux-Termux

```
apt-get update && apt-get upgrade && apt-get install git python3 nodejs
```
```
git clone https://github.com/BlackFoxTM/Fox-CC
```
```
cd Fox-CC
```
```
pip3 install -r requirements.txt
```
```
python3 cc.py
```

# Installation-Windows
### Download NodeJs Installer from [This Link](https://nodejs.org/en/)

### Then Download This project as zip 

### After That Open Cmd and go the Directory that you downloaded 

## run `python cc.py`

---

# ICT Patterns Detector (TradingView PineScript)

A comprehensive PineScript indicator for TradingView that detects Inner Circle Trader (ICT) patterns.

## Features

### Order Blocks
- Detects Bullish Order Blocks (last down candle before a strong up move)
- Detects Bearish Order Blocks (last up candle before a strong down move)
- Customizable colors and lookback period

### Fair Value Gaps (FVG)
- Identifies Bullish FVGs (imbalance zones during upward moves)
- Identifies Bearish FVGs (imbalance zones during downward moves)
- Configurable minimum gap size filter

### Breaker Blocks
- Detects failed Order Blocks that become Breaker Blocks
- Bullish Breakers (failed bearish OB)
- Bearish Breakers (failed bullish OB)

### Market Structure
- Higher Highs (HH)
- Lower Lows (LL)
- Higher Lows (HL)
- Lower Highs (LH)
- Change of Character (CHoCH) detection
- Break of Structure (BOS) detection

### Liquidity Levels
- Buy Side Liquidity (BSL) - swing highs where stops accumulate
- Sell Side Liquidity (SSL) - swing lows where stops accumulate
- Customizable lookback period

### Kill Zones (Trading Sessions)
- Asian Session highlighting
- London Kill Zone highlighting
- New York Kill Zone highlighting
- All times configurable in UTC

### Asian Range
- Automatically draws Asian session high and low
- Projects range for potential breakout trading

### Optimal Trade Entry (OTE)
- Draws the 62%-79% Fibonacci retracement zone
- Identifies key entry zones based on ICT methodology

### Displacement Detection
- Marks large impulsive candles
- Identifies strong momentum moves

### Information Table
- Shows current status of all patterns
- Displays active trading session

### Alerts
- Configurable alerts for all major patterns
- Order Block alerts
- FVG alerts
- BOS alerts
- Kill Zone start alerts
- Displacement alerts

## Installation

1. Open TradingView
2. Go to Pine Editor (bottom panel)
3. Copy the entire content of `ICT_Patterns.pine`
4. Paste it into the Pine Editor
5. Click "Save" and give it a name
6. Click "Add to Chart"

## Settings

All patterns can be individually enabled/disabled and customized:
- Colors for each pattern type
- Lookback periods
- Session times (UTC)
- Minimum FVG size filter
- Label visibility

## Usage Tips

1. **Order Blocks**: Look for price to return to Order Blocks for potential entries
2. **FVGs**: Price often returns to fill Fair Value Gaps
3. **Kill Zones**: Focus trading during London and NY Kill Zones for best setups
4. **Asian Range**: Trade breakouts of Asian Range during London session
5. **OTE Zone**: Look for entries in the 62%-79% retracement zone
6. **CHoCH/BOS**: Use for trend confirmation and reversal signals

## Disclaimer

This indicator is for educational purposes only. Trading involves risk. Always do your own analysis and use proper risk management.
