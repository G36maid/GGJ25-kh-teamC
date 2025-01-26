shader_type canvas_item;

uniform vec4 background_color : source_color = vec4(0.0, 0.02, 0.05, 1.0);
uniform vec4 star_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 nebula_color1 : source_color = vec4(0.5, 0.0, 0.5, 1.0);
uniform vec4 nebula_color2 : source_color = vec4(0.0, 0.2, 0.5, 1.0);
uniform float star_density : hint_range(0.0, 1.0) = 0.5;
uniform float nebula_density : hint_range(0.0, 1.0) = 0.5;
uniform float rotation_speed : hint_range(0.0, 2.0) = 0.1;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 uv) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    for(int i = 0; i < 6; i++) {
        value += amplitude * noise(uv);
        uv *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 uv, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(vec2(c, -s), vec2(s, c));
    return rotation * uv;
}

void fragment() {
    // Rotate and scale UV coordinates
    vec2 centered_uv = UV - 0.5;
    vec2 rotated_uv = rotate(centered_uv, TIME * rotation_speed);
    vec2 scaled_uv = rotated_uv * 3.0;

    // Generate spiral galaxy arms
    float angle = atan(rotated_uv.y, rotated_uv.x);
    float spiral = sin(angle * 2.0 + length(rotated_uv) * 5.0 + TIME * 0.5);

    // Create nebula effect
    float nebula = fbm(scaled_uv + TIME * 0.05);
    nebula *= fbm(scaled_uv * 2.0 - TIME * 0.02);
    nebula = smoothstep(0.0, nebula_density, nebula);

    // Generate multiple layers of stars
    float stars = noise(scaled_uv * 50.0);
    stars *= noise(scaled_uv * 50.0 + TIME * 0.1); // Twinkle
    stars = smoothstep(1.0 - star_density, 1.0, stars);

    // Bright core
    float core = 1.0 - smoothstep(0.0, 0.5, length(rotated_uv));

    // Combine everything
    vec4 nebula_color = mix(nebula_color1, nebula_color2, nebula + spiral * 0.5);
    vec4 final_color = background_color;
    final_color = mix(final_color, nebula_color, nebula * 0.6);
    final_color = mix(final_color, star_color, stars);
    final_color += core * nebula_color1 * 0.3;

    // Add some color variation
    final_color.rgb += vec3(noise(scaled_uv + TIME) * 0.05);

    COLOR = final_color;
}
