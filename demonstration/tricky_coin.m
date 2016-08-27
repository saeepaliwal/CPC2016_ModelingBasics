function tricky_coin(n,k,p)
% Toss a coin n times, k times it shows up heads

% Domain
x = 0:0.01:1;

% Prior
switch p
    case 1
        prior = beta_pdf(x,1,1); % Uniform prior
    case 2
        prior = beta_pdf(x,2,2); % Prior around 0.5 
    case 3
        prior = beta_pdf(x,2,3); % Weak prior around 0.25
end
prior = prior./sum(prior)        

% Liklihood
likelihood = binomial_pdf(x,65,100);

% Posterior
posterior = likelihood.*prior;
posterior = posterior./sum(posterior);
%% Plot
al = 0.7;

figure(101)
clf
bar(x,prior,'FaceColor','r','EdgeColor','none');
alpha(al)
xlim([0 1]);
box off
purty_plot(101,['./figures/Figure1_' sprintf('%d',p)],'eps');

figure(102)
clf
hold on
bar(x,prior,'FaceColor','r','EdgeColor','none');
bar(x,likelihood,'FaceColor','g','EdgeColor','none');
alpha(al)
xlim([0 1]);
box off
purty_plot(102,['./figures/Figure2_' sprintf('%d',p)],'eps');


figure(103);
clf
subplot(1,4,1)
bar(x,prior,'FaceColor','r','EdgeColor','none');
alpha(al)
xlim([0 1]);
box off

subplot(1,4,2);
hold on
bar(x,prior,'FaceColor','r','EdgeColor','none');
bar(x,likelihood,'FaceColor','g','EdgeColor','none');
alpha(al)
xlim([0 1]);
box off

subplot(1,4,3:4);
hold on
bar(x,prior,'FaceColor','r','EdgeColor','none');
bar(x,likelihood,'FaceColor','g','EdgeColor','none');
bar(x,posterior,'FaceColor','b','EdgeColor','none');
alpha(al)
xlim([0 1]);
box off
purty_plot(103,['./figures/Figure3_' sprintf('%d',p)],'eps');
