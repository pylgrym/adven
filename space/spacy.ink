
->sleep_cabin_alarm
->cockpit

VAR bridge_alarm_count=0
==sleep_cabin_alarm
~bridge_alarm_count = bridge_alarm_count+1
You are groggy. 
{sleep_cabin_alarm<2:
     You have just awoken aboard your trusty old spaceship, the "SS/Derelict", to the sound of glaring alarms and flashing red lights. 
}
You are in the sleeping quarters.
A door leads to the bridge. 
{bridge_alarm_count>2: ->explode}
+ [GO BRIDGE] -> bridge_alarm

==bridge_alarm
ALARM:{bridge_alarm_count}
You are on  the bridge. Red lights flash. There is a command control console here. There is an escape pod here.
{bridge_alarm_count>2: ->explode}
+ EXAMINE CONSOLE [] You gather from the ship status information that the engine fusion reactor core has been breached, and that an explosion is imminent. 
~bridge_alarm_count = bridge_alarm_count+1
    ->bridge_alarm
You can see that you are in orbit around a planet, and strangely, it appears there is another spaceship in a nearby orbit.
+ GO ESCAPE POD ->escape_pod
+ [GO SLEEP CABIN] -> sleep_cabin_alarm


==explode
Remaining aboard your ship appears to have been an unwise choice. 
You briefly sensed a flash of light and immense heat behind you. You never sensed anything further. ->END
    

==escape_pod
You are in an escape pod, which just launched itself from your spaceship. Some distance away, you see your old spaceship explode. What now?
+ GO SURFACE [] Your puny escape pod was never meant for atmospheric navigation. It quickly disintegrates and burns up in the corrosive atmosphere of this planet. Out of loyalty, you choose to share its fate. ->END
+ GO SPACESHIP [] You plot a course to the alien spaceship. After an uneventful flight, you reach the unknown ship, and dock with its air lock. ->dock

==dock
+ GO AIRLOCK [] You notice your escape pod was almost out of oxygen. You feel scarily lucky to have reached this spaceship in time. ->cockpit












==cockpit
VAR engine_repaired=false
VAR window=false
VAR shutter_gone=false
VAR first_rotate=true
VAR rotate=0
{cockpit<2:You arrive inside what appears to be the cockpit of the ship. But noone is here. }
Cockpit. 
There is a command console here.
There is a window here. 
{not lounge: A door leads to the lounge.}

{killed_vampire: The dead humanoid lies here.}

{shutter_gone and rotate==2: A faint glow shines from the window.}

VAR got_key=false
 + {not got_key and killed_vampire}[EXAMINE POCKETS] 
   ~ got_key=true
   You find a magnetic key card in his pockets.->cockpit 

 + [START ENGINE]
 {not engine_repaired: The engine appears to be broken. It has blown at least one fuse. Looks like you will have to repair it somehow. ->cockpit }
 {engine_repaired: You hear the engine humming. Plot a course! ->win }
 
 + {not window}[EXAMINE WINDOW] 
   ~ window=true
   The window is shuttered.->cockpit 
   
 + {window and not shutter_gone}[REMOVE SHUTTERS] 
   ~ shutter_gone=true
   You remove the shutters.->cockpit 
 
 + {shutter_gone}[LOOK WINDOW] 
{ rotate:
- 0: The rather large planet you are orbiting is clearly visible outside.
- 1: Outside the window, the andromeda galaxy is faintly visible.
- 2: you see a bright half-full moon clearly shining directly outside the window.
- 3: You see a number of star constellations in view from the window.
}
->cockpit 

 + [ROTATE SHIP] 
{first_rotate:it appears the small steering thrusters still work, and can be operated from the console.} 
    ~first_rotate=false
    ~rotate= (rotate+1)%4
    You rotate the ship slightly.
->cockpit 

 
 + [GO LOUNGE - AFT]->lounge


==win
YOU HAVE WON, CONGRATULATIONS! ->END





==cockpit_rat  
Cockpit. 
There is a command console here.
There is a window here. 
It seems the blood from the rat has attracted the humanoid.
He is suddenly coming towards you, with a wild stare in his bloodshot eyes.
{not got_stake: -> killed_by_vampire}

VAR killed_vampire=false

+ {got_stake and not killed_vampire} [USE STAKE ON HUMANOID] With all your strength, you swing the stake in a wild arc towards the humanoid. 

{rotate==2 and shutter_gone:
    Your initiative is sound in principle, and the moonlight from the open window appears to have weakened him significantly. You have killed him!
    ~ killed_vampire=true
    -> cockpit
-else:
    Your initiative is sound in principle, but he is simply too strong for you to handle. -> killed_by_vampire
}
hello ->END
 










==lounge
VAR fuse=false
VAR hammer=false
VAR cabinet=false
VAR crucifix=false
VAR make_stake=false
VAR got_stake=false
VAR mousetrap=false
{lounge<2: This appears to be the lounge of the ship.}
Lounge.


{ set_mousetrap and not caught_rat:
 ~ caught_rat=true 
 You hear a tiny scream from one of the other rooms.
}

{not hammer: There is a hammer here, possibly in a cabinet}
 + {not hammer}[GET HAMMER] You pick up the hammer.
 ~hammer=true 
 ->lounge
 
{not fuse: There is a fuse here, possibly in a cabinet}
 + {not fuse}[GET FUSE] You pick up the fuse.
 ~fuse=true 
 ->lounge

{not cabinet: There is a wooden book cabinet here.}
 + {not cabinet}[EXAMINE CABINET] 
 ~cabinet=true 
 It contains a strange and varied selection of books. 
 You see an encyclopedia, a muslim Quran, and also a crucifix and a mouse trap. ->lounge 
 

+ {cabinet} [EXAMINE ENCYCLOPEDIA] 
  It appears to be very old. Under V, you read about "...Bloodsucking creatures, which can apparently be killed by driving a sharp object through their heart, and weakened (but not killed) with silver, garlic, strong sunlight, and with symbols that are holy to them. They are uniquely fixated on blood, and can detect the smell of blood across vast distances, even in Canada."
->lounge

+{not crucifix and cabinet} [GET CRUCIFIX] You pick up the crucifix.
 ~crucifix=true 
 ->lounge
 
+{not mousetrap and cabinet} [GET MOUSETRAP] You pick up the mousetrap.
 ~mousetrap=true 
 ->lounge
  
 + {hammer and not make_stake} [HIT CABINET WITH HAMMER] 
     ~make_stake=true
    With all your strength, you swing the hammer in a wild arc towards the cabinet. You damage the shelf and dislodge a long wedge of wood. -> lounge
    
 + {make_stake and not got_stake} [GET WOOD STAKE] 
    ~ got_stake=true
    You pick up the wooden stake. -> lounge
    
 + [GO SLEEPING QUARTERS, AFT] ->sleepquarters
 +{not got_rat or killed_vampire} [GO COCKPIT - FORE]->cockpit
 +{ got_rat and not killed_vampire} [GO COCKPIT - FORE]->cockpit_rat






==sleepquarters
VAR engine_locked = true
VAR pod_examined = false
VAR human_examined = false
VAR set_mousetrap = false
VAR caught_rat=false

{sleepquarters<2: This appears to be the sleeping quarters of the ship.}
Sleeping Quarters.

{not pod_examined: There is a sleep pod here.}

{pod_examined and not killed_vampire: There is a sleeping humanoid here.}
{caught_rat and not got_rat: There is a dead rat here, all bloody.}

+ {human_examined and not killed_vampire} [EXAMINE POCKET] You fumble with his pockets. -> killed_by_vampire 

+ {not pod_examined}[EXAMINE SLEEP POD]
  ~pod_examined=true
  There is a humanoid asleep inside it. ->sleepquarters
  
+ {pod_examined and not killed_vampire}[EXAMINE HUMANOID]
  ~human_examined=true
  He is profoundly asleep. He has unusually sharp and pointy canine teeth. You notice something bulging in his breast pocket. ->sleepquarters
  
+ {pod_examined and not killed_vampire}[WAKE HUMANOID] You try to wake him up by shaking him. -> killed_by_vampire

+ {hammer and not killed_vampire}[HIT HUMANOID WITH HAMMER ] With all your strength, you swing the hammer in a wild arc towards the humanoid. -> killed_by_vampire

+ {crucifix and not killed_vampire}[USE CRUCIFIX ON HUMANOID] With all your strength, you swing the crucifix in a wild arc towards the humanoid. It does not appear to impress him at all. -> killed_by_vampire

+ {got_stake and not killed_vampire}[USE STAKE ON HUMANOID] With all your strength, you swing the stake in a wild arc towards the humanoid. Your initiative is sound in principle, but he is simply too strong for you to handle. -> killed_by_vampire


+ {hammer}[HIT DOOR WITH HAMMER] With all your strength, you swing the hammer in a wide arc at the door. The rebound hurts wildly in your arm and shoulder, but not a scratch on the very robust door. You congratulate the ship builders on their craftmanship, while cursing.
    -> sleepquarters
    
+ {mousetrap and not set_mousetrap}[SET MOUSETRAP] 
    ~set_mousetrap=true
  You set the mousetrap.->sleepquarters

VAR got_rat=false  
+ {caught_rat and not got_rat}[GET RAT] 
    ~got_rat=true
  ->sleepquarters
  
+ {got_key and engine_locked} [UNLOCK DOOR]
    ~engine_locked=false 
    The door mechanism hums, you hear a click - the doors can now be opened! -> sleepquarters

+ [GO LOUNGE - FORE]->lounge
+ [GO ENGINE ROOM - AFT] 
  {engine_locked: The engine room door appears to be locked. There is an electronic card-reader near the handle. ->sleepquarters}
  {not engine_locked: ->engineroom}


==engineroom
Engine Room.
 + [GO SLEEPING QUARTERS - FORE]->sleepquarters

+ {fuse and not engine_repaired} [USE FUSE ON ENGINE] You swap the faulty fuse on the engine with your spare. You see various red lights switch to green. You hear a faint buzzing sound appearing.
    ~engine_repaired=true
    -> engineroom


==killed_by_vampire
Suddenly he appears wide awake, with strange staring
intense eyes. The last you register is him biting
into your neck, grasping you with superhuman strength.
  ->END








==spaceship
We do not want to sharpen the stake.
We do not want to cut ourselves with knife.
Rummy. Bulkhead.->END