clear
close all

%%

nrep = 1000;

n = [1000,10000,100000,1000000];

for trials = 1:7

for i = 1:length(n)
  A = rand([n(i),1]);
  start = tic;
  for rep = 1:nrep;
  B = cumsum(A);
  end
  elapsed(i) = toc(start);
end
fprintf('%0.6g %0.6g %0.6g %0.6g\n',elapsed)

end