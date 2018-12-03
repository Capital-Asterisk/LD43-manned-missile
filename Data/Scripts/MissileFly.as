
class MannedMissile : ScriptObject
{

    Node@ cam;
    RigidBody@ rb;
    SoundSource@ warningSound;
    Light@ engineLight;
    
    bool prevWarn;
    bool launched;
    float shake;
    float maxHeight;
    float time;
    Vector3 joystick;
    Vector3 camFoo;
    
    float timeStart;
    
    void DelayedStart()
    {
        cam = scene.GetChild("Cam");
        rb = cast<RigidBody@>(node.GetComponent("RigidBody"));
        engineLight = cast<Light@>(node.GetChild("Engine").GetComponent("Light"));
        warningSound = cast<SoundSource@>(node.GetChild("Forward").GetComponent("SoundSource"));
        
        SubscribeToEvent("RenderUpdate", "CameraUpdate");
        node.vars["Warning"] = false;
        node.vars["Dead"] = false;
        node.vars["Fuel"] = 100;
        node.vars["ExWarning"] = false;
        
        shake = 0.0;
        launched = false;
        
    }
    
    void Update(float timestep)
    {
        if (!launched && rb.linearVelocity.length > 20)
        {
            launched = true;
            Launch();
        }
    }
    
    void Launch()
    {
        SubscribeToEvent("PhysicsPreStep", "PhysicsUpdate");
        SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
        
        // this enables particles and plays launch sound at the same time
        node.GetChild("EngineFlare").enabled = true;
        
        SoundSource@ engineSound = cast<SoundSource@>(node.GetChild("Engine").GetComponent("SoundSource"));
        engineSound.sound.looped = true;
        engineSound.Play(engineSound.sound);
        
        timeStart = scene.elapsedTime;
        
        shake = 1;
    }
    
    void HandleNodeCollision(StringHash eventType, VariantMap& eventData)
    {
        Node@ objHit = eventData["OtherNode"].GetPtr();
        if (objHit.name == "Target")
        {
            objHit.SetEnabledRecursive(false);
        }
        
        Explode();
    }
    
    void Explode()
    {
        node.vars["Dead"] = true;
        node.SetEnabledRecursive(false);
        
        Node@ boom = scene.InstantiateXML(cache.GetResource("XMLFile", "Objects/Explosion.xml"), node.position, Quaternion());
        
        boom.Scale(6);
    }
    
    void PhysicsUpdate(StringHash eventType, VariantMap& eventData)
    {
    
        // roll, yaw, pitch
        if (GetGlobalVar("InvertPitch").GetBool())
        {
            joystick = Vector3(bint(input.keyDown[KEY_Q]) - bint(input.keyDown[KEY_E]), bint(input.keyDown[KEY_D]) - bint(input.keyDown[KEY_A]), bint(input.keyDown[KEY_W]) - bint(input.keyDown[KEY_S]));
        } else {
            joystick = Vector3(bint(input.keyDown[KEY_Q]) - bint(input.keyDown[KEY_E]), bint(input.keyDown[KEY_D]) - bint(input.keyDown[KEY_A]), bint(input.keyDown[KEY_S]) - bint(input.keyDown[KEY_W]));
        }
        int fLeft = int(Max((timeStart + time - scene.elapsedTime) / time * 100, 0.0));
        
        if (node.vars["Fuel"].GetInt() > 0 && (fLeft == 0))
        {
            Print("just ran out of fuel");
            node.GetChild("EngineFlare").enabled = false;
        }
        node.vars["Fuel"] = fLeft;
        
        if (fLeft != 0)
        {
            rb.linearVelocity = node.rotation * Vector3(30, 0, 0);
            Quaternion angVel = Quaternion(rb.angularVelocity);
            angVel = angVel * node.rotation;
            angVel = angVel * Quaternion(joystick * 0.05);
            angVel = angVel * node.rotation.Inverse();
            rb.angularVelocity = angVel.eulerAngles;
        }
        
        camFoo += (Vector3(joystick.z, -joystick.y, -joystick.x) * 30 - camFoo) * 0.01;
        
        prevWarn = node.vars["Warning"].GetBool();
        node.vars["Warning"] = (node.position.y > (maxHeight - 16)) || (fLeft == 0) || node.vars["ExWarning"].GetBool();
        
        if (node.vars["ExWarning"].GetBool())
        {
            node.vars["ExWarning"] = false;
        }
        
        // if warning and not warning previously
        if (node.vars["Warning"].GetBool() && !prevWarn)
        {
            warningSound.Play(warningSound.sound);
        }
        
        if (node.position.y > maxHeight)
        {
            Explode();
        }
    }

    void CameraUpdate(StringHash eventType, VariantMap& eventData)
    {
    
        scene.GetChild("Skybox").position = cam.position;
        
        if (rb.linearVelocity.length > 1 || launched) {
    
            Quaternion camRot = node.rotation * Quaternion(0, 90, 0);
            Quaternion additional = Quaternion(camFoo);
            cam.position = node.position + node.rotation * (Vector3(-5, 1, 0) + Vector3(Cos(scene.elapsedTime * 133) * 0.2, Sin(scene.elapsedTime * 50) * 0.1, Cos(scene.elapsedTime * 25) * 0.3)) + Vector3(Random(-1.0, 1.0), Random(-1.0, 1.0), Random(-1.0, 1.0)) * shake;
            cam.rotation = camRot;
            cam.RotateAround(Vector3(0, -1, 5), additional, TS_LOCAL);
            
            if (launched){
                engineLight.brightness = Random(9008, 15000);
                shake += (0.003 - shake) * 0.04;
            }
            
        }
        
    }
    

}


int bint(bool b)
{
    return b ? 1 : 0;
}
