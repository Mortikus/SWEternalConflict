#include "aps_include"
#include "gen_inc_color"
#include "inc_server"

const int BIT1  =           1;
const int BIT2  =           2;
const int BIT3  =           4;
const int BIT4  =           8;
const int BIT5  =          16;
const int BIT6  =          32;
const int BIT7  =          64;
const int BIT8  =         128;
const int BIT9  =         256;
const int BIT10 =         512;
const int BIT11 =        1024;
const int BIT12 =        2048;
const int BIT13 =        4096;
const int BIT14 =        8192;
const int BIT15 =       16384;
const int BIT16 =       32768;
const int BIT17 =       65536;
const int BIT18 =      131072;
const int BIT19 =      262144;
const int BIT20 =      524288;
const int BIT21 =     1048576;
const int BIT22 =     2097152;
const int BIT23 =     4194304;
const int BIT24 =     8388608;
const int BIT25 =    16777216;
const int BIT26 =    33554432;
const int BIT27 =    67108864;
const int BIT28 =   134217728;
const int BIT29 =   268435456;
const int BIT30 =   536870912;
const int BIT31 =  1073741824;

const string SERVER_TIME_LEFT = "SERVER_TIME_LEFT";

string   DelimList(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="");

string AddS(string sIn, int iIn) {
   if (iIn==1) return sIn;
   return sIn + "s";
}

string InitCap(string sIn) {
   return GetStringUpperCase(GetStringLeft(sIn,1)) + GetStringLowerCase(GetStringRight(sIn, GetStringLength(sIn)-1));
}

string HoursMinutes(int iTime) {
   int iHours = iTime / 60;
   int iMinutes = iTime % 60;
   string sTime = "";
   if (iHours > 0) sTime = IntToString(iHours) + AddS(" hour", iHours) + " ";
   if (iMinutes > 0) sTime = sTime + IntToString(iMinutes) + AddS(" minute", iMinutes);
   return sTime;
}

int GetMax(int iNum1 = 0, int iNum2 = 0) {
   return (iNum1 > iNum2) ? iNum1 : iNum2;
}

int GetMin(int iNum1 = 0, int iNum2 = 0) {
   return (iNum1 < iNum2) ? iNum1 : iNum2;
}

float GetMaxf(float iNum1 = 0.0, float iNum2 = 0.0) {
   return (iNum1 > iNum2) ? iNum1 : iNum2;
}

float GetMinf(float iNum1 = 0.0, float iNum2 = 0.0) {
   return (iNum1 < iNum2) ? iNum1 : iNum2;
}

int RandomUpperHalf(int nIn) {
   if (nIn) nIn = nIn - Random(nIn/2);
   return nIn;
}

int PickOneInt(int i1=-1, int i2=-1, int i3=-1, int i4=-1, int i5=-1, int i6=-1, int i7=-1, int i8=-1, int i9=-1, int i10=-1) {
   int i=(i1>-1)+(i2>-1)+(i3>-1)+(i4>-1)+(i5>-1)+(i6>-1)+(i7>-1)+(i8>-1)+(i9>-1)+(i10>-1); // count ints not null
   i=Random(i)+1;
   if (i==1) return i1;  if (i==2) return i2;  if (i==3) return i3;  if (i==4) return i4;  if (i==5) return i5;
   if (i==6) return i6;  if (i==7) return i7;  if (i==8) return i8;  if (i==9) return i9;  if (i==10) return i10;
   return -1;
}

int GetTick() {
   int iYear = GetCalendarYear();
   int iMonth = GetCalendarMonth();
   int iDay = GetCalendarDay();
   int iHour = GetTimeHour();
   return (iYear)*12*28*24 + (iMonth-1)*28*24 + (iDay-1)*24 + iHour;
}

string InQs(string sIn) { // Encodes Special Chars and Encloses a string in Single Quotes
   return "'" + SQLEncodeSpecialChars(sIn) + "'";
}

string HoursInDays(int nHours) {
   if (nHours>24) return IntToString(nHours/24)+" days and "+IntToString(nHours%24)+" hours";
   return IntToString(nHours%24)+" hours";
}

int IncLocalInt(object oObject, string sFld, int nVal = 1) {
   int nNew = GetLocalInt(oObject, sFld) + nVal;
   SetLocalInt(oObject, sFld, nNew);
   return nNew;
}

int DefLocalInt(object oObject, string sKey, int iValue) {
   int iCur = GetLocalInt(oObject, sKey);
   if (!iCur) {
      SetLocalInt(oObject, sKey, iValue);
      iCur = iValue;
   }
   return iCur;
}

int CountPlayers() {
   object oPC = GetFirstPC();
   int nCnt = 0;
   while (GetIsObjectValid(oPC)) {
      nCnt++;
      oPC = GetNextPC();
   }
   return nCnt;
}

void DestoryContentsAndSelf(object oChest) {
   object oItem = GetFirstItemInInventory();
   while (GetIsObjectValid(oItem)) {
      DestroyObject(oItem);
      oItem = GetNextItemInInventory();
   }
   DestroyObject(oChest);
}

void DestroyBankChestsOld() {
   int i;
   for (i=0;i<2;i++) {
      effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
      object oChest = GetObjectByTag("spcs_chest", i);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oChest);
      DestoryContentsAndSelf(oChest);
      oChest = GetObjectByTag("spcs_chest_u", i);
      if (oChest!=OBJECT_INVALID) {
         ExecuteScript("spcs_close", oChest);
         DestoryContentsAndSelf(oChest);
      }
   }
}

void DestroyBankChests() {
   int i = 0;
   effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
   object oChest = GetObjectByTag("spcs_chest", i);
   while (GetIsObjectValid(oChest)) {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oChest);
//      DestoryContentsAndSelf(oChest);
      SetLocked(oChest, TRUE);
      SetLockUnlockDC(oChest, 420);
      SetLocalInt(oChest, "in_use", 1);
      i++;
      oChest = GetObjectByTag("spcs_chest", i);
   }
   i = 0;
   oChest = GetObjectByTag("spcs_chest_u", i);
   while (GetIsObjectValid(oChest)) {
//      ExecuteScript("spcs_close", oChest);
//      DestoryContentsAndSelf(oChest);
      object oPC = GetLocalObject(oChest, "user");
      DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(GetStartingLocation())));
      i++;
      oChest = GetObjectByTag("spcs_chest_u", i);
   }
}

void TimedServerReboot(string sSEID, int nHowLong = 0) {
   string sMsg;
   int nRemain;
   if (nHowLong!=0) nRemain = nHowLong;
   else nRemain = GetLocalInt(GetModule(), SERVER_TIME_LEFT) - 1;
   SetLocalInt(GetModule(), SERVER_TIME_LEFT, nRemain);
   if (nRemain==6) DestroyBankChests();
   object oXPChain = GetObjectByTag("BC_XP_CHAIN");
   if (oXPChain!=OBJECT_INVALID) {
      int nXP = IncLocalInt(oXPChain, "XP_TIME_BONUS", CountPlayers());
      if (nXP > 4000 && (nRemain % 5)==0) sMsg = "Blighted City Pull Chain is currently worth " + IntToString(nXP) + " XP!";
   }
   if (nRemain == 0) {
      DelayCommand(3.0,SetLocalString(GetModule(), "NWNX!DMREBOOT", "RebootServer()"));
      sMsg = "Server Session #" + sSEID + " is rebooting. Thank you come again.";
      return;
   } else if ((nRemain % 15)==0 || nRemain == 1) { // 15 min & 5,4,3,2,1 notices
      sMsg = "Server Session #" + sSEID + " will restart in " + HoursMinutes(nRemain) + ".";
      SQLExecDirect("delete from temporaryban where tb_expires<=now()"); // UNBAN THE TEMPS HOURLY
   }
   if (sMsg!="") SpeakString(sMsg, TALKVOLUME_SHOUT);
   DelayCommand(60.0f, TimedServerReboot(sSEID));
}

string RemainingUpTime() {
    return HoursMinutes(GetLocalInt(GetModule(), SERVER_TIME_LEFT));
}

int IsWarpAllowed( object oPC ) {
   if (GetLocalInt(oPC, "PORTS_DEACTIVATE") == 1) {
      SendMessageToPC(oPC, "You cannot port at this time.");
      return FALSE;
   }
   if (GetLocalInt(oPC, "TRANS_ABUSE")>2) {
      SendMessageToPC(oPC, "You cannot port so soon after using multiple transitions. Wait 5 seconds and try again.");
      return FALSE;
   }
    int iHostileRange=25;
    object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
    float distance=GetDistanceBetween(oPC, oCreature);
    if (oCreature!=OBJECT_INVALID) {
        if (iHostileRange != 0 && distance <= IntToFloat(iHostileRange)) {
            SendMessageToPC(oPC, "A nearby enemy broke your concentration");
            return FALSE;
        }
    }
    return TRUE;
}

void UsePortStone(object oPC, string sWPTag) {
   if (IsWarpAllowed(oPC)) {
      SetLocalInt(oPC,"PC_TELEPORTING",1); // Teleport in effects
      DelayCommand(0.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION), oPC));
      DelayCommand(2.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_GLOBE_INVULNERABILITY), oPC));
      DelayCommand(3.0, AssignCommand (oPC,JumpToObject(GetWaypointByTag (sWPTag))));
   }
}

int GetAlignbits(int iAlign) {
   switch (iAlign) {
       case ALIGNMENT_NEUTRAL: return 1;
       case ALIGNMENT_GOOD:    return 2;
       case ALIGNMENT_EVIL:    return 4;
   }
   return 0;
}

int GetItemLevel(int nValue) {
   if (nValue <=1000   ) return 1 ;   if (nValue <=1500   ) return 2 ;   if (nValue <=2500   ) return 3 ;
   if (nValue <=3500   ) return 4 ;   if (nValue <=5000   ) return 5 ;   if (nValue <=6500   ) return 6 ;
   if (nValue <=9000   ) return 7 ;   if (nValue <=12000  ) return 8 ;   if (nValue <=15000  ) return 9 ;
   if (nValue <=19500  ) return 10;   if (nValue <=25000  ) return 11;   if (nValue <=30000  ) return 12;
   if (nValue <=35000  ) return 13;   if (nValue <=40000  ) return 14;   if (nValue <=50000  ) return 15;
   if (nValue <=65000  ) return 16;   if (nValue <=75000  ) return 17;   if (nValue <=90000  ) return 18;
   if (nValue <=110000 ) return 19;   if (nValue <=130000 ) return 20;   if (nValue <=250000 ) return 21;
   if (nValue <=1000000) return 22 + (nValue - 250001) / 250000;
   else return 25 + (nValue - 1000001) / 200000;
}

int GetHDFromXP(int nXP, int nHD = 1) {
   int nNextLvl;
   int nNextXP;
   int i;
   for (i = nHD; i<=40; i++) {
      nNextLvl = i + 1;
      nNextXP = ((nNextLvl * (nNextLvl - 1)) / 2) * 1000;
      if (nXP < nNextXP) return i;
   }
   return nHD;

}

int GetRealLevel(object oPC) {
   int nXP = GetXP(oPC);
   int nHD = GetHitDice(oPC);
   return GetHDFromXP(nXP, nHD);
}

int GetXPByLevel(int nLevel) {
   return ((nLevel * (nLevel - 1)) / 2) * 1000;
}

string Trim(string sIn) {
   int iLen = GetStringLength(sIn);
   while (iLen > 0) {
      if (GetStringRight(sIn,1)==" ") {
         sIn = GetStringLeft(sIn, iLen - 1);
      } else if(GetStringLeft(sIn,1)==" ") {
         sIn = GetStringRight(sIn, iLen - 1);
      } else {
         break;
      }
      iLen = iLen - 1;
   }
   return sIn;
}

string AbilityString(int nAbilityType) {
   if (nAbilityType==IP_CONST_ABILITY_STR) return "STR"; if (nAbilityType==IP_CONST_ABILITY_DEX) return "DEX";
   if (nAbilityType==IP_CONST_ABILITY_CON) return "CON"; if (nAbilityType==IP_CONST_ABILITY_INT) return "INT";
   if (nAbilityType==IP_CONST_ABILITY_WIS) return "WIS"; if (nAbilityType==IP_CONST_ABILITY_CHA) return "CHA";
   return "Missing Ability Text";
}

string DamageTypeString(int nDamageType) {
   if (nDamageType==IP_CONST_DAMAGETYPE_ACID)       return "Acid";
   if (nDamageType==IP_CONST_DAMAGETYPE_COLD)       return "Cold";
   if (nDamageType==IP_CONST_DAMAGETYPE_DIVINE)     return "Divine";
   if (nDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL) return "Electrical";
   if (nDamageType==IP_CONST_DAMAGETYPE_FIRE)       return "Fire";
   if (nDamageType==IP_CONST_DAMAGETYPE_MAGICAL)    return "Magical";
   if (nDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)   return "Negative";
   if (nDamageType==IP_CONST_DAMAGETYPE_POSITIVE)   return "Positive";
   if (nDamageType==IP_CONST_DAMAGETYPE_SONIC)      return "Sonic";
   if (nDamageType==IP_CONST_DAMAGETYPE_BLUDGEONING)return "Blunt";
   if (nDamageType==IP_CONST_DAMAGETYPE_PIERCING)   return "Piercing";
   if (nDamageType==IP_CONST_DAMAGETYPE_SLASHING)   return "Slashing";
   return "Missed DamageTypeString";
}

string OnHitString(int nOnHit) {
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_14)   return "DC 14";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_16)  return "DC 16";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_18)   return "DC 18";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_20)  return "DC 20";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_22)   return "DC 22";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_24)  return "DC 24";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_26)   return "DC 26";
   return "OnHitString MISSING";
}

string OnHitTypeString(int nOnHitType) {
   if (nOnHitType==IP_CONST_ONHIT_DAZE) return "Daze";
   if (nOnHitType==IP_CONST_ONHIT_FEAR) return "Fear";
   if (nOnHitType==IP_CONST_ONHIT_HOLD) return "Hold";
   if (nOnHitType==IP_CONST_ONHIT_SLOW) return "Slow";
   if (nOnHitType==IP_CONST_ONHIT_STUN) return "Stun";
   return "Missed OnHitType";
}

string DamageBonusString(int nDamageBonus) {
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   ) return "1";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4 ) return "1d4";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) return "2";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6 ) return "1d6";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) return "3";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) return "1d8";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) return "4";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10) return "1d10";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) return "5";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) return "1d12";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) return "6";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4 ) return "2d4";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) return "7";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6 ) return "2d6";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) return "8";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8 ) return "2d8";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) return "9";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10) return "2d10";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) return "10"; if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12) return "2d12";
   return "DamageBonusString MISSING";
}

string DamageImmunityString(int nDamageImmunity) {
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_5_PERCENT)   return "5%";    if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_10_PERCENT)  return "10%";
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_25_PERCENT)  return "25%";   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_50_PERCENT)  return "50%";
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_75_PERCENT)  return "75%";   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_100_PERCENT) return "100%";
   return "DamageImmunityString MISSING";
}

string DamageSoakString(int nDamageSoak) {
   if (nDamageSoak==IP_CONST_DAMAGESOAK_5_HP)  return "5";    if (nDamageSoak==IP_CONST_DAMAGESOAK_10_HP) return "10";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_15_HP) return "15";   if (nDamageSoak==IP_CONST_DAMAGESOAK_20_HP) return "20";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_25_HP) return "25";   if (nDamageSoak==IP_CONST_DAMAGESOAK_30_HP) return "30";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_35_HP) return "35";   if (nDamageSoak==IP_CONST_DAMAGESOAK_40_HP) return "40";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_45_HP) return "45";   if (nDamageSoak==IP_CONST_DAMAGESOAK_50_HP) return "50";
   return "DamageSoakString MISSING";
}

string DamageResistanceString(int nDamageResistance) {
   if (nDamageResistance==IP_CONST_DAMAGERESIST_5 )  return "5/-";    if (nDamageResistance==IP_CONST_DAMAGERESIST_10)  return "10/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_15)  return "15/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_20)  return "20/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_25)  return "25/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_30)  return "30/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_35)  return "35/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_40)  return "40/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_45)  return "45/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_50)  return "50/-";
   return "DamageResistanceString MISSING";
}

string SpellResistanceString(int nSR) {
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return "10";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return "12";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return "14";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return "16";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return "18";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return "20";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return "22";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return "24";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return "26";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return "28";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return "30";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return "32";
   return "SpellResistanceString MISSING";
}

string PickOne(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="") {
   int i=(s1!="")+(s2!="")+(s3!="")+(s4!="")+(s5!="")+(s6!=""); // count strings not null
   i=Random(i)+1;
   if (i==1) return s1;   if (i==2) return s2;   if (i==3) return s3;
   if (i==4) return s4;   if (i==5) return s5;   if (i==6) return s6;
   if (i==7) return s7;   if (i==8) return s8;   if (i==9) return s9;
   return "badger";
} // End PickOne

string GetBaseWeaponResRef(object oItem) {
   int nItem = GetBaseItemType(oItem);
   if (nItem == BASE_ITEM_BASTARDSWORD)    return "nw_wswbs001";
   if (nItem == BASE_ITEM_BATTLEAXE)       return "nw_waxbt001";
   if (nItem == BASE_ITEM_CLUB)            return "nw_wblcl001";
   if (nItem == BASE_ITEM_DAGGER)          return "nw_wswdg001";
   if (nItem == BASE_ITEM_DIREMACE)        return "nw_wdbma001";
   if (nItem == BASE_ITEM_DOUBLEAXE)       return "nw_wdbax001";
   if (nItem == BASE_ITEM_DWARVENWARAXE)   return "x2_wdwraxe001";
   if (nItem == BASE_ITEM_GREATAXE)        return "nw_waxgr001";
   if (nItem == BASE_ITEM_GREATSWORD)      return "nw_wswgs001";
   if (nItem == BASE_ITEM_HALBERD)         return "nw_wplhb001";
   if (nItem == BASE_ITEM_HANDAXE)         return "nw_waxhn001";
   if (nItem == BASE_ITEM_HEAVYFLAIL)      return "nw_wblfh001";
   if (nItem == BASE_ITEM_KAMA)            return "nw_wspka001";
   if (nItem == BASE_ITEM_KATANA)          return "nw_wswka001";
   if (nItem == BASE_ITEM_KUKRI)           return "nw_wspku001";
   if (nItem == BASE_ITEM_LIGHTFLAIL)      return "nw_wblfl001";
   if (nItem == BASE_ITEM_LIGHTHAMMER)     return "nw_wblhl001";
   if (nItem == BASE_ITEM_LIGHTMACE)       return "nw_wblml001";
   if (nItem == BASE_ITEM_LONGSWORD)       return "nw_wswls001";
   if (nItem == BASE_ITEM_MORNINGSTAR)     return "nw_wblms001";
   if (nItem == BASE_ITEM_QUARTERSTAFF)    return "nw_wdbqs001";
   if (nItem == BASE_ITEM_RAPIER)          return "nw_wswrp001";
   if (nItem == BASE_ITEM_SCIMITAR)        return "nw_wswsc001";
   if (nItem == BASE_ITEM_SCYTHE)          return "nw_wplsc001";
   if (nItem == BASE_ITEM_SHORTSPEAR)      return "nw_wplss001";
   if (nItem == BASE_ITEM_SHORTSWORD)      return "nw_wswss001";
   if (nItem == BASE_ITEM_SICKLE)          return "nw_wspsc001";
   if (nItem == BASE_ITEM_TWOBLADEDSWORD)  return "nw_wdbsw001";
   if (nItem == BASE_ITEM_WARHAMMER)       return "nw_wblhw001";
   if (nItem == BASE_ITEM_WHIP)            return "x2_it_wpwhip";
   if (nItem == BASE_ITEM_GLOVES)          return "flel_it_mgloves";
   return "";
}

void DestroyObjectDropped(object oItem) {
   if (GetIsObjectValid(oItem)) {
      if (GetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM") == 1) {
         DeleteLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM");
         if (GetItemStackSize(oItem) > 1) SetItemStackSize(oItem, 1);
         DestroyObject(oItem);
      }
   }
}

string ClassString(int nClass = 0) {
   if (nClass == CLASS_TYPE_ABERRATION     ) return "Aberration";         if (nClass == CLASS_TYPE_HARPER         ) return "Harper";
   if (nClass == CLASS_TYPE_ANIMAL         ) return "Animal";             if (nClass == CLASS_TYPE_HUMANOID       ) return "Humanoid";
   if (nClass == CLASS_TYPE_ARCANE_ARCHER  ) return "Arcane_Archer";      if (nClass == CLASS_TYPE_INVALID        ) return "";
   if (nClass == CLASS_TYPE_ASSASSIN       ) return "Assassin";           if (nClass == CLASS_TYPE_MAGICAL_BEAST  ) return "Magical_Beast";
   if (nClass == CLASS_TYPE_BARBARIAN      ) return "Barbarian";          if (nClass == CLASS_TYPE_MONK           ) return "Monk";
   if (nClass == CLASS_TYPE_BARD           ) return "Bard";               if (nClass == CLASS_TYPE_MONSTROUS      ) return "Monstrous";
   if (nClass == CLASS_TYPE_BEAST          ) return "Beast";              if (nClass == CLASS_TYPE_OUTSIDER       ) return "Outsider";
   if (nClass == CLASS_TYPE_BLACKGUARD     ) return "Blackguard";         if (nClass == CLASS_TYPE_PALADIN        ) return "Paladin";
   if (nClass == CLASS_TYPE_CLERIC         ) return "Cleric";             if (nClass == CLASS_TYPE_PALEMASTER     ) return "Palemaster";
   if (nClass == CLASS_TYPE_COMMONER       ) return "Commoner";           if (nClass == CLASS_TYPE_RANGER         ) return "Ranger";
   if (nClass == CLASS_TYPE_CONSTRUCT      ) return "Construct";          if (nClass == CLASS_TYPE_ROGUE          ) return "Rogue";
   if (nClass == CLASS_TYPE_DIVINECHAMPION ) return "Divinechampion";     if (nClass == CLASS_TYPE_SHADOWDANCER   ) return "Shadowdancer";
   if (nClass == CLASS_TYPE_DRAGON         ) return "Dragon";             if (nClass == CLASS_TYPE_SHAPECHANGER   ) return "Shapechanger";
   if (nClass == CLASS_TYPE_DRAGONDISCIPLE ) return "Dragondisciple";     if (nClass == CLASS_TYPE_SHIFTER        ) return "Shifter";
   if (nClass == CLASS_TYPE_DRUID          ) return "Druid";              if (nClass == CLASS_TYPE_SORCERER       ) return "Sorcerer";
   if (nClass == CLASS_TYPE_DWARVENDEFENDER) return "Dwarvendefender";    if (nClass == CLASS_TYPE_UNDEAD         ) return "Undead";
   if (nClass == CLASS_TYPE_ELEMENTAL      ) return "Elemental";          if (nClass == CLASS_TYPE_VERMIN         ) return "Vermin";
   if (nClass == CLASS_TYPE_FEY            ) return "Fey";                if (nClass == CLASS_TYPE_WEAPON_MASTER  ) return "Weapon_Master";
   if (nClass == CLASS_TYPE_FIGHTER        ) return "Fighter";            if (nClass == CLASS_TYPE_WIZARD         ) return "Wizard";
   if (nClass == CLASS_TYPE_GIANT          ) return "Giant";
   return "miss: " + IntToString(nClass);
}


int CountParty(object oMinion) {
   object oParty = GetFirstFactionMember(oMinion);
   int nCnt = 0;
   while (GetIsObjectValid(oParty)) {
      if (GetArea(oParty)==GetArea(oMinion)) nCnt++;
      oParty = GetNextFactionMember(oMinion);
   }
   return nCnt;
}

int PCIsClose(object oObject, float fDist = 50.0) {
   return (GetArea(OBJECT_SELF) == GetArea(oObject) && GetDistanceBetween(OBJECT_SELF, oObject) < fDist);
}

string LightString(int nLight) {
   if (nLight==IP_CONST_LIGHTCOLOR_BLUE  ) return "Blue";   if (nLight==IP_CONST_LIGHTCOLOR_YELLOW) return "Yellow";
   if (nLight==IP_CONST_LIGHTCOLOR_PURPLE) return "Purple"; if (nLight==IP_CONST_LIGHTCOLOR_RED   ) return "Red";
   if (nLight==IP_CONST_LIGHTCOLOR_GREEN ) return "Green";  if (nLight==IP_CONST_LIGHTCOLOR_ORANGE) return "Orange";
   if (nLight==IP_CONST_LIGHTCOLOR_WHITE ) return "White";
   return "LightString MISSING";
}

string VisualEffectString(int nVE) {
   if (nVE==ITEM_VISUAL_ACID   )    return "Acid";          if (nVE==ITEM_VISUAL_COLD) return "Cold";
   if (nVE==ITEM_VISUAL_ELECTRICAL) return "Electrical";    if (nVE==ITEM_VISUAL_EVIL) return "Evil";
   if (nVE==ITEM_VISUAL_FIRE   )    return "Fire";          if (nVE==ITEM_VISUAL_HOLY) return "Holy";
   if (nVE==ITEM_VISUAL_SONIC  )    return "Sonic";
   return "VisualEffectString MISSING";
}

string SaveVsBonusString(int nSaveType) {
   if (nSaveType==IP_CONST_SAVEVS_ACID         ) return "Acid";            if (nSaveType==IP_CONST_SAVEVS_COLD         ) return "Cold";
   if (nSaveType==IP_CONST_SAVEVS_DEATH        ) return "Death";           if (nSaveType==IP_CONST_SAVEVS_DISEASE      ) return "Disease";
   if (nSaveType==IP_CONST_SAVEVS_DIVINE       ) return "Divine";          if (nSaveType==IP_CONST_SAVEVS_ELECTRICAL   ) return "Electrical";
   if (nSaveType==IP_CONST_SAVEVS_FEAR         ) return "Fear";            if (nSaveType==IP_CONST_SAVEVS_FIRE         ) return "Fire";
   if (nSaveType==IP_CONST_SAVEVS_MINDAFFECTING) return "Mindaffecting";   if (nSaveType==IP_CONST_SAVEVS_NEGATIVE     ) return "Negative";
   if (nSaveType==IP_CONST_SAVEVS_POISON       ) return "Poison";          if (nSaveType==IP_CONST_SAVEVS_POSITIVE     ) return "Positive";
   if (nSaveType==IP_CONST_SAVEVS_SONIC        ) return "Sonic";           if (nSaveType==IP_CONST_SAVEVS_UNIVERSAL    ) return "Universal";
   return "Missed SaveVsBonusString";
}

string SaveSpecificBonusString(int nSaveType) {
   if (nSaveType==IP_CONST_SAVEBASETYPE_FORTITUDE) return"Fortitude";      if (nSaveType==IP_CONST_SAVEBASETYPE_WILL     ) return"Will";
   if (nSaveType==IP_CONST_SAVEBASETYPE_REFLEX   ) return"Reflex";
   return "Missed SaveSpecificBonusString";
}

string SkillBonusString(int nSkillType) {
   if (nSkillType==SKILL_ANIMAL_EMPATHY  ) return "Animal Empathy"; if (nSkillType==SKILL_CONCENTRATION   ) return "Concentration";
   if (nSkillType==SKILL_DISABLE_TRAP    ) return "Disable Trap";   if (nSkillType==SKILL_DISCIPLINE      ) return "Discipline";
   if (nSkillType==SKILL_HEAL            ) return "Heal";           if (nSkillType==SKILL_HIDE            ) return "Hide";
   if (nSkillType==SKILL_INTIMIDATE      ) return "Intimidate";     if (nSkillType==SKILL_LISTEN          ) return "Listen";
   if (nSkillType==SKILL_MOVE_SILENTLY   ) return "Move Silently";  if (nSkillType==SKILL_OPEN_LOCK       ) return "Open Lock";
   if (nSkillType==SKILL_PARRY           ) return "Parry";          if (nSkillType==SKILL_PERFORM         ) return "Perform";
   if (nSkillType==SKILL_PICK_POCKET     ) return "Pick Pocket";    if (nSkillType==SKILL_SEARCH          ) return "Search";
   if (nSkillType==SKILL_SET_TRAP        ) return "Set Trap";       if (nSkillType==SKILL_SPELLCRAFT      ) return "Spellcraft";
   if (nSkillType==SKILL_SPOT            ) return "Spot";           if (nSkillType==SKILL_TAUNT           ) return "Taunt";
   if (nSkillType==SKILL_TUMBLE          ) return "Tumble";         if (nSkillType==SKILL_USE_MAGIC_DEVICE) return "Use Magic Device";
   return "Missed SkillBonusString";
}

itemproperty CreateItemProperty(int iPropType, int iSubType, int iBonus) {
    switch(iPropType) {
        case ITEM_PROPERTY_ABILITY_BONUS:                return ItemPropertyAbilityBonus(iSubType, iBonus);
        case ITEM_PROPERTY_AC_BONUS:                     return ItemPropertyACBonus(iBonus);
        case ITEM_PROPERTY_ATTACK_BONUS:                 return ItemPropertyAttackBonus(iBonus);
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:  return ItemPropertyBonusLevelSpell(iSubType, iBonus);
        case ITEM_PROPERTY_DAMAGE_BONUS:                 return ItemPropertyDamageBonus(iSubType, iBonus);
        case ITEM_PROPERTY_DARKVISION:                   return ItemPropertyDarkvision();
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:            return ItemPropertyEnhancementBonus(iBonus);
        case ITEM_PROPERTY_HASTE:                        return ItemPropertyHaste();
        case ITEM_PROPERTY_KEEN:                         return ItemPropertyKeen();
        case ITEM_PROPERTY_LIGHT:                        return ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, iBonus);
        case ITEM_PROPERTY_MASSIVE_CRITICALS:            return ItemPropertyMassiveCritical(iBonus);
        case ITEM_PROPERTY_MIGHTY:                       return ItemPropertyMaxRangeStrengthMod(iBonus);
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:            return ItemPropertyOnHitProps(iSubType, iBonus, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS);
        case ITEM_PROPERTY_REGENERATION:                 return ItemPropertyRegeneration(iBonus);
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:        return ItemPropertyVampiricRegeneration(iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS:           return ItemPropertyBonusSavingThrowVsX(iSubType, iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:  return ItemPropertyBonusSavingThrow(iSubType, iBonus);
        case ITEM_PROPERTY_SKILL_BONUS:                  return ItemPropertySkillBonus(iSubType, iBonus);
        case ITEM_PROPERTY_VISUALEFFECT:                 return ItemPropertyVisualEffect(iBonus);
    }
    return ItemPropertyAttackPenalty(iBonus);
}

string InventorySlotString(int nSlot = 0) {
   if (nSlot == INVENTORY_SLOT_HEAD     ) return "Head";         if (nSlot == INVENTORY_SLOT_CHEST    ) return "Chest";
   if (nSlot == INVENTORY_SLOT_BOOTS    ) return "Boots";        if (nSlot == INVENTORY_SLOT_ARMS     ) return "Arms";
   if (nSlot == INVENTORY_SLOT_RIGHTHAND) return "Right Hand";   if (nSlot == INVENTORY_SLOT_LEFTHAND ) return "Left Hand";
   if (nSlot == INVENTORY_SLOT_CLOAK    ) return "Cloak";        if (nSlot == INVENTORY_SLOT_LEFTRING ) return "Left Ring";
   if (nSlot == INVENTORY_SLOT_RIGHTRING) return "Right Ring";   if (nSlot == INVENTORY_SLOT_NECK     ) return "Neck";
   if (nSlot == INVENTORY_SLOT_BELT     ) return "Belt";         if (nSlot == INVENTORY_SLOT_ARROWS   ) return "Arrows";
   if (nSlot == INVENTORY_SLOT_BULLETS  ) return "Bullets";      if (nSlot == INVENTORY_SLOT_BOLTS    ) return "Bolts";
   return "InventorySlotString Mssing " + IntToString(nSlot);
}

string IPClassString(int nClass = 0) {
   if (nClass == IP_CONST_CLASS_BARD    ) return "Bard"    ;
   if (nClass == IP_CONST_CLASS_CLERIC  ) return "Cleric"  ;
   if (nClass == IP_CONST_CLASS_DRUID   ) return "Druid"   ;
   if (nClass == IP_CONST_CLASS_PALADIN ) return "Paladin" ;
   if (nClass == IP_CONST_CLASS_RANGER  ) return "Ranger"  ;
   if (nClass == IP_CONST_CLASS_SORCERER) return "Sorcerer";
   if (nClass == IP_CONST_CLASS_WIZARD  ) return "Wizard"  ;
   return "IPClassString Mssing " + IntToString(nClass);
}

string IPString(int nProp) {
   switch (nProp) {
      case ITEM_PROPERTY_ABILITY_BONUS:                  return "Ability Bonus";
      case ITEM_PROPERTY_AC_BONUS:                       return "Ac Bonus";
      case ITEM_PROPERTY_ATTACK_BONUS:                   return "Attack Bonus";
      case ITEM_PROPERTY_BONUS_FEAT:                     return "Bonus Feat";
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:    return "Bonus Spell Slot";
      case ITEM_PROPERTY_CAST_SPELL:                     return "Cast Spell";
      case ITEM_PROPERTY_DAMAGE_BONUS:                   return "Damage Bonus";
      case ITEM_PROPERTY_DAMAGE_REDUCTION:               return "Damage Reduction";
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:              return "Damage Resistance";
      case ITEM_PROPERTY_HASTE:                          return "Haste";
      case ITEM_PROPERTY_HOLY_AVENGER:                   return "Holy Avenger";
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:           return "Immunity Damage Type";
      case ITEM_PROPERTY_KEEN:                           return "Keen";
      case ITEM_PROPERTY_MASSIVE_CRITICALS:              return "Massive Criticals";
      case ITEM_PROPERTY_MIGHTY:                         return "Mighty";
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:              return "On Hit Properties";
      case ITEM_PROPERTY_REGENERATION:                   return "Regeneration";
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:          return "Regeneration Vampiric";
      case ITEM_PROPERTY_SAVING_THROW_BONUS:             return "Saving Throw Bonus";
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:    return "Saving Throw Bonus Specific";
      case ITEM_PROPERTY_SKILL_BONUS:                    return "Skill Bonus";
      case ITEM_PROPERTY_SPELL_RESISTANCE:               return "Spell Resistance";
   }
   return "UNKNOWN PROP";
}

string ItemPropertyDesc(int iPropType, int iSubType, int iBonus, int iParam1=0) {
   switch (iPropType) {
      case ITEM_PROPERTY_ABILITY_BONUS:               return AbilityString(iSubType) + "+" + IntToString(iBonus);
      case ITEM_PROPERTY_AC_BONUS:                    return "AC +" + IntToString(iBonus);
      case ITEM_PROPERTY_ATTACK_BONUS:                return "Attack +" + IntToString(iBonus);
      case ITEM_PROPERTY_BONUS_FEAT:
         if (iSubType==37) return "Disarm";
         return "Feat" + IntToString(iSubType);
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: return IPClassString(iSubType) + " Level " + IntToString(iBonus);
      case ITEM_PROPERTY_CAST_SPELL:                  return "Cast Spell " + IntToString(iSubType);
      case ITEM_PROPERTY_DAMAGE_BONUS:                return DamageTypeString(iSubType) + " " + DamageBonusString(iBonus);
      case ITEM_PROPERTY_DAMAGE_REDUCTION:            return " Damage Reduction +" + IntToString(iSubType+1) + " soak " + DamageSoakString(iBonus);
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:           return DamageTypeString(iSubType) + " " + DamageResistanceString(iBonus);
      case ITEM_PROPERTY_DARKVISION:                  return "Darkvision";
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS:     return SaveVsBonusString(iSubType) + " save -" + IntToString(iBonus);
      case ITEM_PROPERTY_ENHANCEMENT_BONUS:           return "Enhancement +" + IntToString(iBonus);
      case ITEM_PROPERTY_HASTE:                       return "Haste";
      case ITEM_PROPERTY_HOLY_AVENGER:                return "Holy Avenger";
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:        return DamageTypeString(iSubType) + " immunity " + DamageImmunityString(iBonus);
      case ITEM_PROPERTY_KEEN:                        return "Keen";
      case ITEM_PROPERTY_LIGHT:                       return LightString(iParam1) + " Light";
      case ITEM_PROPERTY_MASSIVE_CRITICALS:           return "Massive Crits" + DamageBonusString(iBonus);
      case ITEM_PROPERTY_MIGHTY:                      return "Mighty +" + IntToString(iBonus);
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:           return "On Hit " + OnHitTypeString(iSubType) + " " + OnHitString(iBonus);
      case ITEM_PROPERTY_REGENERATION:                return "Regeneration +" + IntToString(iBonus);
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:       return "Vampiric Regen +" + IntToString(iBonus);
      case ITEM_PROPERTY_SAVING_THROW_BONUS:          return "Save Vs " + SaveVsBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: return SaveSpecificBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SKILL_BONUS:                 return SkillBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SPELL_RESISTANCE:            return "Spell Resistance " + SpellResistanceString(iBonus);
      case ITEM_PROPERTY_VISUALEFFECT:                return "Visual Effect " + VisualEffectString(iSubType);
   }
   return "Missed ItemPropertyDesc " + IntToString(iPropType) + " : " + IntToString(iSubType) + " : " + IntToString(iBonus);
}

int GetHasSpellSchool(object oPC, int iSchool) {
   if (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC)) return FALSE; // NO WIZ LEVELS
   int iHasSchool = GetLocalInt(oPC, "SPELL_SCHOOL");
   return (iHasSchool==iSchool);
}

void LetoReadSpellSchool(object oPC) {
   if (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC)) return; // NO WIZ LEVELS, NOTHING TO SEE HERE
   string sPath = GetVaultDir()+"/"+GetPCPlayerName(oPC)+"/";
   string sScript  = "%char = '"+sPath+"'+FindNewestBic('"+sPath+"'); " + " for (/ClassList) {if (/~/School ne '') {print /~/School;}} close %char; ";
   ExportSingleCharacter(oPC);
   WriteTimestampedLogEntry("Leto Get Spell School Script >: "+sScript);
   SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", sScript);
   string sScriptResult = GetLocalString(GetModule(), "NWNX!LETO!SCRIPT");
   WriteTimestampedLogEntry("Leto Results <: "+sScriptResult);
   SetLocalInt(oPC, "SPELL_SCHOOL", StringToInt(sScriptResult));
   SendMessageToPC(oPC, "Spell School is " + sScriptResult);
}

void LoggedSendMessageToPC(object oPC, string sMsg) {
   WriteTimestampedLogEntry("To " + GetName(oPC) + ": " + sMsg);
   SendMessageToPC(oPC, sMsg);
}


int HasShield(int iShield, string sCheck, string sNew) {
   if (GetHasSpellEffect(iShield, OBJECT_SELF)) {
      SendMessageToPC(OBJECT_SELF, sNew + " shield cannot stack with " + sCheck + " shield.");
      return TRUE;
   }
   return FALSE;
}

int IsPure(object oPC) {
   if (GetCasterLevel(oPC)==GetHitDice(oPC)) return GetHitDice(oPC);
   return FALSE;
}

int RemoveEffectBySubType(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID) {
   int bRemove = FALSE;
   effect eSearch = GetFirstEffect(oPC);
   while (GetIsEffectValid(eSearch)) {
      //Check to see if the effect matches a particular type defined below
      if (GetEffectType(eSearch)==nEffectType) {
         if (nEffectSubType==-1 || GetEffectSubType(eSearch)==nEffectSubType) {
            if (oCreator==OBJECT_INVALID) {
               RemoveEffect(oPC, eSearch);
               bRemove = TRUE;
            } else {
               if (GetEffectCreator(eSearch)==oCreator) {
                  RemoveEffect(oPC, eSearch);
                  bRemove = TRUE;
               }
            }
         }
      }
      eSearch = GetNextEffect(oPC);
   }
   return bRemove;
}

int RemoveEffectByCreator(object oPC, object oCreator) {
   int bRemove = FALSE;
   effect eSearch = GetFirstEffect(oPC);
   while (GetIsEffectValid(eSearch)) {
      if (GetEffectCreator(eSearch)==oCreator) {
SendMessageToPC(oPC, "Removed Effect given by " + GetName(oCreator));
         RemoveEffect(oPC, eSearch);
         bRemove = TRUE;
      }

      eSearch = GetNextEffect(oPC);
   }
   return bRemove;
}

void DestroyUndead(object oMaster) { // KILLS ALL DOMINATED CREATURES OF A PC
   int nCnt = GetLocalInt(oMaster, "UNDEADCOUNT");
   if (nCnt==0) return;
   object oMinion = GetFirstObjectInArea(GetArea(oMaster));
   while (GetIsObjectValid(oMinion)) {
      if (GetLocalObject(oMinion, "DOMINATED")==oMaster) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oMinion);
         DestroyObject(oMinion, 0.1);
      }
      oMinion = GetNextObjectInArea(GetArea(oMaster));
   }
   DeleteLocalInt(OBJECT_SELF, "UNDEADCOUNT");
}

string DelimList(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="") {
   if (s2=="") return s1; else s1 = s1 + "," + s2;   if (s3=="") return s1; else s1 = s1 + "," + s3;
   if (s4=="") return s1; else s1 = s1 + "," + s4;   if (s5=="") return s1; else s1 = s1 + "," + s5;
   if (s6=="") return s1; else s1 = s1 + "," + s6;   if (s7=="") return s1; else s1 = s1 + "," + s7;
   if (s8=="") return s1; else s1 = s1 + "," + s8;   if (s9=="") return s1; else s1 = s1 + "," + s9;
   return s1;
}

//void main() {}
