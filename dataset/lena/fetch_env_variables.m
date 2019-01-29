function [params, store] =  fetch_env_variables()

%% Parameter of experiment
params.lens_x = 10; % number of lenslet
params.lens_y = 10;
params.lens_pitch = 100; % pitch of lenslet [mm]
params.camera_pixelsize = 0.0022; % pixel size of image sensor [mm]
params.src_image_name = 'lena_color_256.tif';
params.samples = 50;

%% Parameter of experiment
% Air(Material out of lens) setting
air.IOR = 1.0;

% Lens setting
lens.r1 = 0.1; % radius of curvature 1 [mm]
lens.r2 = Inf;%Inf; % radius of curvature 2 [mm]
lens.thickness = 0.05; % thickness [mm]
lens.radius = 0.05; % Radius of lens [mm]
lens.IOR = 1.43; % refractive index (index of refractive)
lens.EFL = 0.217; % effective focal length [mm]
% lens.EFL = calc_EFL(lens); % effective focal length [mm]
lens.EFL = 1/((lens.IOR-1)*(1/lens.r1-1/lens.r2)+((lens.IOR-1)^2)*lens.thickness/(lens.IOR*lens.r1*lens.r2)); % Lensmaker's equation


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