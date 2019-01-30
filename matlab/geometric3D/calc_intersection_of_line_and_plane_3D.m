%% Calculate the intersection of line and circle
function position = calc_intersection_of_line_and_plane_3D(a1, b1, c1, d1, a2, b2, c2)

% Reference: http://shogo82148.github.io/homepage/memo/geometry/line-circle.html
% ax + by + c == 0
% Circle: position = (x_p, y_p) and radius = r

% calculate the intersection
d = a*x_p + b*y_p + c;
position1.x = (-a*d + b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position2.x = (-a*d - b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position1.y = (-b*d - a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;
position2.y = (-b*d + a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;

end