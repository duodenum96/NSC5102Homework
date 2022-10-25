%% Generate figures for homework
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
cd C:\Users\user\Desktop\brain_stuff\uO\NSC5102\malerHomework
%% Initialize parameters
p_hight = struct;
p_hight.C = 1;
p_hight.E_L = -80;
p_hight.g_L = 8;
p_hight.E_Na = 60;
p_hight.g_Na = 20;
p_hight.E_K = -90;
p_hight.g_K = 10;
p_hight.NaV1_2 = -20;
p_hight.Na_k = 15;
p_hight.tau = 1;
p_hight.KV1_2 = -25;
p_hight.K_k = 5;
p_hight.dt = 0.001;
p_hight.time = p_hight.dt:p_hight.dt:100;

p_lowt = p_hight;
p_lowt.E_L = -78;
p_lowt.KV1_2 = -45;

%% Figure 1: Phase portrait of low-threshold INa,p+IK Model
I = zeros([1 length(p_hight.time)]);

[~, ~, q] = NapK(p_lowt, I, 'phase');
title('Phase portrait of Low-Threshold $I_{Na, p}+I_K$ Model', 'Interpreter', 'Latex')
saveas(gcf, 'Figure 1')
saveas(gcf, 'Figure 1.png')
%% Figure 2: Response to input of various currents
close
colors = {'#0072BD', '#7E2F8E', 	'#77AC30', 	'#4DBEEE', 	'#A2142F', 	'#FF00FF'};
I = zeros([1 length(p_hight.time)]);
Ivals = 10:5:35;
I(10/p_lowt.dt:11/p_lowt.dt) = Ivals(1);
subplot(1,2,1)
[V, n] = NapK(p_lowt, I, 'phase'); hold on
plot(V(5/p_lowt.dt:20/p_lowt.dt), n(5/p_lowt.dt:20/p_lowt.dt),'Color', colors{1})

subplot(1,2,2)
plot(p_lowt.time, V, 'Color', colors{1}), hold on
xlabel('Time (ms)')
ylabel('V')

for i = 2:length(Ivals)
    subplot(1,2,1)
    I(10/p_lowt.dt:11/p_lowt.dt) = Ivals(i);
    [V, n] = NapK(p_lowt, I);
    plot(V(5/p_lowt.dt:20/p_lowt.dt), n(5/p_lowt.dt:20/p_lowt.dt), 'Color', colors{i})
    
    subplot(1,2,2)
    plot(p_lowt.time, V, 'Color', colors{i})
    xlim([5 20])
end
subplot(1,2,1)
hold off
axis square
l = get(gca, 'Legend');
l.String = {'V-nullcline'  'n-nullcline'};
title('Phase trajectories of different inputs')

axes('Position',[.74 .75 .15 .15])
box on
for i = 1:length(Ivals)
    I(10/p_lowt.dt:11/p_lowt.dt) = Ivals(i);
    plot(p_lowt.time, I, 'Color', colors{i}), hold on
    xlim([5 20])
end
ylim([0 37])
saveas(gcf, 'Figure 2')
saveas(gcf, 'Figure 2.png')
%% Figure 3: Response to input of various currents
close
colors = {'#0072BD', '#7E2F8E', 	'#77AC30', 	'#4DBEEE', 	'#A2142F', 	'#FF00FF'};
subplot(1,2,1)
I = zeros([1 length(p_hight.time)]);
[V, n] = NapK(p_lowt, I, 'phase'); hold on

Ivals = [-10, 0, 10];
I(10/p_lowt.dt:11/p_lowt.dt) = 20;
I(1:10/p_lowt.dt-1) = Ivals(1);
[V, n] = NapK(p_lowt, I); hold on
plot(V(5/p_lowt.dt:20/p_lowt.dt), n(5/p_lowt.dt:20/p_lowt.dt),'Color', colors{1})

subplot(1,2,2)
plot(p_lowt.time, V, 'Color', colors{1}), hold on
xlabel('Time (ms)')
ylabel('V')

for i = 2:length(Ivals)
    subplot(1,2,1)
    I(10/p_lowt.dt:11/p_lowt.dt) = 20;
    I(1:10/p_lowt.dt-1) = Ivals(i);
    [V, n] = NapK(p_lowt, I);
    plot(V(5/p_lowt.dt:20/p_lowt.dt), n(5/p_lowt.dt:20/p_lowt.dt), 'Color', colors{i})
    
    subplot(1,2,2)
    plot(p_lowt.time, V, 'Color', colors{i})
    xlim([5 20])
end
subplot(1,2,1)
hold off
axis square
l = get(gca, 'Legend');
l.String = {'V-nullcline'  'n-nullcline'};
title('Phase trajectories of different inputs')

axes('Position',[.74 .75 .15 .15])
box on
for i = 1:length(Ivals)
    I(10/p_lowt.dt:11/p_lowt.dt) = 20;
    I(1:10/p_lowt.dt-1) = Ivals(i);
    plot(p_lowt.time, I, 'Color', colors{i}), hold on
    xlim([5 20])
end
ylim([-13 25])
saveas(gcf, 'Figure 3')
saveas(gcf, 'Figure 3.png')
%% Figure 4: Bifurcation in low-threshold model
I = linspace(0,100, length(p_lowt.time));
[V, n] = NapK(p_lowt, I);
subplot(2,1,1)
plot(p_lowt.time, V, 'k')
xlabel('Time')
ylabel('V')
subplot(2,1,2)
plot(p_lowt.time, I, 'k')
xlabel('Time')
ylabel('I')
% subplot(2,2,[2,4])
% plot(I, V)
% axis square
% xlabel('I')
% ylabel('V')
saveas(gcf, 'Figure 4')
saveas(gcf, 'Figure 4.png')
% -73, -68
%% Figure 5: Phase portraits

Ivals = [0, 10, 30, 45];
for i = 1:length(Ivals)
    subplot(2,2,i)
    I = Ivals(i) * ones(1, length(p_lowt.time));
    [V, n] = NapK(p_lowt, I, 'phase'); hold on, axis square
    plot(V,n)
    l = get(gca, 'Legend');
    l.String = {'V-nullcline'  'n-nullcline'};
    title(['I = ', num2str(Ivals(i))])
end
% saveas(gcf, 'Figure 5')
% saveas(gcf, 'Figure 5.png')
%% Figure 6: Same but high-threshold model
I = linspace(0,30, length(p_hight.time));
[V, n] = NapK(p_hight, I);
subplot(2,1,1)
plot(p_hight.time, V, 'k')
xlabel('Time')
ylabel('V')
subplot(2,1,2)
plot(p_hight.time, I, 'k')
xlabel('Time')
ylabel('I')
% subplot(2,2,[2,4])
% plot(I, V)
% axis square
% xlabel('I')
% ylabel('V')
saveas(gcf, 'Figure 6')
saveas(gcf, 'Figure 6.png')
% First inter-spike interval: 8 seconds, 2nd: 4.4 seconds
%% Figure 7: Phase portraits

Ivals = [0, 4.51, 8, 15];
for i = 1:4
    subplot(2,2,i)
    I = Ivals(i) * ones(1, length(p_hight.time));
    [V, n] = NapK(p_hight, I, 'phase'); hold on, axis square
    plot(V,n)
    l = get(gca, 'Legend');
    l.String = {'V-nullcline'  'n-nullcline'};
    title(['I = ', num2str(Ivals(i))])
    ylim([-0.1 0.7])
end
saveas(gcf, 'Figure 7')
saveas(gcf, 'Figure 7.png')

%% Figure 8: Zoom into phase portrait

Ivals = [0, 4.51, 8, 15];
for i = 1:4
    subplot(2,2,i)
    I = Ivals(i) * ones(1, length(p_hight.time));
    [V, n] = NapK(p_hight, I, 'phase'); hold on, axis square
    plot(V,n)
    l = get(gca, 'Legend');
    l.String = {'V-nullcline'  'n-nullcline'};
    title(['I = ', num2str(Ivals(i))])
    xlim([-80 -40])
    ylim([-0.04 0.12])
end


saveas(gcf, 'Figure 8')
saveas(gcf, 'Figure 8.png')
%% Figure 9: Determining the resonance frequency
close
str = 15;
Fs = 1/dt;
f_in_start = 0.0001;
f_in_end = 1.5;
f_in = linspace(f_in_start, f_in_end, length(p_lowt.time));
phase_in = cumsum(f_in/Fs);
I = str*sin(2*pi*phase_in)+str;


subplot(2,2,2)
[V, n] = NapK(p_lowt, I);
plot(p_lowt.time,V, 'k')
title('Resonator')

subplot(2,2,4)
plot(p_lowt.time,I, 'k')
xlabel('Time (ms)')

str = 4;
Fs = 1/dt;
f_in_start = 0.0001;
f_in_end = 1.5;
f_in = linspace(f_in_start, f_in_end, length(p_lowt.time));
phase_in = cumsum(f_in/Fs);
I = str*sin(2*pi*phase_in)+str;

subplot(2,2,1)
[V, n] = NapK(p_hight, I);
plot(p_lowt.time,V, 'k')
ylabel('Membrane voltage')
title('Integrator')

subplot(2,2,3)
plot(p_lowt.time,I, 'k')
xlabel('Time (ms)')
ylabel('I')

saveas(gcf, 'Figure 9')
saveas(gcf, 'Figure 9.png')
%% Figure 10: Integrators vs resonators
close
iti = [0.5 2.5 4.5]; % Time between stimuli
dur = 5;         % duration of stimuli
str = [4.8, 17.5];         % Strength of stimuli
dt = p_lowt.dt;  

% Integrator in top row, resonator in bottom row
for i = 1:3
    subplot(2,3,i)
    I = zeros(1, length(p_hight.time));
    I([5/dt:(5+dur)/dt, ...
        (5+dur+iti(i))/dt+1:(5+dur+1+iti(i)+dur)/dt, ...
        (5+2*dur+2*iti(i))/dt+1:(5+2*dur+1+2*iti(i)+dur)/dt]) = str(1);
    [V, n] = NapK(p_hight, I);
    plot(p_hight.time, V, 'Color', colors{i})
    ylim([-80 0])
    xlim([0 40])
    title(['ISI = ', num2str(iti(i)), ' ms'])
    if i == 2, title({'Integrators', ['ISI = ', num2str(iti(i)), ' ms']}), end
    if i == 1, ylabel('Membrane voltage'), end
    
    I = zeros(1, length(p_hight.time));
    I([5/dt:(5+dur)/dt, ...
        (5+dur+iti(i))/dt+1:(5+dur+1+iti(i)+dur)/dt, ...
        (5+2*dur+2*iti(i))/dt+1:(5+2*dur+1+2*iti(i)+dur)/dt]) = str(2);
    subplot(2,3,i+3)
    [V, n] = NapK(p_lowt, I);
    plot(p_hight.time, V, 'Color', colors{i})
    ylim([-80 0])
    xlim([0 40])
    if i == 2, title('Resonators'), end
    if i == 1, ylabel('Membrane voltage'), end
    xlabel('Time (ms)')
end
saveas(gcf, 'Figure 10')
saveas(gcf, 'Figure 10.png')
%% Figure 11: Phase portrait of figure 10
close
iti = [0.5 2.5 4.5]; % Time between stimuli
dur = 5;         % duration of stimuli
str = [4.8, 17.5];         % Strength of stimuli
dt = p_lowt.dt;  

I = zeros(1, length(p_hight.time));
subplot(1,2,1)
NapK(p_hight, I, 'phase'); hold on
l = get(gca, 'Legend');
l.Visible = 'off';
title('Integrator')
subplot(1,2,2)
NapK(p_lowt, I, 'phase'); hold on
l = get(gca, 'Legend');
l.Visible = 'off';
title('Resonator')

% Integrator in left, resonator in right
for i = 1:3
    subplot(1,2,1)
    I = zeros(1, length(p_hight.time));
    I([5/dt:(5+dur)/dt, ...
        (5+dur+iti(i))/dt+1:(5+dur+1+iti(i)+dur)/dt, ...
        (5+2*dur+2*iti(i))/dt+1:(5+2*dur+1+2*iti(i)+dur)/dt]) = str(1);
    [V, n] = NapK(p_hight, I);
    plot(V, n, 'Color', colors{i}), axis square
    ylim([-0.1 0.7])
    
    I = zeros(1, length(p_hight.time));
    I([5/dt:(5+dur)/dt, ...
        (5+dur+iti(i))/dt+1:(5+dur+1+iti(i)+dur)/dt, ...
        (5+2*dur+2*iti(i))/dt+1:(5+2*dur+1+2*iti(i)+dur)/dt]) = str(2);
    subplot(1,2,2)
    [V, n] = NapK(p_lowt, I);
    plot(V, n, 'Color', colors{i}), axis square
    ylim([-0.1 0.7])
end
f=get(gca,'Children');
legend([f(3), f(2), f(1)], {'ISI=0.5', 'ISI=2.5', 'ISI=4.5'})
saveas(gcf, 'Figure 11')
saveas(gcf, 'Figure 11.png')
