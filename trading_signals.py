"""
Trading Signal Extraction System
Extracts 1-minute trading signals based on MQL4/MQL5 strategy parameters
"""

import math
import json
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from enum import Enum

class SignalType(Enum):
    CALL = "CALL"
    PUT = "PUT"
    HOLD = "HOLD"

@dataclass
class TradingConfig:
    """Configuration class for trading strategy parameters"""
    
    # Win Rate Filters
    mao_fixa: bool = False
    filtro_mao_fixa: float = 78.0
    aplica_filtro_no_gale: bool = False
    filtro_martingale: float = 92.0
    
    # TMA Filters
    tma231: bool = False
    periodo_tma5357: int = 4
    periodo_tma6357: int = 11
    periodo_tma664: int = 32
    
    tma234: bool = False
    periodo_tma536: int = 20
    periodo_tma636: int = 5
    periodo_tma635: int = 41
    
    # TWR OBITO Strategies
    tma2: bool = False
    periodo_tma5: int = 2
    periodo_tma6: int = 7
    periodo_tma7: int = 18
    periodo_tma8: int = 20
    periodo_tma9: int = 22
    
    tma3: bool = False
    periodo_tma10: int = 20
    periodo_tma11: int = 74
    
    tma4: bool = False
    periodo_tma12: int = 4
    periodo_tma13: int = 45
    periodo_tma14: int = 79
    periodo_tma15: int = 13
    periodo_tma16: int = 25
    
    # MACD Strategies
    ativa_macd2: bool = False
    macd_period4: int = 89
    macd_period5: int = 56
    macd_period6: int = 14
    
    ativa_macd: bool = False
    macd_period1: int = 12
    macd_period2: int = 26
    macd_period3: int = 9
    
    ativa_macd50: bool = False
    macd_period100: int = 6
    macd_period10: int = 13
    macd_period24: int = 6
    
    ativa_macd55: bool = False
    macd_period101: int = 5
    macd_period12: int = 12
    macd_period17: int = 3
    
    # RSI Strategies
    master_estrategia20: bool = False
    periodo_rsi2: int = 7
    max_rsi2: int = 9
    min_rsi2: int = 24
    
    periodo_rsi5: bool = False
    periodo_rsi0: int = 3
    periodo_rsi15: int = 65
    max_rsi10: int = 6
    min_rsi10: int = 87
    
    master_estrategia3: bool = True
    periodo_rsi: int = 3
    max_rsi: int = 65
    min_rsi: int = 35
    
    periodo_rsi6: bool = False
    periodo_rsi1: int = 0
    periodo_rsi16: int = 14
    max_rsi11: int = 30
    min_rsi11: int = 70
    
    periodo_rsi7: bool = False
    periodo_rsi30: int = 8
    periodo_rsi17: int = 1
    max_rsi12: int = 23
    min_rsi12: int = 50
    
    # Strategy Combinations
    sakib_kombiner_pro: bool = False
    master_estrategia: bool = True
    periodo_rsi12: int = 3
    max_rsi22: int = 65
    min_rsi32: int = 35
    
    master_estrategia1: bool = False
    periodo_rsi3: int = 3
    max_rsi1: int = 65
    min_rsi1: int = 35
    
    master_estrategia2: bool = False
    periodo_rsi20: int = 0
    max_rsi20: int = 0
    min_rsi20: int = 0
    
    # Trend Filters
    filtro_tendencia5: bool = False
    gi_84: int = 76
    gd_88: float = 0.0
    trend_gale: bool = False
    
    master_estrategia6: bool = True
    
    # Support and Resistance
    ser: bool = False
    media_movel: int = 14
    filtro_tendencia2: bool = False
    
    # Retraction Filters
    filt_ret: bool = False
    shadow_ratio: int = 80
    filt_ret_2: bool = False
    shadow_ratio2: int = 80

class TechnicalIndicators:
    """Technical indicators implementation for signal generation"""
    
    @staticmethod
    def calculate_rsi(prices: List[float], period: int) -> float:
        """Calculate RSI (Relative Strength Index)"""
        if len(prices) < period + 1:
            return 50.0
        
        deltas = [prices[i] - prices[i-1] for i in range(1, len(prices))]
        gains = [delta if delta > 0 else 0 for delta in deltas[-period:]]
        losses = [-delta if delta < 0 else 0 for delta in deltas[-period:]]
        
        avg_gain = sum(gains) / period if gains else 0.0001
        avg_loss = sum(losses) / period if losses else 0.0001
        
        # Prevent division by zero
        if avg_loss == 0:
            avg_loss = 0.0001
        
        rs = avg_gain / avg_loss
        rsi = 100 - (100 / (1 + rs))
        return rsi
    
    @staticmethod
    def calculate_macd(prices: List[float], fast_period: int, slow_period: int, signal_period: int) -> Tuple[float, float, float]:
        """Calculate MACD (Moving Average Convergence Divergence)"""
        if len(prices) < slow_period:
            return 0.0, 0.0, 0.0
        
        # Simple EMA calculation
        def ema(data: List[float], period: int) -> float:
            if len(data) < period:
                return sum(data) / len(data)
            
            k = 2 / (period + 1)
            ema_prev = sum(data[:period]) / period
            
            for price in data[period:]:
                ema_prev = (price * k) + (ema_prev * (1 - k))
            
            return ema_prev
        
        ema_fast = ema(prices, fast_period)
        ema_slow = ema(prices, slow_period)
        macd_line = ema_fast - ema_slow
        
        # For simplicity, using simple moving average for signal line
        signal_line = macd_line * 0.9  # Simplified signal calculation
        histogram = macd_line - signal_line
        
        return macd_line, signal_line, histogram
    
    @staticmethod
    def calculate_tma(prices: List[float], period: int) -> float:
        """Calculate TMA (Triangular Moving Average)"""
        if len(prices) < period:
            return sum(prices) / len(prices)
        
        # Simple implementation of TMA
        sma1 = sum(prices[-period:]) / period
        
        # Second smoothing
        if len(prices) >= period * 2:
            half_period = period // 2
            recent_prices = prices[-period:]
            sma_values = []
            
            for i in range(half_period, len(recent_prices)):
                sma_values.append(sum(recent_prices[i-half_period:i+1]) / (half_period + 1))
            
            tma = sum(sma_values) / len(sma_values) if sma_values else sma1
        else:
            tma = sma1
        
        return tma

class SignalGenerator:
    """Main signal generation class"""
    
    def __init__(self, config: TradingConfig):
        self.config = config
        self.indicators = TechnicalIndicators()
    
    def generate_signal(self, prices: List[float]) -> Dict:
        """Generate 1-minute trading signal based on configuration"""
        if len(prices) < 14:  # Minimum data required
            return {
                "signal": SignalType.HOLD,
                "confidence": 0.0,
                "reason": "Insufficient data",
                "strategies_used": []
            }
        
        signals = []
        strategies_used = []
        
        # RSI-based signals
        if self.config.master_estrategia3:
            rsi_signal = self._get_rsi_signal(prices, self.config.periodo_rsi, 
                                            self.config.max_rsi, self.config.min_rsi)
            if rsi_signal["signal"] != SignalType.HOLD:
                signals.append(rsi_signal)
                strategies_used.append("RSI-2")
        
        # MACD-based signals
        if self.config.ativa_macd:
            macd_signal = self._get_macd_signal(prices, self.config.macd_period1, 
                                              self.config.macd_period2, self.config.macd_period3)
            if macd_signal["signal"] != SignalType.HOLD:
                signals.append(macd_signal)
                strategies_used.append("TWR OBITO MACD")
        
        # TMA-based signals
        if self.config.tma231:
            tma_signal = self._get_tma_signal(prices, self.config.periodo_tma5357)
            if tma_signal["signal"] != SignalType.HOLD:
                signals.append(tma_signal)
                strategies_used.append("TMA #1")
        
        # Kombiner Pro Strategy
        if self.config.master_estrategia:
            kombiner_signal = self._get_kombiner_signal(prices)
            if kombiner_signal["signal"] != SignalType.HOLD:
                signals.append(kombiner_signal)
                strategies_used.append("TWR SS KOMBINER PRO STRATEGY")
        
        # Trend filter
        if self.config.master_estrategia6:
            trend_signal = self._get_trend_signal(prices)
            if trend_signal["signal"] != SignalType.HOLD:
                signals.append(trend_signal)
                strategies_used.append("TREND WIN RATE 1.0")
        
        return self._combine_signals(signals, strategies_used)
    
    def _get_rsi_signal(self, prices: List[float], period: int, max_rsi: int, min_rsi: int) -> Dict:
        """Generate signal based on RSI"""
        rsi = self.indicators.calculate_rsi(prices, period)
        
        if rsi > max_rsi:
            return {"signal": SignalType.PUT, "confidence": min(1.0, (rsi - max_rsi) / 10), "rsi": rsi}
        elif rsi < min_rsi:
            return {"signal": SignalType.CALL, "confidence": min(1.0, (min_rsi - rsi) / 10), "rsi": rsi}
        else:
            return {"signal": SignalType.HOLD, "confidence": 0.0, "rsi": rsi}
    
    def _get_macd_signal(self, prices: List[float], fast: int, slow: int, signal: int) -> Dict:
        """Generate signal based on MACD"""
        macd_line, signal_line, histogram = self.indicators.calculate_macd(prices, fast, slow, signal)
        
        if macd_line > signal_line and histogram > 0:
            return {"signal": SignalType.CALL, "confidence": min(1.0, abs(histogram) * 10), "macd": macd_line}
        elif macd_line < signal_line and histogram < 0:
            return {"signal": SignalType.PUT, "confidence": min(1.0, abs(histogram) * 10), "macd": macd_line}
        else:
            return {"signal": SignalType.HOLD, "confidence": 0.0, "macd": macd_line}
    
    def _get_tma_signal(self, prices: List[float], period: int) -> Dict:
        """Generate signal based on TMA"""
        if len(prices) < 2:
            return {"signal": SignalType.HOLD, "confidence": 0.0}
        
        tma = self.indicators.calculate_tma(prices, period)
        current_price = prices[-1]
        
        # Prevent division by zero
        if tma == 0:
            return {"signal": SignalType.HOLD, "confidence": 0.0, "tma": tma}
        
        price_diff = (current_price - tma) / tma
        
        if price_diff > 0.001:  # Price above TMA
            return {"signal": SignalType.CALL, "confidence": min(1.0, abs(price_diff) * 100), "tma": tma}
        elif price_diff < -0.001:  # Price below TMA
            return {"signal": SignalType.PUT, "confidence": min(1.0, abs(price_diff) * 100), "tma": tma}
        else:
            return {"signal": SignalType.HOLD, "confidence": 0.0, "tma": tma}
    
    def _get_kombiner_signal(self, prices: List[float]) -> Dict:
        """Generate signal based on Kombiner strategy (combination of multiple indicators)"""
        rsi_signal = self._get_rsi_signal(prices, self.config.periodo_rsi12, 
                                        self.config.max_rsi22, self.config.min_rsi32)
        
        # Simple momentum check
        if len(prices) >= 3:
            momentum = (prices[-1] - prices[-3]) / prices[-3]
            
            if rsi_signal["signal"] == SignalType.CALL and momentum > 0:
                return {"signal": SignalType.CALL, "confidence": 0.8, "momentum": momentum}
            elif rsi_signal["signal"] == SignalType.PUT and momentum < 0:
                return {"signal": SignalType.PUT, "confidence": 0.8, "momentum": momentum}
        
        return {"signal": SignalType.HOLD, "confidence": 0.0}
    
    def _get_trend_signal(self, prices: List[float]) -> Dict:
        """Generate signal based on trend analysis"""
        if len(prices) < 10:
            return {"signal": SignalType.HOLD, "confidence": 0.0}
        
        # Simple trend detection using linear regression slope
        n = min(10, len(prices))
        recent_prices = prices[-n:]
        
        # Calculate slope
        x_values = list(range(n))
        x_mean = sum(x_values) / n
        y_mean = sum(recent_prices) / n
        
        numerator = sum((x_values[i] - x_mean) * (recent_prices[i] - y_mean) for i in range(n))
        denominator = sum((x_values[i] - x_mean) ** 2 for i in range(n))
        
        if denominator == 0 or y_mean == 0:
            return {"signal": SignalType.HOLD, "confidence": 0.0}
        
        slope = numerator / denominator
        slope_percentage = (slope / y_mean) * 100
        
        if slope_percentage > 0.1:
            return {"signal": SignalType.CALL, "confidence": min(1.0, abs(slope_percentage) / 2), "trend": "UP"}
        elif slope_percentage < -0.1:
            return {"signal": SignalType.PUT, "confidence": min(1.0, abs(slope_percentage) / 2), "trend": "DOWN"}
        else:
            return {"signal": SignalType.HOLD, "confidence": 0.0, "trend": "SIDEWAYS"}
    
    def _combine_signals(self, signals: List[Dict], strategies_used: List[str]) -> Dict:
        """Combine multiple signals into final decision"""
        if not signals:
            return {
                "signal": SignalType.HOLD,
                "confidence": 0.0,
                "reason": "No active strategies generated signals",
                "strategies_used": strategies_used,
                "details": {}
            }
        
        # Count signals by type
        call_signals = [s for s in signals if s["signal"] == SignalType.CALL]
        put_signals = [s for s in signals if s["signal"] == SignalType.PUT]
        
        # Calculate weighted confidence
        call_confidence = sum(s.get("confidence", 0) for s in call_signals) / len(signals)
        put_confidence = sum(s.get("confidence", 0) for s in put_signals) / len(signals)
        
        if len(call_signals) > len(put_signals):
            final_signal = SignalType.CALL
            final_confidence = call_confidence
            reason = f"Majority CALL signals ({len(call_signals)}/{len(signals)})"
        elif len(put_signals) > len(call_signals):
            final_signal = SignalType.PUT
            final_confidence = put_confidence
            reason = f"Majority PUT signals ({len(put_signals)}/{len(signals)})"
        else:
            if call_confidence > put_confidence:
                final_signal = SignalType.CALL
                final_confidence = call_confidence
                reason = "Higher CALL confidence"
            elif put_confidence > call_confidence:
                final_signal = SignalType.PUT
                final_confidence = put_confidence
                reason = "Higher PUT confidence"
            else:
                final_signal = SignalType.HOLD
                final_confidence = 0.0
                reason = "Conflicting signals"
        
        return {
            "signal": final_signal,
            "confidence": round(final_confidence, 3),
            "reason": reason,
            "strategies_used": strategies_used,
            "details": {
                "total_signals": len(signals),
                "call_signals": len(call_signals),
                "put_signals": len(put_signals),
                "individual_signals": signals
            }
        }

def create_default_config() -> TradingConfig:
    """Create default trading configuration based on problem statement"""
    return TradingConfig(
        # Activate key strategies mentioned in problem statement
        master_estrategia3=True,  # RSI-2 (enabled by default)
        master_estrategia=True,   # TWR SS KOMBINER PRO STRATEGY (enabled by default)
        master_estrategia6=True,  # TREND WIN RATE 1.0 (enabled by default)
    )

# Example usage and testing
if __name__ == "__main__":
    # Sample price data for testing (simulating 1-minute price movements)
    sample_prices = [
        100.0, 100.2, 100.1, 100.3, 100.5, 100.4, 100.6, 100.8, 100.7, 100.9,
        101.0, 100.8, 100.9, 101.2, 101.1, 101.3, 101.5, 101.4, 101.6, 101.8
    ]
    
    # Create configuration
    config = create_default_config()
    
    # Generate signal
    generator = SignalGenerator(config)
    result = generator.generate_signal(sample_prices)
    
    print("1-Minute Trading Signal:")
    print(f"Signal: {result['signal'].value}")
    print(f"Confidence: {result['confidence']:.1%}")
    print(f"Reason: {result['reason']}")
    print(f"Strategies Used: {', '.join(result['strategies_used'])}")
    print(f"Details: {json.dumps(result['details'], indent=2, default=str)}")