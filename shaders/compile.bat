glslc -fshader-stage=vert vert.glsl -o vert.spv
glslc -fshader-stage=frag frag.glsl -o frag.spv
pause
mv vert.spv ../build/vert.spv
mv frag.spv ../build/frag.spv
