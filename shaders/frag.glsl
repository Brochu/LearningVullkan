#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(binding = 0) uniform UniformBufferObject
{
    vec3 mandelbrotValues;
} ubo;

layout(location = 0) out vec4 outColor;
layout(location = 0) in vec2 UVs;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
    int MAX_ITER = 512;
    vec2 z, c;

    //float scale = 0.05;
    //vec2 center = vec2(1.05, 0.27);
    float scale = ubo.mandelbrotValues.z;
    vec2 center = vec2(ubo.mandelbrotValues.x, ubo.mandelbrotValues.y);
    c.x = 1.3333 * (UVs.x - 0.5) * scale - center.x;
    c.y = (UVs.y - 0.5) * scale - center.y;

    int i;
    z = c;
    for(i=0; i<MAX_ITER; i++) {
        vec2 n = vec2((z.x * z.x - z.y * z.y) + c.x, (z.y * z.x + z.x * z.y) + c.y);

        if(dot(n, n) > 4.0) break;
        z = n;
    }

    // Test UBO values
    //outColor = vec4(ubo.mandelbrotValues, 1.0);

    // HSV color picks
    float value = float(i) / MAX_ITER;
    vec3 hsv;
    hsv.x = value;
    hsv.y = value;
    hsv.z = (i == MAX_ITER) ? 0.0 : value;
    outColor = vec4(hsv2rgb(hsv), 1.0);

    // Defined palette
    //vec3 colors[16];
    //colors[0] = vec3(66, 30, 15);
    //colors[1] = vec3(25, 7, 26);
    //colors[2] = vec3(9, 1, 47);
    //colors[3] = vec3(4, 4, 73);
    //colors[4] = vec3(0, 7, 100);
    //colors[5] = vec3(12, 44, 138);
    //colors[6] = vec3(24, 82, 177);
    //colors[7] = vec3(57, 125, 209);
    //colors[8] = vec3(134, 181, 229);
    //colors[9] = vec3(211, 236, 248);
    //colors[10] = vec3(241, 233, 191);
    //colors[11] = vec3(248, 201, 95);
    //colors[12] = vec3(255, 170, 0);
    //colors[13] = vec3(204, 128, 0);
    //colors[14] = vec3(153, 87, 0);
    //colors[15] = vec3(106, 52, 3);

    //outColor = (i < MAX_ITER && i > 0) ? vec4(colors[i%16], 1.0) : vec4(0, 0, 0, 1);
}
