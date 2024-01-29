clc
clear all

% Parameters
num_agents = 200;             % Number of agents
space_width = 400;            % Width of the space
space_height = 500;           % Height of the space
cohesion_strength = 0.5;      % Cohesion strength
velocity_matching = 1.0;      % Velocity matching factor
noise_factor = 1.0;           % Noise factor

% Define parameter ranges
cohesion_strength_range = [0.1, 0.5, 1.0];
velocity_matching_range = [0.5, 2.5, 5.0];  % Adjusted values for velocity_matching
noise_factor_range = [1.0, 5.0, 10.0];     % Adjusted values for noise_factor

% Simulation parameters
time_steps = 100;   % Number of simulation steps
radius = 10; % Adjust this value to define the interaction radius

% Initialize arrays to store metric data for different parameter variations
time_steps = 100;
num_iterations = numel(cohesion_strength_range) * numel(velocity_matching_range) * numel(noise_factor_range);

avg_neighbor_distance_data = zeros(time_steps, num_iterations);
velocity_alignment_data = zeros(time_steps, num_iterations);
group_dispersion_data = zeros(time_steps, num_iterations);

iteration = 1;

% Nested loops for parameter variation
for coh_idx = 1:numel(cohesion_strength_range)
    for vel_idx = 1:numel(velocity_matching_range)
        for noise_idx = 1:numel(noise_factor_range)
            % Set current parameter values
            cohesion_strength = cohesion_strength_range(coh_idx);
            velocity_matching = velocity_matching_range(vel_idx);
            noise_factor = noise_factor_range(noise_idx);            
            % Initialize agent positions and velocities randomly for each iteration
            positions = space_width * rand(num_agents, 2);
            velocities = rand(num_agents, 2) - 0.5;
            
            % Initialize arrays to store metrics for each iteration
            avg_neighbor_distance = zeros(time_steps, 1);
            velocity_alignment = zeros(time_steps, 1);
            group_dispersion = zeros(time_steps, 1);
            
            % Simulation loop
            for t = 1:time_steps
               
                % Calculate pairwise distances using pdist2
                distances = pdist2(positions, positions); % Calculate pairwise distances
                distances(logical(eye(size(distances)))) = NaN; % Set diagonal elements to NaN
                
                % Calculate metrics for this iteration
                avg_neighbor_distance(t) = nanmean(min(distances,[],2));
                
                % Update velocities
                velocities = velocity_matching * mean(velocities);
                
                % Calculate group dispersion
                group_dispersion(t) = nanstd(velocities);
                
            end

            % Store metrics for this parameter variation
            avg_neighbor_distance_data(:, iteration) = avg_neighbor_distance;
            velocity_alignment_data(:, iteration) = velocity_alignment;
            group_dispersion_data(:, iteration) = group_dispersion;

            iteration = iteration + 1;
        end
    end
end

% Visualize metric data for different parameter variations using heatmaps
figure;

% Plot heatmaps for Average Neighbor Distance
subplot(3, 1, 1);
imagesc(avg_neighbor_distance_data);
colorbar;
title('Average Neighbor Distance Heatmap');
xlabel('Parameter Variation Index');
ylabel('Time Step');

% Plot heatmaps for Velocity Alignment
subplot(3, 1, 2);
imagesc(velocity_alignment_data);
colorbar;
title('Velocity Alignment Heatmap');
xlabel('Parameter Variation Index');
ylabel('Time Step');

% Plot heatmaps for Group Spatial Dispgrersion
subplot(3, 1, 3);
imagesc(group_dispersion_data);
colorbar;
title('Group Spatial Dispersion Heatmap');
xlabel('Parameter Variation Index');
ylabel('Time Step');