#include "x2_inc_itemprop"
#include "zdlg_include_i"
#include "gen_inc_color"
#include "seed_db_inc"
#include "sha_subr_methds"

// PERSIST VARIABLE STRINGS
const string SUBRACE_LIST        = "SUBRACE_LIST";
const string SUBRACE_CONFIRM     = "SUBRACE_CONFIRM";

// PAGES
const int PAGE_MENU_MAIN          =   1;
const int PAGE_SHOW_MESSAGE       =   2;
const int PAGE_CONFIRM_ACTION     =   3;

const int ACTION_CONFIRM          = 101;
const int ACTION_CANCEL           = 102;
const int ACTION_END_CONVO        = 103;
const int ACTION_SELECT_BONUS     = 104;
const int ACTION_EXAMINE_SUBRACE  = 105;
const int ACTION_JOIN_SUBRACE     = 106;

const int TEXT_COLOR = COLOR_TANNER;

void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SUBRACE_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SUBRACE_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SUBRACE_LIST);
void   DoConfirmAction();
void   DoShowMessage();
int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptionSelected(string sList = SUBRACE_LIST);
int    GetPageOptionSelectedInt(string sList = SUBRACE_LIST);
object GetPageOptionSelectedObject(string sList = SUBRACE_LIST);
string GetPageOptionSelectedString(string sList = SUBRACE_LIST);
string SendMsg(string sMsg);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);

object oPC = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST
object oSubRace = OBJECT_SELF;

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SUBRACE_LIST) {
   ReplaceIntElement(AddStringElement(GetColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddIntElement(nSubValue, SUBRACE_LIST + "_SUB", oPC);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SUBRACE_LIST) {
   ReplaceIntElement(AddStringElement(GetColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddStringElement(sSubValue, SUBRACE_LIST + "_SUB", oPC);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SUBRACE_LIST) {
   ReplaceIntElement(AddStringElement(GetColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddObjectElement(oSubValue, SUBRACE_LIST + "_SUB", oPC);
}

void SetPrompt(string sText) {
   SetDlgPrompt(GetColor(TEXT_COLOR)+sText);
}

int GetPageOptionSelected(string sList = SUBRACE_LIST) {
   return GetIntElement(GetDlgSelection(), sList, oPC);
}

int GetPageOptionSelectedInt(string sList = SUBRACE_LIST) {
   return GetIntElement(GetDlgSelection(), sList + "_SUB", oPC);
}

string GetPageOptionSelectedString(string sList = SUBRACE_LIST) {
   return GetStringElement(GetDlgSelection(), sList + "_SUB", oPC);
}

object GetPageOptionSelectedObject(string sList = SUBRACE_LIST) {
   return GetObjectElement(GetDlgSelection(), sList + "_SUB", oPC);
}

int GetNextPage() {
   return GetLocalInt(oPC, SUBRACE_LIST + "_NEXTPAGE");
}
void SetNextPage(int nPage) {
   SetLocalInt(oPC, SUBRACE_LIST + "_NEXTPAGE", nPage);
}

void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(oPC, SUBRACE_CONFIRM, sPrompt);
   SetLocalInt(oPC, SUBRACE_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetPrompt(GetLocalString(oPC, SUBRACE_CONFIRM));
   int nOkAction = GetLocalInt(oPC, SUBRACE_CONFIRM);
   if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt("Ok", nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(oPC, SUBRACE_CONFIRM, sPrompt);
   SetLocalInt(oPC, SUBRACE_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(oPC, SUBRACE_CONFIRM + "_N", nActionCancel);
   SetLocalString(oPC, SUBRACE_CONFIRM + "_Y", sConfirm);
   SetLocalString(oPC, SUBRACE_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetPrompt(GetLocalString(oPC, SUBRACE_CONFIRM));
   AddMenuSelectionInt(GetLocalString(oPC, SUBRACE_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(oPC, SUBRACE_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(oPC, SUBRACE_CONFIRM + "_N"), GetLocalInt(oPC, SUBRACE_CONFIRM+"_N"));
}

int GetConfirmedAction() {
   return GetLocalInt(oPC, SUBRACE_CONFIRM);
}

string SendMsg(string sMsg) {
   SendMessageToPC(oPC, sMsg);
   return sMsg+"\n";
}

int CanBeSubrace(string sSubrace) {
   SetSubRace(oPC, sSubrace);
   int iCanBe = CheckIfPCMeetsAnySubraceCriteria(oPC);
   SetSubRace(oPC, "");
   return iCanBe;
}

void Init() {
   string sTag = GetTag(oSubRace);
   string sSubrace = GetStringRight(sTag, GetStringLength(sTag)-4);
   SetLocalInt(oPC, "CAN_BE_SUBRACE", CanBeSubrace(sSubrace));
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection() {
   int iConfirmed;
   int iSelection = GetDlgSelection(); // THE NUMBER OF THE OPTION SELECTED
   int iOptionSelected = GetPageOptionSelected(); // THE ACTION/PAGE ASSOCIATED WITH THE OPTION
   int    iOptionSubSelected = GetPageOptionSelectedInt(); // THE SUB VALUE ASSOCIATED WITH THE OPTION
   string sOptionSubSelected = GetPageOptionSelectedString(); // THE SUB STRING ASSOCIATED WITH THE OPTION
   string sTag = GetTag(oSubRace);
   string sSubrace = GetStringRight(sTag, GetStringLength(sTag)-4);
   string sText;
   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN        :
      case PAGE_SHOW_MESSAGE     :
      case PAGE_CONFIRM_ACTION   :
         if (GetNextPage()==iOptionSelected) PlaySound("vs_favhen4m_no");
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      case ACTION_EXAMINE_SUBRACE:
         AssignCommand(oPC, ActionExamine(oSubRace));
         return;

      case ACTION_JOIN_SUBRACE:
         sText = "Are you sure you wish to join the " + GetName(oSubRace) + " subrace? You will not be able to change once finalized.";
         SetConfirmAction(sText, ACTION_JOIN_SUBRACE, PAGE_MENU_MAIN);
         return;

      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         EndDlg();
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         iConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (iConfirmed) {
            case ACTION_JOIN_SUBRACE:
               SetXP(oPC, 2);
               SetSubRace(oPC, sSubrace);
               ExportSingleCharacter(oPC);
               InitiateSubraceChecking(oPC);
               //AssignCommand(oPC, JumpToLocation(GetStartingLocation()));
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void BuildPage(int nPage) {
   DeleteList(SUBRACE_LIST, oPC);
   DeleteList(SUBRACE_LIST+"_SUB", oPC);
   string sText;
   string sTag = GetTag(oSubRace);
   string sSubrace = GetStringRight(sTag, GetStringLength(sTag)-4);
   switch (nPage) {
      case PAGE_MENU_MAIN:
         if (GetXP(oPC)>2) {
            sText = GetSubRace(oPC);
            if (sText=="") {
               sText = "Sorry, you must be a new character to select a Subrace.";
            } else {
               sText = "Sorry, you are already a member of the " + GetSubRace(oPC) + " subrace.";
            }
         } else if (GetLocalInt(oPC, "CAN_BE_SUBRACE")) {
            sText = (GetGender(oPC)==GENDER_FEMALE) ? "Sister" : "Brother";
            sText = "Welcome " + sText + "! We share some blood I think! You qualify for the " + GetName(oSubRace) + " subrace. Would you like to join this subrace? There is no reversing this decision.";
            AddMenuSelectionInt("Join the " + GetName(oSubRace) + " subrace." , ACTION_JOIN_SUBRACE);
         } else {
            sText = "Sorry, you do not qualify for the " + GetName(oSubRace) + " subrace. Please try another.";
         }
         AddMenuSelectionInt("Examine " + GetName(oSubRace) + " Properties", ACTION_EXAMINE_SUBRACE);
         SetPrompt(sText);
         return;

      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
    }
}

void CleanUp() {
    DeleteList(SUBRACE_LIST, oPC);
    DeleteList(SUBRACE_LIST+"_SUB", oPC);
}

void main() {
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(TRUE);
         SetDlgResponseList(SUBRACE_LIST, oPC);
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
