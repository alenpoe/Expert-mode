//+------------------------------------------------------------------+
//|                                                 MoneyManager.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"
#include "Input.mqh"

//+------------------------------------------------------------------+
//| Money Manager : Responsible for money-related operations                                                             |
//+------------------------------------------------------------------+
class CMoneyManager
  {
private:
   static const string TAG;
public:
                     CMoneyManager(void);
                    ~CMoneyManager(void);
   static bool       HasEnoughMoney(void);
   static double     GetInitLots(void);
   static double     GetAddLots(void);
   static double     GetOpenLots(void);
  };

const string CMoneyManager::TAG = "CMoneyManager";
//+------------------------------------------------------------------+
//| Check if your money is enough                                                                 |
//+------------------------------------------------------------------+
bool CMoneyManager::HasEnoughMoney(void)
  {
   if(AccountFreeMargin()< MoneyAtLeast)
     {
      Log(TAG,StringConcatenate("Your money is not enough! FreeMargin = ",AccountFreeMargin()));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Calculate the lots to open                                                                    |
//+------------------------------------------------------------------+
double CMoneyManager::GetOpenLots(void)
  {
   return GetAddLots(); //GetInitLots();
  }

//+------------------------------------------------------------------+
//| Calculate the initial lots to open                                                            |
//+------------------------------------------------------------------+
double CMoneyManager::GetInitLots(void)
  {
   double lots=NormalizeDouble(AccountBalance()/MoneyEveryLot,1);
   if(lots < 0.01)
      lots = 0.01;
   else
      if(lots > 100)
         lots = 100;
   Log(TAG,StringConcatenate("AccountBalance = ",AccountBalance(),",lots = ",lots));
   return lots;
  }

//+------------------------------------------------------------------+
//| Calculate the add lots to open                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetAddLots(void)
  {
   double maxLots = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      double orderLots = OrderLots();
      if(orderLots>maxLots)
         maxLots = orderLots;
     }
   return maxLots == 0? GetInitLots():maxLots*AddLotsMultiple;
  }
//+------------------------------------------------------------------+
