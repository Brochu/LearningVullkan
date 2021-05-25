#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 outColor;
layout(location = 0) in vec2 UVs;

void main()
{
    vec2 z, c;

    float scale = 0.05;
    vec2 center = vec2(1.05, 0.27);
    c.x = 1.3333 * (UVs.x - 0.5) * scale - center.x;
    c.y = (UVs.y - 0.5) * scale - center.y;

    int i;
    z = c;
    for(i=0; i<256; i++) {
        vec2 n = vec2((z.x * z.x - z.y * z.y) + c.x, (z.y * z.x + z.x * z.y) + c.y);

        if(dot(n, n) > 4.0) break;
        z = n;
    }

    float t = (i == 256 ? 0.0 : float(i)) / 100.0;
    outColor = vec4(sin(t), 1.0 - cos(t), /*1.0 - */tan(t), 1.0);
}
