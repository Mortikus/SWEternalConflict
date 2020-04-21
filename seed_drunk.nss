#include "seed_helper_func"

const float DRUNK_SECS_PER_POINT = 20.0;
// ALE     = +1 POINT
// WINE    = +2 POINTS
// SPIRITS = +3 POINTS

void MakeDrunk(object oCaster, object oTarget, int nNewPoints) {
   int IsConfused = FALSE;
   int nCurrPoints = GetLocalInt(oTarget, "SEED_DRUNK");
   int nTotalPoints = nCurrPoints + nNewPoints;
   SetLocalInt(oTarget, "SEED_DRUNK", nTotalPoints);
   if (nCurrPoints) { // CURRENTLY DRUNK, REMOVE OLD EFFECTS
      effect eff = GetFirstEffect(oTarget);
      while(GetIsEffectValid(eff)) {
         if (GetEffectCreator(eff)==oCaster) { // EFFECTED CREATED BY CASTER
            if (GetEffectType(eff)==EFFECT_TYPE_ABILITY_DECREASE ||
                GetEffectType(eff)==EFFECT_TYPE_ABILITY_INCREASE ||
                GetEffectType(eff)==EFFECT_TYPE_AC_DECREASE) {
               RemoveEffect(oTarget,eff);
            }
            if (GetEffectType(eff)==EFFECT_TYPE_CONFUSED) IsConfused = TRUE;
         } else {
            //SendMessageToPC(oTarget, "effect  by " + GetTag(GetEffectCreator(eff)));
         }
         eff = GetNextEffect(oTarget);
      }
   }
   if (nTotalPoints<1) {
      SendMessageToPC(oTarget,"Orcish Courage has worn off.");
      return; // DANG, SOBER AGAIN
   }

   int nBad = nTotalPoints / 2;
   effect eStrong = EffectAbilityIncrease(ABILITY_STRENGTH, nBad);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrong, oTarget, DRUNK_SECS_PER_POINT);
   nBad--;
   if (nBad>0) {
      effect eSloppy = EffectACDecrease(nBad);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSloppy, oTarget, DRUNK_SECS_PER_POINT);
   }
   nBad--;
   if (nBad>0) {
      effect eWobbly = EffectAbilityDecrease(ABILITY_DEXTERITY, nBad);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWobbly, oTarget, DRUNK_SECS_PER_POINT);
   }
   nBad--;
   if (nBad>0) {
      effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nBad);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, DRUNK_SECS_PER_POINT);
   }
   if (nNewPoints>0) { // A FRESH DRINK
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_LRG_RED), oTarget);
      FloatingTextStringOnCreature("gArrrgggh!", oTarget, TRUE);
      //AssignCommand(oTarget, SpeakString("Arrrggg! That burns!"));
      PlayVoiceChat(VOICE_CHAT_POISONED, oTarget);
      if (Random(100) + 1 < 40) {
         AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
      } else {
         AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));
      }
      if (d10(3)<=nTotalPoints && !IsConfused) {
         FloatingTextStringOnCreature("Berserk!", oTarget, TRUE);
         effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
         effect eConfuse = EffectConfused();
         effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
         effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
         effect eLink = EffectLinkEffects(eMind, eConfuse);
         eLink = EffectLinkEffects(eLink, eDur);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nTotalPoints));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
      }
      int nHeal = GetMax(10, d2(GetHitDice(oTarget)/2) * nNewPoints);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
      if (nCurrPoints==0) { // SWEET, FIRST DRINK OF THE DAY
         //SendMessageToPC(oTarget,"In Starting RECURSER = " + IntToString(nTotalPoints));
         DelayCommand(DRUNK_SECS_PER_POINT, MakeDrunk(oCaster, oTarget, -1));
     }
   } else if (nNewPoints==-1) { // GETTING SOBER
      SendMessageToPC(oTarget,"Orcish Courage wearing off... (" + IntToString(nTotalPoints)+" OCP)");
      DelayCommand(DRUNK_SECS_PER_POINT, MakeDrunk(oCaster, oTarget, -1));
   }

}

void main() {
   object oCaster = OBJECT_SELF; // BABA YAGA
   int nTotalPoints = GetLocalInt(oCaster, "SEED_DRUNK_POINTS"); // HOW MANY NEW DRUNK POINTS TO ADD
   object oTarget = GetLocalObject(oCaster, "SEED_DRUNK"); // WHO'S PARTYING
   MakeDrunk(oCaster, oTarget, nTotalPoints);
}
