%% Automatic Water Pumping System - MATLAB Simulation
% ME-41032 - Group 8 Project
% System modeling, simulation, and data analysis

clear all; close all; clc;

%% System Parameters (Realistic for University Demo Project)
tankHeight = 20;        % Small demo tank height in cm
lowerThreshold = 6;     % Pump ON threshold (from project specs)
upperThreshold = 15;    % Pump OFF threshold (from project specs)
pumpFlowRate = 5;       % Small pump flow rate (cm/min when ON)
usageRate = 1;          % Water usage/drain rate (cm/min)
simulationTime = 30;    % Simulation time in minutes (short demo)

%% Initialize Variables
dt = 0.1;               % Time step (minutes)
t = 0:dt:simulationTime;
waterLevel = zeros(size(t));
pumpStatus = zeros(size(t));
distance = zeros(size(t));

% Initial conditions (start with low water)
waterLevel(1) = 4;      % Starting below threshold to trigger pump
pumpStatus(1) = 0;      % Pump initially OFF

%% Simulation Loop
fprintf('Starting Water Pump Demo System Simulation...\n');
fprintf('Tank Height: %.0f cm\n', tankHeight);
fprintf('Control Range: %.0f cm (LOW) to %.0f cm (HIGH)\n', lowerThreshold, upperThreshold);
fprintf('----------------------------------------\n');

for i = 2:length(t)
    % Current water level
    currentLevel = waterLevel(i-1);
    
    % Control Logic (Hysteresis) - Same as Arduino
    if pumpStatus(i-1) == 0 && currentLevel <= lowerThreshold
        % Turn pump ON
        pumpStatus(i) = 1;
        fprintf('Time %.1f min: PUMP ON - Water Level: %.1f cm\n', t(i), currentLevel);
    elseif pumpStatus(i-1) == 1 && currentLevel >= upperThreshold
        % Turn pump OFF
        pumpStatus(i) = 0;
        fprintf('Time %.1f min: PUMP OFF - Water Level: %.1f cm\n', t(i), currentLevel);
    else
        % Maintain current pump status
        pumpStatus(i) = pumpStatus(i-1);
    end
    
    % Calculate water level change
    if pumpStatus(i) == 1
        % Pump is ON: water level increases
        waterChange = (pumpFlowRate - usageRate) * dt;
    else
        % Pump is OFF: water level decreases due to usage
        waterChange = -usageRate * dt;
    end
    
    % Update water level
    waterLevel(i) = waterLevel(i-1) + waterChange;
    
    % Ensure water level stays within physical limits
    if waterLevel(i) < 0
        waterLevel(i) = 0;
    elseif waterLevel(i) > tankHeight
        waterLevel(i) = tankHeight;
    end
    
    % Calculate distance (what ultrasonic sensor would measure)
    distance(i) = tankHeight - waterLevel(i);
end

%% Data Analysis
fprintf('\n--- Demo System Performance Analysis ---\n');

% Calculate pump operation statistics
pumpOnTime = sum(pumpStatus) * dt;
pumpOffTime = simulationTime - pumpOnTime;
pumpCycles = sum(diff(pumpStatus) > 0); % Count pump turn-on events

fprintf('Total Pump ON time: %.1f minutes (%.1f%%)\n', pumpOnTime, (pumpOnTime/simulationTime)*100);
fprintf('Total Pump OFF time: %.1f minutes (%.1f%%)\n', pumpOffTime, (pumpOffTime/simulationTime)*100);
fprintf('Number of pump cycles: %d\n', pumpCycles);
fprintf('Average water level: %.1f cm\n', mean(waterLevel));
fprintf('Water level range: %.1f - %.1f cm\n', min(waterLevel), max(waterLevel));

% Check if system works within design thresholds
inRange = sum(waterLevel >= lowerThreshold & waterLevel <= upperThreshold);
fprintf('Time in control range: %.1f%% \n', (inRange/length(waterLevel))*100);

%% Plotting Results
figure('Position', [100, 100, 1000, 700]);

% Plot 1: Water Level vs Time
subplot(3,1,1);
plot(t, waterLevel, 'b-', 'LineWidth', 2.5);
hold on;
yline(lowerThreshold, 'r--', 'Lower Threshold (6cm)', 'LineWidth', 2);
yline(upperThreshold, 'g--', 'Upper Threshold (15cm)', 'LineWidth', 2);
fill([t fliplr(t)], [lowerThreshold*ones(size(t)) upperThreshold*ones(size(t))], ...
     'y', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Target Range');
xlabel('Time (minutes)');
ylabel('Water Level (cm)');
title('Water Level Control - University Demo System');
grid on;
legend('Water Level', 'Lower Threshold', 'Upper Threshold', 'Target Range', 'Location', 'best');
ylim([0, tankHeight]);

% Plot 2: Pump Status vs Time
subplot(3,1,2);
stairs(t, pumpStatus, 'r-', 'LineWidth', 2.5);
xlabel('Time (minutes)');
ylabel('Pump Status');
title('Pump Operation Status');
grid on;
ylim([-0.1, 1.1]);
yticks([0, 1]);
yticklabels({'OFF', 'ON'});

% Plot 3: Ultrasonic Sensor Distance Reading
subplot(3,1,3);
plot(t, distance, 'm-', 'LineWidth', 2);
xlabel('Time (minutes)');
ylabel('Sensor Distance (cm)');
title('Ultrasonic Sensor Reading (Distance from Sensor to Water Surface)');
grid on;
ylim([0, tankHeight]);

% Add overall title
sgtitle('ME-41032 Group 8: Automatic Water Pumping System Analysis', 'FontSize', 14, 'FontWeight', 'bold');

%% Error Analysis (From Project Slide: ±3cm sensor error)
fprintf('\n--- Sensor Error Analysis ---\n');
maxSensorError = 3; % From project documentation: ±3cm
fprintf('Maximum sensor error: ±%.0f cm (from project specs)\n', maxSensorError);

% Simulate realistic sensor readings with noise
sensorNoise = maxSensorError * (2*rand(size(distance)) - 1);
noisyDistance = distance + sensorNoise;
noisyWaterLevel = tankHeight - noisyDistance;

% Ensure noisy readings stay within physical limits
noisyWaterLevel(noisyWaterLevel < 0) = 0;
noisyWaterLevel(noisyWaterLevel > tankHeight) = tankHeight;

figure('Position', [150, 150, 800, 400]);
plot(t, waterLevel, 'b-', 'LineWidth', 2, 'DisplayName', 'True Water Level');
hold on;
plot(t, noisyWaterLevel, 'r:', 'LineWidth', 1.5, 'DisplayName', 'Sensor Reading (±3cm error)');
yline(lowerThreshold, 'k--', 'Alpha', 0.7, 'DisplayName', 'Thresholds');
yline(upperThreshold, 'k--', 'Alpha', 0.7);
xlabel('Time (minutes)');
ylabel('Water Level (cm)');
title('Impact of Sensor Error on Water Level Measurement');
legend('Location', 'best');
grid on;
ylim([0, tankHeight]);

%% Summary for Interview
fprintf('\n--- PROJECT SUMMARY FOR INTERVIEW ---\n');
fprintf('System Type: University demonstration model\n');
fprintf('Tank Size: Small acrylic tank (%.0f cm height)\n', tankHeight);
fprintf('Control Method: Hysteresis control (%.0f-%.0f cm range)\n', lowerThreshold, upperThreshold);
fprintf('Sensor: Ultrasonic distance sensor (±%.0f cm accuracy)\n', maxSensorError);
fprintf('Controller: Arduino microcontroller\n');
fprintf('Analysis Tool: MATLAB simulation and modeling\n');
fprintf('Team: 5-person group project (Group 8)\n');
fprintf('Result: Successfully automated water level control\n');

%% Save Simulation Data
simulationResults = struct();
simulationResults.time = t;
simulationResults.waterLevel = waterLevel;
simulationResults.pumpStatus = pumpStatus;
simulationResults.distance = distance;
simulationResults.parameters.tankHeight = tankHeight;
simulationResults.parameters.lowerThreshold = lowerThreshold;
simulationResults.parameters.upperThreshold = upperThreshold;
simulationResults.parameters.maxError = maxSensorError;

fprintf('\nSimulation complete. Data saved in "simulationResults" structure.\n');
