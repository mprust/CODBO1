#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
    Killcam Shax for BO1 created by Antiga.

    On Spawn, call:
        self.isNotShaxWeapon = true;
        self.shineShaxGunCheck = 0;
        self.shaxTakeaway = 0;
        self.shaxbindnum = 0;
        self.shaxDPAD = "[{UNBOUND}]";
        self.shaxCycle = 0;
        self.shaxGun = "Undefined";
        self.primaryCWeapon can be defined as your primary.
        self.secondaryCWeapon can be dined as your secondary.

    Functions:
    - cycleShaxBind allows for DPAD Cyling.
    - selectShaxWeapon cycles through the list of shaxable weapons.
    - All other functions are working in conjuction with one another.


*/    

cycleShaxBind()
{
	self notify("stopShineShax");
	if(self.shaxbindnum == 0)
	{
		self.shaxbindnum = 1;
		self.shaxDPAD = "[{+actionslot 1}]";
		self thread doShaxBindTest();
	}
	else if(self.shaxbindnum == 1)
	{
		self.shaxbindnum = 2;
		self.shaxDPAD = "[{+actionslot 2}]";
		self thread doShaxBindTest();
	}
	else if(self.shaxbindnum == 2)
	{
		self.shaxbindnum = 3;
		self.shaxDPAD = "[{+actionslot 3}]";
		self thread doShaxBindTest();
	}
	else if(self.shaxbindnum == 3)
	{
		self.shaxbindnum = 4;
		self.shaxDPAD = "[{+actionslot 4}]";
		self thread doShaxBindTest();
	}
	else if(self.shaxbindnum == 4)
	{
		self.shaxbindnum = 0;
		self.shaxDPAD = "[{UNBOUND}]";
        self notify("stopShineShax");
	}
}

doShaxBindTest()
{
    self endon("stopShineShax");
    for(;;)
    {
        if(self.menuOpen == false)
        {
            if(self.shaxbindnum == 1)
            {
                if (self ActionSlotOneButtonPressed())
                {
                    self thread shaxKillcam();
                }
            }
            else if(self.shaxbindnum == 2)
            {
                if (self ActionSlotTwoButtonPressed())
                {
                    self thread shaxKillcam();
                }
            }
            else if(self.shaxbindnum == 3)
            {
                if (self ActionSlotThreeButtonPressed())
                {
                    self thread shaxKillcam();
                }
            }
            else if(self.shaxbindnum == 4)
            {
                if (self ActionSlotFourButtonPressed())
                {
                    self thread shaxKillcam();
                }
            }
        }
        wait 0.05;
    }
}

selectShaxWeapon()
{
    if(self.shaxCycle == 0)
    {
        self.shaxCycle = 1;
        self.shaxGun = "skorpion_mp";
    }
    else if(self.shaxCycle == 1)
    {
        self.shaxCycle = 2;
        self.shaxGun = "mac11_mp";
    }
    else if(self.shaxCycle == 2)
    {
        self.shaxCycle = 3;
        self.shaxGun = "kiparis_mp";
    }
    else if(self.shaxCycle == 3)
    {
        self.shaxCycle = 4;
        self.shaxGun = "mpl_mp";
    }
    else if(self.shaxCycle == 4)
    {
        self.shaxCycle = 5;
        self.shaxGun = "stoner63_mp";
    }
    else if(self.shaxCycle == 5)
    {
        self.shaxCycle = 6;
        self.shaxGun = "fnfal_mp";
    }
    else if(self.shaxCycle == 6)
    {
        self.shaxCycle = 0;
        self.shaxGun = "Undefined";
    }
}

shaxKCCheck()
{
    self.isNotShaxWeapon = false;
    if(isSubStr(self.shaxGun, "skorpion"))
    {
        self.shineShaxGunCheck = 1.1;
        self.shaxTakeaway = 0.25;
    }
    else if(isSubStr(self.shaxGun, "mac11"))
    {
        self.shineShaxGunCheck = 0.92;
        self.shaxTakeaway = 0.30;
    }
    else if(isSubStr(self.shaxGun, "kiparis"))
    {
        self.shineShaxGunCheck = 0.80;
        self.shaxTakeaway = 0.35;
    }
    else if(isSubStr(self.shaxGun, "mpl"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.25;
    }
    else if(isSubStr(self.shaxGun, "stoner63"))
    {
        self.shineShaxGunCheck = 1.30;
        self.shaxTakeaway = 0.40;
    }
    else if(isSubStr(self.shaxGun, "fnfal"))
    {
        self.shineShaxGunCheck = 1.08;
        self.shaxTakeaway = 0.30;
    }
    else
    {
        self.isNotShaxWeapon = true;
        self.shineShaxGunCheck = 0;
        self.shaxTakeaway = 0;
    }
}

doStaticScreen()
{
	self.staticScreeen = newclienthudelem( self );
	self.staticScreeen.x = 0;
	self.staticScreeen.y = 0; 
	self.staticScreeen.horzAlign = "fullscreen";
	self.staticScreeen.vertAlign = "fullscreen";
	self.staticScreeen.foreground = false;
	self.staticScreeen.hidewhendead = false;
	self.staticScreeen.hidewheninmenu = false;
	self.staticScreeen.sort = 0; 
	self.staticScreeen SetShader( "tow_filter_overlay_no_signal", 640, 480 ); 
	self.staticScreeen.alpha = 1;
    self playSound("wpn_strela_fire_plr");
    wait self.shineShaxGunCheck;
    self.staticScreeen destroy();
}

shaxKillcam()
{
    self thread shaxKCCheck();
    self thread doStaticScreen();
    self giveweapon(self.shaxGun);
    self switchToWeapon(self.shaxGun);
    self setWeaponAmmoClip(self.shaxGun, 0);
    doIt = self getWeaponAmmoStock(self.shaxGun);
    wait 0.05;
    self setSpawnWeapon(self.shaxGun);
    wait self.shineShaxGunCheck;
    self setWeaponAmmoStock(self.shaxGun, doIt);
    wait self.shaxTakeaway;
    self takeweapon(self.shaxGun);
    wait 0.05;
    self switchToWeapon(self.primaryCWeapon);
    self setSpawnWeapon(self.primaryCWeapon);
    wait 0.05;
    self switchToWeapon(self.secondaryCWeapon);
    wait 0.05;
    self switchToWeapon(self.primaryCWeapon);
}
