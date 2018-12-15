function [P3Optim,error] = OptimizeTranslationVector(...
    P1Optim, P2Optim, P3Unoptim, corrs123, displayIterFlag)
%OPTIMIZETRANSLATIONVECTOR Summary of this function goes here
%   Detailed explanation goes here
X12 = Triangulate(P1Optim,P2Optim,corrs123(1:4,:));
R = P3Unoptim(1:3,1:3);
tUnoptim = P3Unoptim(:,end);
f = @(st)...
    mean(sum((X12 - Triangulate(P2Optim,[R [st;tUnoptim(3)]],corrs123(3:6,:))).^2));
if exist('displayIterFlag','var') && strcmp(displayIterFlag,'displayIter')
    display = 'iter';
else
    display = 'none';
end
o = optimoptions(@fminunc,'Display',display,'MaxFunctionEvaluations',Inf,...
    'StepTolerance',1e-10,'OptimalityTolerance',1e-10);
[stOptim,error] = fminunc(f,tUnoptim(1:2),o);
P3Optim = [R [stOptim;tUnoptim(3)]];
end