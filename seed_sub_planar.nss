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
// Subrace Name: Aasimar
// ***************************************************************
// *******************************
// Races: Any
// *******************************
   CreateSubrace(RACIAL_TYPE_ALL, "aasimar", "skin_aasimar");

// ***********
// Appearance:
// ***********
// Skin: none + Angel Wings
// Hair Color: Bronze
// Skin Color: White
   ModifySubraceAppearanceAttachment("aasimar", APPEARANCE_TYPE_ATTACHMENT_WINGS_ANGEL, APPEARANCE_TYPE_ATTACHMENT_WINGS_ANGEL, 0, 0, 1);
   ModifySubraceAppearanceColors("aasimar", 45, 44, 41, 40);

// **********************
// Ability Modifications:
// **********************
// STR -2
// CON -2
// CHA +2
// WIS +2
   STR = -2;
   CON = -2;
   DEX = 0;
   INT = 0;
   WIS = 2;
   CHA = 2;
   struct SubraceBaseStatsModifier AasimarStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("aasimar", AasimarStats, 1);

// ********
// Bonuses:
// ********
// +2 Listen
// +2 Spot
// Darkvision
// Resist Energy Acid --- gains -/5 resistance
// Resist Energy Cold --- gains -/5 resistance
// Resist Energy Electrical --- gains -/5 resistance
   ModifySubraceFeat("aasimar", FEAT_DARKVISION, 1);
   ModifySubraceFeat("aasimar", FEAT_RESIST_ENERGY_ACID, 1);
   ModifySubraceFeat("aasimar", FEAT_RESIST_ENERGY_COLD, 1);
   ModifySubraceFeat("aasimar", FEAT_RESIST_ENERGY_ELECTRICAL, 1);
   ModifySubraceSkill("aasimar", SKILL_LISTEN, 2, 1, FALSE);
   ModifySubraceSkill("aasimar", SKILL_SPOT, 2, 1, FALSE);

// **********
// Penalties:
// **********
// (skin) Damage Vulnerability Fire 10%
// (skin) Damage Vulnerability Negative 25%

// ***************************************************************
// ***************************************************************
// Subrace Name: TIEFLING
// ***************************************************************
// *******************************
// Races: Any
// *******************************
   CreateSubrace(RACIAL_TYPE_ALL, "tiefling", "skin_tiefling");

// ***********
// Appearance:
// ***********
// Skin: None + Devil Tail
// Hair Color: Any
// Skin Color: Black
   ModifySubraceAppearanceAttachment("tiefling", 0, 0, APPEARANCE_TYPE_ATTACHMENT_TAIL_DEVIL, APPEARANCE_TYPE_ATTACHMENT_TAIL_DEVIL, 1);
   ModifySubraceAppearanceColors("tiefling", -1, -1, 26, 27);

// **********************
// Ability Modifications:
// **********************
// -2 STR
// +2 DEX
// +2 INT
// -2 CON
   STR = -2;
   CON = -2;
   DEX = 2;
   INT = 2;
   WIS = 0;
   CHA = 0;
   struct SubraceBaseStatsModifier TieflingStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("tiefling", TieflingStats, 1);

// ********
// Bonuses:
// ********
// +2 Hide
// +2 Move Silent
// Darkvision --- grants the ability to see in the dark.
// Resist Energy Acid --- gains -/5 resistance
// Resist Energy Cold --- gains -/5 resistance
// Resist Energy Electrical --- gains -/5 resistance
// Darkness --- gains the ability to cast Darkness.

   ModifySubraceSkill("tiefling", SKILL_MOVE_SILENTLY, 2, 1, FALSE);
   ModifySubraceSkill("tiefling", SKILL_HIDE, 2, 1, FALSE);

   ModifySubraceFeat("tiefling", FEAT_DARKVISION, 1);
   //ModifySubraceFeat("tiefling", FEAT_PRESTIGE_DARKNESS, 1);
   ModifySubraceFeat("tiefling", FEAT_RESIST_ENERGY_ACID, 1);
   ModifySubraceFeat("tiefling", FEAT_RESIST_ENERGY_COLD, 1);
   ModifySubraceFeat("tiefling", FEAT_RESIST_ENERGY_ELECTRICAL, 1);

// **********
// Penalties:
// **********
// Damage Vulnerability Fire 10%
// Damage Vulnerability Positive 25%


// ***************************************************************
// ***************************************************************
// Subrace Name: Wild Dwarf
// ***************************************************************
// *******************************
// Races: Dwarf
// *******************************
   CreateSubrace(RACIAL_TYPE_DWARF, "wilddwarf", "skin_wilddwarf");

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Orange/Red
// Skin Color: Bronze
   ModifySubraceAppearanceColors("wilddwarf", 49, 4, 26, 27);

// **********************
// Ability Modifications:
// **********************
// CON +2
// DEX +2
// INT -2
// WIS -2
   STR =  0;
   CON =  2;
   DEX =  2;
   INT = -2;
   WIS = -2;
   CHA =  0;
   struct SubraceBaseStatsModifier WildDwarfStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("wilddwarf", WildDwarfStats, 1);

// ********
// Bonuses:
// ********
// Use Poison --- is trained in the use of poison
// Resist Poison --- +4 bonus to Fortitude vs poison
// Trackless Step --- +4 Hide and Move Silently when in wilderness area.
// Resist Energy Fire --- gains -/5 resistance
// Weapon Focus: Kukri
// Weapon Focus: Hand Axe

//   ModifySubraceFeat("wilddwarf", FEAT_USE_POISON, 1);
   ModifySubraceFeat("wilddwarf", FEAT_RESIST_POISON, 1);
   ModifySubraceFeat("wilddwarf", FEAT_TRACKLESS_STEP, 1);
   ModifySubraceFeat("wilddwarf", FEAT_RESIST_ENERGY_FIRE, 1);
   ModifySubraceFeat("wilddwarf", FEAT_WEAPON_FOCUS_KUKRI, 1);
   ModifySubraceFeat("wilddwarf", FEAT_WEAPON_FOCUS_HAND_AXE, 1);

// **********
// Penalties:
// **********
// (skin) Reduced Will Save -2
// (skin) Damage Vulnerbility Cold - 10%

}

