
class Turret : ScriptObject
{

    float firerate;
    float bulletSpeed;
    float range;
    float lasttimeshot;

    void DelayedStart()
    {

        SubscribeToEvent("PhysicsPreStep", "PhysicsUpdate");
        
        lasttimeshot = scene.elapsedTime;
    }
    
    void PhysicsUpdate(StringHash eventType, VariantMap& eventData)
    {
        Node@ missile = scene.GetChild("Missile");
        float time = scene.elapsedTime;
        
        float distance = (node.worldPosition - missile.worldPosition).length;
        if (distance < range)
        {
            if (time > lasttimeshot + firerate && !(missile.vars["Dead"].GetBool()))
            {
                Quaternion rot;
                rot.FromLookRotation((missile.worldPosition - node.worldPosition).Normalized());
                rot = rot * Quaternion(0, -90, 0);
                
                Node@ bullet = scene.InstantiateXML(cache.GetResource("XMLFile", "Objects/bullet.xml"), node.worldPosition, rot);
                RigidBody@ brb = cast<RigidBody@>(bullet.GetComponent("RigidBody"));
                
                brb.gravityOverride = Vector3(0.0001, 0, 0);
                
                RigidBody@ mrb = cast<RigidBody@>(missile.GetComponent("RigidBody"));
                float travelTime = distance / bulletSpeed;
                Vector3 lead = missile.worldPosition + mrb.linearVelocity * travelTime * 0.7;
                
                Vector3 dir = (lead - node.worldPosition).Normalized();
                dir = dir + Vector3(Random(-0.04, 0.04), Random(-0.04, 0.04), Random(-0.04, 0.04));
                
                brb.linearVelocity = dir.Normalized() * bulletSpeed;
                
                SoundSource@ firesound = cast<SoundSource@>(node.GetComponent("SoundSource"));
                firesound.Play(firesound.sound);
                lasttimeshot = time;
            }
            missile.vars["ExWarning"] = true;
        }
    }

}
