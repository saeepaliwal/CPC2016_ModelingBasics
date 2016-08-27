function [P F] = mh_inversion(fun)

%% Initial data
% Parameters
nn      = 100;       % Number of samples for examine the AC
N       = 10000;     % Number of samples (iterations)
burnin  = 1000;      % Number of runs until the chain approaches stationarity
lag     = 10;        % Thinning or lag period: storing only every lag-th point


% Storage
theta   = zeros(1,N);      % Samples drawn from the Markov chain (States)
acc     = 0;               % Accepted samples
F = [];

aa = 0;   
bb = 1;       
t = 0.5;    

%% Define distributions   
sig = 0.1;
proposal_PDF = @(x,mu) normpdf(x,mu,sig); 
sample_from_proposal_PDF = @(mu) normrnd(mu,sig);
p = @(x) log_joint(x,fun);

%% Metropolis Hastings
for i = 1:burnin    % Burn-in stage (this gets us closer to the acceptable region)
    [t] = mh(t,p, proposal_PDF, sample_from_proposal_PDF);
end
for i = 1:N         % Total number of samples
    for j = 1:lag   % Thinning
        [t a] = mh(t, p, proposal_PDF, sample_from_proposal_PDF);
    end
    [t a F(end+1)] = mh(t, p, proposal_PDF, sample_from_proposal_PDF);
    theta(i) = t;        % Samples 
    acc      = acc + a;  % Total number of accepted samples
end
accrate = acc/N    % Acceptance rate

% Harmonic mean to calculate Free Energy
F = -log(mean(mean(F)./F)) + log(mean(F));

% Rename proposal
P = theta;

%% Test for convergence (Geweke)
% Remove burn-in period and split your sample into two parts:
% The first 10% and the last 50%. If the chain is at stationarity, the means
% of two samples should be equal. i.e. if mean1~=mean2, you're all clear.
split1 = theta(1:round(0.1*N));     split2 = theta(round(0.5*N):end);
mean1  = mean(split1);              mean2  = mean(split2) ;  
if abs((mean1-mean2)/mean1) < 0.03   % 3% error
   fprintf('\n Awesome! Passed the Geweke test!\n')
else
   fprintf('\n Sadly, the Geweke test failed. \n')
end

%% Plots
% Histogram, target function and samples 
xx = aa:0.01:bb;   % x-axis (Graphs)
figure;

% Histogram and target dist
subplot(2,1,1);    
[n1 x1] = hist(theta, ceil(sqrt(N))); 
bar(x1, n1/(N*(x1(2)-x1(1))));    
xlim([aa bb]); grid on; 
title('Distribution of samples', 'FontSize', 15);
ylabel('Probability density function', 'FontSize', 12);
text(aa+3,0.8,sprintf('Acceptace rate = %g', accrate),'FontSize',12);

% Samples
subplot(2,1,2);    
plot(theta, 1:N, 'b-');   xlim([aa bb]);  ylim([0 N]); grid on; 
xlabel('Location', 'FontSize', 12);
ylabel('Iterations, N', 'FontSize', 12); 

function [t a F] = mh(theta,p,proposal_PDF,sample_from_proposal_PDF)

theta_star = sample_from_proposal_PDF(theta);        % sampling from the proposal PDF with media the current state
alpha = (p(theta_star)*proposal_PDF(theta,theta_star))/...  % Ratio of the density at the
         (p(theta)    *proposal_PDF(theta_star,theta));     % candidate (theta_ast) and current (theta) points

if rand <= min(alpha,1)
   t    = theta_star;        % Accept the candidate
   prob = min(alpha,1);     % Accept with probability min(alpha,1)
   a    = 1;                % Note the acceptance
   F = p(theta_star);
else
   t    = theta;            % Reject the candidate and use the same state
   prob = 1-min(alpha,1);   % The same state with probability 1-min(alpha,1)
   a    = 0;                % Note the rejection
   F = p(theta);
end

return;

function LJ = log_joint(x, fun)

% Prior
switch fun
    case 1
        prior = beta_pdf(x,1,1); % Uniform prior
    case 2
        prior = beta_pdf(x,2,2); % Prior around 0.5 
    case 3
        prior = beta_pdf(x,2,3); % Weak prior around 0.25 
end

% Liklihood
likelihood = binomial_pdf(x,65,100);

% Posterior
LJ = prior.*likelihood;
return;
