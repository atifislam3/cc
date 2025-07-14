import sys
import requests 
import json
from bs4 import BeautifulSoup
from pyfiglet import Figlet 
import colorama
import time
import asyncio
import os
from corex import bin
from trading_signals import SignalGenerator, TradingConfig, create_default_config
from mql_config import parse_mql_config, print_active_strategies

def detect_os():
    if "win" in sys.platform:
        return "windows"
    else:
        return "linux"


rd = colorama.Fore.RED
cv = colorama.Fore.WHITE
mag = colorama.Fore.MAGENTA
bl = colorama.Fore.BLUE
gn = colorama.Fore.GREEN
yl = colorama.Fore.YELLOW
cy = colorama.Fore.CYAN
gg = colorama.Fore.LIGHTCYAN_EX


def logo():
    figlet = Figlet(font="standard").renderText("VENOMPRIME")
    return (gn + figlet)
print (logo())
print (bl + "[-] VENOMPRIME Security Team ")
print (gn + "[+] Made By VENOMPRIME")
print (cy + "[=] VENOMPRIME Tools Version : 1.1")

opr = input (mag + "\n[x] 1) Generate single valid cc\n[x] 2) Generate multi valid cc (generate cc list)\n[x] 3) CC validator\n[x] 4) Generate Multi Bin Number\n[x] 5) 1-Minute Trading Signal Generator\n\n[^] Please Enter an option :  ")

def genscard():
    cookies = {"csrftoken":"8b56rI96TwUH0X7dOT86JmPMBbUVYEpX3EI7ZKp3ZXHWnrRySD9ORyNaAaRXnW7i","_ga":"GA1.2.1579916434.1654760883","_gid":"GA1.2.1410860416.1654760883","_gads":"ID=d4f0fe2265535514-2243e178fad30069:T=1654760893:RT=1654760893:S=ALNI_MaIzJo5Kmg3rKoLXSuvDGnQkyW3uw","_gpi":"UID=0000087f297f7f43:T=1654760893:RT=1654760893:S=ALNI_MbnajBnRWmSHW7vrpR-U1w2uMwyVw",'FCNEC':'[["AKsRol_6etCde6kaPNd_o13SF2anvKLy0qaXvN6Kz0O_d9YbYS_KOfZ-j0xDjsEXL_4Otx5R38juHOOwfg0JShy5DHGmgAw2R6ZN4KZyI3qGimMjR0mQ0SEgj2ncvV4jQ32pssYst9ml2ptS_Ip2XyPbrLivgKXjIQ=="],null,[]]'}
    headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36","content-type":"application/x-www-form-urlencoded","x-csrftoken":"xr2Iy5sVk1nFVZaOfDTiLTU03sLe4oLYsUFJ67ISqsaUitU9jnU0T5So2rIgtGtj","x-requested-with":"XMLHttpRequest"}
    payload = {"brand":"VISA","country":"UNITED STATES","bank":"121 FINANCIAL C.U.","cvv":"","date":"","year":"","range":"500 - 1000","amount":"10","dataformat":"TEXT","pin":"on","ctoken":"xr2Iy5sVk1nFVZaOfDTiLTU03sLe4oLYsUFJ67ISqsaUitU9jnU0T5So2rIgtGtj"}
    sitex = "https://www.vccgenerator.org/fetchdata/generate-home-credit-card/"
    rs = requests.post(sitex , headers=headers , cookies=cookies,data=payload)
    data = json.loads(rs.text)
    card = data['creditCard'][1]
    return (gn + "[-] Brand : %s\n[-] Card Number : %s\n[-] Bank : %s\n[-] Name : %s\n[-] Address : %s\n[-] Country : %s\n[-] Money Range : %s\n[-] CVV : %s\n[-] Expiry : %s\n[-] Pin : %s\n============================\n[*] Telegram : @VENOMPRIME" % (card['IssuingNetwork'] , card['CardNumber'] , card['Bank'] , card['Name'] , card['Address'] , card['Country'] , card['MoneyRange'] , card['CVV'] , card['Expiry'] , card['Pin']) + cv)

def genmcard():
    cookies = {"csrftoken":"8b56rI96TwUH0X7dOT86JmPMBbUVYEpX3EI7ZKp3ZXHWnrRySD9ORyNaAaRXnW7i","_ga":"GA1.2.1579916434.1654760883","_gid":"GA1.2.1410860416.1654760883","_gads":"ID=d4f0fe2265535514-2243e178fad30069:T=1654760893:RT=1654760893:S=ALNI_MaIzJo5Kmg3rKoLXSuvDGnQkyW3uw","_gpi":"UID=0000087f297f7f43:T=1654760893:RT=1654760893:S=ALNI_MbnajBnRWmSHW7vrpR-U1w2uMwyVw",'FCNEC':'[["AKsRol_6etCde6kaPNd_o13SF2anvKLy0qaXvN6Kz0O_d9YbYS_KOfZ-j0xDjsEXL_4Otx5R38juHOOwfg0JShy5DHGmgAw2R6ZN4KZyI3qGimMjR0mQ0SEgj2ncvV4jQ32pssYst9ml2ptS_Ip2XyPbrLivgKXjIQ=="],null,[]]'}
    headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36","content-type":"application/x-www-form-urlencoded","x-csrftoken":"xr2Iy5sVk1nFVZaOfDTiLTU03sLe4oLYsUFJ67ISqsaUitU9jnU0T5So2rIgtGtj","x-requested-with":"XMLHttpRequest"}
    payload = {"brand":"VISA","country":"UNITED STATES","bank":"121 FINANCIAL C.U.","cvv":"","date":"","year":"","range":"500 - 1000","amount":"10","dataformat":"TEXT","pin":"on","ctoken":"xr2Iy5sVk1nFVZaOfDTiLTU03sLe4oLYsUFJ67ISqsaUitU9jnU0T5So2rIgtGtj"}
    sitex = "https://www.vccgenerator.org/fetchdata/generate-home-credit-card/"
    rs = requests.post(sitex , headers=headers , cookies=cookies,data=payload)
    data = json.loads(rs.text)
    open("generated_card.txt","w").write("")
    for i in range(1,10):
        card = data['creditCard'][i]
        f = open("generated_card.txt","a")
        f.write("[-] Brand : %s\n[-] Card Number : %s\n[-] Bank : %s\n[-] Name : %s\n[-] Address : %s\n[-] Country : %s\n[-] Money Range : %s\n[-] CVV : %s\n[-] Expiry : %s\n[-] Pin : %s\n===================================\n" % (card['IssuingNetwork'] , card['CardNumber'] , card['Bank'] , card['Name'] , card['Address'] , card['Country'] , card['MoneyRange'] , card['CVV'] , card['Expiry'] , card['Pin']))
    return (gn + "[$] The operation has been success\n[+] Saved File as generated_card.txt" + cv)

def ccvalidator(number , type):
    site = "https://www.tools4noobs.com/"
    payload = {"action":"ajax_credit_card_validate","text":number,"cc":type}
    result = requests.post(site , data=payload)
    soup = BeautifulSoup(result.text ,"html.parser")
    return (bl + soup.text + cv)

def trading_signal_generator():
    """Generate 1-minute trading signals based on MQL4/MQL5 strategy parameters"""
    print(gn + "[&] 1-Minute Trading Signal Generator")
    print(cy + "[+] Based on MQL4/MQL5 Strategy Parameters")
    print(yl + "[-] Enter price data (comma-separated) for signal analysis")
    print(mag + "[-] Example: 100.0,100.2,100.1,100.3,100.5,100.4,100.6")
    
    price_input = input(bl + "\n[$] Enter price data: " + cv)
    
    try:
        # Parse price data
        if not price_input.strip():
            # Use sample data if no input provided
            prices = [100.0, 100.2, 100.1, 100.3, 100.5, 100.4, 100.6, 100.8, 100.7, 100.9,
                     101.0, 100.8, 100.9, 101.2, 101.1, 101.3, 101.5, 101.4, 101.6, 101.8]
            print(yl + "[*] Using sample price data for demonstration")
        else:
            prices = [float(x.strip()) for x in price_input.split(',')]
        
        if len(prices) < 10:
            print(rd + "[!] Warning: Limited price data may affect signal accuracy")
        
        # Create configuration with strategies from problem statement
        config = parse_mql_config()
        
        # Generate signal
        generator = SignalGenerator(config)
        result = generator.generate_signal(prices)
        
        # Display results
        print(gn + "\n" + "="*60)
        print(gn + "         1-MINUTE TRADING SIGNAL ANALYSIS")
        print(gn + "="*60)
        
        signal_color = gn if result['signal'].value == "CALL" else rd if result['signal'].value == "PUT" else yl
        
        print(signal_color + f"[+] SIGNAL: {result['signal'].value}")
        print(cy + f"[+] CONFIDENCE: {result['confidence']:.1%}")
        print(bl + f"[+] REASON: {result['reason']}")
        print(mag + f"[+] STRATEGIES USED: {', '.join(result['strategies_used'])}")
        
        if result['details']['individual_signals']:
            print(yl + "\n[*] Individual Strategy Signals:")
            for i, signal in enumerate(result['details']['individual_signals'], 1):
                sig_type = signal['signal'].value
                conf = signal.get('confidence', 0)
                print(f"    {i}. {sig_type} (Confidence: {conf:.1%})")
        
        # Strategy explanations
        print(gn + "\n[*] Active Strategy Configurations:")
        active_strategies = []
        if config.master_estrategia3:
            active_strategies.append(f"RSI-2: Period={config.periodo_rsi}, Max={config.max_rsi}, Min={config.min_rsi}")
        if config.master_estrategia:
            active_strategies.append(f"TWR SS KOMBINER PRO: RSI Period={config.periodo_rsi12}")
        if config.master_estrategia6:
            active_strategies.append("TREND WIN RATE 1.0: Enabled")
        
        for strategy in active_strategies:
            print(f"    • {strategy}")
        
        print(gn + "\n" + "="*60)
        print(cv + "[*] Signal generated based on MQL4/MQL5 parameters")
        print(mag + "[$] Telegram: @VENOMPRIME")
        
        # Save to file
        signal_data = {
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
            "prices_analyzed": len(prices),
            "signal": result['signal'].value,
            "confidence": result['confidence'],
            "reason": result['reason'],
            "strategies_used": result['strategies_used'],
            "price_data": prices[-10:]  # Last 10 prices for reference
        }
        
        with open("trading_signal.json", "w") as f:
            json.dump(signal_data, f, indent=2)
        
        print(gn + f"[+] Signal data saved to trading_signal.json")
        
        return f"Signal: {result['signal'].value} | Confidence: {result['confidence']:.1%} | Strategies: {len(result['strategies_used'])}"
        
    except ValueError:
        return rd + "[!] Error: Invalid price data format. Please use comma-separated numbers."
    except Exception as e:
        return rd + f"[!] Error generating signal: {str(e)}"

if opr == "1":
    print (cy + "[&] You selected first option ! \n\n")
    time.sleep(1)
    print (genscard())
elif opr == "2":
    print (yl + "[&] You selected second option ! \n\n")
    print (genmcard())
elif opr == "3":
    print (mag + "[&] You selected third option !! \n\n")
    number = input(yl + "[$] Please Enter your card number : ")
    if detect_os() == "windows":
        popen = os.popen("node corex\\val.js " + number).read()
        print (bl + popen + cv)
    else:
        popen = os.popen("node corex/val.js " + number).read()
        print (bl + popen + cv)
elif opr == "4":
    print (bl + "[&] You Selected Fourth Option !")
    time.sleep(0.3)
    number = input(gn + "[-] Please Enter Bin Number -  > ")
    round = input(cy + "[+] Pleae Enter Quanity ex : (10) - > ")
    print (rd)
    bin.bin_generator(number , round)
    print ("Saved File as bin_generated.txt !")
    print (mag + "[$] Telegram : @VENOMPRIME" + cv)
elif opr == "5":
    print (gn + "[&] You Selected Fifth Option !")
    time.sleep(0.3)
    result = trading_signal_generator()
    print (yl + f"\n[*] Operation Result: {result}")
else:
    print (rd + "[!] Invalid option selected!")
    print (mag + "[$] Telegram : @VENOMPRIME" + cv)
