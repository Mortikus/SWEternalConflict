#include "seed_enc_inc"

void main() {
   if (!GetEncounterActive(OBJECT_SELF)) return;
   if (GetLocalInt(OBJECT_SELF, "SpawnOK")!=0) return; // WAITING FOR ENCOUNTER RESET TIMER
   object oMinion;
   object oEnteredBy=GetEnteringObject();
   object oLocator;
   object oItem;
   object oObject;
   itemproperty ipAdd;
   location lSpawn;
   effect eEffect;
   int i;
   int j;
   int k;
   float l;
   string sRef;
   int PartyCnt;

   string sWhich=GetTag(OBJECT_SELF);
   if (sWhich=="DOT_BARREL_ENC") {
      if (d10()!=1) return; // ONCE EVERY 6 SPAWNS
      oLocator = GetObjectByTag("DOT_BARREL");
      oMinion = MakeCreature("tundradwarf001",oLocator, FALSE);
      HideWeapons(oMinion);
      AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0f, 900.0));
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      SRM_CreateGem(oLocator, TREASURE_MEDIUM, 20);
      oLocator = GetObjectByTag("DOT_CRATE");
      oMinion = MakeCreature("dopkalfarwarrior",oLocator, FALSE);
      HideWeapons(oMinion);
      AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0f, 900.0));
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      SRM_CreateGem(oLocator, TREASURE_MEDIUM, 20);
   } else if (sWhich=="DIF_MAIN_ENC") {
      if (d20()!=1) return; // ONCE EVERY 6 SPAWNS
      for (i=0; i<2; i++) {
         oLocator = GetObjectByTag("DIF_MAGE_WP",i);
         oMinion = MakeCreature("dopkalfar",oLocator, FALSE);
         AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 900.0));
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      }
      oLocator = GetObjectByTag("DIF_WARRIOR_WP");
      oMinion = MakeCreature("dopkalfarwar002",oLocator, FALSE);
      AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0f, 900.0));
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      oLocator = GetObjectByTag("DIF_BOSS_WP");
      oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
      for (j=1; j<=30; j++) DoPrayer(oMinion);
      AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0f, 900.0));
   } else if (sWhich=="DIF_CUTTER_ENC") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      oLocator = GetObjectByTag("DIF_CUTTER_WP");
      oMinion = MakeCreature("frosttiger",oLocator, FALSE);
   } else if (sWhich=="DOC_TOP_ENC") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      oLocator = GetObjectByTag("DOC_RACK_TOP",1);
      if (d3()==1) oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
      else oMinion = MakeCreature("dopkalfar002",oLocator, FALSE);
      for (i=0; i<2; i++) {
         oLocator = GetObjectByTag("DOC_RACK_TOP",i);
         if (d3()==1) SRM_PickWeapon(oLocator, GetHitDice(oMinion) + Random(3), TREASURE_MEDIUM, PickOne("simple","martial","martial","exotic"));
         SRM_CreateGem(oMinion, TREASURE_MEDIUM, 26);
      }
   }
   else if (sWhich=="DOC_BOT_ENC") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      oLocator = GetObjectByTag("DOC_RACK_BOT",1);
      if (d3()==1) oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
      else oMinion = MakeCreature("dopkalfarwar003",oLocator, FALSE);
      for (i=0; i<2; i++) {
         oLocator = GetObjectByTag("DOC_RACK_BOT",i);
         if (d3()==1) SRM_PickWeapon(oLocator, GetHitDice(oMinion) + Random(3), 4, PickOne("simple","martial","martial","exotic"));
         SRM_CreateGem(oMinion, TREASURE_MEDIUM, 26);
      }
   }
   else if (sWhich=="DOC_CHEST_ENC") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      oLocator = GetObjectByTag("DOC_CHEST",1);
      oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
      SRM_CreateGem(oMinion, TREASURE_MEDIUM, 26);
      for (i=0; i<4; i++) {
         oLocator = GetObjectByTag("DOC_CHEST",i);
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      }
   }

   else if (sWhich=="DOS_JAIL_ENC") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      PartyCnt = CountParty(oEnteredBy);
      k = GetMax(PartyCnt, 6);
      for (i=0; i<k; i++) {
         if (d3()<3) {
            oLocator = GetObjectByTag("DOS_JAIL_WP",i);
            if (d3()==1) oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
            else oMinion = MakeCreature("dopkalfarwar003",oLocator, FALSE);
            if (d3()==1) SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0f, 900.0));
            sWhich = PickOne("feyfemale","felinehunter001","felinehunter", "ancientbeetle");
            sWhich = PickOne(sWhich, "trog002","trog003","trog004", "svirfneblin002", "svirfneblin003");
            oMinion = MakeCreature(sWhich,oMinion, FALSE);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR), oMinion, RoundsToSeconds(5));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oMinion, RoundsToSeconds(5));
         }
      }
   }
   else if (GetStringLeft(sWhich,4)=="DOD_") {
      if (d6()!=1) return; // ONCE EVERY 6 SPAWNS
      k = GetMax(PartyCnt, 4);
      for (i=0; i<k; i++) {
         oLocator = GetObjectByTag(sWhich+"_WP",i);
         if (d2()==1) {
            if (d3()==1) sRef = "dopkalfarwar003";
            else sRef = "dopkalfarwar002";
         } else {
            if (d3()<3) {
               sRef = "dopkalfarminstre";
            } else {
               oMinion = MakeCreature("dopkalfar002", oLocator, FALSE);
               sRef = "frosttiger";
            }
         }
         oItem = GetObjectByTag("DOD_OBJECT");
         AssignCommand(oItem, DelayCommand(IntToFloat(i*2), voidMakeCreature(sRef, oLocator, oEnteredBy, TRUE)));
      }
   }
   else if (sWhich=="DTH_MAIN_ENC") {
      if (d20()!=1) return; // ONCE EVERY 20 SPAWNS
      k = GetMax(PartyCnt * 2, 9);
      for (i=0; i<k; i++) {
         oLocator = GetObjectByTag("DTH_BENCH",i);
         if (d2()==1) {
            if (d3()!=1) oMinion = MakeCreature("dopkalfarwarrior",oLocator, FALSE);
            else if (d3()!=1) oMinion = MakeCreature("dopkalfarwar002",oLocator, FALSE);
            else oMinion = MakeCreature("dopkalfar",oLocator, FALSE);
            SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
            HideWeapons(oMinion);
            AssignCommand(oMinion, ActionMoveToObject(oLocator));
            AssignCommand(oMinion, ActionSit(oLocator));
         }
      }
      k = GetMax(PartyCnt, 4);
      for (i=0; i<k; i++) {
         oLocator = GetObjectByTag("DTH_CHAIR",i);
         if (d3()!=1) oMinion = MakeCreature("dopkalfarwar003",oLocator, FALSE);
         else if (d3()!=1) oMinion = MakeCreature("dopkalfar002",oLocator, FALSE);
         else oMinion = MakeCreature("dopkalfarminstre",oLocator, FALSE);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
         HideWeapons(oMinion);
         AssignCommand(oMinion, ActionMoveToObject(oLocator));
         AssignCommand(oMinion, ActionSit(oLocator));
      }
      k = GetMax(PartyCnt,2);
      for (i=0; i<k; i++) {
         oLocator = GetObjectByTag("DTH_TIGER_WP",i);
         oMinion = MakeCreature("frosttiger",oLocator, FALSE);
         AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 900.0));
      }
      oLocator = GetObjectByTag("DTH_BOSS_WP");
      oMinion = SpawnBoss("lilith", oLocator);
      HideWeapons(oMinion);
      oLocator = GetObjectByTag("DTH_THRONE");
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      k = GetMax(PartyCnt, 4);
      for (i=0; i<k; i++) {
         oLocator = GetObjectByTag("DTH_CHEST",i);
         SRM_RandomTreasure(TREASURE_HIGH, oMinion, oLocator);
         SRM_CreateGem(oMinion, TREASURE_HIGH, 32);
      }
   }
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER
}
