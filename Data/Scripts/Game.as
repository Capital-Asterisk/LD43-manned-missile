#include "CommonStuff.as"

class Hubhub : ScriptObject
{

    Hubhub()
    {
        Print("hubhub was made");
    }

    void FixedUpdate(float delta)
    {
        //Print(RandomInt(200, 300));
        //cast<RigidBody@>(node.GetComponent("RigidBody")).linearVelocity = Vector3(0, 1, 0);
    }


}

void RetryLevel()
{
    ChangeScene(sceneFunc_);
    //ChangeScene(S_Game::nextLevel);
}

void GotoNextLevel()
{
    if (S_Game::breif != null)
    {
        scene_.updateEnabled = true;
        S_Game::breif.Remove();
    }
    ChangeScene(S_Game::nextLevel);
}

void TheButtonPress()
{
    Print("pasdfjh");
    SetGlobalVar("InvertPitch", cast<CheckBox@>(S_Game::breif.GetChild("Invert")).checked);
    S_Game::breif.Remove();
    S_Game::music.Play(S_Game::music.sound);
    //cast<PhysicsWorld@>(scene_.GetComponent("PhysicsWorld")).gravity = Vector3(0, -9, 0);
    scene_.updateEnabled = true;

    //cast<RigidBody@>(S_Game::missile.GetComponent("RigidBody")).ReAddBodyToWorld();
    //cast<RigidBody@>(S_Game::missile.GetComponent("RigidBody")).linearVelocity = Vector3(0, -10, 0);
}

namespace S_Game
{

SCENEFUNCTION@ nextLevel;
Node@ target;
UIElement@ targetUI;
UIElement@ hudUI;
UIElement@ breif;
Camera@ cam;
SoundSource@ music;
Node@ missile;
UIElement@ notModal;

int kills = 0;
bool failure;
float timeOfDeath;

// Game stuff go here
void Salamander(int stats)
{

    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene1.xml"));
        

        // Play music
        music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        
        GameCommon(stats);
        
        nextLevel = @SalamanderB;
        Breif("Level 1 - Operation Unskilled Pilot", "Welcome to Manned Missile Master. An enemy supply craft has been located hiding beneath a strategically shaped canyon. Their makowsky jamming equipment makes them impossible to hit with any remote weapon.\n\nThis is where you come in. Fly through the canyon and ram the target at the other end.\n\nThey don't think our pilots are skilled enough to fly through this inconvenience, since AAGSS-69 Manoman pilots like you have no real combat experience in that vehicle. They'll be waiting for you to pop out, so STAY LOW!");
    } else {
        GameCommon(stats);
    }
    
}

void SalamanderB(int stats)
{

    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene2.xml"));
        

        // Play music
        music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        
        
        
        GameCommon(stats);
        
        nextLevel = @SalamanderC;
        Breif("Level 2 - De-Automation", "An unmanned variant of your AAGSS-69 Manoman is being tested, identified as the AAGSS-69-C Unmannedoman.\n\nProve that human control is safer and more reliable than artificial intelligence.\n\nDestroy that prototype missile to halt its development!");
    } else {
        GameCommon(stats);
    }
    
}

void SalamanderC(int stats)
{

    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene3.xml"));
        

        // Play music
        music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        
        
        
        GameCommon(stats);
        
        nextLevel = @SalamanderD;
        Breif("Level 3 - Operation Boring Game", "The enemy has been doing some business with this mysterious cave. Let's just assume it's a place where they're developing advanced thermonuclear weapons. Whatever is being done in there, destroy it.\n\nDestroy the target at the end of the cave. Be careful, fly safe and don't hit anything.");
    } else {
        GameCommon(stats);
    }
    
}

void SalamanderD(int stats)
{

    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene4.xml"));
        

        // Play music
        music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        
        
        
        GameCommon(stats);
        
        nextLevel = @SalamanderE;
        Breif("Level 4 - Solid Moisture", "An armed enemy ship is headed towards our capital. Intercept them.\n\nThey are expected to open fire against anything within their 270 kilofeet range. Try not to hit the projectiles.\n\nIt is advised that hitting sharply from below, or aiming for the nose, is the most effective way to get a direct hit.");
    } else {
        GameCommon(stats);
    }
    
}

void SalamanderE(int stats)
{

    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene5.xml"));
        

        // Play music
        music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        
        
        
        GameCommon(stats);
        
        nextLevel = null;
        Breif("Level 5 - Operation Operation", "Intelligence from previous missions flown by brave pilots had allowed us to locate the enemy base. Their interior isn't quite designed for flying vehicles, but the maps shows that its possible to destroy their generator using an AAGSS-69 Manoman. \n\nTake extreme caution, as there will be turrets.");
    } else {
        GameCommon(stats);
    }
    
}

void Breif(String title, String desc)
{
    breif = ui.LoadLayout(cache.GetResource("XMLFile", "UI/breif.xml"));
    ui.root.AddChild(breif);
    cast<Text@>(breif.GetChild("Tit")).text = title;
    cast<Text@>(breif.GetChild("Desk")).text = desc;
    cast<CheckBox@>(breif.GetChild("Invert")).checked = GetGlobalVar("InvertPitch").GetBool();
    
    SubscribeToEvent(cast<Button@>(breif.GetChild("Begin")), "Released", "TheButtonPress");
    SubscribeToEvent(cast<Button@>(breif.GetChild("Skip")), "Released", "GotoNextLevel");
    
}

void GameCommon(int stats)
{
    if (stats == 1)
    {
        missile = scene_.GetChild("Missile");
        cam = scene_.GetChild("Cam").GetComponent("Camera");
        Viewport@ viewport = Viewport(scene_, cam);
        renderer.viewports[0] = viewport;
        target = scene_.GetChild("Target");
        
        targetUI = ui.LoadLayout(cache.GetResource("XMLFile", "UI/Target.xml"));
        ui.root.AddChild(targetUI);
        
        hudUI = ui.LoadLayout(cache.GetResource("XMLFile", "UI/Hud.xml"));
        ui.root.AddChild(hudUI);
        
        notModal = null;
        
        failure = false;
        
        scene_.updateEnabled = false;
    }
    
    if (!missile.vars["Dead"].GetBool())
    {
        hudUI.GetChild("Warning").opacity = bint(missile.vars["Warning"].GetBool());
        hudUI.opacity = Random(0.8, 1.0);
        //Vector2 screenPos = cam.WorldToScreenPoint(target.position);
        targetUI.position = renderer.viewports[0].WorldToScreenPoint(target.position);
        cast<Text@>(targetUI.GetChild("Distance")).text =
        "DISTANCE: " + int((target.position - missile.position).length);
        
        cast<Text@>(hudUI.GetChild("Fuel")).text = "FUEL: " + missile.vars["Fuel"].GetInt() + "%";
    }
    
    if (missile.vars["Dead"].GetBool() && !failure)
    {
        
        failure = true;
        
        timeOfDeath = scene_.elapsedTime;
        
        music.Stop();
        hudUI.Remove();
        targetUI.Remove();
        
        SoundSource@ boom = cast<SoundSource@>(cam.node.GetComponent("SoundSource"));
        boom.frequency = 44100 * Random(0.9, 1.1);
        boom.gain = 0.6;
        boom.Play(boom.sound);
        // Play failure sound
    }
    
    if (failure)
    {
        cam.node.Translate(Vector3(0, 0, (Cos(Min((scene_.elapsedTime - timeOfDeath) * 100, 180.0)) + 1) * -0.2));
        
        if (scene_.elapsedTime - timeOfDeath > 2 && notModal == null)
        {
            kills += 1;
            if (target.enabled)
            {
                notModal = ui.LoadLayout(cache.GetResource("XMLFile", "UI/failure.xml"));
                SubscribeToEvent(cast<Button@>(notModal.GetChild("Next")), "Released", "RetryLevel");
            } else {
                if (nextLevel != null)
                {
                    notModal = ui.LoadLayout(cache.GetResource("XMLFile", "UI/acompriush.xml"));
                    SubscribeToEvent(cast<Button@>(notModal.GetChild("Next")), "Released", "GotoNextLevel");
                } else {
                    notModal = ui.LoadLayout(cache.GetResource("XMLFile", "UI/thanks.xml"));
                    cast<Text@>(notModal.GetChild("RIP")).text = "PILOTS SACRIFICED: " + kills;
                }
            }
            
            
            ui.root.AddChild(notModal);
        }
        
    }
}

}

int bint(bool b)
{
    return b ? 1 : 0;
}
