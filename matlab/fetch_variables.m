function [params, store] =  fetch_variables()
%% Parameter of experiment import
%fdir = '../dataset/your_dataset_dir/';

% exec_folder = cd(fdir);
% params = fetch_env_variables();
% cd(exec_folder);
% params.fdir = fdir;

%% (Optional) Parameter of experiment
% Air(Material out of lens) setting
air.IOR = 1.0;

% Lens setting
lens.r1 = 0.1; % radius of curvature 1 [mm]
lens.r2 = Inf;%Inf; % radius of curvature 2 [mm]
lens.thickness = 0.05; % thickness [mm]
lens.radius = 0.05; % Radius of lens [mm]
lens.IOR = 1.43; % refractive index (index of refractive)
lens.EFL = 0.217; % effective focal length [mm]

lens.EFL = 1/((lens.IOR-1)*(1/lens.r1-1/lens.r2)+((lens.IOR-1)^2)*lens.thickness/(lens.IOR*lens.r1*lens.r2)); % Lensmaker's equation

lens.m = 0.5;%1.0;
lens.a = (lens.m+1)/lens.m*lens.EFL; % [mm];
lens.b = (lens.m+1)*lens.EFL; % [mm]

% Screen setting
screen.pos.x = lens.b;
screen.pos.y = 0;

% Render limit setting
render_area_right_border = screen.pos.x * 1.1;

% Define the ray condition
ray_entering_lens.pos.x = -lens.a;
ray_entering_lens.pos.y = 0.1;
ray_entering_lens.direction = ray_entering_lens.pos.y/ray_entering_lens.pos.x;

% Copy all paramaters to struct params
params.air = air;
params.lens = lens;
params.screen = screen;
params.render_area_right_border = render_area_right_border;
store.ray_entering_lens = ray_entering_lens;

end