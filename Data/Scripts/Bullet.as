
class Bullet : ScriptObject
{

    float lifetime;
    float timestart;

    void DelayedStart()
    {
        SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
        timestart = scene.elapsedTime;
    }
    
    void Update(float f)
    {
        if (scene.elapsedTime > timestart + lifetime)
        {
            node.Remove();
        }
    }
    
    void HandleNodeCollision(StringHash eventType, VariantMap& eventData)
    {
        lifetime = 0;
    }

}
