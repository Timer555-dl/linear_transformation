%% Linear transformation 3D
% 01.06.2020 RMIT University, Melbourne
% Author: Simon Nickl
% Respect that matrix and vector inputs are transponded!

clear all
close all
clc

write_video = 0;    % <--- Set == 1 to write video file!

% Basis vectors and datapoint
base = [0, 0];
e1 = [1, 0];
e2 = [0, 1];
p = [2, 1]; % <--- Add pont here!
data = [e1; e2; p; base];

% Transformation matrix
unit_matrix = eye(3);
t_matrix_3d = [2, 1, 2; 3, 2, 1]; % <--- Define transformation matrix here!
frames = 100;

x_min_max = 10; % <--- Set min, max values of your grid/axes here!
grid_factor = 5;
y_min_max = x_min_max;
z_min_max = x_min_max;

% Initialize video
if write_video == 1
    vid = VideoWriter('linear_transformation_3d', 'MPEG-4'); % Open video file
    vid.FrameRate = 10;
    open(vid)
end

% Creat transformation matrix for every frame
t_matrix_3d_frames = zeros([size(t_matrix_3d), frames]);
for i = 1:size(t_matrix_3d, 1)
    for j = 1:size(t_matrix_3d, 2)
        t_matrix_3d_frames(i,j,:) = linspace(unit_matrix(i,j),...
            t_matrix_3d(i,j), frames);
    end
end

% Plot
figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:frames
    t_data = data*t_matrix_3d_frames(:, :, i);
    x_grid = -x_min_max*grid_factor:x_min_max*grid_factor;
    y_grid = -y_min_max*grid_factor:y_min_max*grid_factor;
    [X, Y] = meshgrid(x_grid, y_grid);
    grid_pts = reshape([X, Y], [size(X, 1).^2, 2]);
    grid_pts = grid_pts*t_matrix_3d_frames(:, :, i);

    plot3(grid_pts(:,1), grid_pts(:,2), grid_pts(:,3), 'bo', 'MarkerEdgeColor', [0.2,0.2,1],...
        'MarkerFaceColor', 'b', 'MarkerSize', 6);
    
    % Plot parameters
    xlim([-x_min_max, x_min_max]);
    ylim([-y_min_max, y_min_max]);
    zlim([-z_min_max, z_min_max]);
    grid on
    grid minor
    set(gca, 'Color', 'k', 'GridAlpha', 0.5, 'GridColor', 'w',...
    'MinorGridAlpha', 0.3, 'MinorGridColor', 'w', 'XAxisLocation', 'origin',...
    'XColor', 'w','XMinorGrid', 'on', 'YAxisLocation', 'origin',...
    'YColor', 'w', 'YMinorGrid', 'on');
    
    % Plot lines through origin
    line(2*xlim, [0,0], [0,0], 'Linewidth', 2, 'Color', 'w');
    line([0,0], 2*ylim, [0,0], 'Linewidth', 2, 'Color', 'w');
    line([0,0], [0,0], 2*zlim, 'Linewidth', 2, 'Color', 'w');

    % Plot arrows  
    line([0, t_data(3,1)], [0, t_data(3,2)], [0, t_data(3,3)], 'Linewidth', 2, 'Color', 'y');
    line([0, t_data(2,1)], [0, t_data(2,2)], [0, t_data(2,3)], 'Linewidth', 2, 'Color', 'g');
    line([0, t_data(1,1)], [0, t_data(1,2)], [0, t_data(1,3)], 'Linewidth', 2, 'Color', 'r');
    
    % Plot text
    delete(findall(gcf,'type','annotation'))
    textbox = annotation('textbox', [0.605 0.206 0.226 0.176], 'Color', 'w', 'FontSize', 20, 'Interpreter', 'latex');
    m = strcat('$$ T =   \pmatrix{', num2str(t_matrix_3d_frames(1, 1, i)), '&' , num2str(t_matrix_3d_frames(2, 1, i)),...
        ' \cr', num2str(t_matrix_3d_frames(1, 2, i)), '&', num2str(t_matrix_3d_frames(2, 2, i)),...
                ' \cr', num2str(t_matrix_3d_frames(1, 3, i)), '&', num2str(t_matrix_3d_frames(2, 3, i)), '} $$');
    set(textbox, 'String', m);
    
    % Draw plot, change view and get frame
    if i == 1
        for j = 1:90
            view(0, 91-j);
            drawnow;
            if j == 1
                pause(5);
            else
                pause(.1);
            end
            if write_video == 1
                frame = getframe(gcf); % Get frame
                writeVideo(vid, frame);
            end
        end
    end
    
    if i <= frames/2
        view(0,0);
    else
        view(-frames/2+i, -frames/2+i);
    end
    
    drawnow;
    pause(.1);
    if write_video == 1
        frame = getframe(gcf); % Get frame
        writeVideo(vid, frame);
    end    
end

for j = 1:360
    view(-frames/2+i+j, -frames/2+i);
    drawnow;
    pause(0.03);
    if write_video == 1
        frame = getframe(gcf); % Get frame
        writeVideo(vid, frame);
    end    
end

if write_video == 1
    close(vid)
end
