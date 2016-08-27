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

sigma = 1;   
proposal_PDF = @(x) lognrnd(x,mu,sigma);   
sample_from_proposal_PDF = @(mu) lognrnd(mu,sigma);
p = @(x) log_joint(x,fun); 
aa = -3;   
bb = 3;       
t = 0.5;    

% %% Define distributions
% 
% switch example
%     case 1 % Beta-binomial case
%         sigma = 1;   
%         proposal_PDF = @(x,mu) normpdf(x,mu,sigma);  
%         sample_from_proposal_PDF = @(mu) normrnd(mu,sigma);
%         
%     case 2 % Gaussian-gaussian case
%         
% end
        
%% Metroplis-Hastings routine

for i = 1:N         
    theta_star = sample_from_proposal_PDF(theta);
        
        
        
        
        [t a] = MH_routine(t, p, proposal_PDF, sample_from_proposal_PDF);
    end
    theta(i) = t;        % Samples accepted
    acc      = acc + a;  % Accepted ?
end
accrate = acc/N;     % Acceptance rate

keyboard




% Harmonic mean
P = P(:,n:end);
F = F(n:end);
F = -log(mean(mean(F)./F)) + log(mean(F));

% Autocorrelation (AC)
pp = theta(1:nn);   pp2 = theta(end-nn:end);   % First ans Last nn samples
[r lags]   = xcorr(pp-mean(pp), 'coeff');
[r2 lags2] = xcorr(pp2-mean(pp2), 'coeff');

%% Test for convergence (Geweke)
% Remove burn-in period and split your sample into two parts:
% The first 10% and the last 50%. If the chain is at stationarity, the means
% of two samples should be equal. i.e. if mean1~=mean2 OK!

split1 = theta(1:round(0.1*N));     split2 = theta(round(0.5*N):end);
mean1  = mean(split1);              mean2  = mean(split2) ;  
if abs((mean1-mean2)/mean1) < 0.03   % 3% error
   fprintf('\n The Geweke test OK!!! \n')
else
   fprintf('\n The Geweke test FAILS!!! \n')
end

%% Plots
% Autocorrelation
figure;
subplot(2,1,1);   stem(lags, r);
title('Autocorrelation', 'FontSize', 14);
ylabel('AC (first 100 samples)', 'FontSize', 12);
subplot(2,1,2);   stem(lags2, r2);
ylabel('AC (last 100 samples)', 'FontSize', 12);

% Histogram, target function and samples 
xx = aa:0.01:bb;   % x-axis (Graphs)
figure;

% % Histogram and target dist
% subplot(2,1,1);    
% [n1 x1] = hist(theta, ceil(sqrt(N))); 
% bar(x1, n1/(N*(x1(2)-x1(1))));   colormap summer;   hold on;  % Normalized histogram
% plot(xx, p(xx)/trapz(xx,p(xx)), 'r-', 'LineWidth', 2);        % Normalized "PDF"
% xlim([aa bb]); grid on; 
% title('Distribution of samples', 'FontSize', 15);
% ylabel('Probability density function', 'FontSize', 12);
% text(aa+3,0.8,sprintf('Acceptace rate = %g', accrate),'FontSize',12);
% 
% % Samples
% subplot(2,1,2);    
% plot(theta, 1:N, 'b-');   xlim([aa bb]);  ylim([0 N]); grid on; 
% xlabel('Location', 'FontSize', 12);
% ylabel('Iterations, N', 'FontSize', 12); 



function [t a prob] = MH_routine(theta,p,proposal_PDF,sample_from_proposal_PDF)
% Metropolis-Hastings algorithm routine:

theta_ast = sample_from_proposal_PDF(theta);        % sampling from the proposal PDF with media the current state
alpha = (p(theta_ast)*proposal_PDF(theta,theta_ast))/...  % Ratio of the density at the
        (p(theta)    *proposal_PDF(theta_ast,theta));     % candidate (theta_ast) and current (theta) points
if rand <= min(alpha,1)
   t    = theta_ast;        % Accept the candidate
   prob = min(alpha,1);     % Accept with probability min(alpha,1)
   a    = 1;                % Note the acceptance
else
   t    = theta;            % Reject the candidate and use the same state
   prob = 1-min(alpha,1);   % The same state with probability 1-min(alpha,1)
   a    = 0;                % Note the rejection
end

return;

% function LJ = log_joint(x, fun)
% 
% % Prior
% switch fun
%     case 1
%         % Uniform prior
%         prior = beta_pdf(x,1,1); % Uniform distribution
%     case 2
%         prior = beta_pdf(x,2,3); % Weak prior around 0.25
%     case 3
%         prior = beta_pdf(x,300,100); % Strong prior around 0.5   
% end
%         
% % Liklihood
% likelihood = binomial_pdf(x,65,100);
% 
% % Posterior
% LJ = likelihood.*prior;
% LJ = log(LJ);