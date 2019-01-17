clear all;

%% Setup
params = fetch_variables();
lens = params.lens;
ray_from_object = params.ray_from_object;
direction_start = (lens.radius - ray_from_object.pos.y)/(0 - ray_from_object.pos.x);
direction_end = (-lens.radius - ray_from_object.pos.y)/(0 - ray_from_object.pos.x);

params = fetch_variables();
params.ray_from_object.direction = direction;
result_params = lens_simulator(params);

lens = result_params.lens;
screen = result_params.screen;
ray_from_object = result_params.ray_from_object;
ray_in_lens = result_params.ray_in_lens;
ray_from_lens = result_params.ray_from_lens;
projected_p = result_params.projected_p;
p_at_right_border = result_params.p_at_right_border;