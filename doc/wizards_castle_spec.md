# Wizard's Castle Specification

## Background

Wizard's Castle was written by Joseph R. Power in the mid-to-late 1970s
and published in _Recreational Computing Magazine_ in the July/August
1980 issue.

This spec covers the rules of the game, but the original UI is out of
scope.

D&D-style die rolls are used in this spec, e.g. `2d6`.

### References

* [Original article from Archive.org](https://archive.org/details/1980-07-recreational-computing/page/n9)

## Unknowns

### `"_(CSSLFF4`

The first line of the program is:

```basic
10 REM "_(C2SLFF4
```

Some kind of magic number for Exidy Sorcerer BASIC?

### Seeding the PRNG

The value in `T` appears to seed the PRNG on line 80, but the details of
the machine code call and `PEEK` are unknown. (`T` = time???)

```basic
40 POKE 260,218: POKE 261,1: T = USR(0): T = PEEK(-2049)

80 Q = RND(-(2*T+1)): RESTORE: FOR Q = 1 TO 34: READ C$(Q), I$(Q): NEXT Q
```

### Curses bug?

See the [Curses](#Curses) section, below.

## Gameplay

The player runs through the Dungeon hunting for a monster holding the
Runestaff.

One the Runestaff is obtained, the player uses it to teleport into a
warp that's actually The Orb of Zot in disguse.

Once the Orb of Zot is obtained, the player makes their way back to the
entrance and exits the dungeon to win.

## Dungeon

The dungeon is an 8x8x8 grid.

> Though the original game has positive-Y to the right and positive-X
> down, this spec uses the reverse, more standard orientation of
> positive-X to the right and positive-Y down.
>
> Additionally, the original source uses 1-based indexing. This spec
> uses 0-based indexing.

The dungeon wraps around in the X and Y directions. It is clamped in the
Z direction.

There is one entrance at location (3,0,0). If the player moves north
from that room, they exit the dungeon and the game is over.

Rooms contain one displayable character (items, monsters, etc.) The
minor exceptions to this rule are:

1. One of the rooms contains a monster who is carrying the Runestaff
2. One of the rooms contains a warp that is hiding the Orb of Zot

Rooms can be discovered or undiscovered. Undiscovered rooms are marked
as unknown on the map. Rooms are typically discovered by entering them,
but there are other ways (flares, lamp, gazing into an orb, and so on).

### Generation

Algorithm `RAND_PLACE`:
1. Find an empty room at random on a particular level
2. Place the given item in that room

#### Historic Generation

In the steps below, all rooms are undiscovered unless otherwise noted.

1. Mark all rooms as empty.
2. Mark the entrance (discovered) at (3,0,0).
3. For each level 0-6 `RAND_PLACE` 2 stairs down.
4. For each of the stairs down, place a stairs up on the level below at
   the same X,Y.
5. For each level 0-7 `RAND_PLACE` 1 of each type of monster.
6. For each level 0-8 `RAND_PLACE` 3 of each type of item.
7. For each level 0-8 `RAND_PLACE` 3 vendors.
8. For each treasure, choose a random level and `RAND_PLACE` the
   treasure.
9. For all 3 curses, `RAND_PLACE` an empty room and mark it as cursed.
10. Choose an additional random monster and random level. `RAND_PLACE`
    that monster and mark it as carrying the Runestaff.
11. Choose a random level. `RAND_PLACE` an additional warp and mark it
    as containing the Orb of Zot.

#### New Generation

Historically, random rooms were selected by repeatedly searching at
random until an empty room was found. This can be optimized by an number
of means.

Additionally, the Runestaff is hidden in an extra monster and the Orb of
Zot is hidden as an extra warp. This leaks information to the player
that could be hidden by using existing monsters and warps to hold those
items. It would be better to have a consistent number of monsters and
warps per level.

Potential algorithm:

1. Mark all rooms as empty.
2. Choose a level 0-7 for the Runestaff.
3. Choose a level 0-7 for the Orb of Zot.
4. Choose a level 0-7 for each treasure.
5. Choose a level 0-7 for each curse.
6. Add the following to the level, in any easily-programmed order (does
   not need to be random):
   1. Entrance.
   2. 2 stairs down (levels 0-6 only!)
   3. 2 stairs up (levels 1-7 only!)
   4. 1 of each type of monster.
      * If this is the Runestaff level, choose one of the monsters at
        random to possess it.
   5. 3 of each type of item.
      * If this is the Orb of Zot level, choose one of the warps at
        random to possess it.
   6. 3 vendors.
   7. Add all treasures for this level.
   8. Add all curses for this level as empty rooms.
7. Shuffle the level.
   * Note the stairs down locations (levels 0-6 only!)
   * Note the stairs up locations (levels 1-7 only!)
8. Swap the item at (3,0,0) with the entrance. (I.e. move the entrance
   into place.)
9. Swap both stairs up locations (levels 1-7 only!) with whatever is at
   the X,Y coordinates on this level of the stairs down X,Y location on
   the previous level. (I.e. make sure the stairs up are directly below
   the stairs down.)

## Room Contents

### Items

Historic graphic character corresponding to the item shown.

| Room              | Character | Notes              |
|-------------------|:---------:|--------------------|
| Empty room        |    `.`    |                    |
| Entrance          |    `E`    |                    |
| Stairs going up   |    `U`    |                    |
| Stairs going down |    `D`    |                    |
| Pool              |    `P`    |                    |
| Chest             |    `C`    |                    |
| Gold pieces       |    `G`    |                    |
| Flares            |    `F`    |                    |
| Warp              |    `W`    |                    |
| Sinkhole          |    `S`    |                    |
| Crystal orb       |    `O`    | Not the Orb of Zot |
| Book              |    `B`    |                    |

#### The Orb of Zot

One of the warps contains the Orb of Zot.

If you teleport into this warp, you obtain the Orb of Zot and the Runestaff vanishes.

If you enter the warp by any other means, you pass out the other side in
the direction last walked (N, S, W, or E), remaining in all cases on the
same level as the warp.

### Monsters

HP is Hit Points.

|  # | Monster  | Character | HP | Damage | Notes                                  |
|:--:|----------|:---------:|:--:|:------:|----------------------------------------|
|  1 | Kobold   |    `M`    |  3 |    1   |                                        |
|  2 | Orc      |    `M`    |  4 |    2   |                                        |
|  3 | Wolf     |    `M`    |  5 |    2   |                                        |
|  4 | Goblin   |    `M`    |  6 |    3   |                                        |
|  5 | Ogre     |    `M`    |  7 |    3   |                                        |
|  6 | Troll    |    `M`    |  8 |    4   |                                        |
|  7 | Bear     |    `M`    |  9 |    4   |                                        |
|  8 | Minotaur |    `M`    | 10 |    5   |                                        |
|  9 | Gargoyle |    `M`    | 11 |    5   | 1/8 chance of weapon breaking on a hit |
| 10 | Chimera  |    `M`    | 12 |    6   |                                        |
| 11 | Balrog   |    `M`    | 13 |    6   |                                        |
| 12 | Dragon   |    `M`    | 14 |    7   | 1/8 chance of weapon breaking on a hit |
| 13 | Vendor   |    `V`    | 15 |    7   | See below                              |

HP is computed as `monster_num + 2`.

Damage is computed as `1 + INT(monster_num / 2)`.

### The Runestaff

One of the monsters (not counting vendors) holds The Runestaff. When
this monster is killed, the Runstaff is transferred to the player.

### Vendors

| Monster  | Character | HP |
|----------|:---------:|:--:|
| Vendor   |    `V`    | 15 |

Normally you trade with vendors, unless you've attacked them before.

### Treasures

|  # | Treasure       | Character |  Value  | Effect                                      |
|:--:|----------------|:---------:|:-------:|---------------------------------------------|
|  1 | The Ruby Red   |    `T`    | 1d1500  | Protects against the curse of Lethargy      |
|  2 | The Norn Stone |    `T`    | 1d3000  | No special power                            |
|  3 | The Pale Pearl |    `T`    | 1d4500  | Protects against the curse of The Leech     |
|  4 | The Opal Eye   |    `T`    | 1d6000  | Cures blindness                             |
|  5 | The Green Gem  |    `T`    | 1d7500  | Protects against the curse of Forgetfulness |
|  6 | The Blue Flame |    `T`    | 1d9000  | Dissolves books stuck to your hands         |
|  7 | The Palintir   |    `T`    | 1d10500 | No special power                            |
|  8 | The Silmaril   |    `T`    | 1d12000 | No special power                            |

Treasure value is a random number between `1` and `treasure_num * 1500`
used when selling to the vendors.

> In the original game, this was computed each time you traded with any
> vendor. This allowed the player to just keep coming back until they
> got a high number. An alternative implementation might set the value
> one time at the beginning of the game in a range, and then have
> vendors offer a fixed, per-vendor plus or minus on that value.

## Weapons

| # | Weapon | Damage | Initial Price | Vendor Price |
|:-:|--------|:------:|:-------------:|:------------:|
| 1 | Dagger |    1   |       10      |     1250     |
| 2 | Mace   |    2   |       20      |     1500     |
| 3 | Sword  |    3   |       30      |     2000     |

Damage is computed as `weapon_num`.

Initial Cost is computed as `weapon_num * 10`.


## Armor

REM 5 - NO ARMOR
REM 6 - LEATHER
REM 7 - CHAINMAIL
REM 8 - PLATE

## Recipes

REM RECIPES
REM
REM 1 - WICH
REM 2 - STEW
REM 3 - SOUP
REM 4 - BURGER
REM 5 - ROAST
REM 6 - MUNCHY
REM 7 - TACO
REM 8 - PIE

## Character Generation

REM RACES
REM
REM 1 - HOBBIT
REM 2 - ELF
REM 3 - MAN
REM 4 - DWARF

## Curses

REM Curses in the C() array, first index
REM
REM 1 - Lethargy
REM 2 - Leech
REM 3 - Forgetfullness


## Actions

## Combat

## Trading