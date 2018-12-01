
class MannedMissile : ScriptObject
{

    Node@ cam;
    RigidBody@ rb;
    Light@ engineLight;
    
    bool launched;
    float shake;
    Vector3 joystick;
    Vector3 camFoo;
    
    
    
    void DelayedStart()
    {
        cam = scene.GetChild("Cam");
        rb = cast<RigidBody@>(node.GetComponent("RigidBody"));
        engineLight = cast<Light@>(node.GetChild("Engine").GetComponent("Light"));
        
        
        SubscribeToEvent("RenderUpdate", "CameraUpdate");
        
        shake = 0.0;
        launched = false;
        
    }
    
    void Update(float timestep)
    {
        if (!launched && rb.linearVelocity.length > 6)
        {
            launched = true;
            Launch();
        }
    }
    
    void Launch()
    {
        SubscribeToEvent("PhysicsPreStep", "PhysicsUpdate");
        
        // this enables particles and plays launch sound at the same time
        node.GetChild("EngineFlare").enabled = true;
        
        SoundSource@ engineSound = cast<SoundSource@>(node.GetChild("Engine").GetComponent("SoundSource"));
        engineSound.sound.looped = true;
        engineSound.Play(engineSound.sound);
        
        shake = 1;
    }
    
    void PhysicsUpdate(StringHash eventType, VariantMap& eventData)
    {
        // roll, yaw, pitch
        joystick = Vector3(bint(input.keyDown[KEY_Q]) - bint(input.keyDown[KEY_E]), bint(input.keyDown[KEY_D]) - bint(input.keyDown[KEY_A]), bint(input.keyDown[KEY_S]) - bint(input.keyDown[KEY_W]));
        
        rb.linearVelocity = node.rotation * Vector3(30, 0, 0);
        Quaternion angVel = Quaternion(rb.angularVelocity);
        angVel = angVel * node.rotation;
        angVel = angVel * Quaternion(joystick * 0.05);
        angVel = angVel * node.rotation.Inverse();
        rb.angularVelocity = angVel.eulerAngles;
        
        camFoo += (Vector3(joystick.z, -joystick.y, -joystick.x) * 30 - camFoo) * 0.01;
        
    }

    void CameraUpdate(StringHash eventType, VariantMap& eventData)
    {
        Quaternion camRot = node.rotation * Quaternion(0, 90, 0);
        Quaternion additional = Quaternion(camFoo);
        cam.position = node.position + node.rotation * (Vector3(-5, 1, 0) + Vector3(Cos(scene.elapsedTime * 133) * 0.2, Sin(scene.elapsedTime * 50) * 0.1, Cos(scene.elapsedTime * 25) * 0.3)) + Vector3(Random(-1.0, 1.0), Random(-1.0, 1.0), Random(-1.0, 1.0)) * shake;
        cam.rotation = camRot;
        cam.RotateAround(Vector3(0, -1, 5), additional, TS_LOCAL);
        scene.GetChild("Skybox").position = cam.position;
        
        if (launched){
            engineLight.brightness = Random(9008, 15000);
            shake += (0.01 - shake) * 0.04;
        }
        
        
    }
    

}


int bint(bool b)
{
    return b ? 1 : 0;
}
