REM Wizard's Castle
REM
REM By Joseph R. Power
REM
REM Recreational Computing Magazine, July 1980
REM 
REM https://archive.org/details/1980-07-recreational-computing/page/n9
REM
REM Entered and commented by Brian "Beej Jorgensen" Hall <beej@beej.us>
REM
REM CAVEAT: This code has never been run--there are almost certainly
REM transcription errors.

REM Subroutine Index
REM
REM 2800: Take damage (exploding chests, monster hits)
REM 2840: Game over
REM 3200: Choose a random X,Y for a given Z until you find an empty room. Set that room to Q.
REM 3270: Print a horizontal rule of 64 `*`s
REM 3280: Print "YOUR CHOICE", input a string, return leftmost character in O$
REM 3290: Input a string, return the leftmost character in O$
REM 3300: Ask how many points to add to Z$. Sanitize input and make sure enough OT is left. Return result in Q.
REM 3350: Input a number from 1-8.
REM 3370: Prompt to purchase stat
REM 3380: Your Z$ (stat) is now Q
REM 3390: Prints "Here is a list of $Z you can buy"
REM 3400: Pretty print location X, Y, Z

REM No idea what this magic number does

10 REM "_(C2SLFF4

REM C$ names of all the castle contents
REM I$ abbreviations for all the possible castle contents
REM R$ names of the 4 races
REM W$ names of 4 weapons and 4 armor types
REM E$ names of the 8 recipes (for Orc Tacos, etc.)

20 CLEAR 60: DIM C$(34), I$(34), R$(4), W$(8), E$(8)

REM C location and status of the curses
REM T status flags of the treasures (1 = player owns)
REM O location of the Orb of Zot
REM R location of the Runestaff

30 DIM C(3,4), T(8), O(3), R(3): PRINT CHR$(12); "Creating Arrays"

REM Call machine code to get something for random seed??

40 POKE 260,218: POKE 261,1: T = USR(0): T = PEEK(-2049)

REM FND computes room location in memory
REM FNE tags a room as explored

50 DEF FND(Q) = Q*64 + X*8 + Y - 585 : DEF FNE(Q) = Q + 100 * (Q > 99)

REM CHR$(13) is newline

60 Y$ = CHR$(13) + "** ANSWER YES OR NO " + CHR$(13)

REM FNA produces a random number from 1 to Q
REM FNB causes wraparound at borders

70 DEF FNA(Q) = 1 + INT(RND(8)*Q): DEF FNB(Q) = Q + 8 * ((Q=9)-(Q=0))

REM Seed random number with time??
REM Read in names of castle contents and abbreviations for castle contents

80 Q = RND(-(2*T+1)): RESTORE: FOR Q = 1 TO 34: READ C$(Q), I$(Q): NEXT Q

REM Store unexplored empty rooms (101) for all locations
REM Read in the names of the 4 weapons and 4 armors, and 8 recipes

90 FOR Q = -512 TO 0: POKE Q, 101: NEXT Q: FOR Q = 1 TO 8: READ W$(Q), E$(Q): NEXT Q

REM Read in names of 4 races
REM FNC Limits Q to a max of 18

100 FOR Q = 1 TO 4: READ R$(Q): NEXT Q: DEF FNC(Q) = -Q * (Q < 19) - 18 * (Q > 18)

REM CHR$(12) clear screen
REM 3270 Print a horizontal rule of 64 *s

110 PRINT CHR$(12): GOSUB 3270: PRINT TAB(21) "THE WIZARD'S CASTLE": PRINT: GOSUB 3270

120 PRINT "Copyright (C) 1980 by Joseph R Power": PRINT

130 PRINT "Last Revised - 04/12/80  11:10 PM": PRINT

REM X,Y for positioning the entrance on line 150

140 PRINT:PRINT "PLEASE BE PATIENT - ";: X = 1: Y = 4

REM Any time you find POKE FND, it's storing a value in a room at the given level, X, and Y.
REM Put the entrance (2) at 1,4,1

REM 3200 Choose a random X,Y for a given Z until you find an empty room. Set that room to Q.

REM For each level 1-7, place 2 random stairs down. Place stairs up on the next level below.

150 POKE FND(1), 2: PRINT "IN";: FOR Z = 1 TO 7: FOR Q1 = 1 TO 2: Q = 104: GOSUB 3200
160 POKE FND(Z+1), 103: NEXT Q1: NEXT Z: PRINT "I";

REM For each level:
REM    Place 1 of each monster
REM    Place 3 of each item
REM    Place 3 vendors
REM    Print out the next letter of "TIALIZIN"

170 FOR Z = 1 TO 8: FOR Q = 113 TO 124: GOSUB 3200: NEXT Q: FOR Q1 = 1 TO 3
180 FOR Q = 105 TO 112: GOSUB 3200: NEXT Q: Q = 125: GOSUB 3200: NEXT Q1: READ O$: PRINT O$;: NEXT Z

REM Place the treasures in random locations
REM Finish printing "INITIALIZING"

190 FOR Q = 126 TO 133: Z = FNA(8): GOSUB 3200: NEXT Q: PRINT "G";

REM Add the curses as empty rooms, store their location, and mark them uncursed
200 Q = 101: FOR A = 1 TO 3: Z = FNA(8): GOSUB 3200: C(A,1) = X: C(A,2) = Y: C(A,3) = Z: C(A,4) = 0

REM Print " CA" then "S"

REM RC - Race (initialized to zero to indicate the user has not selected a player)
REM ST - Strength
REM Switch race 3 name temporarily from "HUMAN" to "MAN" so the user can select
REM     it with "M" ("H" collides with "HOBBIT").

210 READ O$: PRINT O$;: NEXT A: PRINT "S";: RC = 0: ST = 2: DX = 14: R$(3) = "MAN"

REM Place an extra random monster on a random level
REM Record that monster's location as the Runestaff location

220 Q = 112 + FNA(12): Z = FNA(8): GOSUB 3200: R(1) = X: R(2) = Y: R(3) = Z

REM Place an extra warp on a random level
REM Record that warp's location as the Orb of Zot location
REM Finish printing "CASTLE"

REM Note: the following line originally had no quote mark at the end, but it is
REM included here to keep the syntax highlighting sane.

230 Q = 109: Z = FNA(8): GOSUB 3200: O(1) = X: O(2) = Y: O(3) = Z: PRINT "TLE"

REM BF - book-stuck-to-hands flag (1 = book stuck)
REM OT - amount of other points the player gets
REM AV - number of points your armor absorbs per hit
REM HT - last turn you ate a monster on
REM  T - the turn counter
REM VF - Vendor-anger-flag (1 = Vendors angry)
REM LF - lamp-owned flag (1 = player owns it)
REM TC - total number of treasures you possess
REM GP - total number of gold pieces you possess
REM RF - Runestaff possession flag (1 = player owns it)
REM OF - Orb of Zot possession flag (1 = player owns it)
REM BL - blindness flag (1 = player is blind)

240 BF = 0: OT = 8: AV = 0: HT = 0: T = 1: VF = 0: LF = 0: TC = 0: GP = 60: RF = 0: OF = 0: BL = 0

REM IQ - current number of intelligence points
REM SX - sex (0 = female, 1 = male)
REM Mark all treasures unfound

250 IQ = 8: SX = 0: FOR Q = 1 TO 8: T(Q) = 0: NEXT Q: PRINT CHR$(12); "ALL RIGHT, BOLD ONE"

REM 3280 Print "YOUR CHOICE", return leftmost character in O$

260 PRINT: PRINT "YOU MAY BE AN ELF, DWARF, MAN, OR HOBBIT": GOSUB 3280

REM RC - race (1 = hobbit, 2 = elf, 3 = man, 4 = dwarf)
REM Strength bonus: add 2 * race
REM Dexterity penalty: subtract 2 * race

270 FOR Q = 1 TO 4: IF LEFT$(R$(Q), 1) = O$ THEN RC = Q: ST = ST + 2 * Q: DX = DX - 2 * Q

REM If user selected HOBBIT, subtract 4 "other allocation" points
REM Reset R$(3) name from "MAN" to "HUMAN" if the user selected a valid option

280 NEXT Q: PRINT: OT = OT + 4 * (RC=1): IF RC > 0 THEN R$(3) = "HUMAN": GOTO 300

290 PRINT "** THAT WAS INCORRECT. PLEASE TYPE E, D, M, OR H.": GOTO 260

REM 3290 Input a string, return the leftmost character in O$

300 PRINT: PRINT "SEX ";: GOSUB 3290: IF O$ = "M" THEN SX = 1: GOTO 320

310 IF O$ <> "F" THEN PRINT: PRINT "** CUTE "; R$(RC); ", REAL CUTE. TRY M OR F": GOTO 300

320 PRINT CHR$(12): PRINT "OK "; R$(RC); ", YOU HAVE THESE STATISTICS:": PRINT

330 PRINT "STRENGTH= "; ST; " INTELLIGENCE= "; IQ; " DEXTERITY= "; DX: PRINT

340 PRINT "AND "; OT; " OTHER POINTS TO ALLOCATE AS YOU WISH.": PRINT

REM 3300 Ask how many points to add to Z$. Sanitize input and make sure enough OT is left.
REM Allocate points to IQ
REM Allocate points to ST
REM Allocate points to DX

350 Z$ = "INTELLIGENCE ": GOSUB 3300: IQ = IQ + Q: IF OT = 0 THEN 370
360 Z$ = "STRENGTH ": GOSUB 3300: ST = ST + Q: IF OT THEN Z$ = "DEXTERITY ": GOSUB 3300: DX = DX + Q

370 PRINT CHR$(12): PRINT "OK, "; R$(RC); ", YOU HAVE 60 GOLD PIECES (GP's)": PRINT

REM 3390 Prints "Here is a list of $Z you can buy"

REM AV - number of points your armor absorbs per hit
REM WV - number of points of damage your weapon does
REM FL - total number of flares you possess
REM WC - turns left before a web breaks

380 Z$ = "ARMOR": GOSUB 3390: AV = 0: WV = 0: FL = 0: WC = 0

390 PRINT "PLATE<30> CHAINMAIL<20> LEATHER<10> NOTHING<0>"

REM 3280 Print "YOUR CHOICE", return leftmost character in O$

400 GOSUB 3280: IF O$ = "N" THEN 440

REM Compute armor value in AV:
REM
REM 1 - Leather
REM 2 - Chainmail
REM 3 - Plate

410 AV = -3 * (O$="P") - 2 * (O$="C") - (O$="L"): IF AV > 0 THEN 440

REM On bad input, insultingly call the player a monster

420 PRINT: PRINT "** ARE YOU A "; R$(RC); " OR "; C$(FNA(12)+12);
430 PRINT " ? TYPE P,C,L, OR N": PRINT: GOTO 380

REM AH - total number of hit points your armor has left
REM Subtract armor value from GP

REM Starting armor hit point values:
REM
REM 7 - Leather
REM 14 - Chainmail
REM 21 - Plate

440 AH = AV * 7: GP = GP - AV * 10: PRINT CHR$(12)

450 PRINT: PRINT "OK, BOLD "; R$(RC); ", YOU HAVE "; GP; " GP's LEFT": PRINT

REM 3390 Prints "Here is a list of $Z you can buy"

460 Z$ = "WEAPONS": GOSUB 3390

REM 3280 Print "YOUR CHOICE", return leftmost character in O$

470 PRINT "SWORD<30> MACE<20> DAGGER<10> NOTHING<0>": GOSUB 3280: IF O$ = "N" THEN 500

REM Compute number of hit points your weapon does in damage (WV)
REM
REM 1 - Dagger
REM 2 - Mace
REM 3 - Sword

480 WV = -3 * (O$="S") - 2 * (O$="M") - (O$="D"): IF WV > 0 THEN 500

490 PRINT: PRINT "** IS YOUR IQ REALLY "; IQ; "? TYPE S, M, D, OR N": PRINT: GOTO 460

REM Charge for weapon

500 GP = GP - WV * 10: PRINT CHR$(12): IF GP < 20 THEN 540

REM 3290 Input a string, return the leftmost character in O$

REM See if the player wants a lamp

510 PRINT "WANT TO BUY A LAMP FOR 20 GP's ";: GOSUB 3290

520 IF O$ = "Y" THEN LF = 1: GP = GP - 20: GOTO 540

REM If the player didn't enter Y or N, make them do so

530 IF O$ <> "N" THEN PRINT: PRINT Y$: PRINT: GOTO 510

REM Q - temp var for quantity of flares to buy

540 PRINT CHR$(12): IF GP < 1 THEN Q = 0: GOTO 600

550 PRINT: PRINT "OK, "; R$(RC); ", YOU HAVE "; GP; " GOLD PIECES LEFT": PRINT

560 INPUT "FLARES COST 1 GP EACH. HOW MANY DO YOU WANT "; O$

REM ASCII 48 = '0'

570 Q = VAL(O$): PRINT: IF Q > 0 OR ASC(O$) = 48 THEN 590

580 PRINT "** IF YOU DON'T WANT ANY JUST TYPE 0 (ZERO)": PRINT: GOTO 560

590 IF Q > GP THEN PRINT "** YOU CAN ONLY AFFORD "; GP: PRINT: GOTO 560

REM Add to flare count ??do you bank flares from prior games??

REM Set X,Y,Z to initial player position

600 FL = FL + Q: GP = GP - Q: PRINT CHR$(12): X = 1: Y = 4: Z = 1

REM 1670 (GOTO) Print location, stats, handle room actions

610 PRINT "OK "; R$(RC); ", YOU ENTER THE CASTLE AND BEGIN.": PRINT: GOTO 1670

REM START NEXT TURN

REM Increment turn counter
REM If you have the Runestaff or Orb of Zot, skip the curse effects

620 T = T + 1: IF RF + OF > 0 THEN 690

REM If we have Lethargy and no Ruby Red, increase turn counter by 1 extra

630 IF C(1,4) > T(1) THEN T = T + 1

REM If we have Leech and no Pale Pearl, lose up to 5 GP per turn

640 IF C(2,4) > T(3) THEN GP = GP - FNA(5): IF GP < 0 THEN GP = 0

REM If NOT(we have Forgetfulness and no Green Gem), skip the forgetting code

650 IF C(3,4) <= T(5) THEN 690

REM Apply forgetfulness

REM Save player position in A,B,C
REM Mark a random room unexplored
REM Restore player position from A,B,C

660 A = X: B = Y: C = Z: X = FNA(8): Y = FNA(8): Z = FNA(8)
670 POKE FND(Z), FNE(PEEK(FND(Z))) + 100: X = A: Y = B: Z = C

REM Test for curses

REM If we're in an empty room, check if it's a curse room
REM     If it is, mark the curse as active
REM     If it isn't, mark the curse as inactive (???)
REM
REM This seems like a bug. Shouldn't the curse stay active?
REM
REM As it is, it will clear the moment you step into another empty room.
REM
REM In Adam Biltcliffe's Inform port, he sets the curses active permanently
REM once encountered, and then ignores them if the cure treasure is held:
REM
REM https://ifarchive.org/if-archive/games/source/inform/wcastle.inf
REM
REM This makes sense, since you can sell treasures to vendors, and the
REM docs say the treasures nullify the effects of the curses--implying they
REM don't remove the curses.

680 IF PEEK(FND(Z)) = 1 THEN FOR Q = 1 TO 3: C(Q,4) = -(C(Q,1)=X) * (C(Q,2)=Y) * (C(Q,3)=Z): NEXT

REM 4/5 chance you'll skip the random ("STEPPED ON A FROG"-ish) message

690 IF FNA(5) > 1 THEN 790

REM Print a random message

REM BL - blindness flag (1 = player is blind)

REM If player not blind, choose a random message between 1 - 7.
REM If player is blind, choose a random message between 2 - 8.
REM    If 8 chosen, show 4.

700 PRINT: PRINT "YOU ";: Q = FNA(7) + BL: IF Q > 7 THEN Q = 4

REM Q
REM
REM 1 - See a bat
REM 2 - Hear scream/footsteps/wumpus/thunder
REM 3 - Sneezed
REM 4 - Stepped on a frog
REM 5 - Smell a monster frying
REM 6 - Feel like you're being watched
REM 7 - Are playing Wizard's Castle

710 ON Q GOSUB 750, 730, 740, 720, 760, 770, 780: GOTO 790

720 PRINT "STEPPED ON A FROG": RETURN
730 PRINT "HEAR "; MID$("A SCREAM FOOTSTEPSA WUMPUS THUNDER", FNA(4) * 9 - 8, 9): RETURN
740 PRINT "SNEEZED": RETURN
750 PRINT "SEE A BAT FLY BY": RETURN
760 PRINT "SMELL "; C$(12+FNA(13)); " FRYING": RETURN
770 PRINT "FEEL LIKE YOU'RE BEING WATCHED": RETURN
780 PRINT "ARE PLAYING WIZARD'S CASTLE": RETURN

REM Cure blindness with The Opal Eye

790 IF BL + T(4) = 2 THEN PRINT: PRINT C$(29); " CURES YOUR BLINDNESS": BL = 0

REM Dissolve books with The Blue Flame

800 IF BF + T(6) = 2 THEN PRINT: PRINT C$(31); " DISSOLVES THE BOOK": BF = 0

REM Input a move

810 PRINT: PRINT: PRINT: INPUT "YOUR MOVE "; O$: IF LEFT$(O$,2) = "DR" THEN 1180
820 O$ = LEFT$(O$, 1): IF O$ = "N" THEN 940
830 IF (O$ = "S") OR (O$ = "W") OR (O$ = "E") THEN 950
840 IF O$ = "U" THEN 970
850 IF O$ = "D" THEN 990
860 IF O$ = "M" THEN 1010
870 IF O$ = "F" THEN ON 1 + BL GOTO 1070, 1010
880 IF O$ = "L" THEN ON 1 + BL GOTO 1110, 1010
890 IF O$ = "O" THEN 1310
900 IF O$ = "G" THEN ON 1 + BL GOTO 1480, 1010
910 IF O$ = "T" THEN PRINT: ON 1 + RF GOTO 1590, 1600
920 IF O$ = "Q" THEN 1640

930 PRINT: PRINT "** STUPID "; R$(RC); " THAT WASN'T A VALID COMMAND": GOTO 620

REM MOVE: NORTH

REM If we're at the entrance, handle that. Otherwise fall through to the
REM normal move handler.

940 IF PEEK(FND(Z)) = 2 THEN 2900

REM MOVE: N, S, W, E

950 X = X + (O$="N") - (O$="S"): Y = Y + (O$="W") - (O$="E")

REM Handle wrap

960 X = FNB(X): Y = FNB(Y): GOTO 1670

REM MOVE: UP

970 IF PEEK(FND(Z)) = 3 THEN Z = Z - 1: GOTO 1670

980 Z$ = "UP": GOTO 1000

REM MOVE: DOWN

990 Z$ = "DOWN": IF PEEK(FND(Z)) = 4 THEN Z = Z + 1: GOTO 1670

1000 PRINT: PRINT "** OH "; R$(RC); ", NO STAIRS GOING "; Z$; " IN HERE": GOTO 620

REM Insult player for being blind, or continue to print map otherwise

1010 IF BL = 1 THEN PRINT: PRINT "** YOU CAN'T SEE ANYTHING, DUMB "; R$(RC): GOTO 620

REM PRINT MAP

1020 PRINT: PRINT: A = X: B = Y: FOR X = 1 TO 8: FOR Y = 1 TO 8: Q = PEEK(FND(Z)): IF Q > 99 THEN Q = 34
1030 IF X = A AND Y = B THEN PRINT "<"; I$(Q); ">";: GOTO 1050
1040 PRINT " "; I$(Q); " ";
1050 NEXT Y: PRINT: PRINT: NEXT X: X = A: Y = B: GOTO 1100

REM ???

1060 PRINT ") LEVEL "; Z: GOTO 620

REM FLARE

1070 IF FL = 0 THEN PRINT: PRINT "** HEY BRIGHT ONE, YOU'RE OUT OF FLARES": GOTO 620
1080 PRINT: PRINT: FL = FL - 1: A = X: B = Y: FOR Q1 = A - 1 TO A + 1: X = FNB(Q1): FOR Q2 = B - 1 TO B + 1: Y = FNB(Q2)
1090 Q = FNE(PEEK(FND(Z))): POKE FND(Z), Q: PRINT I$(Q);"  ";: NEXT Q2: PRINT: PRINT: NEXT Q1: X = A: Y = B

REM 3400 Pretty print X,Y,Z

1100 GOSUB 3400: GOTO 620

REM LAMP

1110 IF LF = 0 THEN PRINT: PRINT "** YOU DON'T HAVE A LAMP, "; R$(RC): GOTO 620

REM 3290: Input a string, return the leftmost character in O$

1120 PRINT: PRINT "WHERE DO YOU SHINE THE LAMP (N,S,E, OR W) ";: GOSUB 3290
1130 A = X: B = Y: X = FNB(X + (O$="N") - (O$="S")): Y = FNB(Y + (O$="W") - (O$="E"))
1140 IF A-X + B-Y = 0 THEN PRINT: PRINT "** TURKEY! THAT'S NOT A DIRECTION": GOTO 620
1150 PRINT: PRINT "THE LAMP SHINES INTO ("; X; ","; Y; ") LEVEL ";Z: PRINT

REM Mark as discovered, and print what's there

1160 POKE FND(Z), FNE(PEEK(FND(Z))): PRINT "THERE YOU WILL FIND ";C$(PEEK(FND(Z)))
1170 X = A: Y = B: GOTO 620

REM DRINK

1180 IF PEEK(FND(Z)) <> 5 THEN PRINT: PRINT "** IF YOU WANT A DRINK, FIND A POOL": GOTO 620

1190 Q = FNA(8): PRINT: PRINT "YOU TAKE A DRINK AND ";: IF Q < 7 THEN PRINT "FEEL ";

REM Q
REM
REM 1 - feel stronger (ST goes up 1-3 points, capped at 18)
REM 2 - feel weaker (ST goes down 1-3 points, if zero or less, player dies)
REM 3 - feel smarter (IQ goes up 1-3 points, capped at 18)
REM 4 - feel dumber (IQ goes down 1-3 points, if zero or less, player dies)
REM 5 - feel nimbler (DX goes up 1-3 points, capped at 18)
REM 6 - feel clumsier (DX goes down 1-3 points, if zero or less, player dies)
REM 7 - change race to something you're not
REM 8 - flip gender

1200 ON Q GOTO 1210, 1220, 1230, 1240, 1250, 1260, 1270, 1290

1210 ST = FNC(ST + FNA(3)): PRINT "STRONGER": GOTO 620
1220 ST = ST - FNA(3): PRINT "WEAKER": ON 1 - (ST < 1) GOTO 620, 2840
1230 IQ = FNC(IQ + FNA(3)): PRINT "SMARTER": GOTO 620
1240 IQ = IQ - FNA(3): PRINT "DUMBER": ON 1 - (IQ < 1) GOTO 620, 2840
1250 DX = FNC(DX + FNA(3)): PRINT "NIMBLER": GOTO 620
1260 DX = DX - FNA(3): PRINT "CLUMSIER": ON 1 - (DX < 1) GOTO 620, 2840

1270 Q = FNA(4): IF Q = RC THEN 1270
1280 RC = Q: PRINT "BECOME A "; R$(RC): GOTO 620

1290 SX = 1 - SX: PRINT "TURN INTO A ";: IF SX = 0 THEN PRINT "FE";
1300 PRINT "MALE "; R$(RC): GOTO 620

REM MOVE: OPEN (chest or book)

1310 IF PEEK(FND(Z)) = 6 THEN PRINT: PRINT "YOU OPEN THE CHEST AND": PRINT: GOTO 1430

1320 IF PEEK(FND(Z)) = 12 THEN PRINT: PRINT "YOU OPEN THE BOOK AND": PRINT: GOTO 1340

1330 PRINT: PRINT "** THE ONLY THING YOU OPENED WAS YOUR BIG MOUTH": GOTO 620

REM Open book
REM
REM 1 - player goes blind
REM 2 - Zot's poetry (no effect)
REM 3 - old copy of playhuman/dwarf/elf/hobbit (no effect)
REM 4 - manual of dexterity (set DX to 18)
REM 5 - manual of strength (set ST to 18)
REM 6 - book sticks to player's hands

1340 ON FNA(6) GOTO 1350, 1360, 1370, 1380, 1390, 1400

1350 PRINT "FLASH! OH NO! YOU ARE NOW A BLIND "; R$(RC): BL = 1: GOTO 1420
1360 PRINT "ITS ANOTHER VOLUME OF ZOT'S POETRY! - YEECH!": GOTO 1420
1370 PRINT "ITS AN OLD COPY OF PLAY";R$(FNA(4)): GOTO 1420
1380 PRINT "ITS A MANUAL OF DEXTERITY!": DX = 18: GOTO 1420
1390 PRINT "ITS A MANUAL OF STRENGTH !": ST = 18: GOTO 1420
1400 PRINT "THE BOOK STICKS TO YOUR HANDS -": PRINT
1410 PRINT "NOW YOU CAN'T DRAW YOUR WEAPON!": BF = 1

REM Remove the book/chest from the room (they vanish upon use)

1420 POKE FND(Z), 1: GOTO 620

REM Open chest

REM 1/4 chance of explosion
REM 1/4 chance of gas
REM 1/2 chance of finding treasure

REM Explosion:
REM
REM   Take (d6 - AV) damage, clamped at zero.
REM   Subtract damage from AH
REM   Subtract damage from ST, as well (dying if necessary)
REM   If AH < 0, the armor is destroyed
REM
REM Treasure:
REM
REM   Collect d1000 GP
REM
REM Gas:
REM
REM   Add 20 to turn counter
REM   Choose a random cardinal direction and move there (as if the player had moved that way)

REM In all cases, the chest is removed from the room

1430 ON FNA(4) GOTO 1440, 1450, 1460, 1450

REM 2800 Take damage

1440 PRINT "KABOOM! IT EXPLODES": Q = FNA(6): GOSUB 2800: ON 1 - (ST < 1) GOTO 1420, 2840
1450 Q = FNA(1000): PRINT "FIND "; Q; " GOLD PIECES": GP = GP + Q: GOTO 1420
1460 PRINT "GAS! YOU STAGGER FROM THE ROOM"
1470 POKE FND(Z),1: T = T + 20: O$ = MID$("NSEW", FNA(4), 1): GOTO 950


REM GAZE into orb

REM 1 - See yourself in a bloody heap
REM     Lose 1d2 ST
REM     Room is marked empty
REM 2 - Yourself drinking from a pool and becoming [a monster]
REM 3 - [A monster] gazing back at you
REM 4 - An item at a location.
REM     The room is marked as explored
REM 5 - The Orb of Zot at a location
REM     3/8 chance this is the actual location
REM     5/8 chance that it's a random location
REM 6 - A soap opera rerun

1480 IF PEEK(FND(Z)) <> 11 THEN PRINT: PRINT "** NO ORB - NO GAZE": GOTO 620
1490 PRINT: PRINT "YOU SEE ";: ON FNA(6) GOTO 1500, 1510, 1530, 1540, 1560, 1580

1500 PRINT "YOURSELF IN A BLOODY HEAP": ST = ST - FNA(2): ON 1 - (ST < 1) GOTO 620, 2840

1510 PRINT "YOURSELF DRINKING FROM A POOL AND BECOMING "; C$(12+FNA(13))
1520 GOTO 620

1530 PRINT C$(12 + FNA(13)); " GAZING BACK AT YOU": GOTO 620

1540 A = X: B = Y: C = Z: X = FNA(8): Y = FNA(8): Z = FNA(8): Q = FNE(PEEK(FND(Z))): POKE FND(Z), Q
1550 PRINT C$(Q); " AT ("; X; ","; Y; ") LEVEL "; Z: X = A: Y = B: Z = C: GOTO 620

1560 A = FNA(8): B = FNA(8): C = FNA(8): IF FNA(8) < 4 THEN A = O(1): B = O(2): C = O(3)
1570 PRINT "THE ORB OF ZOT AT ("; A; ","; B; ") LEVEL "; C: GOTO 620

1580 PRINT "A SOAP OPERA RERUN": GOTO 620


REM TELEPORT

1590 IF RF = 0 THEN PRINT: PRINT "** YOU CAN'T TELEPORT WITHOUT THE RUNESTAFF!": GOTO 620
1600 Z$ = "X-COORD (1=FAR NORTH 8=FAR SOUTH) ": GOSUB 3350: X = Q
1610 Z$ = "Y-COORD (1=FAR WEST  8=FAR EAST ) ": GOSUB 3350: Y = Q
1620 Z$ = "LEVEL   (1=TOP       8=BOTTOM   ) ": GOSUB 3350: Z = Q

REM O$ = "T" is the teleport flag, used when discovering the Orb of Zot

1630 O$ = "T": GOTO 1670


REM QUIT

1640 PRINT: PRINT "DO YOU REALLY WANT TO QUIT ";: GOSUB 3290: PRINT
1650 IF O$ <> "Y" THEN PRINT "** THEN DON'T SAY YOU DO": GOTO 620

REM 2940 Game over (defeat)

1660 PRINT: PRINT: GOTO 2940


REM PRINT STATUS

REM 3400 Pretty-print location (if not blind)

1670 PRINT: IF BL = 0 THEN GOSUB 3400: PRINT

1680 PRINT "ST= "; ST; " IQ= "; IQ; " DX= "; DX; " FLARES= "; FL; " GP's= "; GP

REM Print weapon and armor

1690 PRINT: PRINT W$(WV + 1); " / "; W$(AV + 5);: IF LF = 1 THEN PRINT " / A LAMP";

REM WC = turns left before a web breaks
REM "YOU HAVE " appears several times, below.

1700 PRINT: PRINT: WC = 0: Q = FNE(PEEK(FND(Z))): POKEFND(Z),Q: Z$ = "YOU HAVE "

REM PRINT ROOM DESCRIPTION
REM
REM If it's a no-effect room, head back to the main loop.

1710 PRINT "HERE YOU FIND "; C$(Q): IF (Q < 7) OR (Q = 11) OR (Q = 12) THEN 620

REM Gold in room. Add 1d10 to GP.
REM 1420: Mark room as empty

1720 IF Q = 7 THEN GP = GP + FNA(10): PRINT: PRINT Z$; GP: GOTO 1420

REM Flares in room. Add 1d5 to FL.
REM 1420: Mark room as empty

1730 IF Q = 8 THEN FL = FL + FNA(5): PRINT: PRINT Z$; FL: GOTO 1420

REM 9 is a Warp, so we have to test for Orb of Zot

1740 IF Q > 9 THEN 1770

REM 950 Regular move
REM 3050 Discovered Orb of Zot

1750 PRINT: IF (O(1) = X) AND (O(2) = Y) AND (O(3) = Z) THEN ON 1 - (O$ = "T") GOTO 950, 3050

REM Warp?? Who jumps here?
REM Random X, Y, Z
REM 1670 Show location

1760 X = FNA(8): Y = FNA(8): Z = FNA(8): GOTO 1670

REM Sinkhole

1770 IF Q = 10 THEN Z = FNB(Z + 1): GOTO 1670

REM Treasure
REM 1420: Mark room as empty

1780 IF Q > 25 AND Q < 34 THEN PRINT: PRINT "ITS NOW YOURS": T(Q - 25) = 1: TC = TC + 1: GOTO 1420

REM If facing a monster or an angry vendor, do battle (2300)
REM WC = turns left before a web breaks
REM A = monster number (kobold is 1, then counts up)

1790 A = PEEK(FND(Z)) - 12: WC = 0: IF (A < 13) OR (VF = 1) THEN 2300

REM Vendor behavior

1800 PRINT: PRINT "YOU MAY TRADE WITH, ATTACK, OR IGNORE THE VENDOR"

REM 3280 Print "YOUR CHOICE"

1810 GOSUB 3280: IF O$ = "I" THEN 620

REM 2300 Do battle

1820 IF O$ = "A" THEN VF = 1: PRINT: PRINT "YOU'LL BE SORRY YOU DID THAT": GOTO 2300

1830 IF O$ <> "T" THEN PRINT: PRINT "** NICE SHOT, "; R$(RC): GOTO 1800

REM Offer to buy treasures
REM Treasure price random: Min: 1, Max: treasure_number * 1500

1840 PRINT: FOR Q = 1 to 8: A = FNA(Q * 1500): IF T(Q) = 0 THEN 1880

1850 PRINT: PRINT "DO YOU WANT TO SELL "; C$(Q+25); " FOR "; A; "GP's ";

REM 3290 Input string, return left-most character

1860 GOSUB 3290: IF O$ = "Y" THEN TC = TC - 1: T(Q) = 0: GP = GP + A: GOTO 1880

1870 IF O$ <> "N" THEN PRINT Y$: GOTO 1850

1880 NEXT Q

REM If you have less than 1000 GP, you can't trade.

1890 IF GP < 1E3 THEN PRINT: PRINT "YOU'RE TOO POOR TO TRADE, "; R$(RC): GOTO 620

1900 IF GP < 1250 THEN 2130

REM Print GP and current armor

1910 PRINT: PRINT "OK, "; R$(RC);", YOU HAVE "; GP; " GOLD PIECES AND "; W$(AV + 5)

REM 3390 Here is a list of Z$ you can buy

1920 PRINT: Z$ = "ARMOR": GOSUB 3390: PRINT "NOTHING<0> LEATHER<1250> ";
1930 IF GP > 1499 THEN PRINT "CHAINMAIL<1500> ";: IF GP > 1999 THEN PRINT "PLATE<2000>";

REM 3280 Print "YOUR CHOICE"

1940 PRINT: GOSUB 3280: PRINT: IF 0$ = "N" THEN 2010

REM Buy leather

1950 IF O$ = "L" THEN GP = GP - 1250: AV = 1: AH = 7: GOTO 2010

REM Buy chainmail

1960 IF O$ = "C" AND GP < 1500 THEN PRINT "** YOU HAVEN'T GOT THAT MUCH CASH": GOTO 1920
1970 IF O$ = "C" THEN GP = GP - 1500: AV = 2: AH = 14: GOTO 2010

REM Buy plate

1980 IF O$ = "P" AND GP < 2000 THEN PRINT "** YOU CAN'T AFFORD PLATE": GOTO 1920
1990 IF O$ = "P" THEN GP = GP - 2000: AV = 3: AH = 21: GOTO 2010

2000 PRINT: PRINT "** DON'T BE SILLY. CHOOSE A SELECTION": GOTO 1940

2010 IF GP < 1250 THEN 2130

REM Buy weapons

2020 PRINT: PRINT "YOU HAVE "; GP; " GP's LEFT WITH "; W$(WV + 1); " IN HAND": PRINT

REM 3390 Here is a list of Z$ you can buy

2030 PRINT: Z$ = "WEAPON": GOSUB 3390: PRINT "NOTHING<0> DAGGER<1250> ";

2040 IF GP > 1499 THEN PRINT "MACE<1500> ";: IF GP > 1999 THEN PRINT "SWORD<2000>";

REM 3280 Print "YOUR CHOICE"

2050 PRINT: GOSUB 3280: PRINT: IF O$ = "N" THEN 2130

2060 IF O$ = "D" THEN GP = GP - 1250: WV = 1: GOTO 2130
2070 IF O$ = "M" AND GP < 1500 THEN PRINT "** SORRY SIR, I DON'T GIVE CREDIT": GOTO 2030
2080 IF O$ = "M" THEN GP = GP - 1500: WV = 2: GOTO 2130
2090 IF O$ = "S" AND GP < 2000 THEN PRINT "** DUNGEON EXPRESS CARD - ";
2100 IF O$ = "S" AND GP < 2000 THEN PRINT "YOU LEFT HOME WITHOUT IT!": GOTO 2030
2110 IF O$ = "S" THEN GP = GP - 2000: WV = 3: GOTO 2130
2120 PRINT "** TRY CHOOSING A SELECTION": GOTO 2050

2130 IF GP < 1000 THEN 620

REM Buy stats
REM
REM For each stat 1000 GP buys you 1d6 of a stat up to 18 max

REM 3370 Prompt to purchase stat

2140 Z$ = "STRENGTH": GOSUB 3370: IF O$ <> "Y" THEN 2160

REM 3380 Your Z$ (stat) is now Q

2150 GP = GP = 1E3: ST = FNC(ST + FNA(6)): Q = ST: GOSUB 3380: GOTO 2130
2160 IF O$ <> "N" THEN PRINT Y$: GOTO 2140

2170 IF GP < 1000 THEN 620

2180 Z$ = "INTELLIGENCE": GOSUB 3370: IF O$ <> "Y" THEN 2200
2190 GP = GP - 1E3: IQ = FNC(IQ + FNA(6)): Q = IQ: GOSUB 3380: GOTO 2170
2200 IF O$ <> "N" THEN PRINT Y$: GOTO 2180

2210 IF GP < 1000 THEN 620

2220 Z$ = "DEXTERITY": GOSUB 3370: IF O$ <> "Y" THEN 2240
2230 GP = GP - 1E3: DX = FNC(DX + FNA(6)): Q = DX: GOSUB 3380: GOTO 2210
2240 IF O$ <> "N" THEN PRINT Y$: GOTO 2220

2250 IF (GP < 1000) OR (LF = 1) THEN 620

REM Buy lamp?

2260 PRINT: PRINT "WANT A LAMP FOR 1000 GP's "; GOSUB 3290: IF O$ <> "Y" THEN 2280
2270 GP = GP - 1000: LF = 1: PRINT: PRINT "ITS GUARANTEED TO OUTLIVE YOU!": GOTO 620
2280 IF O$ <> "N" THEN PRINT Y$: GOTO 2260

REM Back up to main loop

2290 GOTO 620

REM DO BATTLE
REM
REM You get the initiative UNLESS
REM    You have Lethargy
REM    You're Blind
REM    DX < 2d9
REM
REM If you have the initiative, on the first round of battle you can try a bribe
REM
REM If your IQ > 14, then you can cast a spell

REM Q1 - Damage monster inflicts: 1 + monster_num // 2 
REM Q2 - Monster HP
REM Q3 - 1 = can still bribe, 2 = can't bribe
REM
REM Monster HP:
REM
REM KOBOLD:    3
REM ORC:       4
REM WOLF:      5
REM GOBLIN:    6
REM OGRE:      7
REM TROLL:     8
REM BEAR:      9
REM MINOTAUR: 10
REM GARGOYLE: 11
REM CHIMERA:  12
REM BALROG:   13
REM DRAGON:   14
REM VENDOR:   15


2300 Q1 = 1 + INT(A / 2): Q2 = A + 2: Q3 = 1

REM If you have Lethargy or you're blind or DX < 2d9 then you lose initiative

2310 IF C(1, 4) > T(1) OR (BL = 1) OR (DX < FNA(9) + FNA(9))) THEN 2690

2320 PRINT: PRINT: PRINT "YOU'RE FACING "; C$(A + 12): PRINT: PRINT "YOU MAY ATTACK OR RETREAT";
2330 IF Q3 = 1 THEN PRINT ", OR BRIBE";: IF IQ > 14 THEN PRINT ", OR CAST A SPELL";

REM 3280 Print "YOUR CHOICE"

2340 PRINT: PRINT: PRINT "YOUR STRENGTH IS "; ST; " AND DEXTERITY IS "; DX: PRINT: GOSUB 3280
2350 IF Q$ <> "A" THEN 2480
2360 IF WV = 0 THEN PRINT: PRINT "** POUNDING ON "; C$(12 + A); " WON'T HURT IT": GOTO 2690
2370 IF BF = 1 THEN PRINT: PRINT "** YOU CAN'T BEAT IT TO DEATH WITH A BOOK": GOTO 2690

REM To hit:
REM    If blind: DX < 1d20 + 3
REM    If not blind: DX < 1d20
REM
REM If you hit, the WV is subtracted from monster HP

2380 IF DX < FNA(20) + (BL * 3) THEN PRINT: PRINT "  DRAT! MISSED": GOTO 2690
2390 PRINT: PRINT "  YOU HIT THE LOUSY "; RIGHT$(C$(A + 12), LEN(C$(A + 12)) - 2): Q2 = Q2 - WV

REM If facing a Gargoyle or Dragon, there's a 1/8 chance your weapon breaks on a hit

2400 IF (A = 9 OR A = 12) AND FNA(8) = 1 THEN PRINT: PRINT "OH NO! YOUR "; W$(WV+1); " BROKE": WV = 0
2410 IF Q2 > 0 THEN 2690

REM Monster defeated
REM
REM Player gets the Runstaff (if here) and 1000 GPs

REM MC - ???? Monster count? Bug, or oversight since it doesn't appear elsewhere?

REM If 60 turns have elapsed, have a meal of the monster and reset the timer
REM (Note: H used uninitialized, starts at 0)

2420 PRINT: MC = MC - 1: PRINT C$(A + 12); " LIES DEAD AT YOUR FEET": IF H > T - 60 THEN 2440
2430 PRINT: PRINT "YOU SPEND AN HOUR EATING "; C$(A + 12);E$(FNA(8)): H = T

REM Check for Runestaff at this location

2440 IF X <> R(1) OR Y <> R(2) OR Z <> R(3) THEN ON 1-(A=13) GOTO 2460,3220
2450 PRINT: PRINT "GREAT ZOT! YOU'VE FOUND THE RUNESTAFF": R(1) = 0: RF = 1

2460 Q = FNA(1000): PRINT: PRINT "YOU NOW GET HIS HOARD OF "; Q; " GP's"

REM 1420 Mark room as empty

2470 GP = GP + Q: GOTO 1420

2480 IF O$ = "R" THEN 2690

REM CAST A SPELL
REM
REM To cast a spell, you must have an IQ of 15+, and you must have already attacked
REM    the monster (bribe is no longer possible).
REM
REM Web (makes it so a monster can't attack):
REM    Costs 1 point of ST
REM    Lasts 1d6 + 1 turns (stored in WC)
REM
REM Fireball (causes damage):
REM    Costs 1 point of ST
REM    Costs 1 point of IQ
REM    Does 2d7 damage
REM
REM Deathspell (causes death):
REM    If IQ < 15 + 1d4, player dies
REM    Otherwise monster dies

2490 IF (O$ <> "C") THEN 2610

2500 IF IQ < 15 OR Q3 > 1 THEN PRINT "** YOU CAN'T CAST A SPELL NOW!": GOTO 2320

2510 PRINT: PRINT "WHICH SPELL (WEB, FIREBALL, OR DEATHSPELL) ";:GOSUB 3290: PRINT

2520 IF O$ <> "W" THEN 2540

2530 ST = ST - 1: WC = FNA(8) + 1 : ON 1 - (ST < 1) GOTO 2690, 2840

2540 IF O$ <> "F" THEN 2580

2550 Q = FNA(7) + FNA(7): ST = ST - 1: IQ = IQ - 1: IF (IQ < 1) OR (ST < 1) THEN 2840
2560 PRINT "  IT DOES "; Q; " POINTS OF DAMAGE.": PRINT
2570 Q2 = Q2 - Q: GOTO 2410

2580 IF O$ <> "D" THEN PRINT: PRINT "** TRY ONE OF THE OPTIONS GIVEN": GOTO 2320

2590 PRINT "DEATH - - -"; IF IQ < 15 + FNA(4) THEN PRINT "YOURS": IQ = 0: GOTO 2840
2600 PRINT "HIS": PRINT: Q2 = 0: GOTO 2420


REM BRIBE
REM
REM You can bribe if you have a treasure, otherwise the monster just attacks
REM A random treasure you possess is chosen
REM If you agree to the bribe, the treasure is removed from your inventory
REM If you bribe a Vendor, all Vendors cease being mad at you

2610 IF O$ <> "B" OR Q3 > 1 THEN PRINT: PRINT "** CHOOSE ONE OF THE LISTED OPTIONS": GOTO 2320
2620 IF TC = 0 THEN PRINT: PRINT "'ALL I WANT IS YOUR LIFE!'" GOTO 2690
2630 Q = FNA(8): IF T(Q) = 0 THEN 2630
2640 PRINT: PRINT "I WANT "; C$(Q + 25); ", WILL YOU GIVE IT TO ME ";
2650 GOSUB 3290: IF O$ = "N" THEN 2690
2660 IF O$ <> "Y" THEN PRINT Y$: GOTO 2640
2670 T(Q) = 0: TC = TC - 1: PRINT: PRINT "OK, JUST DON'T TELL ANYONE"
2680 VF = VF + (PEEK(FND(Z)) = 25): GOTO 620

REM Monster attacks
REM
REM Bribe no longer possible (Q3 = 2)
REM
REM Monster hits on:
REM    If blind: DX < 3d7 + 3
REM    If not blind: DX < 3d7
REM
REM If a monster hits, handle 

2690 Q3 = 2: IF WC > 0 THEN WC = WC - 1: IF WC = 0 THEN PRINT: PRINT "THE WEB JUST BROKE!"
2700 Z$ = RIGHT$(C$(12 + A), LEN(C$(12 + A)) - 2): IF WC <= 0 THEN 2750
2710 PRINT: PRINT "THE "; Z$; "IS STUCK AND CAN'T ATTACK": GOTO 2750
2720 PRINT: PRINT "THE "; Z$; "ATTACKS": IF DX < FNA(7) + FNA(7) + FNA(7) + BL * 3 THEN 2740

2730 PRINT: PRINT "  HAH! HE MISSED YOU": GOTO 2750

REM 2800 Take damage

2740 PRINT: PRINT "  OUCH! HE HIT YOU": Q = Q1: GOSUB 2800: IF ST < 1 THEN 2840
2750 IF O$ <> "R" THEN 2320

REM RETREAT
REM
REM If the user selects Retreat, they automatically succeed

2760 PRINT: PRINT "YOU HAVE ESCAPED": PRINT
2770 PRINT "DO YOU GO NORTH, SOUTH, EAST, OR WEST "; GOSUB 3290
2780 IF (O$ = N) OR (O$ = "S") OR (O$ = "E") OR (O$ = "W") THEN 950
2790 PRINT: PRINT "** DON'T PRESS YOUR LUCK "; R$(RC): PRINT: GOTO 2770

REM Take damage
REM
REM This is used with:
REM    Exploding chests
REM    Monster damage

REM Q is damage
REM
REM AH decreases by Q, clamped at or below AV
REM ST decreases by Q - AV, clamped at or above 0
REM
REM In other words:
REM
REM AH decreases by MIN(Q, AV)
REM ST decreases by MAX(Q - AV, 0)
REM
REM if AH < 0, armor is destroyed
REM if ST < 0, player is killed

2800 IF AV = 0 THEN 2830
2810 Q = Q - AV: AH = AH - AV: IF Q < 0 THEN AH = AH - Q: Q = 0

2820 IF AH < 0 THEN AH = 0: AV = 0: PRINT: PRINT "YOUR ARMOR IS DESTROYED - GOOD LUCK"

2830 ST = ST - Q: RETURN

REM Game Over

2840 FOR Q = 1 TO 750: NEXT Q: PRINT CHR$(12): GOSUB 3270
2850 PRINT "A NOBLE EFFORT, OH FORMERLY LIVING "; R$(RC): PRINT
2860 PRINT "YOU DIED FROM LACK OF ";:IF ST < 1 THEN PRINT "STRENGTH"
2870 IF IQ < 1 THEN PRINT "INTELLIGENCE"
2880 IF DX < 1 THEN PRINT "DEXTERITY"
2890 PRINT: PRINT: Q3 = 1: PRINT "WHEN YOU DIED YOU HAD:": PRINT: GOTO 2970
2900 Q3 = 0: PRINT: PRINT "YOU LEFT THE CASTLE WITH";: IF OF = 0 THEN PRINT "OUT";
2910 PRINT " THE ORB OF ZOT": PRINT: IF OF = 0 THEN 2940

2920 PRINT: PRINT "A GLORIOUS VICTORY!": PRINT
2930 PRINT "YOU ALSO GOT OUT WITH THE FOLLOWING:": PRINT: GOTO 2960

2940 PRINT: PRINT "A LESS THAN AWE-INSPIRING DEFEAT."
2950 PRINT: PRINT "WHEN YOU LEFT THE CASTLE YOU HAD:": PRINT

2960 IF Q3 = 0 THEN PRINT "YOUR MISERABLE LIFE"
2970 FOR Q = 1 TO 8: IF T(Q) = 1 THEN PRINT C$(Q+25)
2980 NEXT Q: PRINT W$(WV+1): PRINT W$(AV+5) : IF LF = 1 THEN PRINT "A LAMP"
2990 PRINT FL; " FLARES": PRINT GP; "GP's": IF RF = 1 THEN PRINT "THE RUNESTAFF"
3000 PRINT: PRINT "AND IT TOOK YOU "; T; " TURNS!": PRINT
3010 PRINT: PRINT: PRINT "PLAY AGAIN ";: GOSUB 3290: PRINT
3020 IF O$ = "Y" THEN PRINT "SOME "; R$(RC); "S NEVER LEARN": PRINT: PRINT: GOTO 80
3030 IF O$ <> "N" THEN THEN PRINT Y$: GOTO 3010
3040 PRINT "MAYBE DUMB "; R$(RC); " NOT SO DUMB AFTER ALL": PRINT: END

REM FOUND THE ORB OF ZOT
REM
REM The Runestaff vanishes

3050 PRINT: PRINT "GREAT UNMITIGATED ZOT!": PRINT
3060 PRINT "YOU JUST FOUND THE ORB OF ZOT!": PRINT
3070 PRINT "THE RUNESTAFF IS GONE": RF = 0: OF = 1: O(1) = 0: GOTO 1420

REM ROOM CONTENTS
REM
REM Value+100 means the room is unexplored
REM
REM  1 - AN EMPTY ROOM, .
REM  2 - THE ENTRANCE, E
REM  3 - STAIRS GOING UP, U
REM  4 - STAIRS GOING DOWN, D
REM  5 - A POOL, P
REM  6 - A CHEST, C
REM  7 - GOLD PIECES, G
REM  8 - FLARES, F
REM  9 - A WARP, W
REM 10 - A SINKHOLE, S
REM 11 - A CRYSTAL ORB, O
REM 12 - A BOOK, B
REM 13 - A KOBOLD, M
REM 14 - AN ORC, M
REM 15 - A WOLF, M
REM 16 - A GOBLIN, M
REM 17 - AN OGRE, M
REM 18 - A TROLL, M
REM 19 - A BEAR, M
REM 20 - A MINOTAUR, M
REM 21 - A GARGOYLE, M
REM 22 - A CHIMERA, M
REM 23 - A BALROG, M
REM 24 - A DRAGON, M
REM 25 - A VENDOR, V
REM 26 - THE RUBY RED, T
REM 27 - THE NORN STORN, T
REM 28 - THE PALE PEARL, T
REM 29 - THE OPAL EYE, T
REM 30 - THE GREEN GEM, T
REM 31 - THE BLUE FLAME, T
REM 32 - THE PALINTIR, T
REM 33 - THE SILMARIL T
REM 34 - X, "?"

REM Treasure numbers in the T() array
REM
REM 1 - THE RUBY RED
REM 2 - THE NORN STORN
REM 3 - THE PALE PEARL
REM 4 - THE OPAL EYE
REM 5 - THE GREEN GEM
REM 6 - THE BLUE FLAME
REM 7 - THE PALINTIR
REM 8 - THE SILMARIL

REM WEAPONS AND ARMOR
REM
REM 1 - NO WEAPON
REM 2 - DAGGER
REM 3 - MACE
REM 4 - SWORD
REM 5 - NO ARMOR
REM 6 - LEATHER
REM 7 - CHAINMAIL
REM 8 - PLATE

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

REM RACES
REM
REM 1 - HOBBIT
REM 2 - ELF
REM 3 - MAN
REM 4 - DWARF

REM Curses in the C() array, first index
REM
REM 1 - Lethargy
REM 2 - Leech
REM 3 - Forgetfullness

3080 DATA AN EMPTY ROOM, ., THE ENTRANCE, E, STAIRS GOING UP, U
3090 DATA STAIRS GOING DOWN, D, A POOL, P, A CHEST, C, GOLD PIECES, G
3100 DATA FLARES, F, A WARP, W, A SINKHOLE, S, A CRYSTAL ORB, O
3110 DATA A BOOK, B, A KOBOLD, M, AN ORC, M, A WOLF, M, A GOBLIN, M, AN OGRE, M
3120 DATA A TROLL, M, A BEAR, M, A MINOTAUR, M, A GARGOYLE, M, A CHIMERA, M
3130 DATA A BALROG, M, A DRAGON, M, A VENDOR, V, THE RUBY RED, T
3140 DATA THE NORN STORN, T, THE PALE PEARL, T, THE OPAL EYE, T
3150 DATA THE GREEN GEM, T, THE BLUE FLAME, T, THE PALINTIR, T, THE SILMARIL
3160 DATA T, X, "?", NO WEAPON, WICH
3170 DATA DAGGER, " STEW", MACE, " SOUP", SWORD, " BURGER", NO ARMOR, " ROAST"
3180 DATA LEATHER, " MUNCHY", CHAINMAIL, " TACO", PLATE, " PIE"
3190 DATA HOBBIT, ELF, MAN, DWARF, T, I, A, L, I, Z, I, N, " ", C, A

REM Set a random, empty, undiscovered room to value Q

3200 X = FNA(8): Y = FNA(8): IF PEEK(FND(Z)) <> 101 THEN 3200
3210 POKE FND(Z), Q: RETURN

REM Defeated a Vendor
REM
REM Player gets:
REM    Plate armor
REM    A sword
REM    A strength potion (Add 1d6 to ST, capped at 18)
REM    An intelligence potion (Add 1d6 to IQ, capped at 18)
REM    A dexterity potion (Add 1d6 to DX, capped at 18)
REM    If the player doesn't have a lamp, they get a lamp

3220 PRINT: PRINT "YOU GET ALL HIS WARES:": PRINT: PRINT "PLATE ARMOR": AV = 3: AH = 21
3230 PRINT "A SWORD": WV = 3: PRINT "A STRENGTH POTION": ST = FNC(ST + FNA(6))
3240 PRINT "AN INTELLIGENCE POTION": IQ = FNC(IQ + FNA(6))
3250 PRINT "A DEXTERITY POTION": DX = FNC(FX + FNA(6)): IF LF = 0 THEN PRINT "A LAMP": LF = 1

REM 2460 "You now get his hoard of..."

3260 GOTO 2460

REM Print a horizontal rule of asterisks

3270 FOR Q = 1 TO 64: PRINT "*";:NEXT Q: PRINT: PRINT: RETURN

REM Ask for a player choice
REM Return the first letter of the choice in O$

3280 PRINT: PRINT "YOUR CHOICE ";
3290 INPUT O$: O$ = LEFT$(O$, 1): RETURN

REM Ask how many points the player wants to add to a stat
REM (value returned in Q)

3300 PRINT "HOW MANY POINTS DO YOU ADD TO "; Z$;: INPUT O$: PRINT
3310 Q = VAL(O$): IF (Q = 0) AND (ASC(O$) <> 48) THEN Q = -1
3320 IF (Q < 0) OR (Q > OT) OR (Q <> INT(Q)) THEN PRINT "** ": GOTO 3300
3330 OT = OT - Q: RETURN

REM Input an integer number
REM Return the number in Q

3340 INPUT O$: Q = INT(VAL(O$)): RETURN

REM Prompt in Z$, input a number between 1-8, inclusive

3350 PRINT: PRINT Z$;: INPUT O$: Q = INT(VAL(O$): IF (Q > 0) AND (Q < 9) THEN RETURN
3360 PRINT: PRINT "** TRY A NUMBER FROM 1 TO 8": GOTO 3350

REM Buy stat potions from Vendor

3370 PRINT: PRINT "WANT TO BUY A POTION OF "; $Z; " FOR 1000 GP's "; GOTO 3290

REM Print out your new stat value

3380 PRINT: PRINT "YOUR "; Z$; " IS NOW "; Q: RETURN

REM Prompt to buy weapons or armor

3390 PRINT "HERE IS A LIST OF "; Z$; "YOU CAN BUY (WITH COST IN <>)": PRINT: RETURN

3400 PRINT "YOU ARE AT ("; X; ","; Y; ") LEVEL "; Z: RETURN
