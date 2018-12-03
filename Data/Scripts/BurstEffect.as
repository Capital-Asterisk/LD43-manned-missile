class BurstEffect : ScriptObject
{
    int frames = 3;
    void Updates()
    {
        frames --;
        
        if (frames == 0)
        {
            Array<Component@> emits = node.GetComponents("ParticleEmitter");
            for (int i = 0; i < emits.length; i ++)
            {
                cast<ParticleEmitter@>(emits[i]).emitting = false;
            }
        }
    }
}
