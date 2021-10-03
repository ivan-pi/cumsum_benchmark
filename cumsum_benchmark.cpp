#include <ctime>
#include <random>
#include <iostream>
#include <algorithm>

// Millions of doubles per second
double millions_doubles_per_sec(int n, int nreps, double elapsed) {
    return ((double) n) / (elapsed / ((double) nreps)) * 1.0e-6;
}


int main() {                                                                                                            

    std::default_random_engine generator(std::random_device{}());                                                       
    std::uniform_real_distribution<double> dist(0.0,1.0);

    int ntrials = 7;
    int nreps = 1000;

    std::vector<int> n = {1000,10000,100000,1000000};
    std::vector<double> elapsed(4);

    for (int t = 0; t < ntrials; ++t) {
        for (size_t i = 0; i < n.size(); ++i) {

            std::vector<double> a(n[i]), b(n[i]);
            for (auto &aElem : a) {
                aElem = dist(generator);
            }

            clock_t start = clock();
            for (int rep = 0; rep < nreps; ++rep) {
                std::partial_sum(a.begin(),a.end(),b.begin());
            }
            clock_t end = clock();

            elapsed[i] = (end - start) / ((double) CLOCKS_PER_SEC);
        }
        for (size_t i = 0; i < n.size(); ++i) {
            double mdps = millions_doubles_per_sec(n[i],nreps,elapsed[i]);
            std::cout << mdps << ' ';
        }
        std::cout << '\n';
    }



    //double time_per_iteration = elapsed / ((double) m);
    //std::cout << "Time per iter: " << time_per_iteration << "\n";

    //double mdps = (((double) n) / time_per_iteration) * 1.0e-6;
    //std::cout << "Million doubles per second: " << mdps << "\n";

    return 0;
}