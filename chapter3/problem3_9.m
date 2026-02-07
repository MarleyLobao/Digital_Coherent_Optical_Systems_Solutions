clear; clc;

addpath '..\utils'

x_min = 0;
x_max = 2.5;
fiber_param = 0.05;
a = 0.55;
num_rectangles = 55;

x = x_min:fiber_param:x_max;
y = maxwell_dist_pdf(x, a);

plot(x, y, '-');
hold on;
rect_width = (x_max - x_min) / num_rectangles;
for i = 0:(num_rectangles-1)
    x_left = x_min + i * rect_width;
    x_right = x_left + rect_width;
    y_height = maxwell_dist_pdf((x_left + x_right) / 2, a);
    fill([x_left x_right x_right x_left], [0 0 y_height y_height], 'cyan', 'EdgeColor', 'blue', 'FaceAlpha', 0.5);
end

xlabel('|\tau| [ps]');
ylabel('f(|\tau|)');
title('Empirical and theoretical distributions of the accumulated DGD |\tau| of a 300-km fiber link with mean DGD 0.05 ps/sqrt(km)');
legend('Theory', 'Simulation');
grid on;
hold off;