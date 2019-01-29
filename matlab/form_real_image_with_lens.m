close all;
clear all;
%% Setup
[params, store] = fetch_variables('lena');
lens = params.lens;
screen = params.screen;
samples = params.samples;

% Render limit setting
render_area_right_border = screen.pos.x * 1.1;

src_image = imread([params.fdir '/' params.src_image_name]);
[height, width, color] = size(src_image);

for h = 1:height
    for w = 1:width
        % Define the ray condition for height dimention
        ray_entering_lens.pos.x = -lens.a;
        ray_entering_lens.pos.y = (height - h)*params.camera_pixelsize;
        ray_entering_lens.direction = ray_entering_lens.pos.y/ray_entering_lens.pos.x;
        ray_height_axis.ray_entering_lens = ray_entering_lens;

        rays_height_axis = simulate_ray_propagation_through_the_lens(params, ray_height_axis);

        % Define the ray condition for width dimention
        ray_entering_lens.pos.x = -lens.a;
        ray_entering_lens.pos.y = (w - width)*params.camera_pixelsize;
        ray_entering_lens.direction = ray_entering_lens.pos.y/ray_entering_lens.pos.x;
        ray_width_axis.ray_entering_lens = ray_entering_lens;

        rays_width_axis = simulate_ray_propagation_through_the_lens(params, ray_width_axis);
    end
end

%% Calculate the diffusing ray propagation
diffusing_rays = simulate_diffusing_ray_propagation_through_the_lens(params, store, 100);


