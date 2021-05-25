#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 outColor;
layout(location = 0) in vec2 UVs;

void main()
{
    vec2 z, c;

    // Offset and Zoom for the mandlebrot
    float scale = 2.0;
    vec2 center = vec2(0.35, 0.0);
    c.x = 1.3333 * (UVs.x - 0.5) * scale - center.x; // Difference is related to aspect ratio
    c.y = (UVs.y - 0.5) * scale - center.y;

    int i;
    int MAX_ITER = 10000;
    z = c;
    for(i = 0; i < MAX_ITER; ++i)
    {
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;

        if ((x * x + y * y) > 4.0) break;
        z.x = x;
        z.y = y;
    }

    float t = i / MAX_ITER;
    //outColor = vec4(t, t, t, 1.0);
    outColor = vec4(t*UVs, 0.2, 1.0);
}
