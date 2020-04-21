#include "inc_setmaxhps"
#include "seed_db_inc"

int SellInventory(object oPC) {
   int nGoldInBank = SDB_GetBankGold(oPC);
   int nAmount = 0;
   int nNewAmount = 0;
   object oItem=GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem)) {
      nNewAmount = GetGoldPieceValue(oItem) * 3;
      nAmount = nAmount + nNewAmount;
      SendMessageToPC(oPC, "Sold " + GetName(oItem) + " for " + IntToString(nNewAmount));
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   int iSlot=0;
   for(iSlot=0; iSlot < INVENTORY_SLOT_CWEAPON_L; iSlot++) {
      object oItem = GetItemInSlot(iSlot, oPC);
      if (GetIsObjectValid(oItem)) {
         nNewAmount = GetGoldPieceValue(oItem) * 3;
         nAmount = nAmount + nNewAmount;
         SendMessageToPC(oPC, "Sold " + GetName(oItem) + " for " + IntToString(nNewAmount));
         DestroyObject(oItem);
      }
   }
   nNewAmount = nGoldInBank + nAmount;
   if (nAmount) {
      SDB_SetBankGold(oPC, nNewAmount);
      PlaySound("it_coins");
   }
   return nAmount;
}

int KillBadSubRace(object oPC) {
   string sSubRace = GetSubRace(oPC);
   if (sSubRace=="") { // CHECK IF FIX IS NEEDED
      string sSQL = "select ps_tag from PlayerSubrace where ps_value='11' and ps_plid=" + SDB_GetPLID(oPC);
      SQLExecDirect(sSQL);
      if (SQLFetch()) {
         sSubRace = GetStringUpperCase(SQLGetData(1));
         sSubRace = GetStringRight(sSubRace, GetStringLength(sSubRace)-6);
         SendMessageToPC(oPC, "Your lost subrace information was restored. You are " + sSubRace + " once again.");
         SetSubRace(oPC, sSubRace);
      }
   }

   int nAmount;
   int nXPInBank;
   if (sSubRace=="ETTIN" || sSubRace=="WILDDWARF") {
      int iPLID = StringToInt(SDB_GetPLID(oPC));
      if (iPLID > 10 && iPLID<=11249) { // CHARACTER MADE BEFORE 8 AM ON 5/22/06
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 30.0);
         nAmount = GetXP(oPC);
         nXPInBank = SDB_GetBankXP(oPC);
         SDB_SetBankXP(oPC, nXPInBank + nAmount);
         SendMessageToPC(oPC, "Banked " + IntToString(nAmount) + " XP from deleveling this " + sSubRace + " character.");
         SDB_SetXP(oPC, 3, "BADSUBXP");
         nAmount = SellInventory(oPC);
         SendMessageToPC(oPC, "Banked " + IntToString(nAmount) + " gold from selling all the items in your inventory. This character will be deleted in 5 seconds.");
         SendMessageToPC(oPC, "This character was auto-banked. Sorry for the inconvenience. Your Bank account was credited with full XP and Gold.");
         DelayCommand(20.0, DeletePC(oPC));
         return TRUE;
      }
   }
   return FALSE;
}
