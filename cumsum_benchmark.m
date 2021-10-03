clear
close all

%%

million_doubles_per_sec = @(n,nreps,elapsed) ...
  (n ./ (elapsed./nreps)) .* 1.e-6;


nreps = 1000;

n = [1000,10000,100000,1000000];

for trials = 1:7

for i = 1:length(n)
  A = rand([n(i),1]);
  start = tic;
  for rep = 1:nreps;
  B = cumsum(A);
  end
  elapsed(i) = toc(start);
end
fprintf('%0.6g %0.6g %0.6g %0.6g\n', ...
  million_doubles_per_sec(n,nreps,elapsed))

end