#version 140

uniform mat3 m;
uniform float dash_arrays[16];

in vec2 pos_2d;
in vec4 color;
in float line_length;
in int dash_idx;

out float v_line_length;
out vec4 v_color;
flat out int v_dash_idx;

void main(void) {
    v_line_length = line_length;
    v_color = color;
    gl_Position = vec4((m * vec3(pos_2d, 1.0)).xy, 0.0, 1.0);
}

###

#version 140
uniform float dash_arrays[16];
in vec4 v_color;
in float v_line_length;
flat in int v_dash_idx;
out vec4 out_frag_color;

void main(void) {
    float alpha = 1.0; //1.0 - step(0.5, mod(v_line_length, 1.0));
    float remainder = v_line_length;
    while (remainder > 0) {
        for (int i = 0; i < 4; ++i) {
            remainder -= dash_arrays[v_dash_idx*4 + i];
            if (remainder > 0) {
                alpha = 1.0 - alpha;
            } else {
                break;
            }
        }
    }
    out_frag_color = vec4(v_color.rgb, v_color.a * alpha);
}
