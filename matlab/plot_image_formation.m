close all;
clear all;

%% Setup
[params, store] = fetch_variables();
lens = params.lens;
screen = params.screen;

% Render limit setting
render_area_right_border = screen.pos.x * 1.1;

%% Calculate the diffusing ray propagation
diffusing_rays = simulate_diffusing_ray_propagation_through_the_lens(params, store, 100);

%% Draw the ray propagations
for diffusing_ray = diffusing_rays

    ray_entering_lens = diffusing_ray.ray_entering_lens;
    ray_inside_lens = diffusing_ray.ray_inside_lens;
    ray_leaving_lens = diffusing_ray.ray_leaving_lens;
    
    if isempty(ray_leaving_lens)
        continue;
    end

    %% plot the graph
    x = [];
    y = [];

    tmp_x = linspace(ray_entering_lens.pos.x, ray_inside_lens.pos.x);
    tmp_y = solve_ray_for_y(ray_entering_lens, tmp_x);
    x = [x tmp_x];
    y = [y tmp_y];

    tmp_x = linspace(ray_inside_lens.pos.x, ray_leaving_lens.pos.x);
    tmp_y = solve_ray_for_y(ray_inside_lens, tmp_x);
    x = [x tmp_x];
    y = [y tmp_y];

    tmp_x = linspace(ray_leaving_lens.pos.x, screen.pos.x);
    tmp_y = solve_ray_for_y(ray_leaving_lens, tmp_x);
    x = [x tmp_x];
    y = [y tmp_y];

    tmp_x = linspace(screen.pos.x, render_area_right_border);
    tmp_y = solve_ray_for_y(ray_leaving_lens, tmp_x);
    x = [x tmp_x];
    y = [y tmp_y];

    %plot(x, y);
    plot(x, y, 'Color', 'cyan');
    hold on

end

%% plot the lens
r = lens.r1;
xc = lens.r1 - lens.thickness/2;
yc = 0;

if r == Inf
    y = linspace(-lens.radius, lens.radius);
    x = y*0 -lens.thickness/2;
else
    theta = linspace(pi/2,3*pi/2);
    x = r*cos(theta) + xc;
    y = r*sin(theta) + yc;
    new_x = x(y>=-lens.radius & y<=lens.radius);
    new_y = y(y>=-lens.radius & y<=lens.radius);
    x = new_x;
    y = new_y;
end
plot(x,y, 'Color', [0,0,0])

r = lens.r2;
xc = - lens.r2 + lens.thickness/2;
yc = 0;

if r == Inf
    y = linspace(-lens.radius, lens.radius);
    x = y*0 + lens.thickness/2;
else
    theta = linspace(-pi/2,pi/2);
    x = r*cos(theta) + xc;
    y = r*sin(theta) + yc;
    new_x = x(y>=-lens.radius & y<=lens.radius);
    new_y = y(y>=-lens.radius & y<=lens.radius);
    x = new_x;
    y = new_y;
end
plot(x,y, 'Color', [0,0,0])
 
%% plot object plane
lim = axis;
y = linspace(lim(3), lim(4));
x = y*0 + ray_entering_lens.pos.x;
plot(x,y, 'Color', [0,0,0]);

%% plot screen plane
y = linspace(lim(3), lim(4));
x = y*0 + screen.pos.x;
plot(x,y, 'Color', [0,0,0]);
axis equal
%% plot y axis
% y = linspace(-lens.radius, lens.radius);
% x = y*0;
% plot(x,y, 'Color', [0,0,0]);

function y = solve_ray_for_y(ray, x)
    m = ray.direction;
    x1 = ray.pos.x;
    y1 = ray.pos.y;
    [a, b, c] = pointslope_to_general(m, x1, y1);
    y = solve_linear_for_y(a, b, c, x);
end
