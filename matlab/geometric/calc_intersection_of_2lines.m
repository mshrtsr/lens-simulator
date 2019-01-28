%% Calculate the intersection of 2lines
function position = calc_intersection_of_2lines(a1, b1, c1, a2, b2, c2)

% Reference: https://mathwords.net/nityokusenkoten
% a1*x + b1*y + c1 == 0
% a2*x + b2*y + c2 == 0

% calculate the intersection

position.x = (b1*c2 - b2*c1)/(a1*b2 - a2*b1);
position.y = (a2*c1 - a1*c2)/(a1*b2 - a2*b1);

end