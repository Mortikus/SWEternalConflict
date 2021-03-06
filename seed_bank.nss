#include "zdlg_include_i"
#include "gen_inc_color"
#include "seed_db_inc"
#include "inc_setmaxhps"

// PERSIST VARIABLE STRINGS
const int    MAX_XP_WITHDRAWL = 780000;
const int    BANK_KEEP_GOLD   = 15000;
const string BANK_LIST        = "BANK_LIST";
const string BANK_PAGE        = "BANK_PAGE";
const string BANK_CONFIRM     = "BANK_CONFIRM";

// PAGES
const int PAGE_MENU_MAIN          = 0;  // View the list of options
const int PAGE_CONFIRM_ACTION     = 1;  // Page to Confirm Current Action (ok, cancel)
const int PAGE_SHOW_MESSAGE       = 2;  // Page to Show Result of Current Action (ok)
const int PAGE_MENU_GOLD          = 3;
const int PAGE_MENU_XP            = 4;
const int PAGE_DEPOSIT_GOLD       = 5;
const int PAGE_WITHDRAW_GOLD      = 6;
const int PAGE_DEPOSIT_XP         = 7;
const int PAGE_WITHDRAW_XP        = 8;


// ACTIONS
const int ACTION_CONFIRM          = 20; // CONFIRM CURRENT ACTION
const int ACTION_CANCEL           = 21; // CANCEL CURRENT ACTION
const int ACTION_END_CONVO        = 22; // END CONVERSATION
const int ACTION_SELL_INVENTORY   = 23;
const int ACTION_AMOUNT_CHANGE    = 24; //
const int ACTION_DEPOSIT_FINISH   = 25;
const int ACTION_WITHDRAW_FINISH  = 26;
const int ACTION_DEPOSIT_XP       = 27;
const int ACTION_WITHDRAW_XP      = 28;
const int ACTION_DELETE_CHAR      = 29;

void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = BANK_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = BANK_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = BANK_LIST);
void   DoConfirmAction();
void   DoShowMessage();
int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptionSelected(string sList = BANK_LIST);
int    GetPageOptionSelectedInt(string sList = BANK_LIST);
object GetPageOptionSelectedObject(string sList = BANK_LIST);
string GetPageOptionSelectedString(string sList = BANK_LIST);
string SendMsg(object oPC, string sMsg);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);

object LIST_OWNER = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = BANK_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddIntElement(nSubValue, BANK_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = BANK_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddStringElement(sSubValue, BANK_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = BANK_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddObjectElement(oSubValue, BANK_LIST + "_SUB", LIST_OWNER);
}

int GetPageOptionSelected(string sList = BANK_LIST) {
   return GetIntElement(GetDlgSelection(), sList, LIST_OWNER);
}

int GetPageOptionSelectedInt(string sList = BANK_LIST) {
   return GetIntElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

string GetPageOptionSelectedString(string sList = BANK_LIST) {
   return GetStringElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

object GetPageOptionSelectedObject(string sList = BANK_LIST) {
   return GetObjectElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

int GetNextPage() {
   return GetLocalInt(LIST_OWNER, BANK_PAGE);
}

void SetNextPage(int nPage) {
   SetLocalInt(LIST_OWNER, BANK_PAGE, nPage);
}

void SetAmount(int nAmount) {
   SetLocalInt(LIST_OWNER, BANK_LIST+"_AMT", nAmount);
}

int GetAmount() {
   return GetLocalInt(LIST_OWNER, BANK_LIST+"_AMT");
}

void SetErrorMsg(string sError) {
   SetLocalString(LIST_OWNER, BANK_LIST+"_ERR", sError);
}

string GetErrorMsg() {
   return GetLocalString(LIST_OWNER, BANK_LIST+"_ERR");
}

void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(LIST_OWNER, BANK_CONFIRM, sPrompt);
   SetLocalInt(LIST_OWNER, BANK_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetDlgPrompt(GetLocalString(LIST_OWNER, BANK_CONFIRM));
   int nOkAction = GetLocalInt(LIST_OWNER, BANK_CONFIRM);
   if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt("Ok", nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(LIST_OWNER, BANK_CONFIRM, sPrompt);
   SetLocalInt(LIST_OWNER, BANK_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(LIST_OWNER, BANK_CONFIRM + "_N", nActionCancel);
   SetLocalString(LIST_OWNER, BANK_CONFIRM + "_Y", sConfirm);
   SetLocalString(LIST_OWNER, BANK_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetDlgPrompt(GetLocalString(LIST_OWNER, BANK_CONFIRM));
   AddMenuSelectionInt(GetLocalString(LIST_OWNER, BANK_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(LIST_OWNER, BANK_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(LIST_OWNER, BANK_CONFIRM + "_N"), GetLocalInt(LIST_OWNER, BANK_CONFIRM+"_N"));
}

int GetConfirmedAction() {
   return GetLocalInt(LIST_OWNER, BANK_CONFIRM);
}

string SendMsg(object oPC, string sMsg) {
   SendMessageToPC(oPC, sMsg);
   return sMsg+"\n";
}

int SellInventory(object oPC, int nGoldInBank) {
   int nAmount = 0;
   int nNewAmount = 0;
   object oItem=GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem)) {
      int nBase = GetBaseItemType(oItem);
      nNewAmount = GetGoldPieceValue(oItem) / ((nBase==BASE_ITEM_GEM) ? 1 : 3);
      if (nBase==BASE_ITEM_ARROW || nBase==BASE_ITEM_BOLT || nBase==BASE_ITEM_BULLET || nBase==BASE_ITEM_DART || nBase==BASE_ITEM_SHURIKEN || nBase==BASE_ITEM_THROWINGAXE || nBase==BASE_ITEM_TRAPKIT) nNewAmount = 0;
      nAmount = nAmount + nNewAmount;
      SendMessageToPC(oPC, "Sold " + GetName(oItem) + " for " + IntToString(nNewAmount));
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   nNewAmount = nGoldInBank + nAmount + GetGold(oPC);
   if (nAmount) {
      SDB_SetBankGold(oPC, nNewAmount);
      PlaySound("it_coins");
   }
   return nAmount;
}

int SellAllGems(object oPC) {
   object oItem = GetFirstItemInInventory(oPC);
   int nGold = 0;
   while (oItem != OBJECT_INVALID) { // LOOP THRU ITEM IN INVENTORY
      if (GetBaseItemType(oItem)==BASE_ITEM_GEM || GetTag(oItem)=="ForceCrystal") {
         DestroyObject(oItem);
         nGold = nGold + GetGoldPieceValue(oItem);
      }
      oItem = GetNextItemInInventory(oPC);
   }
   return nGold;

}

void Init() {
   object oPC = GetPcDlgSpeaker();
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection() {
   object oPC = GetPcDlgSpeaker();
   object oItem;
   int iSelection = GetDlgSelection();
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   string sOptionSelected;
   string sSQL;
   string sText;
   int nConfirmed;
   int nGoldInBank = SDB_GetBankGold(oPC);
   int nGoldOnPC = GetGold(oPC);
   int nXPInBank = SDB_GetBankXP(oPC);
   int nXPOnPC = GetXP(oPC);
   int nXPRecover = nXPOnPC / 2; // DIVIDE BY 2
   int nAmount = GetAmount();
   int nTransAmount;
   int nNewAmount;
   int iSlot;
   int bAutoDelete;
   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN:
      case PAGE_MENU_XP:
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      case PAGE_MENU_GOLD:
         if (GetNextPage()==PAGE_MENU_MAIN) SetAmount(nGoldOnPC - BANK_KEEP_GOLD);
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      case PAGE_DEPOSIT_GOLD:
         if (nGoldOnPC==0) {
            SetShowMessage("Silly Customer, you cannot deposit pocket lint!", PAGE_MENU_GOLD);
            PlaySound("as_pl_beggarm1");
         } else if (nGoldOnPC<=BANK_KEEP_GOLD) {
            SetShowMessage("You only have " + IntToString(nGoldOnPC) + " gold in your pocket! No self-respecting adventurer would walk around with less than that.", PAGE_MENU_GOLD);
            PlaySound("as_pl_hangoverm1");
         } else {
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         }
         return;

      case PAGE_WITHDRAW_GOLD:
         if (nGoldInBank<=0) {
            SetShowMessage("I'm afraid your account is empty! You've got some pillaging to do...", PAGE_MENU_GOLD);
            PlaySound("as_pl_beggarm1");
         } else {
            SetAmount(0);
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         }
         return;

      case PAGE_DEPOSIT_XP:
         if (nXPOnPC<1000) {
            SetShowMessage("Silly Customer, you cannot deposit shame!", PAGE_MENU_XP);
            PlaySound("as_pl_noblaughi2");
         } else {
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         }
         return;

      case PAGE_WITHDRAW_XP:
         if (nXPInBank==0) {
            SetShowMessage("I'm afraid your account is empty! You've got some training to do...", PAGE_MENU_XP);
            PlaySound("as_pl_hangoverm1");
         } else {
            nNewAmount = MAX_XP_WITHDRAWL - nXPOnPC;
            nAmount = (nXPInBank > nNewAmount) ? nNewAmount : nXPInBank;
            SetAmount(nAmount);
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         }
         return;

      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         EndDlg();
         return;

      case ACTION_AMOUNT_CHANGE:
         nTransAmount = GetPageOptionSelectedInt();
         nNewAmount = nAmount + nTransAmount;
         switch (GetNextPage()) {
            case PAGE_DEPOSIT_GOLD:
               if (nTransAmount==0) nAmount = nGoldOnPC - BANK_KEEP_GOLD; //
            break;
            case PAGE_WITHDRAW_GOLD:
               if (nTransAmount==0) nAmount = nGoldInBank; //
            break;
         }
         nAmount = nAmount + nTransAmount;
         SetAmount(nAmount);
         PlaySound("it_coins");
         return;

      case ACTION_DEPOSIT_FINISH:
         if (nGoldOnPC < nAmount) { // THEY DROPPED THE GOLD
            nTransAmount = 0;
            oItem = GetNearestObjectByTag("NW_IT_GOLD001", oPC);
            if (oItem != OBJECT_INVALID) {
               if (GetDistanceBetween(oItem, oPC)<10.0) {
                  nTransAmount = GetItemStackSize(oItem);
                  DestroyObject(oItem);
                  oItem = GetNearestObjectByTag("NW_IT_GOLD001", oPC);
                  if (oItem != OBJECT_INVALID) DestroyObject(oItem);
               }
            }
            int nGems = SellAllGems(oPC);
            string sMsg = "had " + IntToString(nGoldOnPC) + " on char but depositing " + IntToString(nAmount) + ". Sold All Gems for " + IntToString(nGems) + " and Wiped Bank Gold from " + IntToString(nGoldInBank);
            if (nTransAmount) sMsg += " found " + IntToString(nTransAmount) + " on ground";
            SDB_LogMsg("BANKGOLDCHEAT", sMsg, oPC);
            nAmount += nGems + nGoldInBank;
            PlaySound("as_pl_customer4");
            DelayCommand(1.0,PlayVoiceChat(VOICE_CHAT_BADIDEA, oPC));
            SetShowMessage("You now owe the bank " + IntToString(nAmount) + " gold...", PAGE_MENU_MAIN);
            SDB_SetBankGold(oPC, -nAmount);
            return;
         }
         TakeGoldFromCreature(nAmount, oPC);
         PlaySound("it_coins");
         DelayCommand(1.0,PlayVoiceChat(VOICE_CHAT_THANKS, oPC));
         SDB_SetBankGold(oPC, nGoldInBank+nAmount);
         SetNextPage(PAGE_MENU_MAIN);
         return;

      case ACTION_WITHDRAW_FINISH:
         SDB_SetBankGold(oPC, nGoldInBank-nAmount);
         GiveGoldToCreature(oPC, nAmount);
         SetNextPage(PAGE_MENU_MAIN);
         PlaySound("it_coins");
         DelayCommand(1.0,PlayVoiceChat(VOICE_CHAT_THANKS, oPC));
         return;

      case ACTION_DEPOSIT_XP:
         sText = "";
         if (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC)) sText = " This character will automatically be cashed out and deleted after banking because it has Pale Master Levels.";
         else if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC)) sText = " This character will automatically be cashed out and deleted after banking because it has Red Dragon Disciple Levels.";
         sText = "Are you sure you want to bank the " + IntToString(nXPRecover) + " recoverable XP on this character?" + sText;
         SetConfirmAction(sText, ACTION_DEPOSIT_XP, PAGE_MENU_XP);
         return;

      case ACTION_WITHDRAW_XP:
         SetConfirmAction("Are you sure you want to withdraw " + IntToString(nAmount) + " XP into this character?", ACTION_WITHDRAW_XP, PAGE_MENU_XP);
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         nConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (nConfirmed) {
            case ACTION_DEPOSIT_XP:
               //nAmount = GetXP(oPC); //2;
               for(iSlot=0;iSlot<INVENTORY_SLOT_CWEAPON_L;iSlot++) {
                  object oItem = GetItemInSlot(iSlot, oPC);
                  if (GetIsObjectValid(oItem)) AssignCommand(oPC, ActionUnequipItem(oItem));
                }
               bAutoDelete = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) || GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
               SDB_SetBankXP(oPC, nXPInBank + nXPRecover);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
               SDB_SetXP(oPC, 3, "SDB_DEPOSITXP");
               ExportSingleCharacter(oPC);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC);
               PlayVoiceChat(VOICE_CHAT_REST, oPC);
               if (bAutoDelete) {
                  nAmount = SellInventory(oPC, nGoldInBank);
                  SendMessageToPC(oPC, "Banked " + IntToString(nAmount) + " gold from selling all the items in your inventory. This character will be deleted in 5 seconds.");
                  DeletePC(oPC);
                  EndDlg();
                  return;
               }
               SetConfirmAction("While you're trashing this character, would you like to sell all the items in your inventory and bank the gold too?", ACTION_SELL_INVENTORY, PAGE_MENU_MAIN);
               //SetNextPage(PAGE_MENU_XP);
               return;

            case ACTION_WITHDRAW_XP:
               SDB_SetBankXP(oPC, nXPInBank - nAmount);
               SDB_SetXP(oPC, nXPOnPC + nAmount, "WITHDRAWXP");
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
               PlayVoiceChat(VOICE_CHAT_YES, oPC);
               SetNextPage(PAGE_MENU_MAIN);
               return;

            case ACTION_SELL_INVENTORY:
               nAmount = SellInventory(oPC, nGoldInBank);
               SetConfirmAction("Banked " + IntToString(nAmount) + " gold from selling all the items in your inventory. Would you like to now delete this character?", ACTION_DELETE_CHAR, PAGE_MENU_MAIN, "Yes, Delete this trash", "No, I have uses for it");
               return;

            case ACTION_DELETE_CHAR:
               DeletePC(oPC);
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void BuildPage(int nPage) {
   object oPC = GetPcDlgSpeaker();
   DeleteList(BANK_LIST, LIST_OWNER);
   DeleteList(BANK_LIST+"_SUB", LIST_OWNER);
   string sMsg;
   int nGoldInBank = SDB_GetBankGold(oPC);
   int nGoldOnPC = GetGold(oPC);
   int nXPInBank = SDB_GetBankXP(oPC);
   int nXPOnPC = GetXP(oPC);
   int nXPRecover = nXPOnPC / 2; // DIVIDE BY 2
   int nAmount = GetAmount();
   int nTransAmount;
   int i = 0;
   switch (nPage) {
      case PAGE_MENU_MAIN:
         SetDlgPrompt("Welcome to the 4th National Bank of deX. Your accounts contain:\n\nGold:     "+IntToString(nGoldInBank)+"\n   XP:     "+IntToString(nXPInBank)+"\n\nWhich would you like to access?");
         AddMenuSelectionInt("Gold", PAGE_MENU_GOLD);
         AddMenuSelectionInt("XP", PAGE_MENU_XP);
         break;
      case PAGE_MENU_GOLD:
         SetDlgPrompt("Bank Account contains "+IntToString(nGoldInBank)+" Gold.\n\nYour Pockets contain "+IntToString(nGoldOnPC)+" Gold.\n\nWhat would you like to do?");
         AddMenuSelectionInt("Deposit Gold", PAGE_DEPOSIT_GOLD);
         AddMenuSelectionInt("Withdraw Gold", PAGE_WITHDRAW_GOLD);
         AddMenuSelectionInt("Back", PAGE_MENU_MAIN);
         break;
      case PAGE_DEPOSIT_GOLD:
         nTransAmount = nAmount;
         sMsg = "Your Account has "+IntToString(nGoldInBank)+" gold\n" +
                "Your Pockets have "+IntToString(nGoldOnPC)+" gold\n" +
                GreenText("-----------------------------------") +
                "\nCurrent Deposit Amount:   "+IntToString(nAmount)+" gold\n" +
                GreenText("-----------------------------------") +
                "Final Account balance "+IntToString(nGoldInBank+nAmount)+" gold\n" +
                "Final In Pocket amount "+IntToString(nGoldOnPC-nAmount)+" gold\n\n" +
                "Change deposit amount?";
         SetDlgPrompt(sMsg);
         AddMenuSelectionInt("All Gold in Pockets (keeps " + IntToString(BANK_KEEP_GOLD) + ")", ACTION_AMOUNT_CHANGE, 0);
         if (nTransAmount >  25000) AddMenuSelectionInt("Reduce Deposit: -25000", ACTION_AMOUNT_CHANGE,   -25000);
         if (nTransAmount >  50000) AddMenuSelectionInt("Reduce Deposit: -50000", ACTION_AMOUNT_CHANGE,   -50000);
         if (nTransAmount > 100000) AddMenuSelectionInt("Reduce Deposit: -100000", ACTION_AMOUNT_CHANGE,  -100000);
         if (nTransAmount > 200000) AddMenuSelectionInt("Reduce Deposit: -200000", ACTION_AMOUNT_CHANGE,  -200000);
         if (nTransAmount > 400000) AddMenuSelectionInt("Reduce Deposit: -400000", ACTION_AMOUNT_CHANGE,  -400000);
         if (nTransAmount > 800000) AddMenuSelectionInt("Reduce Deposit: -800000", ACTION_AMOUNT_CHANGE,  -800000);
         AddMenuSelectionInt("Make the Deposit", ACTION_DEPOSIT_FINISH);
         break;

      case PAGE_WITHDRAW_GOLD:
         nTransAmount = nGoldInBank - nAmount;
         sMsg = "Your Account has "+IntToString(nGoldInBank)+" gold\n" +
                "Your Pockets have "+IntToString(nGoldOnPC)+" gold\n" +
                YellowText("-----------------------------------") +
                "\nCurrent Withdrawal Amount:   "+IntToString(nAmount)+" gold\n" +
                YellowText("-----------------------------------") +
                "Final Account balance "+IntToString(nGoldInBank-nAmount)+" gold\n" +
                "Final In Pocket amount "+IntToString(nGoldOnPC+nAmount)+" gold\n\n" +
                "Change withdraw amount?";
         SetDlgPrompt(sMsg);
         AddMenuSelectionInt("All Gold in Account", ACTION_AMOUNT_CHANGE, 0);
         if (nTransAmount >  25000) AddMenuSelectionInt("Increase Withdraw: 25000", ACTION_AMOUNT_CHANGE,   25000);
         if (nTransAmount >  50000) AddMenuSelectionInt("Increase Withdraw: 50000", ACTION_AMOUNT_CHANGE,   50000);
         if (nTransAmount > 100000) AddMenuSelectionInt("Increase Withdraw: 100000", ACTION_AMOUNT_CHANGE,  100000);
         if (nTransAmount > 200000) AddMenuSelectionInt("Increase Withdraw: 200000", ACTION_AMOUNT_CHANGE,  200000);
         if (nTransAmount > 400000) AddMenuSelectionInt("Increase Withdraw: 400000", ACTION_AMOUNT_CHANGE,  400000);
         if (nTransAmount > 800000) AddMenuSelectionInt("Increase Withdraw: 800000", ACTION_AMOUNT_CHANGE,  800000);
         AddMenuSelectionInt("Make the Withdraw", ACTION_WITHDRAW_FINISH);
         break;

      case PAGE_MENU_XP:
         SetDlgPrompt("Bank Account contains "+IntToString(nXPInBank)+" XP.\n\nYour Character has "+IntToString(nXPOnPC)+" XP.\n\nWhat would you like to do?");
         AddMenuSelectionInt("Deposit XP", PAGE_DEPOSIT_XP);
        //* AddMenuSelectionInt("Withdraw XP", PAGE_WITHDRAW_XP);
        if (nXPOnPC< 780000) AddMenuSelectionInt("Withdraw XP", PAGE_WITHDRAW_XP);
        AddMenuSelectionInt("Back", PAGE_MENU_MAIN);
         break;

      case PAGE_DEPOSIT_XP:
         sMsg = "Your Account has "+IntToString(nXPInBank)+" XP\n" +
                "This PC has "+IntToString(nXPRecover)+" recoverable XP\n" +
                GreenText("-----------------------------------\n") +
                "You will delevel this character to 1!!\n" +
                GreenText("-----------------------------------\n") +
                "Final Account balance "+IntToString(nXPInBank+nXPRecover)+" XP\n\n" +
                "Deposit this XP?";
         SetDlgPrompt(sMsg);
         AddMenuSelectionInt("Ok, Deposit the XP!", ACTION_DEPOSIT_XP, 0);
         break;

      case PAGE_WITHDRAW_XP:
         sMsg = "Your Account contains "+IntToString(nXPInBank)+" XP\n" +
                YellowText("-----------------------------------\n") +
                "You are about to withdraw " + IntToString(nAmount) + " XP\nand level this char to " + IntToString(GetHDFromXP(nAmount+nXPOnPC))+ "\n" +
                YellowText("-----------------------------------\n") +
                "Final Account balance "+IntToString(nXPInBank-nAmount)+" XP\n\n" +
                "Withdraw this XP?";
         SetDlgPrompt(sMsg);
         AddMenuSelectionInt("Ok, Withdraw the XP!", ACTION_WITHDRAW_XP, 0);
         break;

      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
    }
}

void CleanUp() {
    DeleteLocalInt(LIST_OWNER, BANK_PAGE);
    DeleteList(BANK_LIST, LIST_OWNER);
    DeleteList(BANK_LIST+"_SUB", LIST_OWNER);
}

void main() {
   object oPC = GetPcDlgSpeaker();
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(TRUE);
         SetDlgResponseList(BANK_LIST, LIST_OWNER);
         break;
      case DLG_SELECTION:
         HandleSelection();
         break;
      case DLG_ABORT:
      case DLG_END:
         CleanUp();
         break;
   }
}

