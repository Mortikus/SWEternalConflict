#include "seed_db_inc"
#include "zdlg_include_i"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsDM(oPC)) {
      DestroyObject(GetItemActivated());
      SendMessageToPC(oPC, "You are not a DM. Your action has been logged.");
      return;
   }
   if (!GetIsPC(oTarget) || oPC==oTarget) { // Target needs to be PC
      SendMessageToPC(oPC, "Target is not a valid player character");
      return;
   }
   SetLocalObject(oPC, "SDB_PRIZE_TARGET", oTarget);
   OpenNextDlg(oPC,GetItemActivated(), "seed_bling_wand", TRUE, FALSE);
}
