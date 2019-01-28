%% Reform line formula: point-slope form to general form
function [a, b, c] = pointslope_to_general(m, x1, y1)

    a = -m;
    b = 1;
    c = m*x1 - y1;

end