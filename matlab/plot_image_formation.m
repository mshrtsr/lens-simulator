clear all;

%% Setup
params = fetch_variables();
lens = params.lens;
ray_from_object = params.ray_from_object;
direction_start = (lens.radius - ray_from_object.pos.y)/(0 - ray_from_object.pos.x);
direction_end = (-lens.radius - ray_from_object.pos.y)/(0 - ray_from_object.pos.x);

for direction = linspace(direction_start, direction_end)
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

%% plot the graph
x = [];
y = [];

tmp_x = linspace(ray_from_object.pos.x, ray_in_lens.pos.x);
tmp_y = ray_from_object.direction*(tmp_x - ray_from_object.pos.x) + ray_from_object.pos.y;
x = [x tmp_x];
y = [y tmp_y];

tmp_x = linspace(ray_in_lens.pos.x, ray_from_lens.pos.x);
tmp_y = ray_in_lens.direction*(tmp_x - ray_in_lens.pos.x) + ray_in_lens.pos.y;
x = [x tmp_x];
y = [y tmp_y];

tmp_x = linspace(ray_from_lens.pos.x, projected_p.pos.x);
tmp_y = ray_from_lens.direction*(tmp_x - ray_from_lens.pos.x) + ray_from_lens.pos.y;
x = [x tmp_x];
y = [y tmp_y];

tmp_x = linspace(projected_p.pos.x, p_at_right_border.pos.x);
tmp_y = ray_from_lens.direction*(tmp_x - projected_p.pos.x) + projected_p.pos.y;
x = [x tmp_x];
y = [y tmp_y];

%plot(x, y);
plot(x, y, 'Color', 'cyan');
hold on

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
 y = linspace(-lens.radius, lens.radius);
 x = y*0 + ray_from_object.pos.x;
 plot(x,y, 'Color', [0,0,0]);

%% plot screen plane
 y = linspace(-lens.radius, lens.radius);
 x = y*0 + screen.pos.x;
 plot(x,y, 'Color', [0,0,0]);
 axis equal
%% plot y axis
% y = linspace(-lens.radius, lens.radius);
% x = y*0;
% plot(x,y, 'Color', [0,0,0]);
end