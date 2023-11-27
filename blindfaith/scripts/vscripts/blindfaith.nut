Msg("dont blink\n");

IncludeScript("rulescript_base", this)
IncludeScript("response_testbed", null)

HasSpawnedRain <- 0

DirectorOptions <-
{
    ZombieSpawnInFog = true
	cm_DominatorLimit = 6
	cm_AutoReviveFromSpecialIncap = 1
	
	
	
	
	DefaultItems =
	[
		"smg",
		"pistol",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
}

Settings <-
{
	low_particles = 0
	remove_fire = 0
	speak_lines = 1
	change_witch = 1
}

function StoreSettings()
{
			local sData = "{";

			foreach (key, val in Settings)
			{
				switch (typeof val)
				{
				case "string":
					sData = format("%s\n\t%s = \"%s\"", sData, key, val);
					break;
				
				case "float":
					sData = format("%s\n\t%s = %f", sData, key, val);
					break;
				
				case "integer":
				case "bool":
					sData = sData + "\n\t" + key + " = " + val;
					break;
				}
			}

			sData = sData + "\n}";
			StringToFile("blindfaith/settings.nut", sData);
}

function SetSettings()
{
		local tData;
		if (tData = FileToString("blindfaith/settings.nut"))
		{
			try
      {
				tData = compilestring("return " + tData)();

				foreach (key, val in Settings)
				{
					if (tData.rawin(key))
					{
						Settings[key] = tData[key];
					}
				}
			}
			catch (exception)
      {
				print("come on now " + exception + "\n");
        printl("stuff aint workin")
			}
		}
}
SetSettings()
StoreSettings()

	worldspawn <- Entities.FindByClassname (null, "worldspawn");
    worldspawn.__KeyValueFromString("skyname", "sky_l4d_c4m4_hdr")
	if(Settings.change_witch == 1)
	{
    worldspawn.__KeyValueFromString("timeofday", "0")
	}

function OnGameplayStart()
{
    RegFog()
    for (local sun; sun = Entities.FindByClassname(sun, "env_sun"); )
    {
        sun.Kill()
    }
    for (local wind; wind = Entities.FindByClassname(wind, "env_wind"); )
    {
        wind.Kill()
    }
    for (local fog; fog = Entities.FindByClassname(fog, "env_fog_controller"); )
    {
        NetProps.SetPropString(fog, "m_fog.colorPrimary", "10 10 10")
    }
    for (local fire; fire = Entities.FindByClassname(fire, "env_fire"); )
    {
		if(Settings.remove_fire == 1)
		{
        fire.Kill()
		}
    }
    for (local colour; colour = Entities.FindByClassname(colour, "color_correction"); )
    {
        if(colour.GetName() != "colorcorrection_checkpoint")
        {
        NetProps.SetPropString(colour, "m_netlookupFilename", "materials/correction/cc_c4_return.raw")
        }
    }
    for (local rain; rain = Entities.FindByClassname(rain, "func_precipitation"); )
    {
        NetProps.SetPropInt(rain, "m_nPrecipType", 6)
    }

if(Director.GetMapName() != "c4m3_sugarmill_b" && Director.GetMapName() != "c4m4_milltown_b" && Director.GetMapName() != "c4m5_milltown_escape" && Director.GetMapName() != "c6m1_riverbank")
{
StartSpawningShit()
EntFire("sound_mainrain", "Stopsound", "", 0, null)
EntFire("sound_mainrain", "ToggleSound", "", 0, null)
}
}

function StormFog()
{
   director_force_panic_event;
   Convars.SetValue( "cl_drawhud", "0");
   Convars.SetValue( "r_flashlightfar", "133"); 
   Convars.SetValue( "fog_override", "1");
   Convars.SetValue( "fog_start", "-1000");
   Convars.SetValue( "fog_end", "250");
   Convars.SetValue( "fog_color", "0 0 0");
   Convars.SetValue( "fog_colorskybox", "0 0 0");
   EntFire("chch_rain", "alpha", "400", 0, null);
   director_force_panic_event
}

function RegFog()
{
   Convars.SetValue( "cl_drawhud", "1");
   Convars.SetValue( "r_flashlightfar", "400"); 
   Convars.SetValue( "fog_override", "1");
   Convars.SetValue( "fog_start", "-512");
   Convars.SetValue( "fog_end", "768");
   Convars.SetValue( "fog_color", "0 0 0");
   Convars.SetValue( "fog_colorskybox", "0 0 0");
   EntFire("chch_rain", "alpha", "100", 0, null)		
}

function StartSpawningShit()
{
printl("spawning storm stuff")
local blendout = SpawnEntityFromTable("logic_relay", { targetname = "relay_mix_blendout_coop", spawnflags = 0 } )
blendout.ValidateScriptScope()
EntityOutputs.AddOutput(blendout, "OnTrigger", "rainLayer_coop", "Level", ".2", 0.0, -1)
EntityOutputs.AddOutput(blendout, "OnTrigger", "rainLayer_coop", "Level", ".4", 1.0, -1)
EntityOutputs.AddOutput(blendout, "OnTrigger", "rainLayer_coop", "Level", ".6", 2.0, -1)
EntityOutputs.AddOutput(blendout, "OnTrigger", "rainLayer_coop", "Level", ".8", 3.0, -1)
EntityOutputs.AddOutput(blendout, "OnTrigger", "rainLayer_coop", "Level", "1", 4.0, -1)
local blendin = SpawnEntityFromTable("logic_relay", { targetname = "relay_mix_blendin_coop", spawnflags = 0 } )
blendin.ValidateScriptScope()
EntityOutputs.AddOutput(blendin, "OnTrigger", "rainLayer_coop", "Level", ".2", 3.0, -1)
EntityOutputs.AddOutput(blendin, "OnTrigger", "rainLayer_coop", "Level", ".4", 2.0, -1)
EntityOutputs.AddOutput(blendin, "OnTrigger", "rainLayer_coop", "Level", ".6", 1.0, -1)
EntityOutputs.AddOutput(blendin, "OnTrigger", "rainLayer_coop", "Level", ".8", 0.0, -1)
EntityOutputs.AddOutput(blendin, "OnTrigger", "rainLayer_coop", "Level", "0", 4.0, -1)
local blendoutvoip = SpawnEntityFromTable("logic_relay", { targetname = "relay_mix_blendout_voip", spawnflags = 0 } )
blendoutvoip.ValidateScriptScope()
EntityOutputs.AddOutput(blendoutvoip, "OnTrigger", "rainLayer_voip", "Level", ".8", 0.0, -1)
EntityOutputs.AddOutput(blendoutvoip, "OnTrigger", "rainLayer_voip", "Level", ".6", 1.0, -1)
EntityOutputs.AddOutput(blendoutvoip, "OnTrigger", "rainLayer_voip", "Level", ".4", 2.0, -1)
EntityOutputs.AddOutput(blendoutvoip, "OnTrigger", "rainLayer_voip", "Level", ".2", 3.0, -1)
EntityOutputs.AddOutput(blendoutvoip, "OnTrigger", "rainLayer_voip", "Level", "0", 4.0, -1)
local blendinvoip = SpawnEntityFromTable("logic_relay", { targetname = "relay_mix_blendin_voip", spawnflags = 0 } )
blendinvoip.ValidateScriptScope()
EntityOutputs.AddOutput(blendinvoip, "OnTrigger", "rainLayer_voip", "Level", ".2", 0.0, -1)
EntityOutputs.AddOutput(blendinvoip, "OnTrigger", "rainLayer_voip", "Level", ".4", 1.0, -1)
EntityOutputs.AddOutput(blendinvoip, "OnTrigger", "rainLayer_voip", "Level", ".6", 2.0, -1)
EntityOutputs.AddOutput(blendinvoip, "OnTrigger", "rainLayer_voip", "Level", ".8", 3.0, -1)
EntityOutputs.AddOutput(blendinvoip, "OnTrigger", "rainLayer_voip", "Level", "1", 4.0, -1)

local mixlayer1 = SpawnEntityFromTable("sound_mix_layer", { targetname = "rainLayer_voip", MixLayerName = "voipLayer", Level = 0 } )
mixlayer1.ValidateScriptScope()
local mixlayer2 = SpawnEntityFromTable("sound_mix_layer", { targetname = "rainLayer_coop", MixLayerName = "stormLayer", Level = 1 } )
mixlayer2.ValidateScriptScope()

local windself = SpawnEntityFromTable("env_wind", { targetname = "wind_storm", windradius = -1, maxgust = 200, maxgustdelay = 30, maxwind = 150, mingustdelay = 15, minwind = 75, mingust = 100, gustduration = 5, gustdirchange = 20 } )
windself.ValidateScriptScope()

local correct = SpawnEntityFromTable("color_correction", { targetname = "color_correction_main", filename = "materials/correction/cc_c4_return.raw", spawnflags = 1, maxfalloff = -1, fadeInDuration = 2, fadeOutDuration = 2, maxweight = 10, StartDisabled = 0 } )
correct.ValidateScriptScope()

local amb1 = SpawnEntityFromTable("ambient_generic", { targetname = "sound_drip", spawnflags = 49, message = "vehicles/helicopter/helicopterwind_loop.wav", radius = 10000, pitch = "100", pitchstart = "100", health = 10   } )
amb1.ValidateScriptScope()
local amb2 = SpawnEntityFromTable("ambient_generic", { targetname = "sound_drip", spawnflags = 49, message = "ambient/wind/windgust_strong.wav", radius = 10000, pitch = "100", pitchstart = "100", health = 10   } )
amb2.ValidateScriptScope()
local amb3 = SpawnEntityFromTable("ambient_generic", { targetname = "sound_thunder", spawnflags = 49, message = "Weather.thunder_close_all_4", radius = 10000, pitch = "100", pitchstart = "100", health = 10   } )
amb3.ValidateScriptScope()
local amb4 = SpawnEntityFromTable("ambient_generic", { targetname = "sound_mainrain", spawnflags = 17, message = "ambient/ambience/rainscapes/crucial_waterrain_light_loop.wav", radius = 10000, pitch = "100", pitchstart = "100", health = 10  } )
amb4.ValidateScriptScope()

local start = SpawnEntityFromTable("logic_relay", { targetname = "relay_storm_start", spawnflags = 2 } )
start.ValidateScriptScope()
EntityOutputs.AddOutput(start, "OnTrigger", "sound_thunder", "PlaySound", "", 0.0, -1)
EntityOutputs.AddOutput(start, "OnTrigger", "relay_storm_blendin", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(start, "OnTrigger", "!self", "Disable", "", 0.0, -1)
EntityOutputs.AddOutput(start, "OnTrigger", "relay_tonemap_flash", "Trigger", "", 0.3, -1)
EntityOutputs.AddOutput(start, "OnTrigger", "sound_thunder", "PlaySound", "", 2.7, -1)
if(Settings.speak_lines == 1)
{
EntityOutputs.AddOutput(start, "OnTrigger", "orator", "Speakresponseconcept", "c4_storm_start", 0.5, -1)
}
EntityOutputs.AddOutput(start, "OnTrigger", "ldq_stormtime", "HowAngry", "", 3.0, -1)
local flash = SpawnEntityFromTable("logic_relay", { targetname = "relay_tonemap_flash", spawnflags = 2 } )
flash.ValidateScriptScope()
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetTonemapRate", "1000", 0.0, -1)
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetAutoExposureMin", "50", 0.01, -1)
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetAutoExposureMax", "50", 0.01, -1)
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetAutoExposureMin", "1", 0.03, -1)
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetAutoExposureMax", "5", 0.03, -1)
EntityOutputs.AddOutput(flash, "OnTrigger", "tonemap_global", "SetTonemapRate", "0.25", 1.7, -1)
local blendin1 = SpawnEntityFromTable("logic_relay", { targetname = "relay_storm_blendin", spawnflags = 2 } )
blendin1.ValidateScriptScope()
//EntityOutputs.AddOutput(blendin1, "OnTrigger", "fog_storm", "SetEndDistLerpTo", "768", 0.0, -1)
//EntityOutputs.AddOutput(blendin1, "OnTrigger", "fog_storm", "SetStartDistLerpTo", "-512", 0.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "timer_storm_blendin", "Enable", "", 0.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "sound_drip", "Playsound", "", 0.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "sound_drip", "Volume", "10", 0.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "relay_localcontrast_fadein", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "relay_mix_blendin*", "Trigger", "", 0.0, -1)
//EntityOutputs.AddOutput(blendin1, "OnTrigger", "fog_storm", "StartFogTransition", "", 0.1, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "relay_tonemap_flash", "Trigger", "", 3.0, -1)
EntityOutputs.AddOutput(blendin1, "OnTrigger", "sound_thunder", "Playsound", "", 3.0, -1)
//EntityOutputs.AddOutput(blendin1, "OnTrigger", "fog_storm", "SetFarZ", "1024", 5.0, -1)
local blendout1 = SpawnEntityFromTable("logic_relay", { targetname = "relay_storm_blendout", spawnflags = 2 } )
blendout1.ValidateScriptScope()
EntityOutputs.AddOutput(blendout1, "OnTrigger", "timer_storm_blendout", "Enable", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "sound_drip", "Stopsound", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "sound_drip", "Volume", "0", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "relay_storm_start", "Enable", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "relay_localcontrast_fadeout", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "relay_tonemap_flash", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "relay_mix_blendout*", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(blendout1, "OnTrigger", "sound_thunder", "Playsound", "", 0.0, -1)

local scope = blendin1.GetScriptScope()
local scope2 = blendout1.GetScriptScope()
scope.StormFog <- StormFog
scope2.RegFog <- RegFog

blendin1.ConnectOutput("OnTrigger", "StormFog")
blendout1.ConnectOutput("OnTrigger", "RegFog")

local timer = SpawnEntityFromTable("logic_timer", { targetname = "timer_storm_lightning_strike", spawnflags = 0, LowerRandomBound = 1, StartDisabled = 1, UpperRandomBound = 4, UseRandomTime = 1 } )
timer.ValidateScriptScope()
EntityOutputs.AddOutput(timer, "OnTimer", "sound_thunder", "Playsound", "", 0.0, -1)
EntityOutputs.AddOutput(timer, "OnTimer", "relay_tonemap_flash", "Trigger", "", 0.3, -1)
local timer2 = SpawnEntityFromTable("logic_timer", { targetname = "timer_stormtime", spawnflags = 0, StartDisabled = 1, UseRandomTime = 0 } )
timer2.ValidateScriptScope()
EntityOutputs.AddOutput(timer2, "OnTimer", "relay_storm_blendout", "Trigger", "", 0.0, -1)
EntityOutputs.AddOutput(timer2, "OnTimer", "timer_stormtime", "Disable", "", 0.01, -1)

local query = SpawnEntityFromTable("logic_director_query", { distribution = 3, maxAngerRange = 10, minAngerRange = 1, noise = 0 } )
query.ValidateScriptScope()

local ent = null;
if (ent = Entities.FindByName(ent, "orator"))
{
}
else
{
printl("creating orator")
local orator = SpawnEntityFromTable("func_orator", { targetname = "orator", spawnflags = 1, maxThenAnyDispatchDist = 0 } )
orator.ValidateScriptScope()
}

EntityOutputs.AddOutput(query, "On20SecondsToMob", "relay_storm_start", "Trigger", "", 15.00, -1)
local query2 = SpawnEntityFromTable("logic_director_query", { targetname = "ldq_stormtime", distribution = 0, maxAngerRange = 45, minAngerRange = 15, noise = 0 } )
query2.ValidateScriptScope()
EntityOutputs.AddOutput(query2, "OutAnger", "timer_stormtime", "RefireTime", "", 0.0, -1)
EntityOutputs.AddOutput(query2, "OutAnger", "timer_stormtime", "ResetTimer", "", 0.01, -1)
EntityOutputs.AddOutput(query2, "OutAnger", "timer_stormtime", "Enable", "", 0.02, -1)

SpawnRain()
SpawnRain()
SpawnRain()
SpawnRain()
SpawnRain()
SpawnRain()
g_ModeScript.HasSpawnedRain <- 1

/*
for (local view; view = Entities.FindByClassname(view, "point_viewcontrol_survivor"); )
{
local rain4 = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_intro", start_active = 1 } )
rain4.ValidateScriptScope()
NetProps.SetPropEntity(rain4, "moveparent", view)
rain4.SetOrigin(rain4.GetOrigin() + Vector(0, 0, 512))
}
for (local view; view = Entities.FindByClassname(view, "point_deathfall_camera"); )
{
local rain4 = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_intro", start_active = 1 } )
rain4.ValidateScriptScope()
NetProps.SetPropEntity(rain4, "moveparent", view)
rain4.SetOrigin(rain4.GetOrigin() + Vector(0, 0, 512))
}
for (local view; view = Entities.FindByClassname(view, "point_viewcontro*"); )
{
local rain4 = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_intro", start_active = 1 } )
rain4.ValidateScriptScope()
NetProps.SetPropEntity(rain4, "moveparent", view)
rain4.SetOrigin(rain4.GetOrigin() + Vector(0, 0, 512))
}*/
}

function OnGameEvent_player_transitioned( params )
{
EntFire("sound_mainrain", "Stopsound", "", 0, null)
EntFire("sound_mainrain", "ToggleSound", "", 0, null)	

if(g_ModeScript.HasSpawnedRain != 1)
{
SpawnRain()
SpawnRain()
SpawnRain()
if(Settings.low_particles == 0)
{
SpawnRain()
SpawnRain()
SpawnRain()
}
g_ModeScript.HasSpawnedRain <- 1
}

}

/*
function OnGameEvent_player_spawn( params )
{
SetSettings()
StoreSettings()
local player = GetPlayerFromUserID(params.userid)
if(player.IsSurvivor() && Director.GetMapName() != "c4m3_sugarmill_b" && Director.GetMapName() != "c4m4_milltown_b" && Director.GetMapName() != "c4m5_milltown_escape" && Director.GetMapName() != "c6m1_riverbank")
{
if(Settings.low_particles == 0)
{
local rain = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_puddle_ripples_large", start_active = 1 } )
local rain3 = SpawnEntityFromTable("info_particle_system", { effect_name = "Rain_01_fog", start_active = 1 } )
rain.ValidateScriptScope()
rain3.ValidateScriptScope()
NetProps.SetPropEntity(rain, "moveparent", player)
NetProps.SetPropEntity(rain3, "moveparent", player)
rain3.SetOrigin(rain3.GetOrigin() + Vector(0, 0, 952))
}
local rain2 = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_intro", start_active = 1 } )
rain2.ValidateScriptScope()
NetProps.SetPropEntity(rain2, "moveparent", player)
rain2.SetOrigin(rain2.GetOrigin() + Vector(0, 0, 512))
if(!player.IsSurvivor() && !IsPlayerABot(player) && Director.GetMapName() != "c4m3_sugarmill_b" && Director.GetMapName() != "c4m4_milltown_b" && Director.GetMapName() != "c4m5_milltown_escape" && Director.GetMapName() != "c6m1_riverbank")
{
local raininf = SpawnEntityFromTable("info_particle_system", { effect_name = "rain_intro", start_active = 1 } )
NetProps.SetPropEntity(raininf, "moveparent", player)
raininf.SetOrigin(raininf.GetOrigin() + Vector(0, 0, 512))
}
}
}
*/

function OnGameEvent_player_spawn( params )
{
SetSettings()
StoreSettings()
local player = GetPlayerFromUserID(params.userid)
if(player.IsSurvivor() && Director.GetMapName() != "c4m3_sugarmill_b" && Director.GetMapName() != "c4m4_milltown_b" && Director.GetMapName() != "c4m5_milltown_escape" && Director.GetMapName() != "c6m1_riverbank")
{
if(Settings.low_particles == 0)
{
local rain3 = SpawnEntityFromTable("info_particle_system", { effect_name = "Rain_01_fog", start_active = 1 } )
rain3.ValidateScriptScope()
NetProps.SetPropEntity(rain3, "moveparent", player)
rain3.SetOrigin(rain3.GetOrigin() + Vector(0, 0, 952))
}
}
}

function SpawnRain()
{
	local tblKeyvalues =
	{
		targetname  =   "ChCh_Rain",
		preciptype	=	0,
		rendercolor	=	"31 34 52",
		renderamt	=	0,
		minSpeed	=	25,
		maxSpeed	=	35,
		origin		=	Vector(0, 0, 0),
	};

	local trigger = SpawnEntityFromTable( "func_precipitation", tblKeyvalues );
	trigger.ValidateScriptScope()

	DoEntFire( "!self", "AddOutput", "mins -30000 -30000 -30000", 0, null, trigger );
	DoEntFire( "!self", "AddOutput", "maxs 30000 30000 30000", 0, null, trigger );
	DoEntFire( "!self", "AddOutput", "solid 0", 0, null, trigger );
	DoEntFire( "!self", "Alpha", "100", 0, null, trigger );

	printl(trigger)
}

local newrules =
[
	{
		name = "ChCh_StormComin1Namvet", 
		criteria = 
		[
			[ "concept", "_C4_BigStormHits01" ],
			[ "who", "Namvet" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/NamVet/C6DLC3PRESTARTLASTGEN01.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //Get ready, let's do this.
            {   scenename = "scenes/NamVet/Swears03.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin1Teengirl", 
		criteria = 
		[
			[ "concept", "_C4_BigStormHits01" ],
			[ "who", "Teengirl" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/TeenGirl/Incoming18.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Ohhh crap, get ready!
            {   scenename = "scenes/TeenGirl/Incoming23.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Get ready!
            {   scenename = "scenes/TeenGirl/MiniFinaleGetReady01.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Get ready!
            {   scenename = "scenes/TeenGirl/MiniFinaleGetReady02.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Uh oh. Get ready!
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin1Manager", 
		criteria = 
		[
			[ "concept", "_C4_BigStormHits01" ],
			[ "who", "Manager" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/Manager/C6DLC3OPENINGDOOR04.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //Get ready, I don't have a good feeling about this.
            {   scenename = "scenes/Manager/C6DLC3OPENINGDOOR05.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //Stay positive guys, we can handle this.
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin1Biker", 
		criteria = 
		[
			[ "concept", "_C4_BigStormHits01" ],
			[ "who", "Biker" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/Biker/Incoming05.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //Get ready ladies!
            {   scenename = "scenes/Biker/Incoming07.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //This is gonna be good.
            {   scenename = "scenes/Biker/Incoming08.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  }  //Shit, Get ready!
            {   scenename = "scenes/Biker/MiniFinaleGetReady01.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Get ready!
            {   scenename = "scenes/Biker/MiniFinaleGetReady02.vcd", followup = RThen( "any",  "ChCh_StormComin2", {additionalcontext="null"}, 0.04 )  } //Bring it on!
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin2Namvet", 
		criteria = 
		[
			[ "concept", "ChCh_StormComin2" ],
			[ "who", "Namvet" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/NamVet/C6DLC3JUMPINGOFFBRIDGE05.vcd",   }  //Remember: Stay together! No matter what!
            {   scenename = "scenes/NamVet/C6DLC3JUMPINGOFFBRIDGE14.vcd",   }  //No matter what happens: stay together.
            {   scenename = "scenes/NamVet/StayTogether02.vcd",   }  //Come on - we got to stay together.
            {   scenename = "scenes/NamVet/StayTogether03.vcd",   }  //Keep together, people.
            {   scenename = "scenes/NamVet/StayTogether07.vcd",   }  //Stay close.
            {   scenename = "scenes/NamVet/StayTogether08.vcd",   }  //Don't get split up.
            {   scenename = "scenes/NamVet/StayTogether11.vcd",   }  //We've got to stay together.
            {   scenename = "scenes/NamVet/Incoming01.vcd",   } //Here they come!
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin2Teengirl", 
		criteria = 
		[
			[ "concept", "ChCh_StormComin2" ],
			[ "who", "Teengirl" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/TeenGirl/StayTogether05.vcd",   }  //Stick together!
            {   scenename = "scenes/TeenGirl/StayTogether08.vcd",   }  //Stay together!
            {   scenename = "scenes/TeenGirl/StayTogether11.vcd",   }  //We need to stick together
            {   scenename = "scenes/TeenGirl/Incoming04.vcd",   }  //They're coming!
            {   scenename = "scenes/TeenGirl/Incoming05.vcd",   }  //Here they come!
            {   scenename = "scenes/TeenGirl/Incoming18.vcd",   }  //Ohhh crap, get ready!
            {   scenename = "scenes/TeenGirl/Incoming21.vcd",   }  //Here they come, boys!
            {   scenename = "scenes/TeenGirl/Incoming24.vcd",   }  //Get ready, here they come!
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin2Manager", 
		criteria = 
		[
			[ "concept", "ChCh_StormComin2" ],
			[ "who", "Manager" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/Manager/StayTogether03.vcd",   }  //Keep together!
            {   scenename = "scenes/Manager/StayTogether05.vcd",   }  //We've got to stick together.
            {   scenename = "scenes/Manager/StayTogether06.vcd",   }  //Nobody run off.
            {   scenename = "scenes/Manager/Incoming01.vcd",   }  //Here they come!
            {   scenename = "scenes/Manager/Incoming02.vcd",   }  //They're comin'!
            {   scenename = "scenes/Manager/Incoming04.vcd",   } //Oh shit, here they come!
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}

	{
		name = "ChCh_StormComin2Biker", 
		criteria = 
		[
			[ "concept", "ChCh_StormComin2" ],
			[ "who", "Biker" ],
			[ "Coughing", 0 ],
            [ "Incapacitated", 0 ],
		],
		responses = 
		[
            {   scenename = "scenes/Biker/StayTogether02.vcd",   }  //We gotta stay together.
            {   scenename = "scenes/Biker/StayTogether06.vcd",   }  //Don't nobody wander off.
            {   scenename = "scenes/Biker/StayTogether07.vcd",   }  //Stay close.
            {   scenename = "scenes/Biker/StayTogether08.vcd",   }  //Don't get split up!
            {   scenename = "scenes/Biker/StayTogether11.vcd",   }  //Don't stray!
            {   scenename = "scenes/Biker/StayTogether12.vcd",   }  //Keep together!
            {   scenename = "scenes/Biker/Incoming01.vcd",   }  //Here they come!
            {   scenename = "scenes/Biker/Incoming02.vcd",   }  //Holy shit, here they come!
            {   scenename = "scenes/Biker/Incoming03.vcd",   }  //They're coming!
            {   scenename = "scenes/Biker/Incoming07.vcd",   }  //This is gonna be good.
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false, /*matchonce = false*/ })
	}
]
g_rr.rr_ProcessRules( newrules );