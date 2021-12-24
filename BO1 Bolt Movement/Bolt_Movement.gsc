#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/* 
    Converted Sass's Bolt Movement on MW2 to BO1. Partial credits to Antiga for conversion.

    - On connect, call: self.pers["poscount"] = 0;
    - On spawn, call: self.boltSpeed = 5;

    Function Set:
    - cycleBolt allows you to go through DPAD UP - DPAD RIGHT.
    - saveBoltPos saves Bolt Movement points.
    - DeleteBoltPos deletes Bolt Movement points.
    - WatchJumping monitors a button press to exit before Bolt Movement completion.
    - BoltSpeed allows for adjustment of speed.
        - use case in menu: ::boltspeed, 0.5, true) adds
        - use case in menu: ::boltspeed, 0.5) subtracts

*/

waitFrame()
{
    wait 0.05;
}

cycleBolt()
{
	self notify("stopBolting");
	if(self.bmNum == 0)
	{
		self.bmNum = 1;
		self.bmAction = "[{+actionslot 1}]";
		self thread doBoltBind();
	}
	else if(self.bmNum == 1)
	{
		self.bmNum = 2;
		self.bmAction = "[{+actionslot 2}]";
		self thread doBoltBind();
	}
	else if(self.bmNum == 2)
	{
		self.bmNum = 3;
		self.bmAction = "[{+actionslot 3}]";
		self thread doBoltBind();
	}
	else if(self.bmNum == 3)
	{
		self.bmNum = 4;
		self.bmAction = "[{+actionslot 4}]";
		self thread doBoltBind();
	}
	else if(self.bmNum == 4)
	{
		self.bmNum = 0;
		self.bmAction = "[{UNBOUND}]";
        self notify("stopBolting");
	}
}

doBoltBind()
{
    self endon("stopBolting");
    for(;;)
    {
        if(self.bmNum == 1)
        {
            if (self ActionSlotOneButtonPressed())
            {
                self thread BoltStart();
            }
        }
        else if(self.bmNum == 2)
        {
            if (self ActionSlotTwoButtonPressed())
            {
                self thread BoltStart();
            }
        }
        else if(self.bmNum == 3)
        {
            if (self ActionSlotThreeButtonPressed())
            {
                self thread BoltStart();
            }
        }
        else if(self.bmNum == 4)
        {
            if (self ActionSlotFourButtonPressed())
            {
                self thread BoltStart();
            }
        }
        waitframe();
    }
}

saveBoltPos()
{
    self.pers["poscount"] += 1;
    self.pers["boltorigin"][self.pers["poscount"]] = self GetOrigin();
    self iPrintLn("Position ^2#" + self.pers["poscount"] + " ^7saved: " + self.origin);
}

DeleteBoltPos()
{
    if(self.pers["poscount"] == 0)
    {
        self iPrintLn("^1There are no points to delete");
    }
    else
    {
        self.pers["boltorigin"][self.pers["poscount"]] = undefined;
        self iPrintLn("Position ^2#" + self.pers["poscount"] + " ^7deleted");
        self.pers["poscount"] -= 1;
    }
}

BoltStart()
{
    self endon("detachBolt");
    self endon("disconnect");
    if(!self.MenuOpen && self.isBolting == false)
    {
        if(self.pers["poscount"] == 0)
        {
            self iPrintLn("^1There aren't any points to move to...");
        }
        boltModel = spawn("script_model", self.origin);
        boltModel setModel("tag_origin");
        self.isBolting = true;
        setDvar("cg_nopredict", 1); //Allows for ADS
        waitframe();
        self linkTo(boltModel);
        self thread WatchJumping(boltModel);

        for(i=1 ; i < self.pers["poscount"] + 1 ; i++)
        {
            boltModel moveTo(self.pers["boltorigin"][i],self.boltSpeed/ self.pers["poscount"], 0, 0);
            wait(self.boltSpeed / self.pers["poscount"]);
        }
        self unlink();
        boltModel delete();
        self.isBolting = false;
        setDvar("cg_nopredict", 0);
    }
}

WatchJumping(model)
{
	self endon("disconnect");
	if(self JumpButtonPressed())
    {
        self Unlink();
        model delete();
        self.isBolting = false;
        setDvar("cg_nopredict", 0);
    }
}

BoltSpeed(amount, speed)
{
	value = self.boltSpeed;
	if(isDefined(speed))
	{
		value = value + amount;
		self.boltSpeed = value;
	}	
	else
	{
		value = value - amount;
		self.boltSpeed = value;
	}
	self iPrintLn("Bolt Speed Changed To: ^2" + value);
}