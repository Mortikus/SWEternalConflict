#include "seed_db_inc"
#include "zdlg_include_i"

void main() {
   object oPC = GetLastSpeaker();

   if (!SDB_CheckDatabase()) {
      SendMessageToPC(oPC, "Sorry, the bank is closed until Mr SQL feels better. Apparently, he was too sick to come to work today.");
      return;
   }
    OpenNextDlg(oPC,OBJECT_SELF,"seed_bank",TRUE,FALSE);
}
