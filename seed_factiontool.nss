#include "zdlg_include_i"
#include "seed_faction_inc"
#include "artifact_inc"

// PAGES
const int PAGE_MAIN_MENU          =  0;  // View the list of options
const int PAGE_CONFIRM_ACTION     =  1;  // Page to Confirm Current Action (ok, cancel)
const int PAGE_SHOW_MESSAGE       =  2;  // Page to Show Result of Current Action (ok)
const int PAGE_PORT_LEADER        =  4;  // Port to any of the currently online faction leaders
const int PAGE_PICK_FACTION       =  5;  // View faction diplomacy, or edit them (commander/gen only)
const int PAGE_FACTION_SUBMENU    =  6;  // FvF Submenu
const int PAGE_SET_DIPLOMACY      =  7;  // Edit faction diplomacy
const int PAGE_TARGET_SUBMENU     =  8;  // Target Submenu
const int PAGE_DECISIONS_SUBMENU  =  9;  // Faction decisions - ie leave, step down,etc
const int PAGE_DM_MENU            = 10;  // DM Menu, Remove From, or Select a Faction
const int PAGE_DM_SUBMENU         = 11;  // DM Faction Menu, Add To A Faction
const int PAGE_GIVE_GOLD          = 12;  //
const int PAGE_GIVE_XP            = 13;  //

// SHOW PAGE BIT FLAGS
const int SHOW_TARGET_MENU        =   1; // Commanders & Generals
const int SHOW_SET_DIPLOMACY      =   2; // Commanders & Generals
const int SHOW_INVITE_TARGET      =   4; // Commanders & Generals
const int SHOW_REMOVE_TARGET      =   8; // Commanders & Generals
const int SHOW_STEP_DOWN          =  16; // Commanders & General
const int SHOW_PROMOTE_MEMBER     =  32; // Generals only
const int SHOW_DEMOTE_COMMANDER   =  64; // Generals only
const int SHOW_NEW_GENERAL        = 128; // Generals only
const int SHOW_DECISIONS_SUBMENU  = 256; // Non-Generals only
const int SHOW_GIVE               = 512; // Generals only

// ACTIONS
const int ACTION_CONFIRM          = 20; // CONFIRM CURRENT ACTION
const int ACTION_CANCEL           = 21; // CANCEL CURRENT ACTION
const int ACTION_END_CONVO        = 22; // END CONVERSATION

const int ACTION_DEMOTE_COMMANDER = 23; // Demote Commander to Member
const int ACTION_FVF_STATS        = 24;
const int ACTION_INVITE_TARGET    = 25; // Invite Target into faction
const int ACTION_JOIN_PARTY       = 26;
const int ACTION_LEAVE_FACTION    = 27; // Leave your faction (generals must select successors)
const int ACTION_NEW_GENERAL      = 28; // Demote Commander to Member
const int ACTION_PICKED_FACTION   = 29;
const int ACTION_PORT_LEADER      = 30;
const int ACTION_PROMOTE_MEMBER   = 31; // Make a Member a Commander
const int ACTION_REMOVE_MEMBER    = 32; // boot from faction
const int ACTION_SET_DIPLOMACY    = 33;
const int ACTION_SHOW_MEMBERS     = 34;
const int ACTION_STEP_DOWN        = 35; // Step Down As Commander
const int ACTION_FVF_OFFICERS     = 36; // View another factions officers
const int ACTION_VIEW_MEMBERS     = 37; // View the current members of your faction online
const int ACTION_RELOAD_DIPLO     = 38; // Reload faction diplo settings
const int ACTION_PORT_CASTLE      = 39;
const int ACTION_SHOW_ARTIFACTS   = 40;
const int ACTION_GIVE_GOLD        = 41;
const int ACTION_GIVE_XP          = 42;
const int ACTION_AMOUNT_CHANGE    = 43; //
const int ACTION_WITHDRAW_GOLD    = 44; //
const int ACTION_WITHDRAW_XP      = 45; //
const int ACTION_VIEW_ACCOUNT     = 46; // View the current members of your faction online
const int ACTION_AMOUNT_SET       = 47;

// DM ONLY OPTIONS
const int ACTION_DM_ADD           = 51;
const int ACTION_DM_REMOVE        = 52;


int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptions();
int    GetPageOptionSelected(string sList = SDB_TOME_LIST);
int    GetPageOptionSelectedInt(string sList = SDB_TOME_LIST);
int    ShowPage(int nPage);
object GetPageOptionSelectedObject(string sList = SDB_TOME_LIST);
object GetTargetPC();
string GetPageOptionSelectedString(string sList = SDB_TOME_LIST);
string GetTargetOption();
string GetTargetFaction();
void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SDB_TOME_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SDB_TOME_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SDB_TOME_LIST);
void   AddPageOptions(int nOptions);
void   ClearPageOptions();
void   DoConfirmAction();
void   DoShowMessage();
void   RemovePageOption(int nOption);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MAIN_MENU, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);
void   SetTargetOption(string sOption);
void   SetTargetFaction(string sFAID);

object LIST_OWNER = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void ClearPageOptions() {
   SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, 0);
}

void AddPageOptions(int nOptions) {
   SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS) | nOptions);
}

void RemovePageOption(int nOption) {
   SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS) ^ nOption);
}

int GetPageOptions() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS);
}

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SDB_TOME_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddIntElement(nSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SDB_TOME_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddStringElement(sSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SDB_TOME_LIST) {
   ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
   AddObjectElement(oSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}

int ShowPage(int nPage) {
   return (GetPageOptions() & nPage);
}

int GetNextPage() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_PAGE);
}

void SetNextPage(int nPage) {
   SetLocalInt(LIST_OWNER, SDB_TOME_PAGE, nPage);
}

int GetPageOptionSelected(string sList = SDB_TOME_LIST) {
   return GetIntElement(GetDlgSelection(), sList, LIST_OWNER);
}

int GetPageOptionSelectedInt(string sList = SDB_TOME_LIST) {
   return GetIntElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

string GetPageOptionSelectedString(string sList = SDB_TOME_LIST) {
   return GetStringElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

object GetPageOptionSelectedObject(string sList = SDB_TOME_LIST) {
   return GetObjectElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

void SetTargetFaction(string sFAID) {
   SetLocalString(LIST_OWNER, SDB_TOME_TARGET, sFAID);
}

string GetTargetFaction() {
   return GetLocalString(LIST_OWNER, SDB_TOME_TARGET);
}

void SetTargetOption(string sOption) {
   SetLocalString(LIST_OWNER, SDB_TOME_TARGET+"_D", sOption);
}

string GetTargetOption() {
   return GetLocalString(LIST_OWNER, SDB_TOME_TARGET+"_D");
}

void SetCurrentDiplomacy(string sFAID, string sDiplo) {
   SetLocalString(LIST_OWNER, SDB_FACTION_DIPLO + sFAID, sDiplo);
}

string GetCurrentDiplomacy(string sFAID) {
   return GetLocalString(LIST_OWNER, SDB_FACTION_DIPLO + sFAID);
}

object GetTargetPC() {
   return GetLocalObject(LIST_OWNER, SDB_TOME_TARGET);
}

void SetFactionXP(int nXP) {
   SetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_XP", nXP);
}

int GetFactionsXP() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_XP");
}

void SetFactionGold(int nXP) {
   SetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_GOLD", nXP);
}

int GetFactionsGold() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_GOLD");
}

void SetAmount(int nAmount) {
   SetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_AMOUNT", nAmount);
}

int GetAmount() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_AMOUNT");
}


void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM, sPrompt);
   SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetDlgPrompt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM));
   int nOkAction = GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM);
   AddMenuSelectionInt("Ok, thanks.", nOkAction);
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MAIN_MENU, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM, sPrompt);
   SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM + "_N", nActionCancel);
   SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_Y", sConfirm);
   SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetDlgPrompt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM));
   AddMenuSelectionInt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_N"), GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM+"_N"));
   AddMenuSelectionInt("End", ACTION_END_CONVO);
}

int GetConfirmedAction() {
   return GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM);
}

string SendMsg(object oPC, string sMsg) {
   SendMessageToPC(oPC, sMsg);
   return sMsg+"\n";
}

string ZeroPad(string sIn, int nLen) {
   return GetStringRight("0000000000" + sIn, nLen);
}

string GetDiploColor(string sText, string sDiplo) {
   if (sDiplo==SDB_DIPLO_FRIEND) return YellowText(sText);
   if (sDiplo==SDB_DIPLO_ENEMY)  return RedText(sText);
   return GreenText(sText);
}

void Init() {
   ClearPageOptions(); // SET TO DEFAULTS
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetTargetPC();
   if (GetIsDM(oPC)) {
      SetNextPage(PAGE_DM_MENU);
      return;
   }
   string sFAID = SDB_GetFAID(oPC);
   string sRank = SDB_FactionGetRank(oPC);
   string sSQL = "select fa_bankxp, fa_bankgold from faction where fa_faid=" + sFAID;
   SQLExecDirect(sSQL);
   if (SQLFetch() != SQL_ERROR) {
      SetFactionXP(StringToInt(SQLGetData(1)));
      SetFactionGold(StringToInt(SQLGetData(2)));
   }
   if (GetIsObjectValid(oTarget) && oPC!=oTarget) { // WORKING WITH A TARGET
      if (!SDB_FactionIsMember(oTarget)) { // NOT IN ANY FACTION
         if (sRank!=SDB_FACTION_MEMBER) AddPageOptions(SHOW_INVITE_TARGET); // AN OFFICER CAN INVITE
      } else if (SDB_FactionIsMember(oTarget, sFAID)) { // IS TARGET IN MY FACTION?
         string sTargetRank = SDB_FactionGetRank(oTarget); // RANK OF TARGETTED PC
         if (sRank==SDB_FACTION_GENERAL) { // IMA GENERAL I CAN DO ANYTHING!
            AddPageOptions(SHOW_REMOVE_TARGET); // I CAN REMOVE ANYONE I WANT
            if (sTargetRank==SDB_FACTION_MEMBER)     AddPageOptions(SHOW_PROMOTE_MEMBER);   // I CAN PROMOTE MEMBERS TO COMMANDERS
            if (sTargetRank==SDB_FACTION_COMMANDER)  AddPageOptions(SHOW_DEMOTE_COMMANDER | SHOW_NEW_GENERAL); // AND CAN DEMOTE COMMANDERS TO MEMBERS, OR SWAP PLACES WITH COMMANDER
         } else if (sRank==SDB_FACTION_COMMANDER) { // IMA COMMANDER, I CAN DO SOME THINGS
            if (sTargetRank!=SDB_FACTION_GENERAL)    AddPageOptions(SHOW_REMOVE_TARGET);    // I CAN REMOVE ANYONE THAT'S NOT THE GENERAL
            if (sTargetRank==SDB_FACTION_COMMANDER)  AddPageOptions(SHOW_DEMOTE_COMMANDER); // I CAN DEMOTE OTHER COMMANDERS
         }
      } else {
         SendMessageToPC(oPC, "Target is a member of " + SDB_FactionGetName(SDB_GetFAID(oTarget)));
      }
   }
   if (sRank!=SDB_FACTION_MEMBER)    AddPageOptions(SHOW_SET_DIPLOMACY | SHOW_TARGET_MENU); // OFFICERS CAN SET DIPLO AND STEP DOWN
   if (sRank==SDB_FACTION_COMMANDER) AddPageOptions(SHOW_STEP_DOWN);     // COMMANDERS CAN STEP DOWN
   if (sRank!=SDB_FACTION_GENERAL)   AddPageOptions(SHOW_DECISIONS_SUBMENU); // GENERALS DON"T NEED THIS
   if (sRank==SDB_FACTION_GENERAL)   AddPageOptions(SHOW_GIVE); // I CAN GIVE OUT XP/GOLD

   SetNextPage(PAGE_MAIN_MENU);
}

void HandleSelection() {
   object oPC = GetPcDlgSpeaker();
   int iSelection = GetDlgSelection();
   object oMember;
   object oTarget = GetTargetPC();
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   string sOptionSelected;
   object oObjectSelected;
   string sFAID = SDB_GetFAID(oPC);
   string sRank = SDB_FactionGetRank(oPC);
   string sFactionName = SDB_FactionGetName(sFAID);
   string stFAID = GetTargetFaction();
   string stFactionName = SDB_FactionGetName(stFAID);
   string sSQL;
   string sText;
   string sGeneral;
   string sCommander;
   string sMember;
   int nConfirmed;
   int nAmount;
   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MAIN_MENU:
      case PAGE_PICK_FACTION:
      case PAGE_PORT_LEADER:
      case PAGE_SET_DIPLOMACY:
      case PAGE_TARGET_SUBMENU:
      case PAGE_DECISIONS_SUBMENU:
      case PAGE_DM_MENU:
      case PAGE_GIVE_GOLD:
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;
      case PAGE_GIVE_XP:
         SetAmount(GetRealLevel(oPC));
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;
      case PAGE_FACTION_SUBMENU: // GET AND SAVE THE FACTION SELECTED
         //if (GetPageOptionSelectedInt()!=ACTION_CANCEL) SetTargetFaction(GetPageOptionSelectedString()); // ONLY OVERWRITE FACTION IF NOT USING BACK BUTTON TO GET HERE
         SetNextPage(iOptionSelected);
         return;
      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         EndDlg();
         return;
      case ACTION_AMOUNT_SET:
         SetAmount(GetPageOptionSelectedInt());
         PlaySound("it_coins");
         return;
      case ACTION_AMOUNT_CHANGE:
         nAmount = GetPageOptionSelectedInt() + GetAmount();
         SetAmount(nAmount);
         PlaySound("it_coins");
         return;
      case ACTION_WITHDRAW_GOLD:
         nAmount = GetAmount();
         SetConfirmAction("Give " + IntToString(nAmount) + " gold to " + GetName(oTarget) + "?", ACTION_WITHDRAW_GOLD, PAGE_TARGET_SUBMENU);
         return;
      case ACTION_WITHDRAW_XP:
         nAmount = GetAmount();
         sText = " and advance them to level " + IntToString(nAmount);
         nAmount = GetMin(780000, GetMax(0, GetXPByLevel(nAmount) - GetXP(oTarget)));
         SetAmount(nAmount);
         SetConfirmAction("Give " + IntToString(nAmount) + " xp to " + GetName(oTarget) + sText + "?", ACTION_WITHDRAW_XP, PAGE_TARGET_SUBMENU);
         return;
      case ACTION_PICKED_FACTION:
         SetTargetFaction(GetPageOptionSelectedString());
         if (GetIsDM(oPC)) SetNextPage(PAGE_DM_SUBMENU);
         else SetNextPage(PAGE_FACTION_SUBMENU);
         return;
      case ACTION_SET_DIPLOMACY:
         sOptionSelected = GetPageOptionSelectedString();
         SetTargetOption(sOptionSelected);
         SetConfirmAction(GetDiploColor("Set diplomacy for\n\n" + stFactionName + "\n\nto " + sOptionSelected + "?", sOptionSelected), ACTION_SET_DIPLOMACY, PAGE_SET_DIPLOMACY);
         return;
      case ACTION_PORT_LEADER:
         if (GetLocalInt(oPC, "FPORT_WAIT")) {
//             SendMessageToPC(oPC, "You can only use a faction port once every 3 minutes.");
//             return;
         }
         oObjectSelected = GetPageOptionSelectedObject();
         if (oObjectSelected!=OBJECT_INVALID) {
            if (GetCurrentHitPoints(oObjectSelected)<1) {
               SetNextPage(PAGE_PORT_LEADER);
               SendMessageToPC(oPC, "Sorry, " + GetName(oObjectSelected) + " is currently unable to take your call.");
               return;
            } else if (IsWarpAllowed(oPC)) {
               stFAID = GetLocalString(GetArea(oObjectSelected), "FAID"); // FACTION ID OF AREA PORTING TO
               if (stFAID!="" && stFAID!=sFAID) {
                  SetNextPage(PAGE_PORT_LEADER);
                  SendMessageToPC(oPC, "Sorry, " + GetName(oObjectSelected) + " is currently in another Faction's territory.");
                  return;
               } else {
                  oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oObjectSelected);
                  if (oTarget!=OBJECT_INVALID) {
                     if (GetDistanceBetween(oObjectSelected, oTarget) <= 25.0) {
                        SendMessageToPC(oPC, "Sorry, " + GetName(oObjectSelected) + " is too close to enemies.");
                        return;
                     }
                  }
                  SendMessageToPC(oPC, "Porting to " + GetName(oObjectSelected) + "...");
                  ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
                  DelayCommand(0.8f,AssignCommand(oPC, JumpToLocation(GetLocation(oObjectSelected))));
                  SetLocalInt(oPC, "FPORT_WAIT", 1);
                  DelayCommand(180.0f,DeleteLocalInt(oPC, "FPORT_WAIT"));
               }
            }
            EndDlg();
            return;
         }
         SetNextPage(PAGE_PORT_LEADER);
         SendMessageToPC(oPC, "Sorry, that member is not logged in.");
         return;
      case ACTION_PORT_CASTLE:
         if (GetLocalInt(oPC, "FPORT_WAIT")) {
//             SendMessageToPC(oPC, "You can only use a faction port once every 3 minutes.");
//             return;
         }
         oObjectSelected = GetObjectByTag(SDB_FactionGetCastleWP(sFAID));
         if (IsWarpAllowed(oPC)) {
            SendMessageToPC(oPC, "Porting to " + GetName(GetAreaFromLocation(GetLocation(oObjectSelected))) + "...");
            ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
            DelayCommand(0.8f,AssignCommand(oPC, JumpToObject(oObjectSelected)));
            SetLocalInt(oPC, "FPORT_WAIT", 1);
            DelayCommand(180.0f,DeleteLocalInt(oPC, "FPORT_WAIT"));
         }
         EndDlg();
         return;
      case ACTION_SHOW_ARTIFACTS:
         sText = "";
         sText += SendMsg(oPC, "Faction Artifact Locations");
         sText += SendMsg(oPC, Artifact_ShowOwner("1"));
         sText += SendMsg(oPC, Artifact_ShowOwner("2"));
         sText += SendMsg(oPC, Artifact_ShowOwner("3"));
         sText += SendMsg(oPC, Artifact_ShowOwner("4"));
         sText += SendMsg(oPC, Artifact_ShowOwner("5"));
         sText += SendMsg(oPC, Artifact_ShowOwner("6"));
         sText += SendMsg(oPC, Artifact_ShowOwner("7"));
         sText += SendMsg(oPC, Artifact_ShowOwner("8"));
         SetShowMessage(sText, PAGE_MAIN_MENU);
         return;

      case ACTION_FVF_STATS:
         sSQL = "select ff_kills - (ff_killscom + ff_killsgen), ff_killscom, ff_killsgen, ff_kills, ff_deaths - (ff_deathscom + ff_deathsgen), ff_deathscom, ff_deathsgen, ff_deaths from factionvsfaction where ff_faid=" + sFAID + " and ff_faidvs=" + stFAID;
         SQLExecDirect(sSQL);
         if (SQLFetch()) {
            sText = "";
            sText += SendMsg(oPC, "Faction Vs. Faction Stats for");
            sText += SendMsg(oPC, sFactionName + " Vs. " + stFactionName);
            sText += SendMsg(oPC, "\n  TOTAL KILLS: " + SQLGetData(4));
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(1),4) + " Grunts");
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(2),4) + " Commanders");
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(3),4) + " General");
            sText += SendMsg(oPC, "\n  TOTAL DEATHS: " + SQLGetData(8));
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(5),4) + " Grunts");
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(6),4) + " Commanders");
            sText += SendMsg(oPC, "      " + ZeroPad(SQLGetData(7),4) + " General");
            SetShowMessage(sText, PAGE_FACTION_SUBMENU);
            return;
         }
         SetNextPage(PAGE_FACTION_SUBMENU);
         return;
      case ACTION_FVF_OFFICERS:
         { // BLOCK
         string soldCD = "~>~";
         string soldAcct = "~>~";
         string sCD = "~>~";
         string sAcct = "~>~";
         sSQL = "select ca_ckid, ac_name, fm_rank, pl_name from cdkeyaccount, account, player, factionmember where ca_acid=ac_acid and ca_ckid=fm_ckid and ac_acid=pl_acid and fm_rank<>" + InQs(SDB_FACTION_MEMBER) + " and fm_faid=" + stFAID + " order by fm_rank desc";
         SQLExecDirect(sSQL);
         sText = SendMsg(oPC, stFactionName + " Officers:\n");
         while (SQLFetch()) {
            sCD = SQLGetData(1);
            sAcct = SQLGetData(2);
            if (soldCD!=sCD) {
               soldCD=sCD;
               sText += SendMsg(oPC, "Rank: " + SQLGetData(3));
            }
            if (soldAcct!=sAcct) {
               soldAcct=sAcct;
               sText += SendMsg(oPC, "** Account: " + sAcct);
            }
            sText += SendMsg(oPC, " **** Player: " + SQLGetData(4));
         }
         SetShowMessage(sText, PAGE_FACTION_SUBMENU);
         } // END BLOCK
         return;
      case ACTION_VIEW_ACCOUNT:
         sText = "The Faction Account contains:\n" + IntToString(GetFactionsGold()) + " Gold\n" + IntToString(GetFactionsXP()) + " XP.";
         SetShowMessage(sText, PAGE_MAIN_MENU);
         return;
      case ACTION_VIEW_MEMBERS:
         sGeneral = "";
         sCommander = "";
         sMember = "";
         oMember = GetFirstPC();
         while (GetIsObjectValid(oMember)) {
            stFAID = SDB_GetFAID(oMember);
            if (sFAID == stFAID && !GetIsDM(oMember)) {
               sRank = SDB_FactionGetRank(oMember);
               if (sRank==SDB_FACTION_GENERAL) {
                  sGeneral = "   General " +GetName(oMember);
               } else if (sRank==SDB_FACTION_COMMANDER) {
                  sCommander += "   Commander " + GetName(oMember) + "\n";
               } else {
                  sMember = DelimList(GetName(oMember), sMember);
               }
            }
            oMember = GetNextPC();
         }
         if (sGeneral=="")   sGeneral = "   General not logged in.";
         if (sCommander=="") sCommander = "   Commanders not logged in.";
         if (sMember=="")    sMember = "No Members logged in.";
         else sMember = "\nMembers logged in:\n   " + sMember;
         sText += SendMsg(oPC, sFactionName + " members online:\n\nOfficers:");
         sText += SendMsg(oPC, sGeneral);
         sText += SendMsg(oPC, sCommander);
         sText += SendMsg(oPC, sMember);
         SetShowMessage(sText, PAGE_MAIN_MENU);
         return;
      case ACTION_JOIN_PARTY:
         SetConfirmAction("Leave your current party and join your faction party?", ACTION_JOIN_PARTY);
         return;
      case ACTION_LEAVE_FACTION:
         SetConfirmAction("Are you sure you want to leave your faction?", ACTION_LEAVE_FACTION);
         return;
      case ACTION_REMOVE_MEMBER:
         SetConfirmAction("Are you sure you want to remove\n" + GetName(oTarget) + " from " + sFactionName + "?", ACTION_REMOVE_MEMBER);
         return;
      case ACTION_INVITE_TARGET:
         SetConfirmAction("Are you sure you want to invite\n" + GetName(oTarget) + " into " + sFactionName + "?", ACTION_INVITE_TARGET);
         return;
      case ACTION_PROMOTE_MEMBER:
         SetConfirmAction("Are you sure you want to promote\n" + GetName(oTarget) + " to Commander?", ACTION_PROMOTE_MEMBER);
         return;
      case ACTION_STEP_DOWN:
         SetConfirmAction("Are you sure you want to step down\n as a Commander of " + sFactionName + "?", ACTION_STEP_DOWN);
         return;
      case ACTION_DEMOTE_COMMANDER:
         SetConfirmAction("Are you sure you want to strip\n" + GetName(oTarget) + " of the rank Commander of " + sFactionName + "?", ACTION_DEMOTE_COMMANDER);
         return;
      case ACTION_NEW_GENERAL:
         SetConfirmAction("Are you sure you want to step down\n as the General of " + sFactionName + " and pass the torch to " + GetName(oTarget) + "?", ACTION_NEW_GENERAL);
         return;
      case ACTION_RELOAD_DIPLO:
         SDB_FactionLoadDiplomacy(oPC);
         SetShowMessage("Faction Vs Faction Diplomacy reloaded.", PAGE_MAIN_MENU);
         return;
      case ACTION_DM_ADD:
         sOptionSelected = GetPageOptionSelectedString();
         SetTargetOption(sOptionSelected);
         SetConfirmAction("Are you sure you want to add  " + GetName(oTarget) + " to " + stFactionName + " and make them a " + sOptionSelected + "?", ACTION_DM_ADD, PAGE_DM_MENU);
         return;
      case ACTION_DM_REMOVE:
         stFAID = SDB_GetFAID(oTarget);
         stFactionName = SDB_FactionGetName(stFAID);
         SetConfirmAction("Are you sure you want to remove  " + GetName(oTarget) + " from " + stFactionName + "?", ACTION_DM_REMOVE, PAGE_DM_MENU);
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         nConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (nConfirmed) {
            case ACTION_WITHDRAW_GOLD:
               nAmount = GetAmount();
               if (nAmount >= GetFactionsGold()) {
                  SetShowMessage("Sorry, you don't have enough Gold for that transaction.");
                  return;
               }
               sSQL = "update faction set fa_bankgold=fa_bankgold-" + IntToString(nAmount) + " where fa_faid=" + sFAID;
               SQLExecDirect(sSQL);
               SetFactionGold(GetFactionsGold()-nAmount);
               GiveGoldToCreature(oTarget, nAmount);
               SDB_LogMsg("FACTIONGOLD", "Gave " + IntToString(nAmount) + " Gold", oTarget);
               break;
            case ACTION_WITHDRAW_XP:
               nAmount = GetAmount();
               if (nAmount >= GetFactionsXP()) {
                  SetShowMessage("Sorry, you don't have enough XP for that transaction.");
                  return;
               }
               //nAmount = GetXPByLevel(nAmount) - GetXP(oTarget);
               if (nAmount > 0) {
                  sSQL = "update faction set fa_bankxp=fa_bankxp-" + IntToString(nAmount) + " where fa_faid=" + sFAID;
                  SQLExecDirect(sSQL);
                  SetFactionXP(GetFactionsXP()-nAmount);
                  SDB_SetXP(oTarget, GetXP(oTarget) + nAmount, "FACTIONXP");
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
                  PlayVoiceChat(VOICE_CHAT_YES, oPC);
               }
               break;
            case ACTION_JOIN_PARTY:
               SetShowMessage(SDB_JoinFactionParty(oPC));
               return;
            case ACTION_SET_DIPLOMACY:
               sOptionSelected = GetTargetOption();
               SDB_FactionSetDiplomacy(sFAID, stFAID, sOptionSelected);
               SetCurrentDiplomacy(stFAID, sOptionSelected);
               SetShowMessage(GetDiploColor("Diplomacy for\n\n" + stFactionName + "\n\nchanged to " + sOptionSelected, sOptionSelected), PAGE_FACTION_SUBMENU);
               return;
            case ACTION_LEAVE_FACTION:
               SetShowMessage(SDB_FactionRemove(oPC)); // REMOVING SELF
               return;
            case ACTION_REMOVE_MEMBER:
               SetShowMessage(SDB_FactionRemove(oTarget, oPC), PAGE_MAIN_MENU);
               RemovePageOption(SHOW_REMOVE_TARGET);
               AddPageOptions(SHOW_INVITE_TARGET);
               return;
            case ACTION_INVITE_TARGET:
               SetCustomToken(2408,sFactionName); // SAVE FACTION NAME FOR NEXT CONVO
               SetLocalObject(oTarget, "FACTION_SPEAKER", oPC); // SAVE INVITER FOR NEXT CONVO
               AssignCommand(oTarget, ActionStartConversation(oTarget,"flel_faction_inv", FALSE, TRUE)); // ASK TARGET TO JOIN
               SetShowMessage(GetName(oTarget) + " has been invited to join " + sFactionName, PAGE_MAIN_MENU);
               RemovePageOption(SHOW_INVITE_TARGET);
               return;
            case ACTION_PROMOTE_MEMBER:
               SetShowMessage(SDB_FactionSetRank(oTarget, SDB_FACTION_COMMANDER));
               return;
            case ACTION_STEP_DOWN:
               SetShowMessage(SDB_FactionSetRank(oPC, SDB_FACTION_MEMBER));
               return;
            case ACTION_DEMOTE_COMMANDER:
               SetShowMessage(SDB_FactionSetRank(oTarget, SDB_FACTION_MEMBER));
               return;
            case ACTION_NEW_GENERAL:
               SetShowMessage(SDB_FactionNewGeneral(oTarget, oPC));
               return;
            case ACTION_DM_ADD:
               SetShowMessage(SDB_FactionDMAdd(oTarget, stFAID, GetTargetOption()));
               return;
            case ACTION_DM_REMOVE:
               SetShowMessage(SDB_FactionDMRemove(oTarget));
               return;
       }
    }
    SetNextPage(PAGE_MAIN_MENU); // If broken, send to main menu
}

void BuildPage(int nPage) {
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetTargetPC();
   int bValidTarget = GetIsObjectValid(oTarget) && oTarget!=oPC;
   object oMember;
   int nOptions = GetPageOptions();
   string sFAID = SDB_GetFAID(oPC);
   string sRank = SDB_FactionGetRank(oPC);
   string sFactionName = SDB_FactionGetName(sFAID);
   string sName;
   string stFAID;
   string sDiplo;
   string sText;
   int nAccountAmount;
   int nAmount;

   DeleteList(SDB_TOME_LIST, LIST_OWNER);
   DeleteList(SDB_TOME_LIST+"_SUB", LIST_OWNER);
   switch (nPage) {
      case PAGE_DM_MENU:
         stFAID = SDB_GetFAID(oTarget);
         if (stFAID!="0") {
            SetDlgPrompt("Hello DM " + GetName(oPC) + "\nWhat do you want to do with " + GetName(oTarget) + "?");
            AddMenuSelectionInt("Remove " + SDB_FactionGetRank(oTarget) + " from " + SDB_FactionGetName(stFAID), ACTION_DM_REMOVE);
         } else {
            SetDlgPrompt("Hello DM " + GetName(oPC) + "\nSelect the faction to add " + GetName(oTarget) + " to:");
            sFAID = SDB_FactionGetFirst();
            while (sFAID!="") {
               AddMenuSelectionString(SDB_FactionGetName(sFAID), ACTION_PICKED_FACTION, sFAID);
               sFAID = SDB_FactionGetNext();
            }
         }
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_DM_SUBMENU:
         SetDlgPrompt("What rank would you want like to assign " + GetName(oTarget) + "?");
         AddMenuSelectionString("General", ACTION_DM_ADD, SDB_FACTION_GENERAL);
         AddMenuSelectionString("Member",  ACTION_DM_ADD, SDB_FACTION_MEMBER);
         AddMenuSelectionInt("Back", PAGE_DM_MENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_MAIN_MENU:
         SetDlgPrompt("Hello " + sFactionName + " " + sRank + "\nWhat do you want to do?");
         AddMenuSelectionInt("View Members on-line", ACTION_VIEW_MEMBERS);
         AddMenuSelectionInt("Port to a Leader", PAGE_PORT_LEADER);
         AddMenuSelectionInt("Port to Castle", ACTION_PORT_CASTLE);
         AddMenuSelectionInt("Artifact Locations", ACTION_SHOW_ARTIFACTS);
         AddMenuSelectionInt("Join Faction party", ACTION_JOIN_PARTY);
         AddMenuSelectionInt("Reload FvF Diplomacy", ACTION_RELOAD_DIPLO);
         AddMenuSelectionInt("Faction Vs. Faction", PAGE_PICK_FACTION);
         AddMenuSelectionInt("View Faction Bank Account", ACTION_VIEW_ACCOUNT);
         if (ShowPage(SHOW_DECISIONS_SUBMENU)) AddMenuSelectionInt("Faction Decisions", PAGE_DECISIONS_SUBMENU);
         if (ShowPage(SHOW_TARGET_MENU) && GetIsObjectValid(oTarget)) AddMenuSelectionInt("Work on target: " + GetName(oTarget), PAGE_TARGET_SUBMENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_TARGET_SUBMENU:
         SetDlgPrompt("What do you want to do with\n" + SDB_FactionGetRank(oTarget) + " " + GetName(oTarget) + "?");
         if (ShowPage(SHOW_INVITE_TARGET) && bValidTarget)    AddMenuSelectionInt("Invite Target into Faction", ACTION_INVITE_TARGET);
         if (ShowPage(SHOW_REMOVE_TARGET) && bValidTarget)    AddMenuSelectionInt("Remove Target from Faction", ACTION_REMOVE_MEMBER);
         if (ShowPage(SHOW_PROMOTE_MEMBER) && bValidTarget)   AddMenuSelectionInt("Promote Target to Commander", ACTION_PROMOTE_MEMBER);
         if (ShowPage(SHOW_DEMOTE_COMMANDER) && bValidTarget) AddMenuSelectionInt("Demote Commander " + GetName(oTarget), ACTION_DEMOTE_COMMANDER);
         if (ShowPage(SHOW_NEW_GENERAL) && bValidTarget)      AddMenuSelectionInt("Promote Commander " + GetName(oTarget) + " to General", ACTION_NEW_GENERAL);
         if (ShowPage(SHOW_GIVE))                             AddMenuSelectionInt("Give Faction Gold (" + IntToString(GetFactionsGold()) + ") to " + GetName(oTarget), PAGE_GIVE_GOLD);
         if (ShowPage(SHOW_GIVE))                             AddMenuSelectionInt("Give Faction XP (" + IntToString(GetFactionsXP()) + ") to " + GetName(oTarget), PAGE_GIVE_XP);
         AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         SetAmount(0);
         break;
      case PAGE_DECISIONS_SUBMENU:
         if (ShowPage(SHOW_STEP_DOWN)) AddMenuSelectionInt("Step down as Commander", ACTION_STEP_DOWN);
         AddMenuSelectionInt("Leave Faction", ACTION_LEAVE_FACTION);
         AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_FACTION_SUBMENU:
         sFactionName = SDB_FactionGetName(GetTargetFaction());
         sDiplo = GetCurrentDiplomacy(GetTargetFaction());
         SetDlgPrompt("Selected Faction:\n\n" + GetDiploColor(sFactionName, sDiplo) + "\n\nWhat would you like to do next?");
         if (ShowPage(SHOW_SET_DIPLOMACY)) AddMenuSelectionInt("Change Diplomacy", PAGE_SET_DIPLOMACY);
         AddMenuSelectionInt("View FvF Stats", ACTION_FVF_STATS);
         AddMenuSelectionInt("View Officers", ACTION_FVF_OFFICERS);
         AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         return;
      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
      case PAGE_PORT_LEADER:
         SetDlgPrompt("Select the leader to port to:");
         nOptions = 0;
         if (sRank!=SDB_FACTION_GENERAL) {
            AddMenuSelectionObject("General: off-line",   ACTION_PORT_LEADER, OBJECT_INVALID);
            nOptions++;
         }
         if (sRank!=SDB_FACTION_COMMANDER) {
            AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
         }
         AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
         AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
         AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
         oMember = GetFirstPC();
         while (GetIsObjectValid(oMember)) {
            stFAID = SDB_GetFAID(oMember);
            if (stFAID == sFAID) {
               string sRankM = SDB_FactionGetRank(oMember);
               if (oMember != oPC && !GetIsDM(oMember)) {
                  string sName = GetName(oMember);  // + " (" + sRankM + ")";
                  if (sRankM==SDB_FACTION_GENERAL) {
                     ReplaceStringElement(0, "General: " + sName, SDB_TOME_LIST, LIST_OWNER);
                     ReplaceObjectElement(0, oMember,  SDB_TOME_LIST+"_SUB", LIST_OWNER);
                  } else if (sRankM==SDB_FACTION_COMMANDER) {
                     ReplaceStringElement(nOptions, "Commander: " + sName, SDB_TOME_LIST, LIST_OWNER);
                     ReplaceObjectElement(nOptions, oMember,  SDB_TOME_LIST+"_SUB", LIST_OWNER);
                     nOptions++;
                  } else if (sRank!=SDB_FACTION_MEMBER) { // OFFICERS CAN GO TO ANYONE
                     AddMenuSelectionObject(sName, ACTION_PORT_LEADER, oMember);
                  }
               }
            }
            oMember = GetNextPC();
         }
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_PICK_FACTION:
         SetDlgPrompt(sFactionName + " Tome\nSelect the faction to work with:");
         SQLExecDirect("select ff_faidvs, ff_diplomacy from factionvsfaction where ff_faid=" + sFAID + "  order by ff_faidvs");
         while (SQLFetch()) {
            stFAID = SQLGetData(1);
            sDiplo = SQLGetData(2);
            sFactionName = SDB_FactionGetName(stFAID);
            AddMenuSelectionString(GetDiploColor(sFactionName, sDiplo), ACTION_PICKED_FACTION, stFAID);
            SetCurrentDiplomacy(stFAID, sDiplo);
         }
         AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         return;
      case PAGE_SET_DIPLOMACY:
         sFactionName = SDB_FactionGetName(GetTargetFaction());
         sDiplo = GetCurrentDiplomacy(GetTargetFaction());
         SetDlgPrompt("Select the new diplomacy for\n\n" + GetDiploColor(sFactionName, sDiplo) + ":");
         AddMenuSelectionString(GetDiploColor(SDB_DIPLO_FRIEND, SDB_DIPLO_FRIEND),   ACTION_SET_DIPLOMACY, SDB_DIPLO_FRIEND);
         AddMenuSelectionString(GetDiploColor(SDB_DIPLO_NEUTRAL, SDB_DIPLO_NEUTRAL), ACTION_SET_DIPLOMACY, SDB_DIPLO_NEUTRAL);
         AddMenuSelectionString(GetDiploColor(SDB_DIPLO_ENEMY,SDB_DIPLO_ENEMY),      ACTION_SET_DIPLOMACY, SDB_DIPLO_ENEMY);
         AddMenuSelectionInt("Back", PAGE_FACTION_SUBMENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         return;
      case PAGE_GIVE_GOLD:
         nAccountAmount = GetFactionsGold();
         nAmount = GetAmount();
         sText = "Faction Account has "+IntToString(nAccountAmount)+" Gold\n" +
                YellowText("-----------------------------------\n") +
                "Faction Member:       " + GetName(oTarget) + "\n" +
                "Current Withdrawal:   " + IntToString(nAmount)+" gold\n" +
                YellowText("-----------------------------------\n") +
                "Final Balance "+IntToString(nAccountAmount-nAmount)+" gold\n";
         SetDlgPrompt(sText);
         if (nAccountAmount - nAmount > 100000) AddMenuSelectionInt("Increase Withdraw:  100000", ACTION_AMOUNT_CHANGE,  100000);
         if (nAccountAmount - nAmount > 200000) AddMenuSelectionInt("Increase Withdraw:  200000", ACTION_AMOUNT_CHANGE,  200000);
         if (nAccountAmount - nAmount > 400000) AddMenuSelectionInt("Increase Withdraw:  400000", ACTION_AMOUNT_CHANGE,  400000);
         if (nAccountAmount - nAmount > 800000) AddMenuSelectionInt("Increase Withdraw:  800000", ACTION_AMOUNT_CHANGE,  800000);
         if (nAccountAmount - nAmount >1600000) AddMenuSelectionInt("Increase Withdraw: 1600000", ACTION_AMOUNT_CHANGE, 1600000);
         if (nAmount > 0) AddMenuSelectionInt("Make the Withdraw", ACTION_WITHDRAW_GOLD);
         AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
      case PAGE_GIVE_XP:
         int nXP = GetXP(oTarget);
         if (nXP >= 780000) {
            SetDlgPrompt(GetName(oTarget) + " is at max XP.");
            AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
         }
         nAccountAmount = GetFactionsXP();
         nAmount = GetAmount();
         int nNewLevelXP = GetXPByLevel(nAmount); // THIS IS THE XP TO HIT THE NEW LEVEL
         if (nNewLevelXP < nXP) nNewLevelXP = nXP; // THEY HAVE AT LEAST THIS MUCH
         int nXPtoNextLevel = nNewLevelXP - nXP;
         sText = "Faction Account has "+IntToString(nAccountAmount)+" XP\n" +
                YellowText("-----------------------------------\n") +
                "Faction Member:       " + GetName(oTarget) + "\n" +
                "Final Level:            " + IntToString(nAmount) + "\n" +
                "Current Withdrawal:   " + IntToString(nXPtoNextLevel)+" XP\n" +
                YellowText("-----------------------------------\n") +
                "Final Balance "+IntToString(nAccountAmount-nXPtoNextLevel)+" XP\n";
         SetDlgPrompt(sText);

         int nXPNextLevel = GetXPByLevel(nAmount+1) - nXP;
         if (nAccountAmount >= nXPNextLevel && nAmount+1 <= 40) AddMenuSelectionInt("Add One Level", ACTION_AMOUNT_CHANGE,  1);
         nXPNextLevel = GetXPByLevel(10) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 10", ACTION_AMOUNT_SET,  10);
         nXPNextLevel = GetXPByLevel(15) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 15", ACTION_AMOUNT_SET,  15);
         nXPNextLevel = GetXPByLevel(20) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 20", ACTION_AMOUNT_SET,  20);
         nXPNextLevel = GetXPByLevel(25) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 25", ACTION_AMOUNT_SET,  25);
         nXPNextLevel = GetXPByLevel(30) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 30", ACTION_AMOUNT_SET,  30);
         nXPNextLevel = GetXPByLevel(35) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 35", ACTION_AMOUNT_SET,  35);
         nXPNextLevel = GetXPByLevel(40) - nXP;
         if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 40", ACTION_AMOUNT_SET,  40);

         if (nAmount > GetHitDice(oTarget)) AddMenuSelectionInt("Make the Withdraw", ACTION_WITHDRAW_XP);
         AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
         AddMenuSelectionInt("End", ACTION_END_CONVO);
         break;
    }
}

void CleanUp() {
    DeleteLocalObject(LIST_OWNER, SDB_TOME_TARGET);
    DeleteLocalInt(LIST_OWNER, SDB_TOME_PAGE);
    DeleteLocalInt(LIST_OWNER, SDB_TOME_OPTIONS);
    DeleteLocalString(LIST_OWNER, SDB_TOME_TARGET);
    DeleteList(SDB_TOME_LIST, LIST_OWNER);
    DeleteList(SDB_TOME_LIST+"_SUB", LIST_OWNER);
}

void main() {
   object oPC = GetPcDlgSpeaker();
   if (!SDB_FactionIsMember(oPC) && !GetIsDM(oPC)) return;
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         if (oPC==GetTargetPC() && SDB_FactionGetRank(oPC)!=SDB_FACTION_GENERAL) SetLocalObject(LIST_OWNER, SDB_TOME_TARGET, OBJECT_INVALID);
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(FALSE);
         SetDlgResponseList(SDB_TOME_LIST, LIST_OWNER);
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


