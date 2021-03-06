function [d_vib_all t qi_0_matrix] = DampedFreeVibration(DATA, DOFl, MODES, FREQ,d,K_ll, M_ll)

%%% INPUT  %%% 
% Input data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NAME_INPUT_DATA = 'BEAM3D' ;  % Name of the mesh file 
nMODES = 25; % Number of nodes to be included in the modal representation
%DATA.nMODESplot = nMODES;
DATA.nsteps = 500;
DATA.ntimesPERIOD = 40;
DATA.imode_EVOLUTION = 0; % Only plot one mode per simulation
DATA.xiDmin = 0.02; % Minimum damping ratio


% Inputs
K = K_ll;
M = M_ll;
xi = 0.01;
d_dofl = d(DOFl);
T1 = 2*pi/FREQ(5);
t = linspace(0,40*T1,DATA.nsteps);

% Initial conditions
d_0 = d_dofl;
d_dot_0 = zeros(length(d_0),1);

% Calculations
d_vib = zeros(length(d_0),length(t));
d_vib(:,1) = d_0;
wi_damped = zeros(nMODES,1);
qi_0_matrix = (MODES.'*M*d_0);
qi_dot_0_matrix = MODES'*M*d_dot_0;

for j = 2:1:length(t) %time i=1:nMODES
    
    for i=1:nMODES
        time = t(j); 
        qi_0 = qi_0_matrix(i);
        qi_dot_0 = qi_dot_0_matrix(i);
        wi_damped(i) = FREQ(i)*sqrt(1-xi^2);
                
        d_vib(:,j) = d_vib(:,j) + MODES(:,i)*(exp(-xi*FREQ(i)*time)*(qi_0*cos(wi_damped(i)*time) + ...
            (qi_dot_0+xi*FREQ(i)*qi_0)/(wi_damped(i)) * sin(wi_damped(i)*time)));

    end

end

d_vib_all = zeros(length(d),length(t));
d_vib_all(DOFl,:) = d_vib;

end




