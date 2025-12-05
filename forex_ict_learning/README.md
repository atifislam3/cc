# ICT Forex Trading Concepts Learning Tool

An interactive educational web application for learning Inner Circle Trader (ICT) concepts with visual explanations, real-time charts, and practice exercises.

## 🎯 Features

### 📚 Comprehensive ICT Concepts Coverage
- **Fair Value Gap (FVG)** - Price imbalances and how to trade them
- **Break of Structure (BOS)** - Trend continuation signals
- **Change of Character (CHoCH)** - Trend reversal indicators
- **Order Blocks (OB)** - Institutional entry zones
- **Liquidity Concepts** - Understanding stop hunts and liquidity pools
- **Premium & Discount Zones** - Smart money entry areas
- **Kill Zones** - Optimal trading session times
- **Inducement (IDM)** - Retail trap identification
- **Optimal Trade Entry (OTE)** - Fibonacci-based entries
- **Market Structure Shift (MSS)** - Advanced reversal patterns

### 📊 Visual Learning
- SVG-based interactive chart visualizations
- Real-time TradingView charts integration
- Step-by-step visual explanations
- Annotated diagrams for each concept

### 🎮 Interactive Practice
- Concept quizzes with instant feedback
- Interactive exercises
- Progress tracking
- Analysis checklist for chart practice

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- pip (Python package manager)

### Installation

1. Navigate to the forex learning tool directory:
```bash
cd forex_ict_learning
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
python app.py
```

4. Open your browser and navigate to:
```
http://localhost:5000
```

## 📖 Learning Path

We recommend following this learning path for best results:

1. **Foundation** - Start with Market Structure (BOS, CHoCH)
2. **Price Imbalances** - Learn about Fair Value Gaps
3. **Liquidity** - Understand where stop losses cluster
4. **Order Blocks** - Identify institutional entry points
5. **Advanced** - Master Premium/Discount, Kill Zones, and OTE

## 🖥️ Pages Overview

### Home (`/`)
- Overview of all ICT concepts
- Quick navigation to each concept
- Recommended learning path

### Concept Detail (`/concept/<concept_id>`)
- Detailed explanation of each concept
- SVG visualizations
- How to identify
- Trading rules and tips

### Live Chart (`/chart`)
- Real-time TradingView integration
- Major forex pairs (EUR/USD, GBP/USD, etc.)
- Quick reference sidebar
- Analysis checklist

### Quiz (`/quiz/<concept_id>`)
- Multiple choice questions
- Instant feedback
- Score tracking
- Detailed explanations

### Practice (`/practice`)
- Interactive exercises
- Progress tracking
- Study resources

## 🔑 Key ICT Concepts Explained

### Fair Value Gap (FVG)
A price imbalance created when there's a gap between the wicks of candle 1 and candle 3 in a three-candle sequence. Price tends to return and fill these gaps.

### Break of Structure (BOS)
Occurs when price breaks and closes beyond a swing high (bullish) or swing low (bearish), confirming trend continuation.

### Change of Character (CHoCH)
The first break against the current trend, signaling a potential reversal. It's an early warning that market structure may be changing.

### Order Blocks
The last opposing candle before an impulsive move. These zones represent institutional order placement and often act as strong support/resistance.

### Liquidity
Areas where stop losses cluster (above swing highs for BSL, below swing lows for SSL). Smart money targets these pools before major moves.

## ⚠️ Disclaimer

This tool is for educational purposes only. Trading forex involves substantial risk of loss and is not suitable for all investors. Past performance is not indicative of future results. Always practice proper risk management and never trade with money you cannot afford to lose.

## 📝 License

This project is for educational purposes.
