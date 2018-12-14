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

### `REM"_(C2SLFF4`

The first line of the program is:

```basic
10 REM"_(C2SLFF4
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

See the [Curses](#Curses) section.

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

#### Alternate Generation

Historically, random rooms were selected by repeatedly searching at random until
an empty room was found. While this might produce fast results on a sparse
dungeon, it might be irksome to those who want a more regular O(n) solution.

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
   * Note the entrance location.
   * Note the stairs down locations (levels 0-6 only!)
   * Note the stairs up locations (levels 1-7 only!)
8. For level 0, swap the item at (3,0,0) with the entrance. (I.e. move the
   entrance into place.)
9. Swap both stairs up locations (levels 1-7 only!) with whatever is at
   the X,Y coordinates on this level of the stairs down X,Y location on
   the previous level. (I.e. make sure the stairs up are directly below
   the stairs down.)
10. Repeat from step 6 for each level.

## Room Contents

### Items

Historic graphic character corresponding to the item shown.

| Room              | Character | Notes                                          |
|-------------------|:---------:|------------------------------------------------|
| Empty room        |    `.`    |                                                |
| Entrance          |    `E`    | See [Entrance](#entrance)                      |
| Stairs going up   |    `U`    |                                                |
| Stairs going down |    `D`    |                                                |
| Pool              |    `P`    | See [Drink from a pool](#drink-from-a-pool)    |
| Chest             |    `C`    | See [Open a chest](#open-a-chest)              |
| Gold pieces       |    `G`    | Pick up `1d10` gold pieces, mark room as empty |
| Flares            |    `F`    | Pick up `1d5` flares, mark room as empty       |
| Warp              |    `W`    | See [Warp](#warp)                              |
| Sinkhole          |    `S`    | See [Sinkhole](#sinkhole)                      |
| Crystal orb       |    `O`    | See [Gaze into an orb](#gaze-into-an-orb)      |
| Book              |    `B`    | See [Open a book](#open-a-book)                |

#### Entrance

If you go north from this room, you exit the dungeon and the game is over.

#### Warp

When entering a warp (which does not contain the Orb of Zot), the player is
teleported to a random X, Y, Z location. The room effects at the new location
take place as if the player had walked there.

Note that one of the warps holds the Orb of Zot, and its behavior is different.
See [The Orb of Zot](#the-orb-of-zot).

#### Sinkhole

When entering a sinkhole, the player falls to the same X, Y on the level below.
Room effects at the new location take place as if the player had walked there.

Note: sinkholes do appear on the bottom level of the dungeon. If the player
enters one, they "fall" to the topmost level.

#### The Orb of Zot

One of the warps contains the Orb of Zot.

If you teleport into this warp, you obtain the Orb of Zot and the Runestaff
vanishes. In addition, the warp turns into an empty room.

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
| 13 | Vendor   |    `V`    | 15 |    7   | See [Vendors](#vendors)                |

HP is computed as `monster_num + 2`.

Damage is computed as `1 + INT(monster_num / 2)`.

### The Runestaff

One of the monsters (not counting vendors) holds The Runestaff. When
this monster is killed, the Runestaff is transferred to the player.

The Runestaff can be used to teleport to any X, Y, Z location.

If the destination is **not** The Orb of Zot location, then room effects take
place as if the player had walked into that room.

If the destination is The Orb of Zot, the Runestaff vanishes, and the Orb of Zot
is transferred to the player.

### Vendors

| Monster  | Character | HP |
|----------|:---------:|:--:|
| Vendor   |    `V`    | 15 |

Normally you trade with vendors, unless you've attacked them before. See
[Vendor Interactions](#vendor-interactions).

### Treasures

|  # | Treasure       | Character |   Value   | Effect                                      |
|:--:|----------------|:---------:|:---------:|---------------------------------------------|
|  1 | The Ruby Red   |    `T`    | `1d1500`  | Protects against the curse of Lethargy      |
|  2 | The Norn Stone |    `T`    | `1d3000`  | No special power                            |
|  3 | The Pale Pearl |    `T`    | `1d4500`  | Protects against the curse of The Leech     |
|  4 | The Opal Eye   |    `T`    | `1d6000`  | Cures blindness                             |
|  5 | The Green Gem  |    `T`    | `1d7500`  | Protects against the curse of Forgetfulness |
|  6 | The Blue Flame |    `T`    | `1d9000`  | Dissolves books stuck to your hands         |
|  7 | The Palintir   |    `T`    | `1d10500` | No special power                            |
|  8 | The Silmaril   |    `T`    | `1d12000` | No special power                            |

Treasure value is a random number between `1` and `treasure_num * 1500`
used when selling to the vendors.

> In the original game, the value was computed each time you traded with any
> vendor. This allowed the player to just keep coming back until they got a high
> number. An alternative implementation might set the value one time at the
> beginning of the game in a range, and then have vendors offer a fixed,
> per-vendor plus or minus on that value.

## Weapons

| # | Weapon | Damage | Initial Price | Vendor Price |
|:-:|--------|:------:|:-------------:|:------------:|
| 1 | Dagger |    1   |       10      |     1250     |
| 2 | Mace   |    2   |       20      |     1500     |
| 3 | Sword  |    3   |       30      |     2000     |

Damage is computed as `weapon_num`.

Initial Cost is computed as `weapon_num * 10`.


## Armor

| # | Armor     | Protection | Durability | Initial Price | Vendor Price |
|:-:|-----------|:----------:|:----------:|:-------------:|:------------:|
| 1 | Leather   |      1     |      7     |       10      |     1250     |
| 2 | Chainmail |      2     |     14     |       20      |     1500     |
| 3 | Plate     |      3     |     21     |       30      |     2000     |

Protection is computed as `armor_num`.

Durability is computed as `armor_num * 7`.

Initial Price is computed as `armor_num * 10`.

Armor will deflect its Protection rating in points of damage when hit.

Points of damage absorbed are subtracted from the Durability value. When
Durability falls to 0, the armor is destroyed.

## Recipes

If more than 60 turns had elapsed since the last kill OR it was the first kill
of the game, the player would see a message similar to this when a monster was
killed:

```
YOU SPEND AN HOUR EATING KOBOLD STEW
```

This message was constructed by choosing a random monster and a random suffix,
below. The suffix `WICH` was appended directly to the monster name (e.g.
`BEARWICH`), while the others were separated by a space (e.g. `GARGOYLE ROAST`).

| Recipe | Note                                     |
|--------|------------------------------------------|
| wich   | No space between monster name and `wich` |
| Stew   |                                          |
| Soup   |                                          |
| Burger |                                          |
| Roast  |                                          |
| Munchy |                                          |
| Taco   |                                          |
| Pie    |                                          |


## Character Generation

### Starting Stat Values

| # | Race   | ST | DX | IQ | GP | Additional points to allocate |
|:-:|--------|:--:|:--:|:--:|:--:|-------------------------------|
| 1 | Hobbit | 10 | 12 |  8 | 60 | 4                             |
| 2 | Elf    | 12 | 10 |  8 | 60 | 8                             |
| 3 | Human  | 14 |  8 |  8 | 60 | 8                             |
| 4 | Dwarf  | 16 |  6 |  8 | 60 | 8                             |

ST is computed as `ST = 8 + race_num * 2`.

DX is computed as `ST = 14 - race_num * 2`.

Additional points may be allocated at will between ST, DX, and IQ.

Characters can be either male or female.

### Outfitting

You can buy armor and a weapon for their initial prices.

(Only one weapon and armor may be possessed at a time.)

You can buy a lamp for 20 GPs.

You can buy single flares for 1 GP each.

## Curses

There are three curses, each one located in a random empty room in the dungeon.
If you enter this room, you catch the curse.

| Curse         | Warding Treasure | Effect                                                       |
|---------------|------------------|--------------------------------------------------------------|
| Lethargy      | The Ruby Red     | Monsters attack first, turn counter increases by 2 each turn |
| The Leech     | The Pale Pearl   | Lose `1d5` gold pieces per turn                              |
| Forgetfulness | The Green Gem    | Each turn, mark a random room as unexplored                  |

With Forgetfulness, the random room is marked unexplored even if it was already
unexplored.

Possessing the Warding Treasure causes the effects of the curse to be ignored that turn.

Curses are never cured.

If you have the curse and you sell/bribe with the Warding Treasure, the effects
of the curse will start again.

> The original code for this seems to have a bug:
>
> ```basic
> 680 IF PEEK(FND(Z)) = 1 THEN FOR Q = 1 TO 3: C(Q,4) = -(C(Q,1)=X) * (C(Q,2)=Y) * (C(Q,3)=Z): NEXT
> ```
>
> This is saying, if this is an empty room, then Curse `Q` is active if the player
> X, Y, and Z are the same as Curse `Q`'s X, Y, and Z.
>
> (`-1` and `0` are TRUE and FALSE in BASIC boolean expressions.)
>
> Sounds reasonable.
>
> But it's also saying, if this is an empty room, then Curse `Q` is **inactive**
> if the player X, Y, and Z are **not** the same as Curse `Q`'s X, Y, and Z.
>
> So you are cured of the curse when you step into another, non-cursed empty
> room, which doesn't sound nearly as reasonable.
>
> The rest of the code seems to assume that the curse is never cured and that the
> treasures simply cause the effects to be ignored. 

## Regular Actions

### Move N, S, W, or E

This moves you a cardinal direction in the dungeon.

The dungeon wraps around at each edge.

Moving North from the Entrance is a special case that exits the dungeon and ends
the game.

### Move Up or Down

If you are on stairs up or down, you may move up to the previous level or down
to the next level.

There are no stairs up at the top level.

There are no stairs down at the bottom level.

### Show the map

Historically, the map has been shown in text form as follows:

     ?    ?    P    E    .    ?    ?    ?

     ?    ?    .    .    .    ?    ?    ?

     ?    ?    S    V    .    F    ?    ?

     ?    ?    .    B    .   <.>   P    ?

     ?    ?    ?    .    C    .    ?    ?

     ?    ?    ?    ?    ?    ?    ?    ?

     ?    ?    ?    ?    ?    ?    ?    ?

     ?    ?    ?    ?    ?    ?    ?    ?

The room marked in brackets `<X>` is the room the player is currently in.

Rooms marked with `?` are unexplored.

### Light a flare

A flare will "explore" the 8 surrounding squares of the level, wrapping around
if necessary.

### Shine the lamp

The player can shine the lamp, if possessed, N, S, W, or E to explore that
single neighboring room without moving there.

### Open a book

Book effects happen at an even 1/6 chance.

| Effect                  | Result/Notes                                    |
|-------------------------|-------------------------------------------------|
| Player goes blind       | See [Blindness](#blindness)                     |
| Book of Zot's Poetry    | No effect                                       |
| Old copy of playmonster | Monster name chosen at random. No effect.       |
| Manual of Dexterity     | DX set to 18                                    |
| Manual of Strength      | ST set to 18                                    |
| Book sticks to hands    | See [Book stuck to hands](#book-stuck-to-hands) |

#### Blindness

Being blind has a number of mostly ill effects:

* In the [random messages](#random-messages), `YOU SEE A BAT` is replaced by
  `YOU STEPPED ON A FROG`.
* Monsters get the first attack.
* Your to-hit worsens to `DX < 1d20 + 3`. See [Combat](#combat).
* Your to-dodge worsens to `DX < 3d7 + 3`. See [Combat](#combat).
* TODO more

If you have the Opal Eye at the beginning of a turn, your blindness is cured.

#### Book stuck to hands

You can't attack with hand weapons while you have a book stuck to your hands.

If you have the Blue Flame at the beginning of a turn, the book is dissolved.

### Open a chest

If the player opens a chest, there are different chances of different effects.

Once a chest is opened, it is replaced by an empty room.

| Probability | Effect            |
|:-----------:|-------------------|
|    1/4      | Chest explodes    |
|    1/4      | Poison gas        |
|    1/2      | Contains treasure |

#### Exploding chest

1. Compute damage: `1d6` - Armor Value, clamped at 0.
2. Subtract damage from ST (might result in death).
3. Subtract damage from Armor Durability (might result in armor being
   destroyed).

#### Poison gas chest

1. Add 20 to turn counter.
2. Move the player a random direction (N, S, W, E) as if the player had walked
   that way.

#### Treasure chest

Collect `1d1000` gold pieces.

### Gaze into an orb

These orbs found in rooms are _not_ The Orb of Zot.

Orb effects happen at an even 1/6 chance.

| Effect                           | Result/Notes                                          |
|----------------------------------|-------------------------------------------------------|
| See yourself in a bloody heap    | Lose `1d2` ST, room is marked as empty (orb removed)  |
| See yourself becoming a monster  | Type of monster chosen at random                      |
| See a monster gazing back at you | Type of monster chosen at random                      |
| An item at a location            | Location chosen randomly, marked as explored on map   |
| The Orb of Zot at a location     | 3/8 chance this is the real location, else it's a lie |
| A soap opera rerun               | No effect                                             |

### Drink from a pool

If you drink from a pool, one of 8 things happen with equal probability.

| Pool Effect   | Description                                |
|---------------|--------------------------------------------|
| Feel Stronger | Add `1d3` to ST, capped at 18              |
| Feel Weaker   | Subtract `1d3` from ST                     |
| Feel Smarter  | Add `1d3` to IQ, capped at 18              |
| Feel Dumber   | Subtract `1d3` from IQ                     |
| Feel Nimbler  | Add `1d3` to DX, capped at 18              |
| Feel Clumsier | Subtract `1d3` from DX                     |
| Change Race   | Change your race to something you're not   |
| Change Gender | Change your gender to something you're not |

### Teleport

If you have the Runestaff, you can teleport to any X, Y, Z location. See [The
Runestaff](#the-runestaff).

### Quit

The game is over.

## Vendor Interactions

## Combat

## Random Messages

Each turn there is a 1/5 chance that a random message will be shown.

One of the following messages is shown with equal probability:

| Message                            | Note                                                     |
|------------------------------------|----------------------------------------------------------|
| You see a bat fly by               |                                                          |
| You hear {sound}                   | either "a scream", "footsteps", "a wumpus", or "thunder" |
| You sneezed                        |                                                          |
| You stepped on a frog              |                                                          |
| You smell a {monster} frying       | chosen at random, not counting vendors                   |
| You feel like you're being watched |                                                          |
| You are playing Wizard's Castle    |                                                          |

If the player is [blind](#blindness), then "you see a bat fly by" is replaced by
"you stepped on a frog".

> This could be simplified to merely not show any messages that had anything to
> do with seeing, and not by duplicating another message.

## Turn Sequence

## Game Over, Man

If you exit the dungeon:

* If you have the Orb of Zot, you win.
* If you do not have the Orb of Zot, you lose.

If any of your stats fall to 0 or below, you die and lose.
