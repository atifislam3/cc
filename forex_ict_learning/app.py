"""
Forex ICT Concepts Learning Tool
A comprehensive educational application for learning Inner Circle Trader (ICT) concepts
Including: FVG, BOS, CHoCH, IDM, Order Blocks, Liquidity, and more
"""

from flask import Flask, render_template, jsonify, request
import json

app = Flask(__name__)

# ICT Concepts Database
ICT_CONCEPTS = {
    "fvg": {
        "name": "Fair Value Gap (FVG)",
        "short_name": "FVG",
        "category": "Price Action",
        "difficulty": "Beginner",
        "description": """
        A Fair Value Gap (FVG) is an imbalance in price action that occurs when there is a gap between 
        candlesticks where price didn't trade. It represents areas where aggressive buying or selling 
        created an inefficiency in the market.
        
        FVGs are created when the wick of a candle doesn't overlap with the wick of the candle 
        two positions away, leaving a gap in price.
        """,
        "how_to_identify": [
            "Look for three consecutive candlesticks",
            "Check if the wick of candle 1 doesn't touch the wick of candle 3",
            "The gap between these wicks is the FVG",
            "Bullish FVG: Gap above price (occurs in upward moves)",
            "Bearish FVG: Gap below price (occurs in downward moves)"
        ],
        "trading_rules": [
            "Price tends to return to fill FVGs (mean reversion)",
            "FVGs act as support/resistance levels",
            "Use FVGs as entry points in the direction of the trend",
            "Combine with higher timeframe bias for better accuracy",
            "Look for FVGs in premium/discount zones"
        ],
        "image_description": "Three candlestick formation showing gap between candle 1 and candle 3 wicks",
        "visual_elements": ["candle_1", "candle_2", "candle_3", "gap_zone"]
    },
    "bos": {
        "name": "Break of Structure (BOS)",
        "short_name": "BOS",
        "category": "Market Structure",
        "difficulty": "Beginner",
        "description": """
        Break of Structure (BOS) occurs when price breaks through a previous swing high or swing low, 
        indicating a continuation of the current trend. It's a key concept in understanding market 
        structure and trend direction.
        
        A bullish BOS happens when price breaks above a previous swing high.
        A bearish BOS happens when price breaks below a previous swing low.
        """,
        "how_to_identify": [
            "Identify the current market structure (higher highs/higher lows or lower highs/lower lows)",
            "Mark the most recent swing high and swing low",
            "Wait for price to break beyond these levels",
            "A break with body close confirmation is stronger than a wick break",
            "Volume can confirm the strength of the break"
        ],
        "trading_rules": [
            "Trade in the direction of the BOS",
            "Wait for a pullback after BOS for entry",
            "Use the broken level as support/resistance",
            "Combine with FVG for high-probability entries",
            "Always consider the higher timeframe trend"
        ],
        "image_description": "Price action showing swing highs and lows with break confirmation",
        "visual_elements": ["swing_high", "swing_low", "break_candle", "trend_direction"]
    },
    "choch": {
        "name": "Change of Character (CHoCH)",
        "short_name": "CHoCH",
        "category": "Market Structure",
        "difficulty": "Intermediate",
        "description": """
        Change of Character (CHoCH) signals a potential reversal in market structure. Unlike BOS which 
        continues the trend, CHoCH indicates that the market might be changing direction.
        
        It occurs when price breaks a swing point in the opposite direction of the current trend,
        suggesting that buyers/sellers are losing control.
        """,
        "how_to_identify": [
            "In an uptrend: Look for price to break below the most recent higher low",
            "In a downtrend: Look for price to break above the most recent lower high",
            "The first break against the trend is the CHoCH",
            "Confirmation comes with a follow-through BOS in the new direction",
            "Often occurs at key levels or after extended moves"
        ],
        "trading_rules": [
            "CHoCH is an early warning signal, not an immediate entry",
            "Wait for confirmation before trading the reversal",
            "Look for CHoCH at premium/discount zones",
            "Combine with divergence for stronger signals",
            "Use smaller position sizes for CHoCH trades"
        ],
        "image_description": "Trend reversal showing the first break against the prevailing trend",
        "visual_elements": ["previous_trend", "choch_point", "new_direction", "confirmation"]
    },
    "idm": {
        "name": "Inducement (IDM)",
        "short_name": "IDM",
        "category": "Liquidity",
        "difficulty": "Intermediate",
        "description": """
        Inducement (IDM) refers to obvious levels where retail traders place their stop losses, 
        which smart money targets to grab liquidity before the real move. These are essentially 
        'trap' levels that appear to be valid trading opportunities.
        
        Smart money uses these levels to accumulate positions by triggering retail stop losses.
        """,
        "how_to_identify": [
            "Look for obvious swing points that retail traders would use",
            "Equal highs/lows are prime inducement areas",
            "Minor swing points within a larger structure",
            "Areas where stop losses would naturally be placed",
            "Often appears as small consolidation areas"
        ],
        "trading_rules": [
            "Don't place stops at obvious levels",
            "Wait for inducement to be taken before entering",
            "Use inducement runs as entry triggers",
            "Expect price to run inducement before reversing",
            "Combine with order blocks for high-probability trades"
        ],
        "image_description": "Price levels showing liquidity pools and stop-loss hunting areas",
        "visual_elements": ["retail_stops", "liquidity_grab", "real_direction", "smart_money_entry"]
    },
    "order_blocks": {
        "name": "Order Blocks (OB)",
        "short_name": "OB",
        "category": "Supply & Demand",
        "difficulty": "Intermediate",
        "description": """
        Order Blocks are specific candlesticks or price areas where institutional traders have placed 
        significant orders. They represent the last up-close candle before a down move (bearish OB) 
        or the last down-close candle before an up move (bullish OB).
        
        These zones often act as strong support/resistance where price is likely to react.
        """,
        "how_to_identify": [
            "Bullish OB: Last bearish candle before an impulsive bullish move",
            "Bearish OB: Last bullish candle before an impulsive bearish move",
            "The move away from the OB should be aggressive",
            "OB should lead to a BOS for validity",
            "Use the body of the candle, not just the wicks"
        ],
        "trading_rules": [
            "Enter trades when price returns to the OB",
            "Place stop loss beyond the OB",
            "Look for OBs at key structural levels",
            "Higher timeframe OBs are more significant",
            "Combine with FVG inside OB for precision entries"
        ],
        "image_description": "Candlestick pattern showing institutional order placement zone",
        "visual_elements": ["last_candle", "impulsive_move", "ob_zone", "reaction"]
    },
    "liquidity": {
        "name": "Liquidity Concepts",
        "short_name": "LIQ",
        "category": "Liquidity",
        "difficulty": "Beginner",
        "description": """
        Liquidity refers to the availability of orders at certain price levels. In ICT methodology, 
        liquidity pools exist where stop losses and pending orders cluster. Smart money targets 
        these pools to fill their large orders.
        
        Types include: Buy-side liquidity (above highs), Sell-side liquidity (below lows), 
        and Internal liquidity (within ranges).
        """,
        "how_to_identify": [
            "Buy-side liquidity: Above swing highs and equal highs",
            "Sell-side liquidity: Below swing lows and equal lows",
            "Old highs/lows that haven't been tested",
            "Areas of consolidation contain internal liquidity",
            "Trendlines also represent liquidity pools"
        ],
        "trading_rules": [
            "Expect liquidity to be taken before reversal",
            "Don't trade until liquidity has been grabbed",
            "Use liquidity sweeps as entry triggers",
            "Target the opposite liquidity pool",
            "Combine with time analysis (Kill Zones)"
        ],
        "image_description": "Chart showing buy-side and sell-side liquidity pools",
        "visual_elements": ["buy_side_liq", "sell_side_liq", "liquidity_sweep", "reversal"]
    },
    "premium_discount": {
        "name": "Premium & Discount Zones",
        "short_name": "P&D",
        "category": "Price Action",
        "difficulty": "Beginner",
        "description": """
        Premium and Discount zones divide any price range into two halves using the equilibrium 
        (50% level). Premium is above equilibrium (expensive), and Discount is below (cheap).
        
        Smart money buys in discount zones and sells in premium zones. This concept helps 
        identify optimal entry areas within any price range.
        """,
        "how_to_identify": [
            "Identify a significant swing high and swing low",
            "Calculate the 50% (equilibrium) level",
            "Above 50% = Premium zone (sell zone)",
            "Below 50% = Discount zone (buy zone)",
            "Use Fibonacci retracement tool (0.5 level is equilibrium)"
        ],
        "trading_rules": [
            "Look for longs only in discount zones",
            "Look for shorts only in premium zones",
            "Best entries are deep in discount/premium",
            "Combine with FVG and OB in these zones",
            "Higher probability when aligned with HTF bias"
        ],
        "image_description": "Price range divided into premium and discount zones",
        "visual_elements": ["swing_high", "swing_low", "equilibrium", "premium_zone", "discount_zone"]
    },
    "kill_zones": {
        "name": "Kill Zones (Trading Sessions)",
        "short_name": "KZ",
        "category": "Time & Price",
        "difficulty": "Intermediate",
        "description": """
        Kill Zones are specific time windows when the market is most active and volatile. 
        These are the times when institutional traders are most active and when the best 
        trading opportunities occur.
        
        The main Kill Zones are: Asian, London, and New York sessions.
        """,
        "how_to_identify": [
            "Asian Kill Zone: 20:00-00:00 EST",
            "London Kill Zone: 02:00-05:00 EST",
            "New York Kill Zone: 07:00-10:00 EST",
            "London Close: 10:00-12:00 EST",
            "These times see the highest volume and volatility"
        ],
        "trading_rules": [
            "Focus trading during Kill Zones for best moves",
            "Asian session often sets up the daily range",
            "London session often reverses Asian moves",
            "New York session provides continuation or reversal",
            "Avoid trading outside Kill Zones"
        ],
        "image_description": "24-hour chart showing different trading session zones",
        "visual_elements": ["asian_session", "london_session", "ny_session", "time_markers"]
    },
    "optimal_trade_entry": {
        "name": "Optimal Trade Entry (OTE)",
        "short_name": "OTE",
        "category": "Entry Techniques",
        "difficulty": "Advanced",
        "description": """
        Optimal Trade Entry (OTE) is a precise entry technique using Fibonacci retracement levels. 
        The OTE zone is typically between the 62% and 79% retracement of an impulsive move, 
        which is considered the "sweet spot" for entries.
        
        This zone provides the best risk-to-reward ratio for trades.
        """,
        "how_to_identify": [
            "Identify an impulsive move in your trading direction",
            "Apply Fibonacci retracement from swing to swing",
            "The OTE zone is between 0.618 and 0.786 levels",
            "Look for confluence with FVG or OB in this zone",
            "Wait for a reaction at this level before entry"
        ],
        "trading_rules": [
            "Only enter at OTE when in line with bias",
            "Use limit orders at the OTE zone",
            "Place stop loss beyond the swing point",
            "Target at least 1:2 risk-to-reward",
            "Best used in Kill Zones"
        ],
        "image_description": "Fibonacci retracement showing the optimal entry zone",
        "visual_elements": ["impulsive_move", "fib_levels", "ote_zone", "entry_point"]
    },
    "market_structure_shift": {
        "name": "Market Structure Shift (MSS)",
        "short_name": "MSS",
        "category": "Market Structure",
        "difficulty": "Advanced",
        "description": """
        Market Structure Shift (MSS) is essentially a stronger form of CHoCH. It occurs when 
        the market structure definitively changes from bullish to bearish or vice versa, 
        often with a clear displacement move.
        
        MSS provides high-probability reversal signals when combined with other ICT concepts.
        """,
        "how_to_identify": [
            "Look for a clear trend in place",
            "Identify liquidity being swept",
            "Watch for aggressive displacement move",
            "Structure shift with body close confirmation",
            "Should create a FVG during the shift"
        ],
        "trading_rules": [
            "MSS at key levels is high probability",
            "Wait for price to return to the FVG after MSS",
            "Use the MSS swing as stop loss reference",
            "Target opposing liquidity pool",
            "Best when aligned with higher timeframe structure"
        ],
        "image_description": "Complete market structure change with displacement",
        "visual_elements": ["old_structure", "liquidity_sweep", "displacement", "new_structure"]
    }
}

# Quiz questions for each concept
QUIZ_QUESTIONS = {
    "fvg": [
        {
            "question": "What creates a Fair Value Gap?",
            "options": [
                "When price consolidates for a long time",
                "When there's a gap between candle 1's wick and candle 3's wick",
                "When two candles have the same close",
                "When volume is very low"
            ],
            "correct": 1,
            "explanation": "A FVG is created when there's a gap between the wicks of candle 1 and candle 3, indicating an imbalance in price action."
        },
        {
            "question": "What tends to happen after a FVG is created?",
            "options": [
                "Price continues in the same direction forever",
                "Price tends to return and fill the gap",
                "The gap becomes larger over time",
                "Volume always increases"
            ],
            "correct": 1,
            "explanation": "Price tends to return to fill FVGs due to mean reversion, making them excellent entry points."
        }
    ],
    "bos": [
        {
            "question": "What confirms a Break of Structure?",
            "options": [
                "Price touching a level briefly",
                "A candle body close beyond the swing point",
                "High volume only",
                "A specific candlestick pattern"
            ],
            "correct": 1,
            "explanation": "A body close beyond the swing high/low provides stronger confirmation than just a wick break."
        },
        {
            "question": "A bullish BOS occurs when:",
            "options": [
                "Price breaks below a swing low",
                "Price makes a lower high",
                "Price breaks above a swing high",
                "Price creates a FVG"
            ],
            "correct": 2,
            "explanation": "A bullish BOS happens when price breaks and closes above a previous swing high, indicating trend continuation."
        }
    ],
    "choch": [
        {
            "question": "What does CHoCH indicate?",
            "options": [
                "Trend continuation",
                "Potential trend reversal",
                "Range bound market",
                "News event"
            ],
            "correct": 1,
            "explanation": "CHoCH (Change of Character) signals a potential reversal in market structure, unlike BOS which continues the trend."
        }
    ],
    "order_blocks": [
        {
            "question": "What is a bullish Order Block?",
            "options": [
                "The last bullish candle before a down move",
                "The last bearish candle before an up move",
                "Any green candle",
                "A candle with high volume"
            ],
            "correct": 1,
            "explanation": "A bullish OB is the last bearish candle before an impulsive bullish move, representing institutional buying."
        }
    ],
    "liquidity": [
        {
            "question": "Where is buy-side liquidity located?",
            "options": [
                "Below swing lows",
                "At the 50% level",
                "Above swing highs and equal highs",
                "Inside consolidation areas only"
            ],
            "correct": 2,
            "explanation": "Buy-side liquidity exists above swing highs and equal highs where stop losses from short positions cluster."
        }
    ]
}


@app.route('/')
def home():
    """Home page with overview of ICT concepts"""
    return render_template('index.html', concepts=ICT_CONCEPTS)


@app.route('/concept/<concept_id>')
def concept_detail(concept_id):
    """Detailed page for each ICT concept"""
    if concept_id in ICT_CONCEPTS:
        concept = ICT_CONCEPTS[concept_id]
        return render_template('concept.html', concept=concept, concept_id=concept_id)
    return "Concept not found", 404


@app.route('/quiz/<concept_id>')
def quiz(concept_id):
    """Quiz page for testing understanding"""
    if concept_id in QUIZ_QUESTIONS:
        questions = QUIZ_QUESTIONS[concept_id]
        concept = ICT_CONCEPTS.get(concept_id, {})
        return render_template('quiz.html', questions=questions, concept=concept, concept_id=concept_id)
    return render_template('quiz.html', questions=[], concept=ICT_CONCEPTS.get(concept_id, {}), concept_id=concept_id)


@app.route('/chart')
def live_chart():
    """Live chart page with TradingView widget"""
    return render_template('chart.html')


@app.route('/practice')
def practice():
    """Practice area with interactive exercises"""
    return render_template('practice.html', concepts=ICT_CONCEPTS)


@app.route('/api/concepts')
def api_concepts():
    """API endpoint for all concepts"""
    return jsonify(ICT_CONCEPTS)


@app.route('/api/concept/<concept_id>')
def api_concept(concept_id):
    """API endpoint for a specific concept"""
    if concept_id in ICT_CONCEPTS:
        return jsonify(ICT_CONCEPTS[concept_id])
    return jsonify({"error": "Concept not found"}), 404


@app.route('/api/quiz/<concept_id>')
def api_quiz(concept_id):
    """API endpoint for quiz questions"""
    if concept_id in QUIZ_QUESTIONS:
        return jsonify(QUIZ_QUESTIONS[concept_id])
    return jsonify([])


if __name__ == '__main__':
    import os
    debug_mode = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    app.run(debug=debug_mode, port=5000)
