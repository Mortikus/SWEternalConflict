#include "zdlg_include_i"

void main() {
   object oPC = GetLastSpeaker();
   if (GetXP(oPC)>2) {
      string sText = GetSubRace(oPC);
      if (sText=="") {
         SendMessageToPC(oPC, "Sorry, you must be a new character to select a Subrace.");
      } else {
         SendMessageToPC(oPC, "Sorry, you are already a member of the " + GetSubRace(oPC) + " subrace.");
      }
   }
   OpenNextDlg(oPC,OBJECT_SELF,"seed_subpick",TRUE,FALSE);
}

