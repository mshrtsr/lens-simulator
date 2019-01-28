function [params, store] =  fetch_variables()
%% Include geometric lib
addpath geometric;

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
lens.EFL = calc_EFL(lens); % effective focal length [mm]

% Lens magnitude setting
lens.m = 1.0; % lens magnitude
lens.a = (lens.m+1)/lens.m*lens.EFL; % Distance from object to lens [mm];
lens.b = (lens.m+1)*lens.EFL; % Distance from screen to lens [mm];

% Screen setting
screen.pos.x = lens.b;
screen.pos.y = 0;

% Define the ray condition
ray_entering_lens.pos.x = -lens.a;
ray_entering_lens.pos.y = 0.1;
ray_entering_lens.direction = ray_entering_lens.pos.y/ray_entering_lens.pos.x;

%% Copy all paramaters to struct params
params.air = air;
params.lens = lens;
params.screen = screen;

store.ray_entering_lens = ray_entering_lens;

end