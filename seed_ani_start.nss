#include "zdlg_include_i"

void main() {
    object oPC = GetItemActivator();
//    StartDlg(oPC,GetItemActivated(),"seed_ani_token",TRUE,FALSE);
    OpenNextDlg(oPC, GetItemActivated(), "seed_ani_token", TRUE, FALSE);
}
