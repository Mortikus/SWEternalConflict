#include "seed_helper_func"
#include "nw_i0_tool"
#include "x2_inc_itemprop"
#include "x0_i0_position"

const int KEG_COST_ABILITY       = 1000;
const int KEG_COST_BLESSWEAPON   = 2500;
const int KEG_COST_DEAFCLANG     = 8000;
const int KEG_COST_GRMAGICWEAPON = 4000;
const int KEG_COST_DARKFIRE      = 4000;
const int KEG_COST_HASTE         = 4000;


void ApplyBoost(object oUser, int iSpell, string sFloatText = "") {
   object oCaster = GetObjectByTag("BABA_YAGA");
//   AssignCommand(oCaster, ActionCastSpellAtObject(iSpell, oUser, METAMAGIC_EXTEND, TRUE));
   ActionCastSpellAtObject(iSpell, oUser, METAMAGIC_EXTEND, TRUE);
   if (sFloatText != "") FloatingTextStringOnCreature(sFloatText, oUser, TRUE);
   DeleteLocalInt(oUser, "BUFFING");
}

void BoostBuddy(object oUser, int iSpell, int iBeam = 0) {
   object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
   if (GetIsObjectValid(oFam)) {
      if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oUser, BODY_NODE_CHEST), oFam, 0.75);
      DelayCommand(0.5, ApplyBoost(oFam, iSpell));
      object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
      if (GetIsObjectValid(oSum) && oFam!=GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser)) {
         if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oFam, BODY_NODE_CHEST), oSum, 0.75);
         DelayCommand(0.5, ApplyBoost(oSum, iSpell));
      }
   }
}

int PayPiper(object oUser, int iPrice) {
   object oFish = GetItemPossessedBy(oUser, "NW_IT_MSMLMISC20"); // SHE LOVES FISHHEADS
   if (GetIsObjectValid(oFish)) {
      DestroyObject(oFish);
      SendMessageToPC(oUser, "Baba Yaga eats your fish.");
      PlaySound(PickOne("as_pl_x2rghtav1","as_pl_x2rghtav2","as_pl_x2rghtav3"));
      return TRUE;
   }
   if (iPrice == 0) return TRUE; // FREEBIE
   if (iPrice > GetGold(oUser)) {
      FloatingTextStringOnCreature("Sorry, no credit.", oUser, TRUE);
      return FALSE;
   }
   TakeGoldFromCreature(iPrice, oUser);
   PlaySound("it_coins");
   return TRUE;
}

int AlreadyBuffed(object oUser, int iSpell) {
   if (GetHasSpellEffect(iSpell, oUser)) {
      FloatingTextStringOnCreature("Already buffed.", oUser, TRUE);
      return TRUE;
   }
   if (GetLocalInt(oUser, "BUFFING")) {
      FloatingTextStringOnCreature("Waiting for buff...", oUser, TRUE);
      return TRUE;
   }
   return FALSE;

}

void KegDrink(object oUser, int iSpell, int iPrice, string sFloatText = "") {
   if (AlreadyBuffed(oUser, iSpell)) return;
   //if (HasItem(oUser, "NW_IT_MSMLMISC20")) iPrice = 1; // FISH FOR BABA
   if (!PayPiper(oUser, iPrice)) return;
   SetLocalInt(oUser, "BUFFING", TRUE);
   AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
   DelayCommand(1.0, ApplyBoost(oUser, iSpell, sFloatText));
   DelayCommand(1.1, BoostBuddy(oUser, iSpell));
}

void GemUse(object oUser, int iSpell, int iPrice, int iBeam) {
   object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
   if (oRight==OBJECT_INVALID) {
      FloatingTextStringOnCreature("No Weapon Held.", oUser, TRUE);
      return;
   }

   if (AlreadyBuffed(oUser, iSpell)) return;
   //if (HasItem(oUser, "NW_IT_MSMLMISC20")) iPrice = 1; // FISH FOR BABA
   if (!PayPiper(oUser, iPrice)) return;
   SetLocalInt(oUser, "BUFFING", TRUE);
   object oCaster = GetObjectByTag("BABA_YAGA");
   AssignCommand(oCaster, ClearAllActions());
   AssignCommand(oCaster, SetFacingPoint(GetPosition(oUser)));
   AssignCommand(oCaster, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 2.5));
   DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oCaster, BODY_NODE_HAND), OBJECT_SELF, 2.20));
   DelayCommand(0.9, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
   DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), OBJECT_SELF));
   DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oCaster));
   DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_ODD), OBJECT_SELF));
   DelayCommand(2.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oCaster));
   DelayCommand(2.4, AssignCommand(oCaster, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0)));
   DelayCommand(2.5, ApplyBoost(oUser, iSpell));
   DelayCommand(2.6, BoostBuddy(oUser, iSpell, iBeam));
   object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
   if (oLeft!=OBJECT_INVALID) {
      if (IPGetIsMeleeWeapon(oLeft)) {
         if (PayPiper(oUser, iPrice)) {
            DelayCommand(2.7, AssignCommand(oUser, ClearAllActions()));
            DelayCommand(2.8, AssignCommand(oUser, ActionUnequipItem(oRight)));
            DelayCommand(2.9, ApplyBoost(oUser, iSpell));
            DelayCommand(3.0, AssignCommand(oUser, ActionEquipItem(oRight, INVENTORY_SLOT_RIGHTHAND)));
            DelayCommand(3.1, AssignCommand(oUser, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND)));
         }
      }
   }
   DelayCommand(6.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

void main() {
   object oUser = GetLastUsedBy();
   if (oUser==OBJECT_INVALID) oUser = GetEnteringObject();
   object oLocator;
   location lTarget;
   int iSpell;
   string sTxt="";
   int iPrice;
   effect eEffect;

   string sTag=GetTag(OBJECT_SELF);

   if (GetStringLeft(sTag,4)=="KEG_") {
      if (HasItem(oUser, "BottomlessMug")) iPrice = 0;
      else iPrice = KEG_COST_ABILITY;
   }

   if (GetIsObjectValid(oUser) && GetIsPC(oUser)) {
      if (sTag=="KEG_STR") {
         KegDrink(oUser, SPELL_GREATER_BULLS_STRENGTH, iPrice, "grr");
         return;
      } else if (sTag=="KEG_CON") {
         KegDrink(oUser, SPELL_GREATER_ENDURANCE, iPrice, "mmm");
         return;
      } else if (sTag=="KEG_DEX") {
         KegDrink(oUser, SPELL_GREATER_CATS_GRACE, iPrice, "yum");
         return;
      } else if (sTag=="KEG_WIS") {
         KegDrink(oUser, SPELL_GREATER_OWLS_WISDOM, iPrice, "om");
         return;
      } else if (sTag=="KEG_INT") {
         KegDrink(oUser, SPELL_FOXS_CUNNING, iPrice, "hmm");
         return;
      } else if (sTag=="KEG_CHA") {
         KegDrink(oUser, SPELL_GREATER_EAGLE_SPLENDOR, iPrice, "ooh");
         return;
      } else if (sTag=="GEM_HASTE") {
         KegDrink(oUser, SPELL_HASTE, KEG_COST_HASTE, "Ándale!!");
         return;
      } else if (sTag=="GEM_YELLOW") {
         GemUse(oUser, SPELL_BLESS_WEAPON, KEG_COST_BLESSWEAPON, VFX_BEAM_HOLY);
         return;
      } else if (sTag=="GEM_BLUE") {
         GemUse(oUser, SPELL_DEAFENING_CLANG, KEG_COST_DEAFCLANG, VFX_BEAM_LIGHTNING);
         return;
      } else if (sTag=="GEM_RED") {
         GemUse(oUser, SPELL_DARKFIRE, KEG_COST_DARKFIRE, VFX_BEAM_FIRE);
         return;
      } else if (sTag=="GEM_GREEN") {
         GemUse(oUser, SPELL_GREATER_MAGIC_WEAPON, KEG_COST_GRMAGICWEAPON, VFX_BEAM_MIND);
         return;
      } else if (sTag=="SERVER_PORTAL") {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oUser);
         DelayCommand(1.0,ExecuteScript("port_other_serv", oUser));
      } else if (sTag=="CAVERN_GONG") {
          eEffect=EffectVisualEffect(VFX_FNF_SOUND_BURST);
          ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,OBJECT_SELF);
          AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1"));
          DelayCommand(0.5,AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1")));
          DelayCommand(1.0,AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1")));
      } else if (sTag=="COO_STOUT") {
         KegDrink(oUser, SPELL_GREATER_ENDURANCE, 0, "mmm...Imperial Stout");
         return;
      } else if (sTag=="COO_ACIDPUDDLE") {
         sTxt="?";
         iSpell = SPELL_INFLICT_LIGHT_WOUNDS;
         AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 3.0f));
         DelayCommand(1.0f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(2.0f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(2.9f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oUser));
         DelayCommand(3.0f, FloatingTextStringOnCreature("Ouch!", oUser, FALSE));
         DelayCommand(3.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(), oUser, 3.0f));
      } else if (sTag=="COO_ACIDFOUNTAIN") {
         sTxt="?";
         iSpell = SPELL_DOOM;
         AssignCommand(oUser, ActionSpeakString(PickOne("...oh the colors...","I serve you Aass!","Down I go...","..what the..")));
         AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 3.0f));
         DelayCommand(2.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oUser));
         DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(), oUser, 3.0f));
      } else if (GetStringLeft(sTag,15)=="COO_TA_ACIDBATH") {
         sTxt="Owie";
         DelayCommand(1.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(2.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(3.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(4.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(5.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(6.5f, FloatingTextStringOnCreature("Ow!", oUser, FALSE));
         DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oUser));
         DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(), oUser, 5.0f));
         DelayCommand(2.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(), DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY), oUser));
         DelayCommand(6.2f, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 20.0f)));
         return;
      } else if (sTag=="COO_MQ_ACIDBATH") {
         sTxt="Fizz";
         DelayCommand(1.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(2.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(3.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(4.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(5.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(6.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(7.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(8.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(9.5f, FloatingTextStringOnCreature(sTxt, oUser, FALSE));
         DelayCommand(10.5f, FloatingTextStringOnCreature("Ow!", oUser, FALSE));
         DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oUser));
         DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(), oUser, 10.0f));
         DelayCommand(2.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(2), DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY), oUser));
         DelayCommand(11.2f, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 20.0f)));
         return;
      } else if (GetStringLeft(sTag,15)=="COO_BALLISTA") {
         oUser = GetObjectByTag("COO_TARGET");
         PlaySound("cb_ht_arrow1");
         iSpell = SPELL_MELFS_ACID_ARROW;
         sTxt="Twunk!";
      } else if (sTag=="PARTY_PORTAL") {
         if (GetLocalInt(oUser, "PARTY_PORT")) {
            SendMessageToPC(oUser, "Yawn...You must rest before using the Party Portal again.");
            return;
         }
         object oLeader = GetFactionLeader(oUser);
         string stFAID = GetLocalString(GetArea(oLeader), "FAID"); // FACTION ID OF AREA PORTING TO
         string sFAID = GetLocalString(oUser, "SDB_FAID");
         if (stFAID!="" && stFAID!=sFAID) {
            SendMessageToPC(oUser, "Sorry, " + GetName(oLeader) + " is currently in a Faction territory.");
            return;
         }
         int bPortFlag = TRUE;
         if (GetName(oUser) != GetName(oLeader)) {
            if (abs(GetHitDice(oLeader)-GetHitDice(oUser))>10) {
               SendMessageToPC(oUser, "The level difference between you and the Party Leader is too much. The max is 10 levels.");
               return;
            }
            if (GetHitDice(oUser)==40) {
               SendMessageToPC(oUser, "Sorry, you are level 40 and cannot use this portal.");
               return;
            }
            if (GetHitDice(oLeader)==40) {
               SendMessageToPC(oUser, "Sorry, your Party Leader is level 40 and cannot be ported to.");
               return;
            }
            object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oLeader);
            lTarget = GetFlankingRightLocation(oLeader);
            if (oCreature!=OBJECT_INVALID) {
               if (GetDistanceBetween(oLeader, oCreature) < 25.0) {
                  SendMessageToPC(oUser, "It is unsafe to port to the Party Leader. Try again in a few seconds.");
                  lTarget = GetLocation(GetObjectByTag("BYH_DOOR_WP"));
                  bPortFlag = FALSE;
               }
            }
            if (bPortFlag) SetLocalInt(oUser, "PARTY_PORT", 1);
            ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oUser);
            DelayCommand(0.5f,AssignCommand(oUser, JumpToLocation(lTarget)));
         } else {
            SendMessageToPC(oUser, "One cannot port to one's self.");
         }

      }
   } else  {
      SendMessageToPC(oUser,"Doh! OnUsedBonusElse!");
   }
}
