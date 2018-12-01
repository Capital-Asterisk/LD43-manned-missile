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

namespace S_Game
{

Node@ target;
UIElement@ targetUI;
Camera@ cam;
Node@ missile;


// Game stuff go here
void Salamander(int stats)
{
    if (stats == 1)
    {
        scene_.LoadXML(cache.GetFile("Scenes/Scene1.xml"));
        
        //Node@ n = scene_.CreateChild("Laran");
        //StaticModel@ model = n.CreateComponent("StaticModel");
        //model.model = cache.GetResource("Model", "Models/ezsphere.mdl");
        //ScriptObject@ so = n.CreateScriptObject("Scripts/Game.as", "Hubhub");
        //RigidBody@ rb = n.CreateComponent("RigidBody");
        //rb.mass = 1.0f;
        //rb.friction = 1.0f;
        //CollisionShape@ cs = n.CreateComponent("CollisionShape");
        //cs.SetBox(Vector3::ONE);

        missile = scene_.GetChild("Missile");
        cam = scene_.GetChild("Cam").GetComponent("Camera");
        Viewport@ viewport = Viewport(scene_, cam);
        renderer.viewports[0] = viewport;
        target = scene_.GetChild("Target");
        
        targetUI = ui.LoadLayout(cache.GetResource("XMLFile", "UI/Target.xml"));
        ui.root.AddChild(targetUI);
        
        // Play music
        SoundSource@ music = cast<SoundSource@>(scene_.GetChild("Music").GetComponent("SoundSource"));
        music.sound.looped = true;
        music.Play(music.sound);
        
    }
    
    //Vector2 screenPos = cam.WorldToScreenPoint(target.position);
    targetUI.position = renderer.viewports[0].WorldToScreenPoint(target.position);
    cast<Text@>(targetUI.GetChild("Distance")).text =
    "DISTANCE: " + int((target.position - missile.position).length);
}

}
