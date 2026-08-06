% -------------------------------------------------------------------------
% Active Vibration Control Platform
% Platform: MQ-9A Reaper with Raytheon MTS-B Turret (FSM Sub-system)
% -------------------------------------------------------------------------

close all;
clear;
clc;

%% 1-Disturbance and Sampling Parameters
f_bpf = 80; % Blade Pass Frequency of turboprop in Hz
fs = 2000; % System Sampling Frequency in Hz (Min 2 kHz required)
Ts = 1/fs; % Discrete Sample Time in seconds

%% 2-Physical Plant Parameters Modeled as a 2nd-order Mechanical Oscillator
m = 0.5; % Mass of the internal mirror payload in kilos
k = 5000; % Mechanical stiffness of piezo mounts in N/m
c = 2.5; % Structural damping coefficient in Ns/m

%% 3-Continuous-Time State-Space Construction (State vector x = [position; velocity])
A_cont = [0, 1;
         -k/m, -c/m];
B_cont = [0;
          1/m];
C_cont = [1, 0]; % Measuring physical displacement
D_cont = 0; % No direct feedthrough in the mechanical plant

% Create the continuous state-space object
sys_cont = ss(A_cont, B_cont, C_cont, D_cont);

%% 4- Discretization (Zero-Order Hold)
sys_discrete = c2d(sys_cont, Ts, 'zoh');
Ad = sys_discrete.A;
Bd = sys_discrete.B;
Cd = sys_discrete.C;
Dd = sys_discrete.D;

%% 5-Secondary Path Modeling (S(z))
% The DSP must have an accurate mathematical model of the physical plant to 
% maintain phase alignment. We will use the actual discretized FSM plant.
sys_tf = tf(sys_discrete);
[num_s, den_s] = tfdata(sys_tf, 'v');

%% 6-FxLMS Algorithm Parameters
mu = 0.5;% Adaptive step-size (Requires fine tuning in Simulink to ensure stability)
filter_length = 64; % Number of FIR filter taps for the counter wave generation

disp('-------------------------------------------------------------------------');
disp('Initialization Complete.');
disp('Continuous physical plant has been successfully discretized.');
disp('Workspace is now populated with Ad, Bd, Cd matrices and DSP parameters.');
disp('We may now execute the Simulink model!');
disp('-------------------------------------------------------------------------');