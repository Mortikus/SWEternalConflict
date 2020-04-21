#include "sha_subr_methds"
void main() {

   int STR = 0;
   int CON = 0;
   int DEX = 0;
   int INT = 0;
   int WIS = 0;
   int CHA = 0;

// ***************************************************************
// ***************************************************************
// Subrace Name: Drow
// ***************************************************************
// *******************************
// Races: Elf, Half Elf
// *******************************
   CreateSubrace(RACIAL_TYPE_ELF, "drow", "skin_drow");
   AddAdditionalBaseRaceToSubrace("drow", RACIAL_TYPE_HALFELF);

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Silver
// Skin Color: Black
   ModifySubraceAppearanceColors("drow", 56, 56, 43, 41);

// **********************
// Ability Modifications:
// **********************
// -2 STR
// +2 INT
// -2 CON
// +2 CHA
   STR = -2;
   CON = -2;
   DEX =  0;
   INT =  2;
   WIS =  0;
   CHA =  2;
   struct SubraceBaseStatsModifier DrowStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("drow", DrowStats, 1);

// ********
// Bonuses:
// ********
// +2 Hide
// +2 Move Silent
// Darkvision
// Hardiness vs. Spells --- +2 racial bonus on saving throws vs. spells.
// Darkness --- gains the ability to cast Darkness.
// Two Weapon Fighting Feat
   ModifySubraceSkill("drow", SKILL_HIDE, 2, 1, FALSE);
   ModifySubraceSkill("drow", SKILL_MOVE_SILENTLY, 2, 1, FALSE);
   ModifySubraceFeat("drow", FEAT_DARKVISION, 1);
   ModifySubraceFeat("drow", FEAT_HARDINESS_VERSUS_SPELLS, 1);
//   ModifySubraceFeat("drow", FEAT_PRESTIGE_DARKNESS, 1);
   ModifySubraceFeat("drow", FEAT_TWO_WEAPON_FIGHTING, 1);

// **********
// Penalties:
// **********
// (skin) Damage Vulnerbility Positive - 25%
// (skin) Reduce Save Fortitude -2



// ***************************************************************
// ***************************************************************
// Subrace Name: Duergar
// ***************************************************************
// *******************************
// Races: Dwarf
// *******************************
   CreateSubrace(RACIAL_TYPE_DWARF, "duergar", "skin_duergar");

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Red
// Skin Color: Black
   ModifySubraceAppearanceColors("duergar", 7, 5, 19, 17);

// **********************
// Ability Modifications:
// **********************
// STR +2
// CON +2
// DEX -2
// INT -2
   STR =  2;
   CON =  2;
   DEX = -2;
   INT = -2;
   WIS =  0;
   CHA =  0;
   struct SubraceBaseStatsModifier DuergarStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("duergar", DuergarStats, 1);

// ********
// Bonuses:
// ********
// +4 Move Silently
// Immunity to Paralysis --- immunity to paralysis.
// Venom Immunity --- immune to all poisons.
// Invisibility --- is able to cast the spell Invisibility 1x/day.
// Weapon Focus: War Hammer
   ModifySubraceSkill("duergar", SKILL_MOVE_SILENTLY, 4, 1, FALSE);
//   ModifySubraceFeat("duergar", FEAT_DRAGON_IMMUNE_PARALYSIS, 1);
//   ModifySubraceFeat("duergar", FEAT_VENOM_IMMUNITY, 1);
//   ModifySubraceFeat("duergar", FEAT_PRESTIGE_INVISIBILITY_1, 1);
   ModifySubraceFeat("duergar", FEAT_WEAPON_FOCUS_WAR_HAMMER, 1);

// **********
// Penalties:
// **********
// (skin) Reduce Save Reflex -2
// (skin) Damage Vulnerbility Positive - 25%


// ***************************************************************
// ***************************************************************
// Subrace Name: Svirfneblin
// ***************************************************************
// *******************************
// Races: Gnome, Halfling
// *******************************
   CreateSubrace(RACIAL_TYPE_GNOME, "svirfneblin", "skin_svirfneblin");
   AddAdditionalBaseRaceToSubrace("svirfneblin", RACIAL_TYPE_HALFLING);

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Any
// Skin Color: Black
   ModifySubraceAppearanceColors("svirfneblin", -1, -1, 19, 17);

// **********************
// Ability Modifications:
// **********************
// -2 CON
// +2 DEX
// -2 WIS
// +2 CHA
   STR =  0;
   CON = -2;
   DEX =  2;
   INT =  0;
   WIS = -2;
   CHA =  2;
   struct SubraceBaseStatsModifier SvirfneblinStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("svirfneblin", SvirfneblinStats, 1);

// ********
// Bonuses:
// ********
// +2 Hide
// +2 Move Silent
// Darkvision --- grants the ability to see in the dark.
// Stonecunning --- +2 bonus on Search checks made in interior areas.
// Dodge --- +1 dodge bonus to his AC against
// Greater Spell Focus Illusion
// Weapon Focus: Dart
   ModifySubraceSkill("svirfneblin", SKILL_MOVE_SILENTLY, 2, 1, FALSE);
   ModifySubraceSkill("svirfneblin", SKILL_HIDE, 2, 1, FALSE);

   ModifySubraceFeat("svirfneblin", FEAT_BATTLE_TRAINING_VERSUS_GIANTS, 1);
   ModifySubraceFeat("svirfneblin", FEAT_BATTLE_TRAINING_VERSUS_GOBLINS, 1);
   ModifySubraceFeat("svirfneblin", FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS, 1);
   ModifySubraceFeat("svirfneblin", FEAT_DARKVISION, 1);
   ModifySubraceFeat("svirfneblin", FEAT_DODGE, 1);
   ModifySubraceFeat("svirfneblin", FEAT_GREATER_SPELL_FOCUS_ILLUSION, 1);
   ModifySubraceFeat("svirfneblin", FEAT_HARDINESS_VERSUS_ILLUSIONS, 1);
   ModifySubraceFeat("svirfneblin", FEAT_SKILL_AFFINITY_CONCENTRATION, 1);
   ModifySubraceFeat("svirfneblin", FEAT_SPELL_FOCUS_ILLUSION, 1);
   ModifySubraceFeat("svirfneblin", FEAT_STONECUNNING, 1);
   ModifySubraceFeat("svirfneblin", FEAT_WEAPON_FOCUS_DART, 1);

   // REMOVE THESE HALFLING FEATS
   ModifySubraceFeat("svirfneblin", FEAT_FEARLESS, 1, TRUE);
   ModifySubraceFeat("svirfneblin", FEAT_GOOD_AIM, 1, TRUE);
   ModifySubraceFeat("svirfneblin", FEAT_LUCKY, 1, TRUE);
   ModifySubraceFeat("svirfneblin", FEAT_SKILL_AFFINITY_MOVE_SILENTLY, 1, TRUE);

// **********
// Penalties:
// **********
// (skin) Reduce Save Fortitude -2
// (skin) Damage Vulnerbility Positive - 25%

}
