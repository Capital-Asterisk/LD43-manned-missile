
class ConstantVelocity : ScriptObject
{

    Vector3 velocity;
    bool local = false;
    RigidBody@ rb;

    void Start()
    {
        rb = cast<RigidBody@>(node.GetComponent("RigidBody"));
        SubscribeToEvent("PhysicsPreStep", "PhysicsUpdate");
        
    }
    
    void PhysicsUpdate(StringHash eventType, VariantMap& eventData)
    {
        rb.linearVelocity = node.rotation * velocity;

    }

}
