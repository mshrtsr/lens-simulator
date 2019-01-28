%% Calculate Effective focal length using LensMaker's equation.
function EFL = calc_EFL(lens)

% Lens setting
r1 = lens.r1; % radius of curvature 1 [mm]
r2 = lens.r2; %Inf; % radius of curvature 2 [mm]
thickness = lens.thickness; % thickness [mm]
IOR = lens.IOR; % refractive index (index of refractive)

EFL = 1/((IOR-1)*(1/r1-1/r2)+((IOR-1)^2)*thickness/(IOR*r1*r2));

end