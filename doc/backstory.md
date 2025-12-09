# The Story of The Wizard's Castle

> _This is reproduced from
> [http://www.armchairarcade.com/neo/node/1381](https://web.archive.org/web/20190305222031/http://www.armchairarcade.com/neo/node/1381)
> and mirrored here in the interest of preserving this bit of computing
> history._

Wed, 06/27/2007 - 12:23pm — Matt Barton

One of the great things about writing a book is that you get to hear so
many interesting stories. One of the best I've heard so far involves a
very, very early game for the Exidy Sorcerer named The Wizard's Castle.
Although programmed by Joe Power a few years earlier (in the mid 1970s),
the game wasn't officially released until 1980, when it was printed as
source code in Recreational Computing magazine. It's been ported to
several other platforms (by Power and others). Eventually it was played
by Derell L., who prefers to go by his nickname "Derelict." Derelict
converted the game for Windows and added sprite-based graphics (you can
download it here). Anyway, I had the chance to talk to both Joe and
Derelict about their games, and have decided to print them here for your
enjoyment! Note that I haven't edited these interviews--I didn't have
to!

First, Joe:

> The year was 1975. I was a freshman at Michigan State University and I
> tagged along with some friends going to the Windycon science fiction
> convention in Chicago. Someone on the con committee had arranged to
> have some remote terminals tied into some college's time-share system
> upon which you could run a primitive version of Star Trek and another,
> very similar game with a fantasy motif (called HOBBIT). These were
> printing terminals, not CRTs (the ADM-3a was still about a year and a
> half away at that point.)
> 
> I found the game intriguing and, when someone managed to break the
> game I managed to get a listing of it while trying to restart it.
> 
> Up to that point I'd only learned FORTRAN IV in a batch processing
> environment and the program was written in a dialect of HP BASIC (1
> letter variable names, 1-dimensional arrays only, if statements could
> only branch, etc.) Even so, I could figure out enough of the code to
> realize that whoever had written it must have simply sat down at a
> terminal and started banging away - it was a horrible pile of
> spaghetti code.
> 
> That summer I happened to be near a Radio Shack that sold the TRS-80s
> which had just come out. The owner had a model 1 (4K of RAM, integer
> basic, 300baud cassette tape storage) available for demonstration /
> experimentation. I bought a book on TRS-80 Basic and taught myself
> enough to write my own version of HOBBIT. It was a much cleaner
> version of the code and played roughly the same as the one I'd played.
> Several of the other nerds hanging out at the store that summer played
> it a lot and enjoyed it and the store owner often used it to show off
> what could be done with even the entry-level machine. I, however,
> wasn't satisfied with it.
> 
> The problem, for me, was that there simply weren't enough ways to
> interact with the program and it became repetitive - wander around,
> kill monsters, get treasures, lather, rinse, repeat. By then I was
> playing Dungeons & Dragons (the original 3 book set and the Greyhawk
> supplement) so I was used to a much richer game experience.
> 
> I decided to re-write the game from scratch. I thought about what
> extra features I would put in the game and ended up with everything
> you see in Wizard's Castle plus one big section that I pulled from the
> final version (originally, you could buy a shovel from a merchant and
> use it to bury some or all of your possessions. Later you could dig
> them up. There were monsters that stole things from you to give you a
> reason to do this. The amount of code needed to implement this was so
> large I decided it wasn't cost effective and eliminated it.)
> 
> Michigan State was still almost entirely a batch-only environment
> (heck, there were punch card vending machines in the computer center!)
> and any microcomputer of the time large enough to run what I had in
> mind cost a small fortune and had to be assembled by the user. As a
> consequence, I decided to write the program in a pascal/basic/english
> hybrid pseudo-code figuring I'd convert it to whatever specific
> language I would eventually have access to.
> 
> Long about then a few fellows got together and opened up a computer
> store in East Lansing. At the time there were still not that many
> microcomputers for sale and, like so many of the early computer
> stores, New Dimensions in Computing sold more magazines (Byte,
> Kilobaud, Creative Computing, etc.) and books than anything else. They
> didn't have enough capitalization to satisfy Apple's requirements to
> be an authorized dealer, but they did have Northstar systems for small
> businesses and the Exidy Sorcerer for home use.
> 
> I was friends with a couple of the owners and they didn't mind if I
> played with their 16K demo machine when it wasn't in use. (By the way,
> the "Kingdom of N'dic" was a nod to them for their kindness.)
> 
> I converted my pseudo-code into Sorcerer Basic (which was the cheaper
> version of Microsoft's flagship product at that time) and started
> typing it in. Naturally I discovered that the program wouldn't fit in
> the machine! I threw out all the comments, looked for common code
> fragments I could turn into ugly subroutines, tightened up the code
> overall and - most significantly - I used the Sorcerer's
> user-definable character memory instead of a Basic array to hold the
> castle array.
> 
> (The Exidy Sorcerer's characters were 8x8 bits and the top 128
> character shape definitions were stored in a specific RAM location.
> This made the Sorcerer nearly ideal for displaying foreign character
> sets and - because changing the shape definition of a character
> changed EVERY instance of that character on the screen in a single
> refresh - made it a natural for games like Space Invaders, Pacman,
> etc. Of course, if you didn't happen to use any user-definable
> characters then the memory was available for other purposes. This fact
> will become important in a bit.)
> 
> Eventually the guys took pity on me and increased the memory in the
> demo model to 24K. Between that and my code squeezing Wizard's Castle
> finally fit. I corrected a few obvious flaws and then sat back and
> watched others play it, making notes and fixing bugs as needed. I
> continued to compress the code because I really wanted it to fit in
> 16K (which was the standard amount of memory the Sorcerer came with.)
> 
> I'm still somewhat amazed the store owners didn't banish the program
> (and me) as they seemed to get a steady stream of people wanting to
> play it (though I know of at least two systems sold because kids who'd
> been playing it dragged their parents in!)
> 
> Right about the time I finished polishing the code there was an
> announcement in Kilobaud magazine that they were starting up a
> software division and were actively seeking programs for the Exidy
> Sorcerer. Seeing visions of megabucks dancing before my eyes, I
> decided to submit Wizard's Castle but I needed to write documentation
> for it. I did this and sent both program and user manual in and waited
> to hear back from them.
> 
> Before too long I got a call indicating they really wanted to sell my
> program. We went over a few things and one of the questions they asked
> was "could I put any user-defined graphics in it?" as they had heard
> that this was one of the big features of the Sorcerer. I explained
> that in order to make the program fit in 16K I had to use the graphics
> memory for another purpose. "No problem" they said. "We really want to
> get it out by Christmas." A contract soon arrived and I thought all
> was well.
> 
> Days turned into weeks turned into a couple months and I'd heard
> nothing from them. Finally I was able to get through to the person
> who'd taken over for the person who'd replaced the person with whom
> I'd talked. He looked at my file and told me there was a hold on doing
> anything with the program until they found out if I could put any
> user-defined graphics in. Grrrr... I explained that I'd answered that
> question and did so again.
> 
> By then, of course, it was too late to make the Christmas season and a
> few months afterwards it became clear that they were getting out of
> the Sorcerer market altogether. We mutually revoked the contract.
> Although I wasn't all that devastated I wasn't going to rake in the
> big bucks from it, it seemed a shame to just let Wizard's Castle die
> and when Recreational Computing magazine announced they were going to
> do a fantasy game issue I submitted a listing and the documentation
> I'd written. They printed it in their July/August 1980 issue. (There
> were a couple other articles with comparably sized programs listed as
> well.)
> 
> As I mentioned in the article, by then the program had been ported to
> several other systems. A small local software company sold a few of
> the TRS-80 ports and I later ported it to the Apple II for a friend of
> mine. Eventually there was a port to the Heath H8 and other CP/M
> systems. It was one of these that was reviewed in the first Whole
> Earth Software Catalog. Since then I've seen a version for the TI-83
> and, of course, there was the nice version with the graphic tiles you
> mentioned.
> 
> Time has certainly passed it by, but Wizard's Castle seems to have
> been enjoyed by quite a few people. I learned a lot and had a lot of
> fun writing it. It appears to have influenced some subsequent games
> just as it was influenced by what came before it. Really, how much
> more can you ask of a game?
> 
> You asked about the gaming context in which I wrote Wizard's Castle.
> The town I grew up in was too small to support a wargaming culture so
> almost all of my gaming interest went into chess. When I got to
> college I encountered SPI and AH games and then D&D. Tunnels & Trolls
> never really caught on, but Runequest was a vastly more sensible game
> system to pirate mechanics from (by then we were almost all "rolling
> our own" rules.) I got hooked on some of the microgames (Ogre and
> WarpWar.) In fact, I liked WarpWar so much I attempted to adapt its
> combat system for Wizard's Castle - boy did that not work out!
> 
> Almost all the computer games available at the time I was writing
> Wizard's Castle were either small Basic programs, arcade-style games
> or stripped down Adventure clones. I tried Wizardry a few years after
> and liked the idea of a rat's eye view maze (even though I have no
> sense of direction and kept getting lost) but the game was s-l-o-w.
> After I graduated from college and started working I bought my own
> Sorcerer and wrote a few arcade games in Basic (including a wholly
> original one that, even though only a handfull of people ever saw it,
> I was as proud of as I was of Wizard's Castle.)
> 
> I think I'll stop here for now and let you figure out what I missed
> and what follow-up questions you'd like to ask. 

Now, Derelict!

> Well, I was an engineering student at Calpoly SLO, from 1982-1986.
> Sometime in 1985, a fellow student of mine got himself a PC (which was
> quite an accomplishment for a student, back in those days!!). He had a
> copy of the BASIC version of the game on his PC, but I don't know
> where he actually got it from. I was ENTHRALLED with the game, and
> spent hours playing it; at first he had to keep chasing me off his
> machine so he could do homework. Then, once I started working on my
> senior project, I had access to a PC in the engineering lab, and
> continued playing there. The really annoying things were dealing with
> the map; the fact that M had to be used every few steps, and every
> time you entered another room you had to spend six keystrokes just
> looking into adjacent rooms. So my goal was to re-write it as a
> full-screen interactive program which *always* had the map displayed,
> and I wanted to make the interface keystroke-active (i.e., I didn't
> want to repeatedly have to hit Enter).
>
> After I graduated from Calpoly in '86, I took a class in Pascal at a
> local junior college. The reason that I did this was that Borland had
> just revolutionized the programming world by introducing a $35 Pascal
> compiler, with an integrated editor!! This is why there was an
> explosion of games and other utilities around that time; before Turbo
> Pascal, compilers for any language started at $400 and went up fast!!
> So, I spent some time converting Wizard's Castle to Turbo Pascal, but
> unfortunately there weren't really any good ways of distributing
> software widely in those pre-internet days, and I ended up putting it
> on the shelf for years. I took occasional stabs at converting it to C,
> but it was sooooo much work that I kept putting it off until recently,
> when I finally got motivated enough to put in the several weeks of
> work that led to the current released form.
> 
> In terms of releasing it for free, vs shareware or some such, there
> were several issues that led to that decision:
> 
> 1. it's *alot* of work to manage a shareware program; if you don't put
>    in mechanisms to coerce people to donate, they won't, except for an
>    occasional token offering. And I *really* didn't feel like putting
>    alot of work into an effort that likely wouldn't have returned a
>    significant amount of money in any case.
> 
> 2. The original software that I derived it from was freeware; I would
>    have felt like a real curmudgeon if I'd charged for the derivative
>    work!!
> 
> 3. Wizard's Castle is, in a sense, one of the precursors of the vast
>    genre of Rogue-like games; these have traditionally been freeware
>    games, and in fact some of the greatest games that I've ever played
>    were the roguelikes, including Hack (later Nethack), Omega and
>    Angband. It would have been a violation of that tradition for me to
>    do otherwise...
> 
> In terms of other games, I didn't really play anything other that WC,
> Rogue, and later the other roguelikes, until the better graphics-based
> games came out much later. I never was very inspired by the
> text-adventures; I played most of Colossal Cave, and a little of Zork
> I, but got *very* tired of mapping, and ultimately passed on that
> genre. In terms of later graphics games, I most loved Ultima
> Underworld I/II, the Eye of the Beholder series, Ultima 4, Might &
> Magic 3-6 (didn't like 7 and later nearly as much). I played most of
> the "Gold Box" games from SSI, but mostly because there wasn't much
> else available; I found the endless random battles so annoying that I
> frequently considered just deleting them before I even finished!! More
> recently, I've been a GREAT fan of the Baldur's Gate series
> (especially with the magnificent user mods), and DeusEx.
>
> BTW, After I released the Windows version of Wizard's Castle, I got a
> brief email from Joseph Power, the author of the original game. I
> tried replying to him, but never heard anything further. I'm enclosing
> a copy of his email in this message in case you're interested; it has
> a little history of the original game, which you won't find anywhere
> else.
> 
> Good luck on your book!! (BTW, if you do include any of my emails or
> other data in your book, *please* do NOT include my email address!! I
> get more than enough spam already...) 

All in all, great stuff, and hopefully interesting reading for anyone
interested in CRPGs, game development, and retro stuff.
