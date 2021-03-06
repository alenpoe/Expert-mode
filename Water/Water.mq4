//+------------------------------------------------------------------+
//|                                                        Water.mq4 |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "Common\MoneyManager.mqh"
#include "Common\OrderManager.mqh"
#include "Common\EnvChecker.mqh"
#include "Common\TradeSystemController.mqh"
#include "Common\Log.mqh"
#include "Common\ShowUtil.mqh"
#include "Common\Const.mqh"
#include "Common\TSControllerFactory.mqh"

CTradeSystemController *controller = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   LogR("OnInit...");
   controller = CTSControllerFactory::Create();
   EventSetTimer(60);   // Trigger timer every 60 seconds
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   LogR("OnDeinit...reason=",IntegerToString(reason));
   delete(controller);
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   LogR("OnTimer...");
   CheckSafe();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Check the runtime environment
   if(!CheckEnv())
      return;
// Update the max equity
   CMoneyManager::UpdateMaxEquity();
// Process trade signals
   ProcessTradeSignals();
// Show some info on screen
   ShowInfo();
  }

//+------------------------------------------------------------------+
//| Process trade signals, and check when to open or close orders
//+------------------------------------------------------------------+
void ProcessTradeSignals()
  {
   int signal = controller.ComputeTradeSignal();
   switch(signal)
     {
      case SIGNAL_OPEN_BUY:
         if(OpenBuy())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_OPEN_SELL:
         if(OpenSell())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_CLOSE_BUY:
      case SIGNAL_CLOSE_SELL:
         CloseOrder();
     }

// CheckStopLoss(); // TODO
// CheckTakeProfit(); // TODO
  }

//+------------------------------------------------------------------+
//| Check the safety of the position regularly,
//| to see if there is no need for manual intervention                                                              |
//+------------------------------------------------------------------+
void CheckSafe()
  {
   int state = controller.GetSafeState();
   string msg = "";
   switch(state)
     {
      case POSITION_STATE_WARN:
         msg = "Your "+_Symbol+" position is NOT SAFE! Pls check.";
         Print(msg);
         if(AllowMail)
            SendMail("Attention!",msg);
         break;
      case POSITION_STATE_DANG:
         msg = "Your "+_Symbol+" position is DANGEROUS! Pls check.";
         Print(msg);
         if(AllowMail)
            SendMail("Dangerous!",msg);
         if(AllowHedge)
            OpenHedgePosition(true);
     }
  }

//+------------------------------------------------------------------+
//| Show some key information on screen immediately                                                                |
//+------------------------------------------------------------------+
void ShowInfo()
  {
// show profit
   double totalProfit = CMoneyManager::GetSymbolProfit();
   string profitContent = "               Profit:"+DoubleToStr(totalProfit,2)+"("+DoubleToStr(100*totalProfit/AccountBalance(),2)+"%)";
   ShowDynamicText("Profit",profitContent,0,0);
// show drawdown
   double drawdown  = CMoneyManager::GetDrawdownPercent();
   string drawdownContent = "               Drawdown:"+DoubleToStr(drawdown,2)+"%";
   ShowDynamicText("Drawdown",drawdownContent,0,-200);
  }

//+------------------------------------------------------------------+
