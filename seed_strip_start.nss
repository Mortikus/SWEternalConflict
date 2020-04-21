#include "zdlg_include_i"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsDM(oPC)) {
      DestroyObject(GetItemActivated());
      SendMessageToPC(oPC, "You are not a DM. Your action has been logged.");
   }
   SetLocalObject(oPC, "DM_STRIP", oTarget);
   OpenNextDlg(oPC, GetItemActivated(), "seed_itemedit", TRUE, FALSE);
}
