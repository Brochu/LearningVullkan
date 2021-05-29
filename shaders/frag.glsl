#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(binding = 0) uniform UniformBufferObject
{
    vec3 mandelbrotValues;
} ubo;

layout(location = 0) in vec2 UVs;
layout(location = 1) in vec3 fragColor;

layout(location = 0) out vec4 outColor;

dvec3 hsv2rgb(dvec3 c)
{
    dvec4 K = dvec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    dvec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
    int MAX_ITER = 512;
    dvec2 z, c;

    //float scale = 0.05;
    //vec2 center = vec2(1.05, 0.27);
    double scale = ubo.mandelbrotValues.z;
    dvec2 center = dvec2(ubo.mandelbrotValues.x, ubo.mandelbrotValues.y);
    c.x = 1.3333 * (UVs.x - 0.5) * scale - center.x;
    c.y = (UVs.y - 0.5) * scale - center.y;

    int i;
    z = c;
    for(i=0; i<MAX_ITER; i++) {
        dvec2 n = dvec2((z.x * z.x - z.y * z.y) + c.x, (z.y * z.x + z.x * z.y) + c.y);

        if(dot(n, n) > 4.0) break;
        z = n;
    }

    // Test UBO values
    //outColor = vec4(ubo.mandelbrotValues, 1.0);

    // HSV color picks
    double value = double(i) / MAX_ITER;
    //dvec3 hsv;
    //hsv.x = value;
    //hsv.y = value;
    //hsv.z = (i == MAX_ITER) ? 0.0 : value;
    //outColor = vec4(hsv2rgb(hsv), 1.0);
    if (i == MAX_ITER || i == 0)
        outColor = vec4(0, 0, 0, 1);
    else
        outColor = vec4(0, value * UVs.y, value * UVs.x, 1.0);
}
