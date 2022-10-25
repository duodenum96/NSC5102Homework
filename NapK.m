function [V, n, q, V_p, n_p, dV, dn, V_null, n_null] = NapK(p, I, varargin)
%% Simulate Persistent Sodium + Potassium Neuron
% Input: 
%   p: A struct of parameters of the model
%   I: Total current density (mikroamper / cm^2)
%   If the user specifies 'phase', the program gives the nullclines and
%   phase portrait
%
% Output:
%   V: Membrane voltage time series
%   n: Activation parameter (probability of open activation gates)
%   If phase portrait: 
%       V_p: x-axis of phase portrait
%       n_p: y-axis of phase portrait
%       dV: Meshgrid of change in V per V_p
%       dn: Meshgrid of change in n per V_p
%       V_null: V-nullcline
%       n_null: n-nullcline
%       q: Quiver plot handle
%
% Authored by Yasir Çatal a.k.a. Duodenum
%% Extract parameters from the struct
dt = p.dt;              % Timesteps for Euler integration (ms)
time = p.time;          % Time vector (x-axis in time-series plots: dt:dt:endtime

C = p.C;                % Membrane Capacitance
E_L = p.E_L;            % Equilibrium potential (mV)
g_L = p.g_L;            % Conductance density (mS / cm^2)
E_Na = p.E_Na;          % Equilibrium potential (mV)
g_Na = p.g_Na;          % Conductance density (mS / cm^2)
E_K = p.E_K;            % Equilibrium potential (mV)
g_K = p.g_K;            % Conductance density (mS / cm^2)
tau = p.tau;

NaV1_2 = p.NaV1_2;      % The value that satisfies m_inf(V1/2) = 0.5
Na_k = p.Na_k;          % Slope factor of Boltzman function

KV1_2 = p.KV1_2;        % The value that satisfies n_inf(V1/2) = 0.5
K_k = p.K_k;            % Slope factor of Boltzman function
%% Initialize variables
V = zeros([1 length(time)]);
V(1) = -65;
n = zeros([1 length(time)]);
n(1) = 0.04;

for t = 1:length(time)-1
    n_inf = n_inff(V(t), KV1_2, K_k);
    m_inf = m_inff(V(t), NaV1_2, Na_k);
    
    dV = ( I(t) - g_L*(V(t) - E_L) - g_Na*m_inf*(V(t) - E_Na) - g_K*n(t)*(V(t) - E_K) ) / C;
    dn = (n_inf - n(t)) / tau;
    
    V(t+1) = V(t) + dt*dV;
    n(t+1) = n(t) + dt*dn;
end

if CheckInput(varargin,'phase')
    V_p = -90:1:20;
    n_p = 0.01:0.04:0.80;
    
    n_null = n_inff(V_p, KV1_2, K_k);
    V_null = ( I(1) - g_L.*(V_p - E_L) - g_Na.*m_inff(V_p, NaV1_2, Na_k).*(V_p - E_Na) ) ./ (g_K.*(V_p - E_K));
    
    [x, y] = meshgrid(V_p, n_p);
    dV = ( I(1) - g_L*(x - E_L) - g_Na*m_inff(V_p, NaV1_2, Na_k).*(x - E_Na) - g_K*y.*(x - E_K) );
    dn = (n_inff(V_p, KV1_2, K_k) - y) / tau;
    
    q = quiver(x(1:9:end),y(1:9:end),dV(1:9:end), dn(1:9:end), 'k', 'filled');
    hold on
    p1 = plot(V_p, V_null);
    p2 = plot(V_p, n_null);
    ylim([-0.01 0.7])
    xlim([-90 20])
    q.MaxHeadSize = 0.0005;
    q.Marker = '.';
    q.MarkerSize = 3;
    
    xlabel('V')
    ylabel('n')
    
    legend([p1, p2], {'V-nullcline', 'n-nullcline'})
    
end
end
%% Boltzmann functions
function n_inf = n_inff(V, KV1_2, K_k)
n_inf = 1 ./ (1 + exp((KV1_2 - V) ./ K_k));
end

function m_inf = m_inff(V, NaV1_2, Na_k)
m_inf = 1 ./ (1 + exp((NaV1_2 - V) ./ Na_k));
end



