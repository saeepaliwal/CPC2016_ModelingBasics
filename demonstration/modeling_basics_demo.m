%% Step 1: Question
% How can we estimate the probability of heads (success) for a tricky coin?

%% Step 2: Hypothesis
% Beta priors

% Domain
x = 0:0.01:1

% Example: Uniform
a = 1;
b = 1;
prior = beta_pdf(x,a,b)
prior = prior./sum(prior)

% Plot
figure(101)
clf
bar(x,prior,'FaceColor','r','EdgeColor','none');
alpha(0.7);
xlim([0 1]);
box off
purty_plot(101,['./figures/Figure_Prior'],'eps');

%% Step 3: Task
% Say we observe 65 heads from 100 coin tosses
n = 100;
k = 65;

%% Step 4: Model
% Define a binomial likelihood
likelihood = binomial_pdf(x,k,n);
likelihood = likelihood./sum(likelihood);

% Plot
figure(102)
clf
hold on
bar(x,prior,'FaceColor','r','EdgeColor','none');
bar(x,likelihood,'FaceColor','g','EdgeColor','none');
alpha(0.7);
xlim([0 1]);
box off
purty_plot(102,['./figures/Figure_Prior_and_Likelihood'],'eps');

%% Step 5: Simulations
% Simulate a tricky coin with varying success rates for varying priors

% Type of prior:
% 1 = uniform
% 2 = weak around p=0.3
% 3 = strong around p=0.5
p = 1; 

% Set up likelihood:
% Binomial distribution with 2 parameters
% n = total number of trials
% k = total number of successes
n = 100; 
k = 65; 

% Simulate tricky coin:
% Uniform prior
[Pr1 L1 Po1] = tricky_coin(n,k,1);

% 0.5 prior
[Pr2 L2 Po2] = tricky_coin(n,k,2);

% 0.2 prior
[Pr3 L3 Po3] = tricky_coin(n,k,3);

%% Step 6: Model inversion
% Say we observe 45 heads out of 100 tosses
n = 100;
k = 45;

% Invert for uniform prior
[P1 F1] = mh_inversion(1,n,k);

% Invert for tight prior around 0.5
[P2 F2] = mh_inversion(2,n,k);

% Invert for weak prior around 0.3
[P3 F3] = mh_inversion(3,n,k);

%%
al = 0.6;
figure(104)
subplot(1,3,1);
hist(P1,50,'EdgeColor','none');
alpha(al);
subplot(1,3,2);
hist(P2,50,'EdgeColor','none');
alpha(al);
subplot(1,3,3);
hist(P3,50,'EdgeColor','none');
alpha(al);
purty_plot(104,['./figures/Figure_MH_Samples'],'eps');


%% Step 7: Model comparison
figure(104)
clf
hold on
bar([1 2 3],[F1 F2 F3],'FaceColor','k','EdgeColor','none');
alpha(0.7);
box off
purty_plot(104,['./figures/Figure_ModelComparison'],'eps');




