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
// Subrace Name: Goblin
// ***************************************************************
// *******************************
// Races: Gnome, Half Elf, Dwarf, Halfling
// *******************************
   CreateSubrace(RACIAL_TYPE_GNOME, "goblin", "skin_goblin");
   AddAdditionalBaseRaceToSubrace("goblin", RACIAL_TYPE_HALFELF);
   AddAdditionalBaseRaceToSubrace("goblin", RACIAL_TYPE_HALFLING);
   AddAdditionalBaseRaceToSubrace("goblin", RACIAL_TYPE_DWARF);

// ***********
// Appearance:
// ***********
// Skin: Goblin
   CreateSubraceAppearance("goblin", TIME_BOTH, APPEARANCE_TYPE_GOBLIN_A, APPEARANCE_TYPE_GOBLIN_B, 1);
   //CreateSubraceAppearance("goblin", TIME_BOTH, APPEARANCE_TYPE_GOBLIN_SHAMAN_A, APPEARANCE_TYPE_GOBLIN_SHAMAN_B, 20);
   CreateSubraceAppearance("goblin", TIME_BOTH, APPEARANCE_TYPE_GOBLIN_CHIEF_A, APPEARANCE_TYPE_GOBLIN_CHIEF_B, 40);

// **********************
// Ability Modifications:
// **********************
// +2 DEX, +2 CON, -2 INT, -2 STR
   STR = -2;
   CON =  2;
   DEX =  2;
   INT = -2;
   WIS =  0;
   CHA =  0;
   struct SubraceBaseStatsModifier GoblinStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("goblin", GoblinStats, 1);

// ********
// Bonuses:
// ********
// +4 Move Silent
// +2 Tumble
// Darkvision
// Bullheaded --- +2 bonus on resisting Taunts and a +1 bonus on Will saving throws.
// Weapon Focus Short Sword
   ModifySubraceSkill("goblin", SKILL_MOVE_SILENTLY, 4, 1, FALSE);
   ModifySubraceSkill("goblin", SKILL_TUMBLE, 2, 1, FALSE);
   ModifySubraceFeat("goblin", FEAT_DARKVISION, 1);
   ModifySubraceFeat("goblin", FEAT_BULLHEADED, 1);


// **********
// Penalties:
// **********
// (skin) Reduce Skill Discipline -4



// ***************************************************************
// ***************************************************************
// Subrace Name: Kobold
// ***************************************************************
// *******************************
// Races: Gnome, Dwarf, Half-elf
// *******************************
   CreateSubrace(RACIAL_TYPE_GNOME, "kobold", "skin_kobold");
   AddAdditionalBaseRaceToSubrace("kobold", RACIAL_TYPE_HALFELF);
   AddAdditionalBaseRaceToSubrace("kobold", RACIAL_TYPE_DWARF);

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Red
// Skin Color: Black
   CreateSubraceAppearance("kobold", TIME_BOTH, APPEARANCE_TYPE_KOBOLD_SHAMAN_A, APPEARANCE_TYPE_KOBOLD_SHAMAN_B, 1);
   CreateSubraceAppearance("kobold", TIME_BOTH, APPEARANCE_TYPE_KOBOLD_A, APPEARANCE_TYPE_KOBOLD_B, 20);
   CreateSubraceAppearance("kobold", TIME_BOTH, APPEARANCE_TYPE_KOBOLD_CHIEF_A, APPEARANCE_TYPE_KOBOLD_CHIEF_B, 40);

// **********************
// Ability Modifications:
// **********************
// +4 DEX,         -2 INT, -2 STR
   STR = -2;
   CON =  0;
   DEX =  4;
   INT = -2;
   WIS =  0;
   CHA =  0;
   struct SubraceBaseStatsModifier koboldStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("kobold", koboldStats, 1);

// ********
// Bonuses:
// ********
// +4 Move Silently
// +2 Tumble
// Snake Blood
// Weapon Focus Short Sword
   ModifySubraceSkill("kobold", SKILL_MOVE_SILENTLY, 4, 1, FALSE);
   ModifySubraceSkill("kobold", SKILL_TUMBLE, 2, 1, FALSE);
   ModifySubraceFeat("kobold", FEAT_DARKVISION, 1);
   ModifySubraceFeat("kobold", FEAT_SNAKEBLOOD, 1);

// **********
// Penalties:
// **********
// (skin) Reduce Skill Discipline -4



// ***************************************************************
// ***************************************************************
// Subrace Name: ljosalfar (Fire Ef)
// ***************************************************************
// *******************************
// Races: Elf, Half Elf
// *******************************
   CreateSubrace(RACIAL_TYPE_ELF, "ljosalfar", "skin_ljosalfar");
   AddAdditionalBaseRaceToSubrace("ljosalfar", RACIAL_TYPE_HALFELF);

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Black
// Skin Color: Red
   ModifySubraceAppearanceColors("ljosalfar", 49, 45, 14, 13);

// **********************
// Ability Modifications:
// **********************
// +2 STR, +2 CON, -2 INT, -2 WIS
   STR =  2;
   CON =  2;
   DEX =  0;
   INT = -2;
   WIS = -2;
   CHA =  0;
   struct SubraceBaseStatsModifier ljosalfarStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("ljosalfar", ljosalfarStats, 1);

// ********
// Bonuses:
// ********
// Resist Energy Fire --- gains -/10 resistance
   ModifySubraceFeat("ljosalfar", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1, 1);

// **********
// Penalties:
// **********
// (skin) Damage Vulnerability Cold 25%


// ***************************************************************
// ***************************************************************
// Subrace Name: dopkalfar (Ice Elf)
// ***************************************************************
// *******************************
// Races: Elf, Half Elf
// *******************************
   CreateSubrace(RACIAL_TYPE_ELF, "dopkalfar", "skin_dopkalfar");
   AddAdditionalBaseRaceToSubrace("dopkalfar", RACIAL_TYPE_HALFELF);

// ***********
// Appearance:
// ***********
// Skin: None
// Hair Color: Blue
// Skin Color: White
   ModifySubraceAppearanceColors("dopkalfar", 56, 56, 60, 60);

// **********************
// Ability Modifications:
// **********************
// +2 INT, +2 WIS, -2 STR, -2 CON
   STR = -2;
   CON = -2;
   DEX =  0;
   INT =  2;
   WIS =  2;
   CHA =  0;
   struct SubraceBaseStatsModifier dopkalfarStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("dopkalfar", dopkalfarStats, 1);

// ********
// Bonuses:
// ********
// Resist Energy Cold --- gains -/10 resistance
   ModifySubraceFeat("dopkalfar", FEAT_EPIC_ENERGY_RESISTANCE_COLD_1, 1);

// **********
// Penalties:
// **********
// (skin) Damage Vulnerability Fire 25%

// ***************************************************************
// ***************************************************************
// Subrace Name: ettin
// ***************************************************************
// *******************************
// Races: Gnome, Half Elf, Dwarf, Halfling
// *******************************
   CreateSubrace(RACIAL_TYPE_HALFORC, "ettin", "skin_ettin");
   AddAdditionalBaseRaceToSubrace("ettin", RACIAL_TYPE_HALFELF);
   AddAdditionalBaseRaceToSubrace("ettin", RACIAL_TYPE_ELF);

// ***********
// Appearance:
// ***********
// Skin: ettin
   CreateSubraceAppearance("ettin", TIME_BOTH, APPEARANCE_TYPE_ETTIN, APPEARANCE_TYPE_ETTIN, 1);

// **********************
// Ability Modifications:
// **********************
// +4 CON, -2 DEX, -2 WIS
   STR =  0;
   CON =  4;
   DEX = -2;
   INT =  0;
   WIS = -2;
   CHA =  0;
   struct SubraceBaseStatsModifier ettinStats = CustomBaseStatsModifiers(STR, DEX, CON, INT, WIS, CHA, MOVEMENT_SPEED_CURRENT);
   CreateBaseStatModifier("ettin", ettinStats, 1);

// ********
// Bonuses:
// ********
// Alertness --- +2 bonus to Listen and Spot checks due two heads
// Keen Sense --- apply their full Search skill even when making a passive search.
// Resist Poison --- +4 bonus to Fortitude saving throws against poison.
// Use Poison --- trained in the use of poison
// Weapon Focus Spear
// Weapon Focus Club

   ModifySubraceFeat("ettin", FEAT_ALERTNESS, 1);
   ModifySubraceFeat("ettin", FEAT_KEEN_SENSE, 1);
   ModifySubraceFeat("ettin", FEAT_RESIST_POISON, 1);
   ModifySubraceFeat("ettin", FEAT_USE_POISON, 1);
   ModifySubraceFeat("ettin", FEAT_WEAPON_FOCUS_CLUB, 1);
   ModifySubraceFeat("ettin", FEAT_WEAPON_FOCUS_SPEAR, 1);


// **********
// Penalties:
// **********
// (skin) -10 Move Silent
// (skin) -10 Hide
// (skin) -5 Death
// (skin) -2 Will
// (skin) -2 Reflex
// (skin) Damage Vulnerability Electric 10%
// (skin) Damage Vulnerability Cold 10%

}
